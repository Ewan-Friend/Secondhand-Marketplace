import os
from flask import Blueprint, jsonify, request
from supabase import create_client, Client
from ..services import fetch_user_by_id

users_bp = Blueprint("users", __name__)

# Initialise supabase project reference variables
SUPABASE_URL = os.environ.get("SUPABASE_URL")
SUPABASE_KEY = os.environ.get("SUPABASE_KEY")

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)


@users_bp.route("/profile/<uuid:user_id>", methods=["GET"])
def get_user_profile(user_id):
    user_profile = fetch_user_by_id(supabase, str(user_id))

    if not user_profile:
        return jsonify({"message": "profile could not be found", "status_code": 404})

    return jsonify({"table_data": user_profile, "status_code": 200})


@users_bp.route("/me", methods=["GET"])
def get_current_user():
    """
    Get current authenticated user's profile information.
    Returns: user profile data
    """
    # Get user_id from Authorization header or session
    # For now, using mock data - in production, extract from JWT token
    auth_header = request.headers.get("Authorization", "")

    # Mock user data - in production, fetch from database based on user_id from token
    user_data = {
        "id": "user_123",
        "email": "john@gmail.com",
        "display_name": "John Doe",
        "location": "Bristol, UK",
        "avatar_url": None,
        "rating": 4.7,
        "review_count": 23,
        "joined_date": "2024-04-15",
        "verified": True,
    }

    return jsonify({"data": user_data, "status_code": 200})


@users_bp.route("/me", methods=["PATCH"])
def update_current_user():
    """
    Update current authenticated user's profile information.
    Accepts: display_name, location, avatar_url in JSON body
    Returns: updated user data
    """
    data = request.get_json()

    if not data:
        return jsonify({"message": "No data provided", "status_code": 400}), 400

    # Extract fields
    display_name = data.get("display_name", "").strip()
    location = data.get("location", "").strip()
    avatar_url = data.get("avatar_url", "").strip()

    # Validate display_name
    if display_name and len(display_name) > 40:
        return jsonify(
            {
                "message": "Display name must be 40 characters or less",
                "status_code": 400,
            }
        ), 400

    # TODO: Update user in database based on user_id from token

    # Mock updated user data
    updated_user = {
        "id": "user_123",
        "email": "john@gmail.com",
        "display_name": display_name or "John Doe",
        "location": location or "Bristol, UK",
        "avatar_url": avatar_url or None,
        "rating": 4.7,
        "review_count": 23,
        "joined_date": "2024-04-15",
        "verified": True,
    }

    return jsonify(
        {
            "message": "Profile updated successfully",
            "data": updated_user,
            "status_code": 200,
        }
    )
