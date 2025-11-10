import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/item_model.dart';

// Widget that contains the UI needed to represent an 'Item' in the home page 
class ItemCard extends StatelessWidget{
  final Item item;

  // Placeholder no image URL
  static const String noImageUrl = 'https://i.imgur.com/placeholder-no-image.png';

  const ItemCard({super.key, required this.item}); 

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
        child: Column(children: [
          ListTile(
            title: Text(
              item.title,
            ),
          ),
        ],
      ),
    );
  }}