import os
from supabase import create_client, Client

def fetch_user_by_id(supabase_client, user_id):
    # Check that user_id exists first
    if not user_id:
        return None

    try:
        # try build a response with all fields from the "profiles" table
        # returns only the profile with the matching user_id
        response = (
            supabase_client.table("profiles")
            .select(
                "id",
                "created_at",
                "updated_at",
                "username",
                "location",
                "rating_score",
                "rating_count",
                "avatar_url",
                "bio",
            )
            .eq("id", user_id)
            .single()
            .execute()
        ).data

        return response
    except Exception as e:
        print(f"searching for profile returned an error: {e}")
        return None


def fetch_item_by_id(supabase_client, item_id):
    # Check that item_id exists first
    if not item_id:
        return None

    try:
        # try build a response with related from the "item_images" table
        # returns only the profile with the matching item_id
        response = (
            supabase_client.table("items")
            .select(
                "*, item_images(image_url)"
            )
            .eq("id", item_id)
            .single()
            .execute()
        )
        item = response.data

        if not item:
            return None

        seller_id = item.get("seller_id")
        seller_info = fetch_user_by_id(supabase_client, seller_id)

        images = [img.get("image_url") for img in item.get("item_images", [])]

        # Logic stolen from 'routes'
        return  {
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
    except Exception as e:
        print(f"searching for item returned an error: {e}")
        return None
