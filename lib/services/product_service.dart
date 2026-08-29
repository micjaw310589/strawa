import 'package:strawa/domain/dtos/product_list_element_dto.dart';
import 'package:strawa/domain/entities/enums/sort_product_enum.dart';
import 'package:strawa/domain/entities/filters.dart';
import 'package:strawa/domain/repositories/product_repository.dart';
import 'package:strawa/locator.dart';

class ProductService {
  final _productRepository = locator<ProductRepository>();

  static final defaultSortBy = SortProduct.byRating;
  static final defaultSortAscending = false;
  SortProduct sortBy = defaultSortBy;
  bool sortAscending = defaultSortAscending;

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
        sortBy: sortBy,
        sortAscending: sortAscending,
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