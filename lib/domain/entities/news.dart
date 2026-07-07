class News {
  final String id;
  final String title;
  final String content;
  final String? imageUrl;
  final DateTime? publishedAt;
  final bool isActive;
  final bool isDeleted;

  News({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    this.publishedAt,
    required this.isActive,
    required this.isDeleted
  });
}