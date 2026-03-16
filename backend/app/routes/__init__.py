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
