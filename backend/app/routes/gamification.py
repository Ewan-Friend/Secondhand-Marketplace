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

@bp.route("/levels", methods=["GET"])
def get_levels():
    return jsonify({"data": LEVEL_CONFIGURATION, "status_code": 200})
