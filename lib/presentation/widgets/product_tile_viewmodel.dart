import 'package:flutter/material.dart';
import 'package:strawa/domain/dtos/product_list_element_dto.dart';

class ProductTileViewModel extends ChangeNotifier {
  final ProductListElementDto _product;

  ProductTileViewModel({
    required this._product
  });

  ProductListElementDto get product => _product;

  // if it's going to be modified any time in the future,
  // just remember to use notifyListeners()
}