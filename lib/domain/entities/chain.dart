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
      logoUrl = json['logoUrl'] as String,
      websiteUrl = json['websiteUrl'] as String,
      createdAt = json['createdAt'] as DateTime,
      isDeleted = json['isDeleted'] as bool;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name' : name,
    'logoUrl' : logoUrl,
    'websiteUrl' : websiteUrl,
    'createdAt' : createdAt,
    'isDeleted' : isDeleted
  };
}