class Chain {
  final String id;
  final String name;
  final String? logoUrl;
  final String? websiteUrl;
  final DateTime? createdAt;
  final bool isDeleted;

  Chain({
    required this.id,
    required this.name,
    this.logoUrl,
    this.websiteUrl,
    this.createdAt,
    required this.isDeleted
  });
}