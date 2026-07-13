class Tag {
  final String id;
  final String name;
  final bool isDeleted;

  Tag({
    required this.id,
    required this.name,
    required this.isDeleted
  });

  Tag.fromJson(Map<String, dynamic> json)
  : id = json['id'] as String,
    name = json['name'] as String,
    isDeleted = json['is_deleted'] as bool;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name' : name,
    'isDeleted' : isDeleted
  };

}