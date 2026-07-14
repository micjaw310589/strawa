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
  final _productService = ProductService();
  late Future<List<ProductListElementDto>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _productService.getProductsForMainList();
  }

  // void _refresh() {
  //   setState(() {
  //     _productsFuture = _productService.getProductsForMainList();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posiłki')),
      body: FutureBuilder(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Błąd: ${snapshot.error}'));
          }
          final products = snapshot.data ?? [];

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) => ProductTile(
              product: products[index],
            ),
          );
        },
      ),
    );
  }
}