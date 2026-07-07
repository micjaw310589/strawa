import 'package:decimal/decimal.dart';

class Product {
  final String id;
  final String chainId;
  final String name;
  final String? imageUrl;
  final Decimal? price;
  final int? calories;
  final int? proteinG;
  final int? carbohydratesG;
  final int? fatG;
  final int? weightG;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isActive;
  final bool isDeleted;

  Product({
    required this.id,
    required this.chainId,
    required this.name,
    this.imageUrl,
    this.price,
    this.calories,
    this.proteinG,
    this.carbohydratesG,
    this.fatG,
    this.weightG,
    this.createdAt,
    this.updatedAt,
    required this.isActive,
    required this.isDeleted
  });
}