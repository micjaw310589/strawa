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

  Future<void> _refresh() async {
    setState(() {
      _productsFuture = _productService.getProductsForMainList();
    });
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
        child: FutureBuilder(
          future: _productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Wystąpił błąd: ${snapshot.error}',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _refresh,
                      child: const Text('Spróbuj ponownie'),
                    ),
                  ],
                ),
              );
            }

            final products = snapshot.data ?? [];

            if (products.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 60,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Brak produktów do wyświetlenia',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
              itemCount: products.length,
              itemBuilder: (context, index) => ProductTile(
                product: products[index],
              ),
            );
          },
        ),
      ),
    );
  }
}
