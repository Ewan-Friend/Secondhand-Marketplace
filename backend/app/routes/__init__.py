# Imports
from flask import Blueprint, jsonify, request
from supabase import create_client, Client
from ..services import fetch_user_by_id, fetch_item_by_id
import os

# Create a blueprint called 'main'
bp = Blueprint("api", __name__)

# Initialise supabase project reference variables
SUPABASE_URL = os.environ.get("SUPABASE_URL")
SUPABASE_KEY = os.environ.get("SUPABASE_KEY")

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)


# Gets data attributed to 'items' from supabase
@bp.route("/items", methods=["GET"])
def get_items():
    # Get query parameters for filtering
    # status = request.args.get('status')  # 'active' or None
    # sold = request.args.get('sold')  # 'true' or None
    user_id = request.args.get("user_id")  # filter by user

    # Start building query
    # Limit number of fetched items to 128 as to not overload (if the app ever scales that high)
    query = (
        supabase.table("items")
        .select(
            "id, seller_id, title, created_at, description, condition, rating, price, item_images(image_url)"
        )
        .limit(128)
    )

    # Apply filters based on query parameters
    # if status == 'active':
    #     query = query.eq('status', 'active')

    # if sold == 'true':
    #     query = query.eq('sold', True)
    # elif sold == 'false':
    #     query = query.eq('sold', False)

    if user_id:
        query = query.eq("seller_id", user_id)

    # Execute query
    response = query.order("created_at", desc=True).limit(32).execute()
    data = response.data or []

    items_list = []
    # Cleans up items into named formats
    for item in data:
        seller_id = item.get("seller_id")
        seller_info = fetch_user_by_id(supabase, seller_id)

        # Create a list of image URLS
        images = [img.get("image_url") for img in item.get("item_images", [])]

        items_list.append(
            {
                "id": item.get("id"),
                "seller_id": item.get("seller_id"),
                "seller_info": seller_info,
                "title": item.get("title"),
                "created_at": item.get("created_at"),
                "description": item.get("description"),
                "condition": item.get("condition"),
                "rating": float(item.get("rating")) if item.get("rating") else 0.0,
                "price": float(item.get("price")) if item.get("price") else 0.0,
                "image_urls": images,
                # 'status': item.get('status', 'active'),
                # 'sold': item.get('sold', False)
            }
        )

    # Return all items and corresponding data
    return jsonify({"table_data": items_list, "status_code": 200})


@bp.route("/profile/<uuid:user_id>", methods=["GET"])
def get_user_profile(user_id):
    user_profile = fetch_user_by_id(supabase, str(user_id))

    if not user_profile:
        return jsonify({"message": "profile could not be found", "status_code": 404})

    return jsonify({"table_data": user_profile, "status_code": 200})


@bp.route("/item/<uuid:item_id>", methods=["GET"])
def get_item(item_id):
    item = fetch_item_by_id(supabase, str(item_id))

    if not item:
        return jsonify({"message": "item could not be found", "status_code": 404})

    return jsonify({"table_data": item, "status_code": 200}), 200


@bp.route("/items", methods=["POST"])
def post_item():
    # TODO: add categories
    MISCELLANEOUS_PLACEHOLDER = "37d39021-f90e-4c62-9be4-2723864e3ceb"
    # Get the JSON data from the request
    data = request.get_json()

    # Validate that data exists
    if not data:
        return jsonify({"message": "No data provided", "status_code": 400}), 400

    # Extract required fields from frontend
    title = data.get("title", "").strip()
    description = data.get("description", "").strip()
    price = data.get("price")
    seller_id = data.get("seller_id")
    condition = data.get("condition")
    # image_urls = data.get("image_urls", [])

    # Validate required fields
    if not title or price is None or not seller_id:
        # Insert item into Supabase
        return jsonify(
            {
                "message": "Missing required fields: title, price, seller_id",
                "status_code": 400,
            }
        ), 400

    if not description:
        description = "no description has been provided for this item"

    if not condition:
        condition = "no condition"

    print("c: ", condition)

    try:
        print(
            f"Attempting to insert item: title={title}, price={price}, seller_id={seller_id}"
        )
        # Insert item into Supabase
        response = (
            supabase.table("items")
            .insert(
                {
                    "title": title,
                    "description": description,
                    "rating": 0.0,
                    "price": float(price),
                    "seller_id": seller_id,
                    "condition": condition,
                    "category_id": MISCELLANEOUS_PLACEHOLDER,
                }
            )
            .execute()
        )

        print("created response")

        return jsonify(
            {
                "message": "Item posted successfully",
                "status_code": 201,
                "data": response.data,
            }
        ), 201
    except Exception as e:
        print(f"Error posting item: {str(e)}")  # This will show the actual error
        print(f"Error type: {type(e)}")
        import traceback

        traceback.print_exc()
        return jsonify(
            {"message": f"Failed to post item: {str(e)}", "status_code": 400}
        ), 400


@bp.route("/register", methods=["POST"])
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


@bp.route("/me", methods=["GET"])
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


@bp.route("/me", methods=["PATCH"])
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
