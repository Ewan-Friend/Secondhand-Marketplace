def test_example():
    """Basic test to verify pytest works"""
    assert 1 + 1 == 2

def test_addition():
    """Another simple test"""
    result = 2 + 2
    assert result == 4

def test_string():
    """Test string operations"""
    text = "hello"
    assert text.upper() == "HELLO"