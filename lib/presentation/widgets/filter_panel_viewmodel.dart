import 'package:flutter/material.dart';
import 'package:strawa/domain/dtos/product_list_element_dto.dart';
import 'package:strawa/domain/entities/filters.dart';
import 'package:strawa/services/chain_service.dart';
import 'package:strawa/services/product_service.dart';
import 'package:strawa/services/tag_service.dart';

class FilterPanelViewModel extends ChangeNotifier {
  final TagService _tagService = TagService();
  final ChainService _chainService = ChainService();

  List<String> _availableTags = [];
  bool _isLoadingTags = false;
  List<String> _availableChains = [];
  bool _isLoadingChains = false;
  String _errorMessage = "";

  late Filters _selectedFilters;

  final Function(Filters filters) onFiltersApplied;

  FilterPanelViewModel({
    required Filters initialFilters,
    required this.onFiltersApplied
  }) : 
    _selectedFilters = initialFilters;
  

  Future<void> _loadAvailableTagsAndChains() async {
    // set flags for fetch operation status
    _isLoadingTags = true;
    _isLoadingChains = true;
    _errorMessage = "";
    notifyListeners();
    
    // get tags
    try{
      _availableTags = await _tagService.getTagNames();
    }
    catch (e) {
      _availableTags = [];
      if (_errorMessage.isNotEmpty) {
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

    // get chains
    try{
      _availableChains = await _chainService.getChainNames();
    }
    catch (e) {
      _availableChains = [];
      if (_errorMessage.isNotEmpty) {
        _errorMessage += "\nCouldn't retrieve chains: ${e.toString()}";
      }
      else {
        _errorMessage = "Couldn't retrieve chains: ${e.toString()}";
      }
    }
    finally {
      _isLoadingChains = false;
      notifyListeners();
    }
  }

  void _clearFilters() {
      _selectedFilters = Filters();
  }

  void _applyFilters() {
    onFiltersApplied(
      _selectedFilters
    );
  }
}