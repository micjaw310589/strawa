import 'package:strawa/domain/dtos/product_list_element_dto.dart';
import 'package:strawa/domain/entities/filters.dart';
import 'package:strawa/domain/repositories/product_repository.dart';

class ProductService {
  final _productRepository = ProductRepository();

  Filters get filters => _productRepository.filters;
  set filters(Filters f) {
    if (f.minRating < 0.0){
      throw Exception("Rating can't be lower than 0");
    }
    if (f.minRating > 5.0){
      throw Exception("Rating can't be higher than 5.0");
    }
    if (f.minPrice < 0.0 || f.maxPrice < 0.0) {
      throw Exception("Price can't be lower than 0");
    }
    if (f.maxPrice < f.minPrice){
      throw Exception("Max price can't be lower than min price");
    }

    _productRepository.filters = f;
  }


  Future<List<ProductListElementDto>> getProductsForMainList({
    required int page,
    int pageSize = 20,
  }) async {
    try{
      final productList = await _productRepository.fetchProductList(
        page: page,
        pageSize: pageSize
      );
      return productList;
    }
    catch(e) {
      throw Exception("Service failed to retrieve product list from database: ${e.toString()}");
    }
  }
}