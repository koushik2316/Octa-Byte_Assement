# 📝 Todo-List-Dockerized-Flask-WebApp

This is a simple **Flask** web application for managing TODO tasks, backed by a **PostgreSQL** database and containerized using **Docker**. It's ready for both local development and production deployment via `docker-compose`.

---

## 🚀 Features

- Add and delete tasks
- PostgreSQL for data persistence
- Dockerized with `gunicorn` for production
- `unittest` test coverage
- Compatible with CI/CD pipelines (GitHub Actions)

---

## 🧰 Tech Stack

- Python 3.10 + Flask
- PostgreSQL (local or RDS)
- SQLAlchemy ORM
- Docker / Docker Compose
- Gunicorn (WSGI server)
- GitHub Actions (CI/CD)
- Unit Testing: `unittest`
---

## 🚀 Getting Started

### 1️⃣ Clone the Repo


git clone https://github.com/koushik23n/todo-app.git
cd todo-app


### 2️⃣ Run with Docker Compose 

```bash
docker-compose up --build
```bash

Access the app at: http://localhost:5000

