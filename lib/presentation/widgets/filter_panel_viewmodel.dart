import 'package:flutter/material.dart';
import 'package:strawa/domain/dtos/product_list_element_dto.dart';
import 'package:strawa/domain/entities/filters.dart';
import 'package:strawa/services/chain_service.dart';
import 'package:strawa/services/product_service.dart';
import 'package:strawa/services/tag_service.dart';

class FilterPanelViewModel extends ChangeNotifier {
  final ProductService _productService;
  final TagService _tagService = TagService();
  final ChainService _chainService = ChainService();

  List<String> _availableTags = [];
  bool _isLoadingTags = false;
  List<String> _availableChains = [];
  bool _isLoadingChains = false;
  String _errorMessage = "";

  final Filters _initialFilters; 
  late Filters _selectedFilters;

  final Function(List<ProductListElementDto>, List<String>, List<String>, double, double, double) onFiltersApplied;

  FilterPanelViewModel({
    required this._productService,
    required this._initialFilters,
    required this.onFiltersApplied
  });
  

  Future<void> _loadAvailableTagsAndChains() async {
    // powiadom że pobierasz dane z bazy
    _isLoadingTags = true;
    _isLoadingChains = true;
    _errorMessage = "";
    notifyListeners();
    
    // pobierz tagi
    try{
      _availableTags = await _tagService.getTagNames();
    }
    catch (e) {
      _availableTags = [];
      if (_errorMessage != "") {
        _errorMessage += "\nCouldn't retrieve tags: ${e.toString()}";
      }
      else {
        _errorMessage = "Couldn't retrieve tags: ${e.toString()}";
      }
    }
    finally {
      _isLoadingTags = false;
      notifyListeners();
    }

    // pobierz chainy
    try{
      _availableChains = await _chainService.getChainNames();
    }
    on Exception {
      _availableChains = [];
    }
    finally {
      _isLoadingChains = false;
      notifyListeners();
    }
  }

}