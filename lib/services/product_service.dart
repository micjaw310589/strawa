import 'package:decimal/decimal.dart';
import 'package:strawa/domain/dtos/product_list_element_dto.dart';
import 'package:strawa/domain/repositories/product_repository.dart';

class ProductService {
  final _productRepository = ProductRepository();

  Future<List<ProductListElementDto>> getProductsForMainList({
    required int page,
    int pageSize = 20,
    String tagName = '*',
    String chainName = '*',
    Decimal? minPrice,
    Decimal? maxPrice,
    double minRating = 0.0,
    double maxRating = 5.0
  }) async {
    if (minRating < 0.0 || maxRating < 0.0){
      throw Exception("Rating can't be lower than 0");
    }
    if (minRating > 5.0 || maxRating > 5.0){
      throw Exception("Rating can't be higher than 5.0");
    }

    minPrice = (minPrice == null) ? Decimal.zero : minPrice;
    maxPrice = (maxPrice == null) ? Decimal.parse(9999.99.toString()) : maxPrice;

    if (minPrice.toDouble() < 0.0 || maxPrice.toDouble() < 0.0) {
      throw Exception("Price can't be lower than 0");
    }

    try{
      final productList = await _productRepository.fetchProductList(
        page: page,
        pageSize: pageSize,
        tagName: tagName,
        chainName: chainName,
        minPrice: minPrice,
        maxPrice: maxPrice,
        minRating: minRating,
        maxRating: maxRating
      );
      return productList;
    }
    catch(e) {
      throw Exception("Couldn't retrieve product list from database: ${e.toString()}");
    }
  }
}