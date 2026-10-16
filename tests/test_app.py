"""Unit tests that run without PostgreSQL or Redis (fake dependencies)."""
import pytest
from app.server import create_app


class FakeDeps:
    def __init__(self):
        self._records = [{"id": 1, "title": "seed"}]
        self._counter = 0

    def database_ready(self):
        return True

    def redis_ready(self):
        return True

    def records(self):
        return list(self._records)

    def create_record(self, title):
        rec = {"id": len(self._records) + 1, "title": title}
        self._records.append(rec)
        return rec

    def counter(self):
        self._counter += 1
        return self._counter


@pytest.fixture()
def client():
    app = create_app(config={"INSTANCE_ID": "test-pod"}, dependencies=FakeDeps())
    return app.test_client()


def test_index(client):
    r = client.get("/")
    assert r.status_code == 200
    assert r.get_json()["service"] == "barq-api"


def test_health(client):
    assert client.get("/health").get_json()["status"] == "alive"


def test_ready(client):
    r = client.get("/ready")
    assert r.status_code == 200
    assert r.get_json()["dependencies"] == {"postgres": "ready", "redis": "ready"}


def test_instance_header(client):
    assert client.get("/instance").headers["X-Instance-ID"] == "test-pod"


def test_records_create_and_list(client):
    r = client.post("/records", json={"title": "from test"})
    assert r.status_code == 201
    titles = [x["title"] for x in client.get("/records").get_json()["records"]]
    assert "from test" in titles


def test_records_rejects_empty_title(client):
    assert client.post("/records", json={"title": "   "}).status_code == 400


def test_counter_increments(client):
    assert client.get("/counter").get_json()["counter"] == 1
    assert client.get("/counter").get_json()["counter"] == 2
