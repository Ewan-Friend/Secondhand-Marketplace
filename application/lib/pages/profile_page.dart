import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ProfilePage extends StatefulWidget {
  final String? userId; // If null, shows current user's profile
  final bool isOwnProfile; // True if viewing own profile

  const ProfilePage({
    super.key,
    this.userId,
    this.isOwnProfile = true,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final APIService _apiService = APIService();
  
  bool _isLoading = true;
  bool _showAllReviews = false;
  
  Map<String, dynamic>? _userData;
  List<dynamic> _userListings = [];
  List<dynamic> _userFavorites = [];
  List<dynamic> _userReviews = [];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    setState(() => _isLoading = true);

    try {
      // Load user profile
      final profileResponse = await _apiService.getCurrentUserProfile();
      if (profileResponse['data'] != null) {
        _userData = profileResponse['data'];
      }

      // Load user listings
      if (_userData != null && _userData!['id'] != null) {
        final itemsResponse = await _apiService.getUserItems(_userData!['id']);
        if (itemsResponse['table_data'] != null) {
          _userListings = itemsResponse['table_data'];
        }

        // Load reviews
        final reviewsResponse = await _apiService.getUserReviews(_userData!['id']);
        if (reviewsResponse['data'] != null) {
          _userReviews = reviewsResponse['data'];
        }
      }

      // Add mock listings if empty (for demo purposes)
      if (_userListings.isEmpty) {
        _userListings = [
          {
            'id': '1',
            'title': 'Vintage Camera',
            'price': 150.0,
            'status': 'Like New',
            'location': 'Redland, Bristol, UK',
          },
          {
            'id': '2',
            'title': 'Leather Jacket',
            'price': 85.0,
            'status': 'Good',
            'location': 'Redland, Bristol, UK',
          },
          {
            'id': '3',
            'title': 'Gaming Laptop',
            'price': 650.0,
            'status': 'Excellent',
            'location': 'Redland, Bristol, UK',
          },
          {
            'id': '4',
            'title': 'Coffee Table',
            'price': 45.0,
            'status': 'Good',
            'location': 'Redland, Bristol, UK',
          },
          {
            'id': '5',
            'title': 'Bicycle',
            'price': 120.0,
            'status': 'Very Good',
            'location': 'Redland, Bristol, UK',
          },
          {
            'id': '6',
            'title': 'Desk Lamp',
            'price': 25.0,
            'status': 'Like New',
            'location': 'Redland, Bristol, UK',
          },
        ];
      }

      // Mock favorites for demo purposes
      _userFavorites = [
        {
          'id': 'fav1',
          'title': 'Wireless Headphones',
          'price': 95.0,
          'status': 'Excellent',
          'location': 'Clifton, Bristol, UK',
          'seller_name': 'Emma Wilson',
          'seller_rating': 4.8,
          'seller_reviews': 45,
        },
        {
          'id': 'fav2',
          'title': 'Yoga Mat',
          'price': 20.0,
          'status': 'Like New',
          'location': 'Redland, Bristol, UK',
          'seller_name': 'Sarah Jones',
          'seller_rating': 4.5,
          'seller_reviews': 28,
        },
        {
          'id': 'fav3',
          'title': 'Running Shoes',
          'price': 55.0,
          'status': 'Good',
          'location': 'Southville, Bristol, UK',
          'seller_name': 'Mike Brown',
          'seller_rating': 4.3,
          'seller_reviews': 19,
        },
        {
          'id': 'fav4',
          'title': 'Office Chair',
          'price': 110.0,
          'status': 'Very Good',
          'location': 'Cotham, Bristol, UK',
          'seller_name': 'Lisa Davis',
          'seller_rating': 4.9,
          'seller_reviews': 52,
        },
        {
          'id': 'fav5',
          'title': 'Kitchen Blender',
          'price': 35.0,
          'status': 'Excellent',
          'location': 'Bishopston, Bristol, UK',
          'seller_name': 'Tom Harris',
          'seller_rating': 4.6,
          'seller_reviews': 31,
        },
        {
          'id': 'fav6',
          'title': 'Winter Coat',
          'price': 75.0,
          'status': 'Like New',
          'location': 'Clifton, Bristol, UK',
          'seller_name': 'Amy Clark',
          'seller_rating': 4.7,
          'seller_reviews': 38,
        },
      ];

    } catch (e) {
      print('Error loading profile: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const Icon(Icons.location_on, color: Color(0xFFFF7B7B), size: 20),
            const SizedBox(width: 4),
            Text(
              _userData?['location']?.split(',').first ?? 'Bristol, UK',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadProfileData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileHeader(),
            const SizedBox(height: 24),
                    _buildLocationAndRating(),
                    const SizedBox(height: 32),
                    _buildListingsSection(),
                    const SizedBox(height: 32),
                    if (_userFavorites.isNotEmpty) ...[
                      _buildFavoritesSection(),
                      const SizedBox(height: 32),
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: _userData?['avatar_url'] != null
                ? NetworkImage(_userData!['avatar_url'])
                : null,
            child: _userData?['avatar_url'] == null
                ? Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.grey.shade600,
                  )
                : null,
          ),
          const SizedBox(width: 20),
          
          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userData?['display_name'] ?? 'Full Name',
                  style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
                const SizedBox(height: 4),
                Text(
                  '@${_userData?['email']?.split('@').first ?? 'user_name_291'}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
                // Show verified badge (always visible for testing)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: Colors.green.shade200,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified,
                        size: 14,
                        color: Colors.green.shade700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Verified Seller',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Edit Profile / Message button
          widget.isOwnProfile
              ? ElevatedButton(
                  onPressed: _showEditProfileDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                )
              : ElevatedButton(
                  onPressed: () {
                    // Handle message action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7B7B),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Message',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildLocationAndRating() {
    final rating = _userData?['rating']?.toDouble() ?? 4.12;
    final reviewCount = _userData?['review_count'] ?? _userReviews.length;
    
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location section
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Location',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Color(0xFFFF7B7B),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _userData?['location'] ?? 'Redland, Bristol',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
            Text(
                            'BS6, United Kingdom',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 24),
          
          // Rating section
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rating',
              style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              rating.toStringAsFixed(2),
                              style: const TextStyle(
                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            _buildStarRating(rating),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'posting for 7 months',
                          style: TextStyle(
                            fontSize: 12,
                color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 24),
                    // Show reviews button (always visible for testing)
                    TextButton(
                      onPressed: () {
                        setState(() => _showAllReviews = !_showAllReviews);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        _showAllReviews ? 'Hide reviews' : 'Show reviews',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Reviews section (for other user's profile)
          if (!widget.isOwnProfile && _showAllReviews && _userReviews.isNotEmpty)
            Expanded(
              flex: 3,
              child: _buildReviewsList(),
            ),
        ],
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor() ? Icons.star : Icons.star_border,
          size: 16,
          color: const Color(0xFFFF7B7B),
        );
      }),
    );
  }

  Widget _buildReviewsList() {
    final reviewsToShow = _showAllReviews ? _userReviews : _userReviews.take(3).toList();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...reviewsToShow.map((review) => _buildReviewItem(review)).toList(),
          if (_userReviews.length > 3)
            TextButton(
              onPressed: () {
                setState(() => _showAllReviews = !_showAllReviews);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(_showAllReviews ? 'Show less' : 'Show all reviews'),
            ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(Map<String, dynamic> review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey.shade300,
                child: Icon(Icons.person, size: 16, color: Colors.grey.shade600),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['reviewer_name'] ?? 'Buyer Name',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      review['location'] ?? 'Bristol, UK',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ...List.generate(5, (index) {
                return Icon(
                  index < (review['rating'] ?? 5) ? Icons.star : Icons.star_border,
                  size: 12,
                  color: const Color(0xFFFF7B7B),
                );
              }),
              const SizedBox(width: 8),
              Text(
                review['created_at'] ?? '2 weeks ago',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            review['comment'] ?? '',
            style: const TextStyle(fontSize: 12),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildListingsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.isOwnProfile ? 'My Listings' : 'Listings',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _userListings.isEmpty
              ? Container(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Text(
                      'No listings yet',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _userListings.length,
                  itemBuilder: (context, index) {
                    final item = _userListings[index];
                    return GestureDetector(
                      onTap: () {
                        // Navigate to item detail
                      },
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Image Placeholder
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(Icons.image, size: 50, color: Colors.grey),
                                ),
                              ),
                            ),
                            // Product Details
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Item name and price
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item['title'] ?? 'Item Name',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        'CHF ${item['price']?.toStringAsFixed(0) ?? '200'}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Color(0xFFFF7B7B),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  // Location
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        size: 12,
                                        color: Color(0xFFFF7B7B),
                                      ),
                                      const SizedBox(width: 2),
                                      Expanded(
                                        child: Text(
                                          _userData?['location'] ?? 'Redland, Bristol, UK',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey.shade600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  // Condition badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      item['status'] ?? 'Condition',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildFavoritesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Favourites',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.85,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _userFavorites.length,
            itemBuilder: (context, index) {
              final item = _userFavorites[index];
              return GestureDetector(
                onTap: () {
                  // Navigate to item detail
                },
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image Placeholder with favorite icon
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                              ),
                              child: const Center(
                                child: Icon(Icons.image, size: 50, color: Colors.grey),
                              ),
                            ),
                            // Favorite icon
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () {
                                  // Remove from favorites
                                  setState(() {
                                    _userFavorites.removeAt(index);
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Removed from favorites'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.favorite,
                                    color: Color(0xFFFF7B7B),
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Product Details
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Item name and price
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    item['title'] ?? 'Item Name',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  'CHF ${item['price']?.toStringAsFixed(0) ?? '200'}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color(0xFFFF7B7B),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            // Location
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 12,
                                  color: Color(0xFFFF7B7B),
                                ),
                                const SizedBox(width: 2),
                                Expanded(
                                  child: Text(
                                    item['location'] ?? 'Redland, Bristol, UK',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            // Seller info
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 8,
                                  backgroundColor: Colors.grey.shade300,
                                  child: Icon(
                                    Icons.person,
                                    size: 10,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    item['seller_name'] ?? 'User Name',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const Icon(
                                  Icons.star,
                                  size: 10,
                                  color: Color(0xFFFF7B7B),
                                ),
                                Text(
                                  ' ${item['seller_rating']?.toStringAsFixed(1) ?? '4.1'}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _userData?['display_name']);
    final locationController = TextEditingController(text: _userData?['location']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Display Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Update profile
              final result = await _apiService.updateUserProfile(
                displayName: nameController.text,
                location: locationController.text,
              );

              if (result['data'] != null) {
                setState(() {
                  _userData = result['data'];
                });
              }

              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF7B7B),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
