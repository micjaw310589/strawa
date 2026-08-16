class TagNameOnlyDto {
  final String name;

  TagNameOnlyDto({required this.name});

  TagNameOnlyDto.fromJson(Map<String, dynamic> json)
  : name = json['name'] as String;
}