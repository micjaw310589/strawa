import 'package:flutter/material.dart';
import 'package:strawa/domain/entities/enums/sort_product_enum.dart';
import 'package:strawa/locator.dart';
import 'package:strawa/services/product_service.dart';

class SortingScreenViewModel extends ChangeNotifier {
  final ProductService _productService = locator<ProductService>();

  final Map<SortProduct, String> options = {
    SortProduct.byPrice: 'Cena',
    SortProduct.byRating: 'Ocena',
    SortProduct.byProductsName: 'Nazwa produktu',
    SortProduct.byChainsName: 'Nazwa sieci',
    SortProduct.byCalories: 'Kalorie',
    SortProduct.byCarbs: 'Węglowodany',
    SortProduct.byProtein: 'Białko',
    SortProduct.byFat: 'Tłuszcz',
    SortProduct.byWeight: 'Masa',
    SortProduct.byRatingToPrice: 'Stosunek ocena/cena',
    SortProduct.byProteinToPrice: 'Stosunek białko/cena',
    SortProduct.byWeightToPrice: 'Stosunek masa/cena',
  };

  final Map<bool, String> order = {
    true : 'Rosnąco',
    false : 'Malejąco'
  };

  final Function onSortingApplied;
  late SortProduct selectedOption = _productService.sortBy;
  late bool selectedOrder = _productService.sortAscending;

  SortingScreenViewModel({
    required this.onSortingApplied
  });
  
  void resetToDefault() {
    selectedOption = ProductService.defaultSortBy;
    selectedOrder = ProductService.defaultSortAscending;

    notifyListeners();
  }

  void applyFilters() {
    _productService.sortBy = selectedOption;
    _productService.sortAscending = selectedOrder;

    onSortingApplied();
  }

}