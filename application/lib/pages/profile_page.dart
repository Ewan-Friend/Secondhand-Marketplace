import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/header.dart';
import '../widgets/item_widget.dart';
import '../models/item_model.dart';

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

    // hardcode userID for testing
    final userID = widget.userId ?? '55d89a2e-d30c-4b20-a51d-6a979ba6b7da';

    try {
      // Fetch full profile for the chosen id so `_userData` has avatar/name/location
      try {
        final profileResponse = await _apiService.getUserById(userID);
        if (profileResponse != null) {
          if (profileResponse['table_data'] != null) {
            _userData = Map<String, dynamic>.from(profileResponse['table_data']);
          } else if (profileResponse['data'] != null) {
            _userData = Map<String, dynamic>.from(profileResponse['data']);
          } else if (profileResponse is Map<String, dynamic>) {
            _userData = profileResponse;
          }
        }
      } catch (_) {
        _userData = {'id': userID};
      }

      // Load user listings for the chosen id
      final itemsResponse = await _apiService.getUserItems(userID);
      if (itemsResponse['table_data'] != null) {
        _userListings = itemsResponse['table_data'];
      }

      // Load reviews for the chosen id
      final reviewsResponse = await _apiService.getUserReviews(userID);
      if (reviewsResponse['data'] != null) {
        _userReviews = reviewsResponse['data'];
      }
      



    } catch (e) {
      print('Error loading profile: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      appBar: PreferredSize(
        // top navigation bar
        preferredSize: Size.fromHeight(80),
        child: Header(showSearch: false), 
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
      color: Theme.of(context).colorScheme.surface,
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
                  _userData?['username'] ?? 'Full Name',
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
      color: Theme.of(context).colorScheme.surface,
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
                        foregroundColor: Theme.of(context).colorScheme.onSurface,
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
          color: Theme.of(context).colorScheme.primary,
        );
      }),
    );
  }

  Widget _buildReviewsList() {
    final reviewsToShow = _showAllReviews ? _userReviews : _userReviews.take(3).toList();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
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
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 360,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.76,
                  ),
                  itemCount: _userListings.length,
                  itemBuilder: (context, index) {
                    final raw = _userListings[index];
                    final item = _toItem(raw);
                    return ItemCard(item: item);
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
              final raw = _userFavorites[index];
              final item = _toItem(raw);
              return ItemCard(item: item);
            },
          ),
        ],
      ),
    );
  }

  // Helper to convert dynamic/map data into an `Item` object for ItemCard
  Item _toItem(dynamic raw) {
    if (raw is Item) return raw;
    final map = Map<String, dynamic>.from(raw as Map);

    if (!map.containsKey('seller_info')) {
      map['seller_info'] = {
        'username': map['seller_name'] ?? 'Seller',
        'rating_score': map['seller_rating'] ?? 0.0,
        'rating_count': map['seller_reviews'] ?? 0,
        'avatar_url': map['seller_avatar'] ?? null,
      };
    }

    if (!map.containsKey('image_urls')) {
      map['image_urls'] = [];
    }

    // Ensure numeric types are consistent
    if (map['price'] is String) {
      map['price'] = double.tryParse(map['price']) ?? 0.0;
    }

    return Item.fromJson(map);
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
