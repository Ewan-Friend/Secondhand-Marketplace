from flask import Blueprint, jsonify, request

reviews_bp = Blueprint("reviews", __name__)


@reviews_bp.route("/reviews", methods=["GET"])
def get_reviews():
    """
    Get reviews for a user.
    Query params: user_id (or 'me' for current user)
    Returns: list of reviews
    """
    user_id = request.args.get("user_id", "me")

    # Mock reviews data
    reviews = [
        {
            "id": "review_1",
            "reviewer_name": "Alice Smith",
            "rating": 5,
            "comment": "Great seller! Item exactly as described.",
            "created_at": "2024-11-01",
        },
        {
            "id": "review_2",
            "reviewer_name": "Bob Johnson",
            "rating": 4,
            "comment": "Good transaction, fast shipping.",
            "created_at": "2024-10-28",
        },
        {
            "id": "review_3",
            "reviewer_name": "Carol Williams",
            "rating": 5,
            "comment": "Excellent communication and product quality!",
            "created_at": "2024-10-15",
        },
    ]

    return jsonify({"data": reviews, "status_code": 200})
