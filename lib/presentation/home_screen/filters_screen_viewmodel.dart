import 'package:flutter/material.dart';
import 'package:strawa/domain/entities/filters.dart';
import 'package:strawa/locator.dart';
import 'package:strawa/services/chain_service.dart';
import 'package:strawa/services/product_service.dart';
import 'package:strawa/services/tag_service.dart';

class FitlersScreenViewModel extends ChangeNotifier {
  final TagService _tagService = locator<TagService>();
  final ChainService _chainService = locator<ChainService>();
  final ProductService _productService = locator<ProductService>();

  final Function onFiltersApplied;

  late Filters selectedFilters = _productService.filters;

  List<String> tags = [];
  List<String> chains = [];
  List<double> ratings = [3.0, 3.5, 4.0, 4.5, 4.75];
  bool isLoadingTags = false;
  bool isLoadingChains = false;
  String errorMessage = "";

  FitlersScreenViewModel({
    required this.onFiltersApplied
  });
  
  Future<void> loadTagsAndChains() async {
    // set flags for fetch operation status
    isLoadingTags = true;
    isLoadingChains = true;
    errorMessage = "";
    notifyListeners();
    
    // get tags
    try{
      tags = await _tagService.getTagNames();
    }
    catch (e) {
      tags = [];
      if (errorMessage.isNotEmpty) {
        errorMessage += "\nCouldn't retrieve tags: ${e.toString()}";
      }
      else {
        errorMessage = "Couldn't retrieve tags: ${e.toString()}";
      }
    }
    finally {
      isLoadingTags = false;
      notifyListeners();
    }

    // get chains
    try{
      chains = await _chainService.getChainNames();
    }
    catch (e) {
      chains = [];
      if (errorMessage.isNotEmpty) {
        errorMessage += "\nCouldn't retrieve chains: ${e.toString()}";
      }
      else {
        errorMessage = "Couldn't retrieve chains: ${e.toString()}";
      }
    }
    finally {
      isLoadingChains = false;
      notifyListeners();
    }
  }

  void clearFilters() {
    selectedFilters = Filters();
    notifyListeners();

    applyFilters();
  }

  void applyFilters() {
    try {
      _productService.filters = selectedFilters;
    }
    catch(e) {
      errorMessage = "Service failed to set filters: ${e.toString()}";
      notifyListeners();
    }
    onFiltersApplied();
  }

  void addTag(String tag) {
    selectedFilters = selectedFilters.copyWith(tags: [...selectedFilters.tags, tag]);
    notifyListeners();
  }

  void removeTag(String tag) {
    selectedFilters = selectedFilters.copyWith(tags: selectedFilters.tags.where((t) => t != tag).toList());
    notifyListeners();
  }

  void addChain(String chain) {
    selectedFilters = selectedFilters.copyWith(chains: [...selectedFilters.chains, chain]);
    notifyListeners();
  }

  void removeChain(String chain) {
    selectedFilters = selectedFilters.copyWith(chains: selectedFilters.tags.where((c) => c != chain).toList());
    notifyListeners();
  }

  void updatePriceRange(double min, double max) {
    selectedFilters = selectedFilters.copyWith(minPrice: min, maxPrice: max);
    notifyListeners();
  }

  void updateMinRating(double minRating) {
    selectedFilters = selectedFilters.copyWith(minRating: minRating);
    notifyListeners();
  }

  bool isPriceRangeSame(double min, double max) {
    return selectedFilters.minPrice == min && selectedFilters.maxPrice == max;
  }
}