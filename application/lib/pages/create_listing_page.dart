import 'package:flutter/material.dart';

class CreateListingPage extends StatelessWidget {
  const CreateListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post a Listing')),
      body: const Center(child: Text('Create Listing Page')),
    );
  }
}