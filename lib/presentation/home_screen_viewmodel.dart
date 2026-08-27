import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:strawa/domain/dtos/product_list_element_dto.dart';
import 'package:strawa/services/product_service.dart';

class HomeScreenViewModel extends ChangeNotifier {
  final _productService = ProductService();
  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 1;
  final int _pageLimit;

  final List<ProductListElementDto> _products = [];
  UnmodifiableListView<ProductListElementDto> get products => UnmodifiableListView(_products);

  HomeScreenViewModel({
    this._pageLimit = 20,
  });


  Future<void> fetchPageContent() async {
    if (!_isLoading && _hasMore) {
      // tell the view you are loading content
      _isLoading = true;
      notifyListeners();

      // fetch next page
      List<ProductListElementDto> nextPage = await _productService.getProductsForMainList(
        page: _page,
        pageSize: _pageLimit
      );

      // if less content than page limit, then there's no more to load
      if (nextPage.length < _pageLimit){
        _hasMore = false;
        notifyListeners();
      }

      // add fetched content to page list
      _products.addAll(nextPage);
      _isLoading = false;
      _page++;
      notifyListeners();
    }
  }
  
  Future<void> refresh() async {
    _page = 1;
    _hasMore = true;
    _products.clear();
    await fetchPageContent();
  }

}