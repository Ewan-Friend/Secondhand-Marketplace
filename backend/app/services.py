import os
from supabase import create_client, Client


def fetch_user_by_id(supabase_client, user_id):
    # Check that user_id exists first
    if not user_id:
        return None

    try:
        # try build a response with all fields from the "profile" table
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
