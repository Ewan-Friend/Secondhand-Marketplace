import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/header.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int _selectedCategoryIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _apiMessage = 'Checking API Connection...';

  // Placeholder categories
  final List<String> _categories = [
    'Explore', 'Clothing', 'Electronics', 'Home', 'Kids', 'Sports', 'Books & Media', 'Vehicles', 'Hobbies', 'Beauty'
  ];

  // Placeholder product data
  final List<Map<String, dynamic>> _products = [
    {
      'name': 'iPhone 13 Pro',
      'price': '\$799',
      'image': Icons.phone_iphone,
      'condition': 'Like New'
    },
    {
      'name': 'Leather Sofa',
      'price': '\$450',
      'image': Icons.weekend,
      'condition': 'Good'
    },
    {
      'name': 'Winter Jacket',
      'price': '\$85',
      'image': Icons.checkroom,
      'condition': 'Excellent'
    },
    {
      'name': 'MacBook Air',
      'price': '\$650',
      'image': Icons.laptop_mac,
      'condition': 'Very Good'
    },
    {
      'name': 'Gaming Chair',
      'price': '\$200',
      'image': Icons.chair,
      'condition': 'Good'
    },
    {
      'name': 'Bicycle',
      'price': '\$320',
      'image': Icons.pedal_bike,
      'condition': 'Excellent'
    },
  ];

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to different pages based on index
    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        Navigator.pushNamed(context, '/create');
        break;
      case 2:
        // TODO: Navigate to favorites page
        break;
      case 3:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  @override 
  void initState(){
    super.initState();
    // Calls check on API
    _checkApi();
  }

  void _checkApi() async {
    final apiService = APIService();
    final result = await apiService.checkConnection();
    setState(() {
      _apiMessage = result['message'] ?? 'Unknown';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        // top navigation bar
        preferredSize: Size.fromHeight(80),
        child: Header(), 
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              // API connection check, displays message
             Padding(
               padding: const EdgeInsets.all(16.0),
               child: Text(
                  _apiMessage, // the message from APIService
                  style: const TextStyle(
                  color: Colors.red,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Horizontal Category List
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final isSelected = index == _selectedCategoryIndex;

                  return TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedCategoryIndex = index;
                      });
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.only(right: 16, left: 8),
                      minimumSize: const Size(0, 0), // avoid oversized buttons
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      _categories[index],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Featured Items Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Featured Items',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('View all'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Product Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/item');
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
                                color: Colors.grey.shade200,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  _products[index]['image'],
                                  size: 60,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                          ),
                          // Product Details
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _products[index]['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _products[index]['condition'],
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _products[index]['price'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.blue,
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
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Sell',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}