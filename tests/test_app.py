import unittest
from app import app, db

class BasicTestCase(unittest.TestCase):
    def setUp(self):
        self.app = app.test_client()
        with app.app_context():
            db.create_all()

    def tearDown(self):
        with app.app_context():
            db.drop_all()

    def test_homepage(self):
        response = self.app.get('/')
        self.assertEqual(response.status_code, 200)

if __name__ == "__main__":
    unittest.main()