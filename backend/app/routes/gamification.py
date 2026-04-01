import os
from flask import Blueprint, jsonify, request
from supabase import create_client, Client
from ..services import fetch_user_by_id, fetch_item_by_id

game_bp = Blueprint("gamification", __name__)

# Initialise supabase project reference variables
SUPABASE_URL = os.environ.get("SUPABASE_URL")
SUPABASE_KEY = os.environ.get("SUPABASE_KEY")

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

LEVEL_CONFIGURATION = [
    {"level": 1, "name": "Starter", "xp": 0},
    {"level": 2, "name": "Verified Member", "xp": 250},
    {"level": 3, "name": "Trusted Seller", "xp": 1000},
    {"level": 4, "name": "Power Seller", "xp": 2000},
    {"level": 5, "name": "Elite Seller", "xp": 4000},
]


@game_bp.route("/levels", methods=["GET"])
def get_levels():
    return jsonify({"data": LEVEL_CONFIGURATION, "status_code": 200})


@game_bp.route("/me/xp", methods=["PATCH"])
def update_xp():
    data = request.get_json()
    # extract xp form the request

    xp = data.get("xp")
    currentLevel = data.get("level")

    if xp is None or currentLevel is None:
        return jsonify(
            {"message": "XP value and level are required", "status_code": 400}
        ), 400

    # TODO: extract user_id from token instead of request body once authentication is working
    user_id = "55d89a2e-d30c-4b20-a51d-6a979ba6b7da"  # for testing uses hardcoded user

    max_level = LEVEL_CONFIGURATION[-1]["level"]

    # only check for a next level if the user is not already at max level
    if currentLevel < max_level:
        nextLevelXP = LEVEL_CONFIGURATION[currentLevel]["xp"]

        # check whether user has reached a new level, if yes, update level
        if xp >= nextLevelXP:
            currentLevel = currentLevel + 1
    else:
        # keep user at max level
        currentLevel = max_level

    try:
        print(f"Attempting to update XP for user {user_id} with XP: {xp}")
        response = (
            supabase.table("profiles")
            .update({"xp": xp, "level": currentLevel})
            .eq("id", user_id)
            .execute()
        )
        print(f"XP updated successfully for user {user_id}. Response: {response}")
        # return the response of the request
        return jsonify(
            {
                "message": "XP updated successfully",
                "status_code": 200,
                "data": {"xp": xp, "level": currentLevel},
            }
        ), 200

    except Exception as e:
        print(f"Error updating XP: {str(e)}")
        return jsonify({"message": "Failed to update XP", "status_code": 400}), 400
