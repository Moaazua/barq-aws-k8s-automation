"""Small Flask/PostgreSQL/Redis service for the BARQ assessment."""
import json
import os
import re
import time
import uuid
from datetime import datetime, timezone
import psycopg
import redis
from flask import Flask, g, jsonify, request
from werkzeug.exceptions import HTTPException

VERSION = "2.0.0"

def log_event(level, event, **fields):
    print(json.dumps({"timestamp": datetime.now(timezone.utc).isoformat(timespec="milliseconds"),
                      "level": level, "service": "barq-api", "event": event, **fields}), flush=True)

class Dependencies:
    def __init__(self, database_url, redis_url):
        self.database_url = database_url
        self.cache = redis.Redis.from_url(redis_url, socket_connect_timeout=2,
                                          socket_timeout=2, decode_responses=True)

    def query(self, statement, params=()):
        with psycopg.connect(self.database_url, connect_timeout=2,
                             options="-c statement_timeout=2000") as connection:
            with connection.cursor() as cursor:
                cursor.execute(statement, params)
                return cursor.fetchall()

    def database_ready(self):
        return self.query("SELECT 1") == [(1,)]

    def redis_ready(self):
        return bool(self.cache.ping())

    def records(self):
        return [{"id": row[0], "title": row[1]} for row in
                self.query("SELECT id, title FROM records ORDER BY id")]

    def create_record(self, title):
        row = self.query("INSERT INTO records (title) VALUES (%s) RETURNING id, title", (title,))[0]
        return {"id": row[0], "title": row[1]}

    def counter(self):
        return self.cache.incr("barq:requests")

def create_app(config=None, dependencies=None):
    app = Flask(__name__)
    app.config.update(INSTANCE_ID=os.getenv("INSTANCE_ID", "local"),
                      APP_MESSAGE=os.getenv("APP_MESSAGE", "Welcome to BARQ Systems"),
                      MAX_CONTENT_LENGTH=16 * 1024)
    if config:
        app.config.update(config)
    instance = app.config["INSTANCE_ID"]
    if not re.fullmatch(r"[A-Za-z0-9_-]{1,64}", instance):
        raise ValueError("Invalid INSTANCE_ID")
    deps = dependencies or Dependencies(os.getenv("DATABASE_URL", ""),
                                        os.getenv("REDIS_URL", "redis://redis:6379/0"))
    app.extensions["dependencies"] = deps

    def response(payload, status=200):
        return jsonify(service="barq-api", version=VERSION, instance_id=instance, **payload), status

    @app.before_request
    def begin_request():
        incoming = request.headers.get("X-Request-ID", "")
        g.request_id = incoming if re.fullmatch(r"[A-Za-z0-9_.:-]{1,128}", incoming) else uuid.uuid4().hex
        g.started = time.perf_counter()

    @app.after_request
    def finish_request(result):
        result.headers["X-Instance-ID"] = instance
        result.headers["X-Request-ID"] = g.request_id
        result.headers["Cache-Control"] = "no-store"
        log_event("INFO" if result.status_code < 400 else "WARN", "http_request",
                  instance_id=instance, request_id=g.request_id, method=request.method,
                  path=request.path, status=result.status_code,
                  duration_ms=round((time.perf_counter() - g.started) * 1000, 3))
        return result

    @app.errorhandler(HTTPException)
    def http_error(exc):
        return response({"error": exc.name.lower().replace(" ", "_")}, exc.code)

    def unavailable(name, exc):
        log_event("ERROR", "dependency_error", dependency=name, error_type=type(exc).__name__,
                  request_id=g.request_id, instance_id=instance)
        return response({"error": name + "_unavailable"}, 503)

    @app.get("/")
    def index():
        return response({"message": app.config["APP_MESSAGE"]})

    @app.get("/health")
    def health():
        return response({"status": "alive"})

    @app.get("/instance")
    def identity():
        return response({"status": "ok"})

    @app.get("/ready")
    def ready():
        checks = {}
        for name, check in [("postgres", deps.database_ready), ("redis", deps.redis_ready)]:
            try:
                checks[name] = "ready" if check() else "unavailable"
            except Exception as exc:
                checks[name] = "unavailable"
                log_event("ERROR", "dependency_error", dependency=name, error_type=type(exc).__name__,
                          request_id=g.request_id, instance_id=instance)
        healthy = all(value == "ready" for value in checks.values())
        return response({"status": "ready" if healthy else "not_ready", "dependencies": checks},
                        200 if healthy else 503)

    @app.route("/records", methods=["GET", "POST"])
    def records():
        title = None
        if request.method == "POST":
            body = request.get_json(silent=True)
            title = body.get("title") if isinstance(body, dict) else None
            if not isinstance(title, str) or not 1 <= len(title.strip()) <= 200:
                return response({"error": "title_must_be_1_to_200_characters"}, 400)
        try:
            if request.method == "POST":
                return response({"record": deps.create_record(title.strip())}, 201)
            return response({"records": deps.records()})
        except Exception as exc:
            return unavailable("postgres", exc)

    @app.get("/counter")
    def counter():
        try:
            return response({"counter": deps.counter()})
        except Exception as exc:
            return unavailable("redis", exc)
    return app

if __name__ == "__main__":
    log_event("INFO", "configuration_loaded", database_url=os.getenv("DATABASE_URL", ""),
              redis_url=os.getenv("REDIS_URL", ""))
    create_app().run(host=os.getenv("APP_HOST", "0.0.0.0"),
                     port=int(os.getenv("APP_PORT", "8080")), threaded=True, debug=False)
