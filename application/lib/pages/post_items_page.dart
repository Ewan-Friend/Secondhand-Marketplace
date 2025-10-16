import 'package:flutter/material.dart';

class PostItemsPage extends StatelessWidget {
  const PostItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post Items')),
      body: const Center(child: Text('Post Items')),
    );
  }
}
