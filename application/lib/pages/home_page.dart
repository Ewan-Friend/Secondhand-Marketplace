import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/header.dart';
import '../widgets/user_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedCategoryIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  
  // --- DYNAMIC STATE ---
  //final APIService _apiService = APIService(); 
  String _apiMessage = 'Checking API connection...';

  // Placeholder categories
  final List<String> _categories = [
    'Explore', 'Clothing', 'Electronics', 'Home', 'Kids', 'Sports', 'Books & Media', 'Vehicles', 'Hobbies', 'Beauty'
  ];

  // Placeholder product data
  final List<Map<String, dynamic>> _products = [
    {
      'name': 'iPhone 13 Pro',
      'price': 'CHF 799',
      'image': Icons.phone_iphone,
      'condition': 'Like New',
      'location' : 'Bristol, UK'
    },
    {
      'name': 'Leather Sofa',
      'price': 'CHF 250',
      'image': Icons.weekend,
      'condition': 'Good',
      'location' : 'Bristol, UK'
    },
    {
      'name': 'Winter Jacket',
      'price': 'CHF 85',
      'image': Icons.checkroom,
      'condition': 'Excellent',
      'location' : 'Cheltenham, UK'
    },
    {
      'name': 'MacBook Air',
      'price': 'CHF 650',
      'image': Icons.laptop_mac,
      'condition': 'Very Good',
      'location' : 'Bath, UK'
    },
    {
      'name': 'Gaming Chair',
      'price': 'CHF 200',
      'image': Icons.chair,
      'condition': 'Good',
      'location' : 'Bristol, UK'
    },
    {
      'name': 'Bicycle',
      'price': 'CHF 320',
      'image': Icons.pedal_bike,
      'condition': 'Excellent',
      'location' : 'Bristol, UK'
    },
  ];

  @override 
  void initState(){
    super.initState();
    // Calls check on API
    _checkApi();
  }

  
  void _checkApi() async {
    final apiService = APIService();

    try {
      final result = await apiService.checkConnection();
      setState(() {
        _apiMessage = result['message'] ?? 'Unknown response';
      });
    } catch (e) {
      setState(() {
        _apiMessage = 'Error: $e';
      });
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
                separatorBuilder: (_,_) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final isSelected = index == _selectedCategoryIndex;

                  return TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedCategoryIndex = index;
                      });
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.only(right: 16, left: 16),
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

            // Product Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: 
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 500, // max width per card
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.76, // width / height ratio of each card
                  ),
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {Navigator.pushNamed(context, '/item');},
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 400,
                        ),
                        child: Card(
                          elevation: 0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image
                              AspectRatio(
                                aspectRatio: 1.2, // slightly wider than tall
                                child: Container(
                                  color: Colors.grey.shade300,
                                  child: Center(
                                    child: Icon(
                                      _products[index]['image'],
                                      size: 60,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                ),
                              ),
                              // Description — fits inside fixed card height
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _products[index]['name'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500, fontSize: 22),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                          _products[index]['price'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400, fontSize: 20),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.location_on,
                                                size: 16, color: Color(0xFFE36D6D)),
                                            const SizedBox(width: 4),
                                            Text(
                                              _products[index]['location'] ?? 'Unknown',
                                              style: TextStyle(
                                                  fontSize: 14, color: Colors.grey.shade700),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.sell,
                                                size: 16, color: Color(0xFFE36D6D)),
                                            const SizedBox(width: 4),
                                            Text(
                                              _products[index]['condition'] ?? 'Unknown',
                                              style: TextStyle(
                                                  fontSize: 14, color: Colors.grey.shade700),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    UserWidget(
                                      userName: "Markus Aurelius",
                                      rating: 4.84,
                                      reviews: 23,
                                      avatarUrl: null,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}