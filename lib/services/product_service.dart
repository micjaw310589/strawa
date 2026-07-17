import 'package:strawa/domain/dtos/product_list_element_dto.dart';
import 'package:strawa/domain/repositories/product_repository.dart';

class ProductService {
  final _productRepository = ProductRepository();

  Future<List<ProductListElementDto>> getProductsForMainList() async {
    try{
      final productList = await _productRepository.getProductList();
      return productList;
    }
    catch(e) {
      throw Exception("Couldn't retrieve product list from database: ${e.toString()}");
    }
  }
}