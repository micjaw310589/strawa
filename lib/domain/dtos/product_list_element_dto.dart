import 'package:decimal/decimal.dart';

class ProductListElementDto {
  final String id;
  final String name;
  final String? imageUrl;
  final Decimal? price;
  final String chainName;
  final double reviewRatingAvg;
  final List<String> tagNames;

  ProductListElementDto({
    required this.id,
    required this.name,
    this.imageUrl,
    this.price,
    required this.chainName,
    required this.reviewRatingAvg,
    required this.tagNames
  });

  ProductListElementDto.fromJson(Map<String, dynamic> json, double avg)
  : id = json['id'] as String,
    name = json['name'] as String,
    imageUrl = json['image_url'] as String,
    price = Decimal.parse(json['price'].toString()),
    chainName = json['chains']['name'] as String,
    reviewRatingAvg = avg,
    tagNames = (json['tags'] as List).map((tag) => tag['name'] as String).toList();
    
}