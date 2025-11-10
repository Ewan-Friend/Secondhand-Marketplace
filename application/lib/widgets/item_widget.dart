import 'package:application/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/item_model.dart';

// Widget that contains the UI needed to represent an 'Item' in the home page 
class ItemCard extends StatelessWidget{
  final Item item;

  // Placeholder no image URL
  static const String noImageUrl = 'hhttps://rakyxzkfdntbmhhjkltp.supabase.co/storage/v1/object/public/item_images/noimage.jpeg';

  const ItemCard({
    super.key, 
    required this.item
    }); 

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Image Area
          Expanded(
            child: Ink.image(
              // TODO: implement image into item_model, currently at placeholder
              image: NetworkImage(noImageUrl),
              fit: BoxFit.cover,
              child: InkWell(
                onTap: () {
                  // Navigate to item detail page, passing item.id
                  Navigator.pushNamed(
                    context,
                    '/item',
                    arguments: item.id
                  );
                },
              ),
            ),
          ),
          
          // 2. Details Area (Title, Price)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis, // Prevents text overflow
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  }