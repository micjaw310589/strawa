import 'package:flutter/material.dart';
import 'package:strawa/domain/dtos/product_list_element_dto.dart';
import 'package:strawa/locator.dart';
import 'package:strawa/presentation/widgets/nav_bar_viewmodel.dart';
import 'package:strawa/services/product_service.dart';

class StrawaDayScreenViewModel extends ChangeNotifier {
  final NavBarViewModel _navBarViewModel = locator<NavBarViewModel>();
  final ProductService _productService = locator<ProductService>();

  ProductListElementDto? _product;
  DateTime? _drawnDate;
  bool _isDrawing = false;
  String? _errorMessage;

  final String title;

  StrawaDayScreenViewModel({this.title = 'Strawa Dnia'}) {
    _navBarViewModel.setActiveItem(NavBarItem.strawaDnia);
  }

  ProductListElementDto? get product => _product;
  bool get isDrawing => _isDrawing;
  String? get errorMessage => _errorMessage;

  bool get hasDrawnProduct {
    return _product != null && _isDrawnToday();
  }

  Future<void> drawRandomProduct() async {
    if (_isDrawing) return;

    _isDrawing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final ProductListElementDto drawnProduct = await _productService
          .getRandomProduct();
      _product = drawnProduct;
      _drawnDate = DateTime.now();
    } catch (_) {
      _errorMessage = 'Nie udało się wylosować produktu. Spróbuj ponownie.';
    } finally {
      _isDrawing = false;
      notifyListeners();
    }
  }

  void resetDraw() {
    _product = null;
    _drawnDate = null;
    _errorMessage = null;
    notifyListeners();
  }

  void clearDrawIfFromPreviousDay() {
    if (_product != null && !_isDrawnToday()) {
      resetDraw();
    }
  }

  bool _isDrawnToday() {
    final DateTime? drawnDate = _drawnDate;
    if (drawnDate == null) return false;

    final DateTime now = DateTime.now();
    return drawnDate.year == now.year &&
        drawnDate.month == now.month &&
        drawnDate.day == now.day;
  }
}
