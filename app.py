from flask import Flask, render_template, request, redirect, url_for
from flask_sqlalchemy import SQLAlchemy
import os

app = Flask(__name__)

# PostgreSQL environment variables (for Docker Compose setup)
POSTGRES_USER = os.getenv('POSTGRES_USER', 'postgres')
POSTGRES_PW = os.getenv('POSTGRES_PW', 'password')
POSTGRES_URL = os.getenv('POSTGRES_URL', 'localhost:5432')
POSTGRES_DB = os.getenv('POSTGRES_DB', 'todoapp')

app.config['SQLALCHEMY_DATABASE_URI'] = f'postgresql://{POSTGRES_USER}:{POSTGRES_PW}@{POSTGRES_URL}/{POSTGRES_DB}'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

# Model
class Todo(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    task = db.Column(db.String(200), nullable=False)
    complete = db.Column(db.Boolean, default=False)

# Initialize DB (first-time setup or dev use)
with app.app_context():
    db.create_all()

# Routes
@app.route('/')
def index():
    todos = Todo.query.all()
    return render_template('index.html', todo_list=todos)

@app.route('/add', methods=['POST'])
def add():
    task_content = request.form['content']
    if not task_content.strip():
        return redirect(url_for('index'))  # simple validation
    new_task = Todo(task=task_content)
    db.session.add(new_task)
    db.session.commit()
    return redirect(url_for('index'))

@app.route('/update/<int:id>')
def update(id):
    task = Todo.query.get_or_404(id)
    task.complete = not task.complete
    db.session.commit()
    return redirect(url_for('index'))

@app.route('/delete/<int:id>')
def delete(id):
    task_to_delete = Todo.query.get_or_404(id)
    db.session.delete(task_to_delete)
    db.session.commit()
    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
