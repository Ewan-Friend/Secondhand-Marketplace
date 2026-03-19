import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/header.dart';
import '../widgets/item_widget.dart';
import '../models/item_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.apiService});

  final APIService? apiService;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  late APIService _apiService;
  late Future<List<Item>> _futureItems;
  String _apiMessage = 'Checking API connection...';

  @override
  void initState() {
    super.initState();
    _apiService = widget.apiService ?? APIService();
    _futureItems = _apiService.getItems();
    _checkApi();
  }

  Future<void> _checkApi() async {
    try {
      final message = await _apiService.checkConnection(); // <-- String dönüyor
      if (!mounted) return;
      setState(() {
        _apiMessage = message;
      });
    } catch (e) {
      if (!mounted) return;
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
        preferredSize: const Size.fromHeight(80),
        child: Header(),// not show search and back button on home page
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // API message (debug)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _apiMessage,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Items grid from API
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: FutureBuilder<List<Item>>(
                future: _futureItems,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final items = snapshot.data ?? [];
                  if (items.isEmpty) {
                    return const Center(child: Text('No items found'));
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 400,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.76,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
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