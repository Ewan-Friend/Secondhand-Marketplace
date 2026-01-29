import os
from supabase import create_client, Client

# Initialise supabase project reference variables
SUPABASE_URL = os.environ.get("SUPABASE_URL")
SUPABASE_KEY = os.environ.get("SUPABASE_KEY")

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)


def fetch_user_by_id(user_id):
    # Check that user_id exists first
    if not user_id:
        return None

    try:
        # try build a response with all fields from the "profile" table
        # returns only the profile with the matching user_id
        response = (
            supabase.table("profiles")
            .select(
                "id",
                "created_at",
                "updated_at",
                "usernamelocation",
                "rating_score",
                "rating_count",
                "avatar_urlbio",
            )
            .eq(id, user_id)
            .single()
            .execute
        )

        return response
    except Exception as e:
        print(f"searching for profile returned an error: {e}")
        return None
