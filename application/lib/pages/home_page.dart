import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/header.dart';
import '../widgets/user_widget.dart';
import '../widgets/item_widget.dart';
import '../models/item_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedCategoryIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  
  // --- DYNAMIC STATE ---
  final APIService _apiService = APIService(); 
  late Future<List<Item>> _futureItems;
  String _apiMessage = 'Checking API connection...';

  // Placeholder categories
  final List<String> _categories = [
    'Explore', 'Clothing', 'Electronics', 'Home', 'Kids', 'Sports', 'Books & Media', 'Vehicles', 'Hobbies', 'Beauty'
  ];

  @override 
    void initState(){
      super.initState();
      // Start fetching item data immediately
      _futureItems = _apiService.getItems(); 
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
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: PreferredSize(
        // top navigation bar
        preferredSize: Size.fromHeight(80),
        child: Header(showSearch: true), 
      ),
      body: SingleChildScrollView(
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

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
              child: FutureBuilder<List<Item>>(
                future: _futureItems, // Your API call initialized in initState
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No items found'));
                  }

                  final items = snapshot.data!;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 500, // max width per card
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.76, // Matches your design ratio
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      // This replaces the manual GestureDetector/Card block
                      return ItemCard(item: items[index]);
                    },
                  );
                },
              ),
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