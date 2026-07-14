import 'package:flutter/material.dart';
import 'package:strawa/domain/dtos/product_list_element_dto.dart';

class ProductTile extends StatelessWidget {
  final ProductListElementDto product;

  const ProductTile({
    super.key,
    required this.product
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      product.name,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
    );
  } 
}