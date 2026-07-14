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

  Chain.fromJson(Map<String, dynamic> json)
    : id = json['id'] as String,
      name = json['name'] as String,
      logoUrl = json['logo_url'] as String,
      websiteUrl = json['website_url'] as String,
      createdAt = json['created_at'] as DateTime,
      isDeleted = json['is_deleted'] as bool;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name' : name,
    'logo_url' : logoUrl,
    'website_url' : websiteUrl,
    'created_at' : createdAt,
    'is_deleted' : isDeleted
  };
}