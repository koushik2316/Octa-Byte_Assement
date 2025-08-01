from flask import Flask, render_template, request, redirect, url_for
from flask_sqlalchemy import SQLAlchemy
import logging
import os

app = Flask(__name__, template_folder='../templates')

# Set up basic logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s [%(levelname)s] %(name)s: %(message)s'
)
logger = logging.getLogger(__name__)

# Environment variables for PostgreSQL connection
DB_USER = os.getenv('DB_USER', 'postgres')
DB_PASSWORD = os.getenv('DB_PASSWORD', 'password')
DB_HOST = os.getenv('DB_HOST', 'localhost')
DB_PORT = os.getenv('DB_PORT', '5432')
DB_NAME = os.getenv('DB_NAME', 'todoapp')

app.config['SQLALCHEMY_DATABASE_URI'] = f'postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

# Model
class Todo(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    task = db.Column(db.String(200), nullable=False)
    complete = db.Column(db.Boolean, default=False)

# Initialize DB (used in test/dev environments)
with app.app_context():
    db.create_all()

# Routes
@app.route('/')
def index():
    logger.info("Accessed home route")
    todos = Todo.query.all()
    return render_template('index.html', todo_list=todos)

@app.route('/add', methods=['POST'])
def add():
    task_content = request.form['content']
    if not task_content.strip():
        logger.warning("Empty task submitted")
        return redirect(url_for('index'))
    new_task = Todo(task=task_content)
    db.session.add(new_task)
    db.session.commit()
    logger.info(f"Added task: {task_content}")
    return redirect(url_for('index'))

@app.route('/update/<int:id>')
def update(id):
    task = Todo.query.get_or_404(id)
    task.complete = not task.complete
    db.session.commit()
    logger.info(f"Updated task {id} to complete={task.complete}")
    return redirect(url_for('index'))

@app.route('/delete/<int:id>')
def delete(id):
    task_to_delete = Todo.query.get_or_404(id)
    db.session.delete(task_to_delete)
    db.session.commit()
    logger.info(f"Deleted task {id}")
    return redirect(url_for('index'))

if __name__ == '__main__':
    logger.info("Starting Flask TODO App...")
    app.run(host='0.0.0.0', port=5000)
