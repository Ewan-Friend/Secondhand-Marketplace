# Imports
from flask import Blueprint, jsonify

# Create a blueprint called 'main'
bp = Blueprint('api', __name__)

# When you visit http://127.0.0.1:5000/hello, flask runs hello message
# @bp.route("/hello")
# def hello():
#     return jsonify({"message": "flask says hello"})


@bp.route("/status", methods=['GET'])
def get_status():
    # A test endpoint for Flutter to connect to
    return jsonify({
        'message': 'Flask backend successfully connected', 
        'status_code': 200
        })