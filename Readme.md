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

```bash
git clone https://github.com/koushik23n/todo-app.git
cd todo-app


2️⃣ Run with Docker Compose 

 docker-compose up --build


 Access the app at: http://localhost:5000


---

🐳 Docker Setup (Manual)
Build and Run Docker Container

docker build -t todolist-flask .
docker run -d -p 5000:5000 \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PW=password \
  -e POSTGRES_URL=<RDS_OR_DB_HOST>:5432 \
  -e POSTGRES_DB=todoapp \
  todolist-flask

⚙️ Environment Variables
Variable	Default	Description
POSTGRES_USER	postgres	DB username
POSTGRES_PW	password	DB password
POSTGRES_URL	db:5432	Host:port of PostgreSQL
POSTGRES_DB	todoapp	Database name
