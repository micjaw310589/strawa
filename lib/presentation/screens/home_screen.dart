import 'package:flutter/material.dart';
import 'package:strawa/presentation/widgets/product_tile.dart';
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

      List<ProductListElementDto> nextPage = await _productService.getProductsForMainList(page: _page, pageSize: _pageLimit);
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
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
          itemCount: _products.length + (_hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _products.length) {
              return Center(child: CircularProgressIndicator());
            }
            return ProductTile(
                product: _products[index],
            );
          }
        )
      ),
    );
  }
}
