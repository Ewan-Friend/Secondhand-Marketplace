# Imports
from flask import Blueprint, jsonify, request

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


@bp.route("/register", methods=['POST'])
def register_user():
    """
    Register a new user endpoint.
    Accepts: email, username, password in JSON body
    Returns: success message or error message
    """
    # Get JSON data from request
    data = request.get_json()
    
    # Validate that data exists
    if not data:
        return jsonify({
            'message': 'No data provided',
            'status_code': 400
        }), 400
    
    # Extract required fields
    email = data.get('email', '').strip()
    username = data.get('username', '').strip()
    password = data.get('password', '').strip()
    
    # Validate that all required fields are present and not empty
    if not email:
        return jsonify({
            'message': 'Email is required',
            'status_code': 400
        }), 400
    
    if not username:
        return jsonify({
            'message': 'Username is required',
            'status_code': 400
        }), 400
    
    if not password:
        return jsonify({
            'message': 'Password is required',
            'status_code': 400
        }), 400
    
    # Basic email validation (simple check for @ symbol)
    if '@' not in email or '.' not in email.split('@')[1]:
        return jsonify({
            'message': 'Invalid email format',
            'status_code': 400
        }), 400
    
    # Basic password validation (minimum length)
    if len(password) < 6:
        return jsonify({
            'message': 'Password must be at least 6 characters',
            'status_code': 400
        }), 400
    
    # TODO: Check for duplicate email/username in database (Issue 4)
    # TODO: Hash password before storing (Issue 4)
    # TODO: Save user to database (Issue 4)
    
    # For now, return success response
    # In Issue 4, this will actually save to database
    return jsonify({
        'message': 'User registered successfully',
        'status_code': 201,
        'data': {
            'email': email,
            'username': username
            # Note: password should never be returned
        }
    }), 201
