import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

  // Simply returns the no image symbol
  Widget _placeholderImage() {
    return Image.network(noImageUrl);
  }

  // Simply builds the image from the corresponding Supabase link
  Widget buildImage(){
    if (item.imageUrls.isNotEmpty){
      return Image.network(item.imageUrls[0],
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _placeholderImage(),
      );
    }
    else{
      return _placeholderImage();
    }
  }

  // Format pricing (currency, decimals, etc.)
  String _priceFormat() {
    if (item.price == 0) return 'Free';
    return '£${item.price.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/item/${item.id}', arguments: item.id);},
        //context.go('/item/${item.id}'),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 400,
        ),
        child: Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ~~~~~ IMAGE~~~~~
              AspectRatio(
                aspectRatio: 1.2, 
                child: buildImage(),
              ),
              // ~~~~~ ALL OF THE DETAILS ~~~~~
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          // ~~~~~ TITLE ~~~~~
                          child: Text(
                            //Use item title
                            item.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          // ~~~~~ LOCATION ~~~~~
                          children: [
                            Icon(Icons.location_on,
                                        size: 16, color: Theme.of(context).colorScheme.primary),
                            SizedBox(width: 4),
                            Text(
                              item.location,
                              style: TextStyle(
                                  fontSize: 14, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8)),
                            ),
                          ],
                        ),
                        Row(
                          // ~~~~~ CONDITION ~~~~~~~
                          children: [
                            Icon(Icons.sell,
                              size: 16, color: Theme.of(context).colorScheme.primary),
                            SizedBox(width: 4),
                            Text(
                              item.condition,
                              style: TextStyle(
                                  fontSize: 14, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Seller Info Section with price aligned to the right
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: UserWidget(
                            userName: item.sellerInfo["username"],
                            rating: item.sellerInfo["rating_score"],
                            reviews: item.sellerInfo["rating_count"],
                            avatarUrl: item.sellerInfo["avatar_url"],
                          ),
                        ),
                        // Price on the same row as seller info
                        Text(
                          _priceFormat(),
                            style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18),
                        ),
                      ],
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