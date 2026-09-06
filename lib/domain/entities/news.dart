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

  News.fromJson(Map<String, dynamic> json)
  : id = json['id'] as String,
    title = json['title'] as String,
    content = json['content'] as String,
    imageUrl = json['imageUrl'] as String,
    publishedAt = json['publishedAt'] as DateTime,
    isActive = json['isActive'] as bool,
    isDeleted = json['isDeleted'] as bool;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'title' : title,
    'content' : content,
    'imageUrl' : imageUrl,
    'publishedAt' : publishedAt,
    'isActive' : isActive,
    'isDeleted' : isDeleted
  };

}