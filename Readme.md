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

### Clone the Repo
```bash
# clone the repo into your local host
$ git clone https://github.com/koushik2316/Octa-Byte_Assement
$ cd  Octa-Byte_Assement
```
### To Run Locally with Docker Compose 
```bash
$ docker-compose up --build

#Access the app at: http://localhost:5000
```

### 💻 To Run Locally (Without Docker)
  ## Create a Virtual Environment & Install Dependencies
``` bash
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

pip install -r requirements.txt
```
### Set Up PostgreSQL Database
```bash
# Make sure PostgreSQL is installed and running. Create a database and set environment variables:

# Example for local setup
export POSTGRES_USER=postgres
export POSTGRES_PW=password
export POSTGRES_URL=localhost:5432
export POSTGRES_DB=todoapp
```
### Run the App
```bash
$ python app.py