from flask import Blueprint, jsonify

health_bp = Blueprint("health", __name__)


@health_bp.route("/status", methods=["GET"])
def get_status():
    # A test endpoint for Flutter to connect to
    return jsonify(
        {"message": "Flask backend successfully connected", "status_code": 200}
    )
