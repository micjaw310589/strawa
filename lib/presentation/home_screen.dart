import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import 'package:strawa/presentation/widgets/product_tile_view.dart';
import 'package:strawa/presentation/widgets/filter_panel.dart';
import 'package:strawa/presentation/widgets/product_tile_viewmodel.dart';
import 'package:strawa/services/product_service.dart';
import 'package:strawa/domain/dtos/product_list_element_dto.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();
  final _productService = ProductService();
  List<ProductListElementDto> _products = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 1;
  final int _pageLimit = 20;

  // Filter state
  List<String> _selectedTags = [];
  List<String> _selectedChains = [];
  double _minPrice = 0.0;
  double _maxPrice = 100.0;
  double _minRating = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent){
        _fetchPage();
      }
    });
    _fetchPage();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    _page = 1;
    _hasMore = true;
    _products.clear();
    await _fetchPage();
  }

  Future<void> _fetchPage() async {
    if (!_isLoading && _hasMore){
      setState(() {
        _isLoading = true;
      });

      List<ProductListElementDto> nextPage = await _productService.getProductsForMainList(
        page: _page,
        pageSize: _pageLimit,
        tagNames: _selectedTags,
        chainNames: _selectedChains,
        minPrice: Decimal.fromInt(_minPrice.toInt()),
        maxPrice: Decimal.fromInt(_maxPrice.toInt()),
        minRating: _minRating,
      );
      if (!mounted) return;

      if (nextPage.length < _pageLimit) {
        setState(() {
          _hasMore = false;
        });
      }

      setState(() {
        _products.addAll(nextPage);
        _isLoading = false;
        _page++;
      });
    }
  }

  void _showFilterPanel() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => FilterPanel(
        initialTags: _selectedTags,
        initialChains: _selectedChains,
        initialMinPrice: _minPrice,
        initialMaxPrice: _maxPrice,
        initialMinRating: _minRating,
        onFiltersApplied: (filteredProducts, selectedTags, selectedChains, minPrice, maxPrice, minRating) {
          setState(() {
            _products = filteredProducts;
            _selectedTags = selectedTags;
            _selectedChains = selectedChains;
            _minPrice = minPrice;
            _maxPrice = maxPrice;
            _minRating = minRating;
            _page = 1;
            _hasMore = filteredProducts.length == _pageLimit;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Strawa',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
            tooltip: 'Odśwież listę produktów',
          ),
        ],
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 8.0, bottom: 80.0),
              itemCount: _products.length + (_hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _products.length) {
                  return Center(child: CircularProgressIndicator());
                }
                return ProductTileView(
                    viewModel: ProductTileViewModel(product: _products[index])
                );
              }
            )
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _showFilterPanel,
              backgroundColor: Colors.blue,
              child: const Icon(Icons.filter_list, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
