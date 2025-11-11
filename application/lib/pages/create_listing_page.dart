import 'package:flutter/material.dart';
import '../widgets/header.dart';

class CreateListingPage extends StatelessWidget {
  const CreateListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Header(), 
      ),
      body: Column(
        children: [
          Center(
            child: Text('Listing Page Content Here'),
          ),
        ],
      ),
    );
  }
}