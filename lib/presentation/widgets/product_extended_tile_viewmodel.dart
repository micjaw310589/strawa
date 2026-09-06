import 'package:flutter/material.dart';
import 'package:strawa/domain/dtos/product_list_element_dto.dart';

class ProductExtendedTileViewModel extends ChangeNotifier {
  final ProductListElementDto _product;

  ProductExtendedTileViewModel({required this._product});

  ProductListElementDto get product => _product;

}
