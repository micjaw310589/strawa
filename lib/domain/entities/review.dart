class Review {
  final String id;
  final String productId;
  final int rating;
  final String? androidId;
  final DateTime? createdAt;
  final bool isDeleted;

  Review({
    required this.id,
    required this.productId,
    required this.rating,
    this.androidId,
    this.createdAt,
    required this.isDeleted
  });

  Review.fromJson(Map<String, dynamic> json)
  : id = json['id'] as String,
    productId = json['product_id'] as String,
    rating = json['rating'] as int,
    androidId = json['android_id'] as String,
    createdAt = json['created_at'] as DateTime,
    isDeleted = json['is_deleted'] as bool;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'productId' : productId,
    'rating' : rating,
    'androidId' : androidId,
    'createdAt' : createdAt,
    'isDeleted' : isDeleted
  };

}