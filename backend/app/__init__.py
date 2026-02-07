# Imports
from flask import Flask
from flask_cors import CORS
from dotenv import load_dotenv
import os

load_dotenv()

from .routes import bp


# Creates and configures a new flask app
from flask import Flask, jsonify
from flask_cors import CORS
from .routes import bp  # routes.py içindeki blueprint


def create_app():
    app = Flask(__name__)
    CORS(app)  # Enable CORS for routes to establish connection with Flutter

    app.register_blueprint(bp, url_prefix="/api")
    return app
