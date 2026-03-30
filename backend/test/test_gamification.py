import pytest
from unittest.mock import patch, MagicMock
from app import create_app

def test_update_xp_success(client):
    """Test PATCH /me/xp endpoint with valid XP"""
    with patch("app.routes.gamification.supabase") as mock_supabase:
        mock_supabase.table.return_value.update.return_value.eq.return_value.execute.return_value = MagicMock()
        
        response = client.patch("/api/me/xp", json={"xp": 300, "level": 2})
        data = response.get_json()
        
        assert response.status_code == 200
        assert data["status_code"] == 200
        assert "XP updated successfully" in data["message"]
        assert data["data"]["xp"] == 300
        assert data["data"]["level"] == 2


def test_update_xp_level_2(client):
    # Test XP 250 gives level 2
    with patch("app.routes.gamification.supabase") as mock_supabase:
        mock_supabase.table.return_value.update.return_value.eq.return_value.execute.return_value = MagicMock()
        
        response = client.patch("/api/me/xp", json={"xp": 250, "level": 1})
        data = response.get_json()
        
        assert response.status_code == 200
        assert data["data"]["level"] == 2


def test_update_xp_level_3(client):
    # Test XP 1500 gives level 3
    with patch("app.routes.gamification.supabase") as mock_supabase:
        mock_supabase.table.return_value.update.return_value.eq.return_value.execute.return_value = MagicMock()
        
        response = client.patch("/api/me/xp", json={"xp": 1500, "level": 2})
        data = response.get_json()
        
        assert response.status_code == 200
        assert data["data"]["level"] == 3


def test_update_xp_level_4(client):
    # Test XP 2500 gives level 4
    with patch("app.routes.gamification.supabase") as mock_supabase:
        mock_supabase.table.return_value.update.return_value.eq.return_value.execute.return_value = MagicMock()
        
        response = client.patch("/api/me/xp", json={"xp": 2500, "level": 3})
        data = response.get_json()
        
        assert response.status_code == 200
        assert data["data"]["level"] == 4


def test_update_xp_level_5_max(client):
    # Test XP 5000 gives max level 5
    with patch("app.routes.gamification.supabase") as mock_supabase:
        mock_supabase.table.return_value.update.return_value.eq.return_value.execute.return_value = MagicMock()
        
        response = client.patch("/api/me/xp", json={"xp": 5000, "level": 4})
        data = response.get_json()
        
        assert response.status_code == 200
        assert data["data"]["level"] == 5


def test_update_xp_missing_xp_level_value(client):
    # Test missing XP and level returns 400
    response = client.patch("/api/me/xp", json={})
    data = response.get_json()
    
    assert response.status_code == 400
    assert "XP value and level are required" in data["message"]


def test_update_xp_null_xp_value(client):
    # Test null XP and level returns 400
    response = client.patch("/api/me/xp", json={"xp": None, "level": None})
    data = response.get_json()
    
    assert response.status_code == 400
    assert "XP value and level are required" in data["message"]


def test_update_xp_database_error(client):
    # Test database error handling
    with patch("app.routes.gamification.supabase") as mock_supabase:
        mock_supabase.table.return_value.update.return_value.eq.return_value.execute.side_effect = Exception(
            "Database connection error"
        )
        
        response = client.patch("/api/me/xp", json={"xp": 300, "level": 2})
        data = response.get_json()
        
        assert response.status_code == 400
        assert "Failed to update XP" in data["message"]