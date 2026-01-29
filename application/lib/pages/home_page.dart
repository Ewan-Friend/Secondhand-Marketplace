import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/header.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedCategoryIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  // --- API HEALTH CHECK STATE ---
  final APIService _apiService = APIService();
  String _apiMessage = 'Checking backend...';

  // Placeholder categories
  final List<String> _categories = [
    'Explore',
    'Clothing',
    'Electronics',
    'Home',
    'Kids',
    'Sports',
    'Books & Media',
    'Vehicles',
    'Hobbies',
    'Beauty'
  ];

  @override
  void initState() {
    super.initState();
    _checkApi();
  }

  Future<void> _checkApi() async {
    try {
      final message = await _apiService.checkConnection(); // <-- returns String
      setState(() {
        _apiMessage = message;
      });
    } catch (e) {
      setState(() {
        _apiMessage = 'Backend error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Header(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Backend status banner
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                _apiMessage,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
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
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final isSelected = index == _selectedCategoryIndex;

                  return TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedCategoryIndex = index;
                      });
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      _categories[index],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // ✅ Placeholder 
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Items will load here (Commit 4).',
                style: TextStyle(fontSize: 14),
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