# Imports
from flask import Blueprint, jsonify, request
from supabase import create_client, Client
import os

# Create a blueprint called 'main'
bp = Blueprint('api', __name__)

# Initialise supabase project reference variables
SUPABASE_URL = os.environ.get("SUPABASE_URL", "https://rakyxzkfdntbmhhjkltp.supabase.co")
SUPABASE_KEY = os.environ.get("SUPABASE_KEY", "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJha3l4emtmZG50Ym1oaGprbHRwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE5MTgwMTQsImV4cCI6MjA3NzQ5NDAxNH0.0YGZOLNn-nSba2B1fXJ4Hevq1zNPw7VIKyiGI2-CeWs")

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

@bp.route("/status", methods=['GET'])
def get_status():
    # A test endpoint for Flutter to connect to
    return jsonify({
        'message': 'Flask backend successfully connected', 
        'status_code': 200
        })

# Gets data attributed to 'items' from supabase
@bp.route("/items", methods=['GET'])
def get_items():
    # Fetch all the items from the table
    # TODO: retrieve and cleanup item images
    response = supabase.table("items").select(
        "id, seller_id, title, created_at, description, rating, price"
    ).order("created_at", desc=True).limit(16).execute()

    data = response.data or []

    items_list = []
    # Cleans up items into named formats
    for item in data:
        items_list.append({
            'id': item.get('id'),
            'seller_id': item.get('seller_id'),
            'title': item.get('title'),
            'created_at': item.get('created_at'),
            'rating': item.get('rating'),
            'price': float(item.get('price')) if item.get('price') else 0.0
        })


    # Return all items and corresponding data
    return jsonify({
        'table_data': items_list,
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
