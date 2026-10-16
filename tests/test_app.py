"""App-only contract checks, not Docker/NGINX or real-dependency validation."""
import unittest
from app.server import create_app

class FakeDependencies:
    def __init__(self):
        self.rows, self.count = [], 0
        self.database_up = self.redis_up = True
    def database_ready(self):
        if not self.database_up:
            raise ConnectionError("simulated PostgreSQL failure")
        return True
    def redis_ready(self):
        if not self.redis_up:
            raise ConnectionError("simulated Redis failure")
        return True
    def records(self):
        self.database_ready()
        return self.rows
    def create_record(self, title):
        self.database_ready()
        row = {"id": len(self.rows) + 1, "title": title}
        self.rows.append(row)
        return row
    def counter(self):
        self.redis_ready()
        self.count += 1
        return self.count

class ContractTests(unittest.TestCase):
    def setUp(self):
        self.deps = FakeDependencies()
        self.client = create_app({"TESTING": True, "INSTANCE_ID": "test-instance"}, self.deps).test_client()
    def test_root_identity_and_headers(self):
        for path in ["/", "/instance"]:
            response = self.client.get(path, headers={"X-Request-ID": "test-123"})
            self.assertEqual(response.status_code, 200)
            self.assertEqual(response.json["instance_id"], "test-instance")
            self.assertEqual(response.headers["X-Instance-ID"], "test-instance")
            self.assertEqual(response.headers["X-Request-ID"], "test-123")
    def test_liveness_independent_of_dependencies(self):
        self.deps.database_up = self.deps.redis_up = False
        self.assertEqual(self.client.get("/health").status_code, 200)
        response = self.client.get("/ready")
        self.assertEqual(response.status_code, 503)
        self.assertEqual(set(response.json["dependencies"].values()), {"unavailable"})
    def test_readiness_checks_each_dependency(self):
        self.assertEqual(self.client.get("/ready").status_code, 200)
        self.deps.database_up = False
        self.assertEqual(self.client.get("/ready").status_code, 503)
        self.deps.database_up, self.deps.redis_up = True, False
        self.assertEqual(self.client.get("/ready").status_code, 503)
    def test_create_and_list(self):
        response = self.client.post("/records", json={"title": "  demo  "})
        self.assertEqual(response.status_code, 201)
        self.assertEqual(response.json["record"]["title"], "demo")
        self.assertEqual(self.client.get("/records").json["records"], [response.json["record"]])
    def test_invalid_records(self):
        for data in [{}, {"title": ""}, {"title": 2}, {"title": "x" * 201}, []]:
            self.assertEqual(self.client.post("/records", json=data).status_code, 400)
    def test_counter_increases(self):
        self.assertEqual(self.client.get("/counter").json["counter"], 1)
        self.assertEqual(self.client.get("/counter").json["counter"], 2)
    def test_failures_are_503(self):
        self.deps.database_up = self.deps.redis_up = False
        for path in ["/records", "/counter"]:
            self.assertEqual(self.client.get(path).status_code, 503)
        self.assertEqual(self.client.post("/records", json={"title": "test"}).status_code, 503)
    def test_unknown_and_head(self):
        self.assertEqual(self.client.get("/missing").status_code, 404)
        self.assertEqual(self.client.head("/health").data, b"")

if __name__ == "__main__":
    unittest.main()