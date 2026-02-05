class Item {
  final String id;
  final String sellerId;
  final String title;
  final double rating;
  final double price;
  final List<String> imageUrls;
  // final String listingDate;

  Item({
    required this.id,
    required this.sellerId,
    required this.title,
    required this.rating, 
    required this.price,
    required this.imageUrls
    // required this.listingDate
  });



  factory Item.fromJson(Map<String, dynamic> json){
    return Item(
      id:           (json['id'] ?? '')  as String,
      sellerId:     (json['seller_id'] ?? '')as String,
      title:        (json['title'] ?? 'Untitled')as String,
      rating:       (json['rating'] as num? ?? 0.0).toDouble(),
      price:        (json['price'] as num? ?? 0.0).toDouble(),
      // Choose between a converted list of strings or (if null) all empty list
      imageUrls:    (json['image_urls'] != null ? List<String>.from(json['image_urls']) : [])
      // listingDate:  json['created_at'] as String,
    );
  }
}