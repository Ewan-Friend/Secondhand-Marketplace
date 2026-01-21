import 'package:application/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/item_model.dart';
import '../widgets/user_widget.dart';

// Widget that contains the UI needed to represent an 'Item' in the home page 
class ItemCard extends StatelessWidget{
  final Item item;

  // Placeholder no image URL
  static const String noImageUrl = 'https://rakyxzkfdntbmhhjkltp.supabase.co/storage/v1/object/public/item_images/noimage.jpeg';

  const ItemCard({
      super.key, 
      required this.item
    }); 

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/item', arguments: item.id);
      },
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
              // ~~~~~ IMAGE~~~~~
              AspectRatio(
                aspectRatio: 1.2, 
                child: Container(
                  color: Colors.grey.shade300,
                  child: Center(
                    child: Icon(
                      // Placeholder image, holding default for icons so far
                      Icons.image,
                      size: 60,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
              // ~~~~~ ALL OF THE DETAILS ~~~~~
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          // ~~~~~ TITLE ~~~~~
                          child: Text(
                            item.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // ~~~~~ PRICE ~~~~~
                        Text(
                          'CHF ${item.price.toString()}',
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
                          // ~~~~~ LOCATION ~~~~~
                          children: [
                            const Icon(Icons.location_on,
                                size: 16, color: Color(0xFFE36D6D)),
                            const SizedBox(width: 4),
                            Text(
                              'location not implemented',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                        Row(
                          // ~~~~~ CONDITION ~~~~~
                          children: [
                            const Icon(Icons.sell,
                                size: 16, color: Color(0xFFE36D6D)),
                            const SizedBox(width: 4),
                            Text(
                              'condition not added',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Seller Info Section
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
  }
  }