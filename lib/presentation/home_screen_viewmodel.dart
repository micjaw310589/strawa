import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:strawa/domain/dtos/product_list_element_dto.dart';
import 'package:strawa/locator.dart';
import 'package:strawa/services/product_service.dart';
import 'package:strawa/presentation/widgets/nav_bar_viewmodel.dart';

class HomeScreenViewModel extends ChangeNotifier {
  final _productService = locator<ProductService>();
  final _navBarViewModel = locator<NavBarViewModel>();

  final List<ProductListElementDto> _products = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 1;
  final int _pageLimit;

  HomeScreenViewModel({
    this._pageLimit = 20,
  }) {
    _navBarViewModel.setActiveItem(NavBarItem.home);
  }

  UnmodifiableListView<ProductListElementDto> get products => UnmodifiableListView(_products);
  bool get hasMore => _hasMore;

  Future<void> fetchPage() async {
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
      }

      // add fetched content to page list and notify of the end of operation
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
    await fetchPage();
  }

}