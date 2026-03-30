import os
from flask import Blueprint, jsonify, request
from supabase import create_client, Client

auth_bp = Blueprint("auth", __name__)

# Initialise supabase project reference variables
SUPABASE_URL = os.environ.get("SUPABASE_URL")
SUPABASE_KEY = os.environ.get("SUPABASE_KEY")

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)


@auth_bp.route("/register", methods=["POST"])
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
        return jsonify({"message": "No data provided", "status_code": 400}), 400

    # Extract required fields
    email = data.get("email", "").strip()
    username = data.get("username", "").strip()
    password = data.get("password", "").strip()

    # Validate that all required fields are present and not empty
    if not email or not password:
        return jsonify(
            {"message": "Email and password are required", "status_code": 400}
        ), 400

    if not username:
        return jsonify({"message": "Username is required", "status_code": 400}), 400

    # Hashing passwords directly are not necessary
    # Establish new user in 'Users' table
    try:
        # Call built in Supabase sign_up
        response = supabase.auth.sign_up(
            {"email": email, "password": password},
            # options={
            #     "data":{
            #         "username": username
            #     }
            # }
        )

        # Handles a successful response from supabase
        if response.user:
            return jsonify(
                {
                    "message": "User registered successfully",
                    "status_code": 201,
                    "data": {
                        "email": email,
                        "username": username,
                        # Note: password should never be returned
                    },
                }
            )

        # Default behaviour:
        return jsonify(
            {"message": "Registration initiated. Please check your email."}
        ), 202

    except Exception as e:
        # Handle errors from supabase, this is things such as weak passwords or duplocate emails
        error_message = str(e)

        # Handles the exact error messages that Supabase returns
        if "duplicate key value violates unique constraint" in error_message:
            return jsonify({"message": "Email already registered."}), 409

        # Default error response
        return jsonify({"message": f"Registration failed: {error_message}"}), 400

    # TODO: Check for duplicate email/username in database (Issue 4)
    # TODO: Hash password before storing (Issue 4)
    # TODO: Save user to database (Issue 4)

    # For now, return success response
    # In Issue 4, this will actually save to database
    return jsonify(
        {
            "message": "User registered successfully",
            "status_code": 201,
            "data": {
                "email": email,
                "username": username,
                # Note: password should never be returned
            },
        }
    ), 201
