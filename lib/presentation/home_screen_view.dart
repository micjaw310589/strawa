import 'package:flutter/material.dart';
import 'package:strawa/presentation/home_screen_viewmodel.dart';
import 'package:strawa/presentation/widgets/product_tile_view.dart';
import 'package:strawa/presentation/filters_screen_view.dart';
import 'package:strawa/presentation/widgets/product_tile_viewmodel.dart';
import 'package:strawa/services/product_service.dart';
import 'package:strawa/domain/dtos/product_list_element_dto.dart';

class HomeScreenView extends StatefulWidget {
  const HomeScreenView({super.key});

  @override
  State<HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView> {
  late final HomeScreenViewModel _viewModel;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _viewModel = HomeScreenViewModel();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent){
        _viewModel.fetchPage();
      }
    });
    _viewModel.fetchPage();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showFilterPanel() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => FiltersScreenView(),
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
            onPressed: _viewModel.refresh,
            tooltip: 'Odśwież listę produktów',
          ),
        ],
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _viewModel.refresh,
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 8.0, bottom: 80.0),
              itemCount: _viewModel.products.length + (_viewModel.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _viewModel.products.length) {
                  return Center(child: CircularProgressIndicator());
                }
                return ProductTileView(
                    viewModel: ProductTileViewModel(product: _viewModel.products[index])
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
