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
}