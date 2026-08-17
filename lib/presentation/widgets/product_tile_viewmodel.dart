import 'package:flutter/material.dart';
import 'package:strawa/domain/dtos/product_list_element_dto.dart';

class ProductTileViewModel extends ChangeNotifier {
  ProductTileViewModel({
    required this._product
  });

  final ProductListElementDto _product;

  ProductListElementDto get product => _product;
}