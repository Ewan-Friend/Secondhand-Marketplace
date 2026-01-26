# Imports
from flask import Flask
from flask_cors import CORS
from .routes import bp

# Creates and configures a new flask app
from flask import Flask, jsonify
from flask_cors import CORS
from .routes import bp   # routes.py içindeki blueprint

def create_app():
    app = Flask(__name__)
    CORS(app)  # Enable CORS for Flutter / frontend

    # Root endpoint (Elastic Beanstalk + tarayıcı için)
    @app.route("/", methods=["GET"])
    def root():
        return jsonify({
            "message": "Backend is running",
            "health": "ok"
        }), 200

    # API routes
    app.register_blueprint(bp, url_prefix="/api")

    return app