class Item {
  final String id;
  final String sellerId;
  final String title;
  final double rating;
  final double price;
  // final String listingDate;

  Item({
    required this.id,
    required this.sellerId,
    required this.title,
    required this.rating, 
    required this.price,
    // required this.listingDate
  });

  factory Item.fromJson(Map<String, dynamic> json){
    return Item(
      id:           (json['id'] ?? '')  as String,
      sellerId:     (json['seller_id'] ?? '')as String,
      title:        (json['title'] ?? 'Untitled')as String,
      rating:       (json['rating'] as num).toDouble(),
      price:        (json['price'] as num).toDouble(),
      // listingDate:  json['created_at'] as String,
    );
  }
}