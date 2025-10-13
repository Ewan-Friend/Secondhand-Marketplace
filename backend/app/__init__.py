# Imports
from flask import Flask
from .routes import bp

# Creates and configures a new flask app
def create_app():
    app = Flask(__name__)
    app.register_blueprint(bp)
    return app