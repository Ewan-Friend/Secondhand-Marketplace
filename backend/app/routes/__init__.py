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
