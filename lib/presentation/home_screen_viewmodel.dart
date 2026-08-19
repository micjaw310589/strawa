import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:strawa/domain/dtos/product_list_element_dto.dart';
import 'package:strawa/services/product_service.dart';

class HomeScreenViewModel extends ChangeNotifier {
  final ProductService _productService;
  List<ProductListElementDto> _products = [];
  int _page = 1;
  final int _pageLimit;

  HomeScreenViewModel({
    required this._productService,
    required this._pageLimit
  });

  UnmodifiableListView<ProductListElementDto> get products => UnmodifiableListView(_products);

  Future<void> _fetchPage() async {
    // TODO: implement page fetch after creating filter panel viewmodel
    throw UnimplementedError();
  }
}