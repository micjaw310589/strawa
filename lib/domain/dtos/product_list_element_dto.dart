import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

@immutable
class ProductListElementDto {
  final String id;
  final String name;
  final String? imageUrl;
  final Decimal? price;
  final String chainName;
  final double reviewRatingAvg;
  final List<String> tagNames;

  const ProductListElementDto({
    required this.id,
    required this.name,
    this.imageUrl,
    this.price,
    required this.chainName,
    required this.reviewRatingAvg,
    required this.tagNames
  });

  ProductListElementDto.fromJson(Map<String, dynamic> json)
  : id = json['id'] as String,
    name = json['name'] as String,
    imageUrl = json['image_url'] as String,
    price = Decimal.parse(json['price'].toString()),
    chainName = json['chains']['name'] as String,
    reviewRatingAvg = (json['average_rating'] as num?)?.toDouble() ?? 0.0,
    tagNames = (json['tags'] as List).map((tag) => tag['name'] as String).toList();
    
}