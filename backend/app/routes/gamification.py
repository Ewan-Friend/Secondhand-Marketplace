import os
from flask import Blueprint, jsonify, request
from supabase import create_client, Client
from ..services import fetch_user_by_id, fetch_item_by_id

game_bp = Blueprint("gamification", __name__)


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
    nextLevelXP = LEVEL_CONFIGURATION[currentLevel]["xp"]
    print(f"current level: {currentLevel}")
    print(f"new XP: {xp}")
    print(f"nextXP for level {currentLevel+1}: {nextLevelXP}")

    # TODO: extract user_id from token instead of request body once authentication is working
    user_id = '55d89a2e-d30c-4b20-a51d-6a979ba6b7da'    # for testing uses hardcoded user
    
    # check whether user has reached a new level, if yes, update level
    if xp >= nextLevelXP:
        currentLevel = currentLevel + 1

    if xp is None:
        return jsonify({"message": "XP value is required", "status_code": 400}), 400

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
        return jsonify({
            "message": "XP updated successfully", 
            "status_code": 200
            }), 200
    
    except Exception as e:
        print(f"Error updating XP: {str(e)}")
        return jsonify({
            "message": "Failed to update XP",
              "status_code": 400
              }), 400