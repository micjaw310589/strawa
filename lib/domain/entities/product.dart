import 'package:decimal/decimal.dart';

class Product {
  final String id;
  final String chainId;
  final String name;
  final String? imageUrl;
  final Decimal? price;
  final int? calories;
  final Decimal? proteinG;
  final Decimal? carbohydratesG;
  final Decimal? fatG;
  final Decimal? weightG;
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

  Product.fromJson(Map<String, dynamic> json)
  : id = json['id'] as String,
    chainId = json['chain_id'] as String,
    name = json['name'] as String,
    imageUrl = json['image_url'] as String,
    price = Decimal.parse(json['price'].toString()),
    calories = json['calories'] as int,
    proteinG = Decimal.parse(json['protein_g'].toString()),
    carbohydratesG = Decimal.parse(json['carbohydrates_g'].toString()),
    fatG = Decimal.parse(json['fat_g'].toString()),
    weightG = Decimal.parse(json['weight_g'].toString()),
    createdAt = json['created_at'] as DateTime,
    updatedAt = json['updated_at'] as DateTime,
    isActive = json['is_active'] as bool,
    isDeleted = json['is_deleted'] as bool;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'chain_id' : chainId,
    'name' : name,
    'image_url' : imageUrl,
    'price' : price,
    'calories' : calories,
    'protein_g' : proteinG,
    'carbohydrates_g' : carbohydratesG,
    'fat_g' : fatG,
    'weight_g' : weightG,
    'created_at' : createdAt,
    'updated_at' : updatedAt,
    'is_active' : isActive,
    'is_deleted' : isDeleted
  };
}