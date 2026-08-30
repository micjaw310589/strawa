import 'package:decimal/decimal.dart';
import 'package:strawa/domain/dtos/product_list_element_dto.dart';
import 'package:strawa/domain/entities/enums/sort_product_enum.dart';
import 'package:strawa/domain/entities/filters.dart';
import 'package:strawa/domain/entities/product.dart';
import 'package:strawa/domain/repositories/repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductRepository implements Repository<Product>{
  final SupabaseClient _client = Supabase.instance.client;

  Filters filters = Filters();

  // ============ Basic CRUD ============

  @override
  Future<List<Product>> fetchAll() async {
    final data = await _client.from('products').select()
      .eq('is_deleted', false)
      .eq('is_active', true)
      .order('created_at');
    return (data as List)
            .map((json) => Product.fromJson(json))
            .toList();
  }

  @override
  Future<Product> fetchById(String id) async {
    final data = await _client.from('products').select()
      .eq('is_deleted', false)
      .eq('is_active', true)
      .eq('id', id)
      .limit(1);
    return (data as List)
            .map((json) => Product.fromJson(json))
            .first;
  }

  @override
  Future<void> insert(Product obj) async {
    await _client.from('products').insert(obj.toJson());
  }

  @override
  Future<void> update(Product obj) async {
    await _client.from('products').update(obj.toJson())
      .eq('is_deleted', false)
      .eq('id', obj.id);
  }

  @override
  Future<void> delete(String id) async {
    await _client.from('products').update({'is_deleted' : true}).eq('id', id);
  }

  // ============ CRUD END ============


  static PostgrestTransformBuilder<List<Map<String, dynamic>>> _applySorting(
    PostgrestFilterBuilder<List<Map<String, dynamic>>> query,
    SortProduct sortingType,
    {bool ascending = true})
  {
    switch (sortingType) {
      case SortProduct.byPrice:
        return query.order('price', ascending: ascending);
      case SortProduct.byRating:
        return query.order('average_rating', ascending: ascending);
      case SortProduct.byProductsName:
        return query.order('name', ascending: ascending);
      case SortProduct.byChainsName:
        return query.order('name', referencedTable: 'chains', ascending: ascending);
      case SortProduct.byCalories:
        return query.order('calories', ascending: ascending);
      case SortProduct.byCarbs:
        return query.order('carbohydrates_g', ascending: ascending);
      case SortProduct.byProtein:
        return query.order('protein_g', ascending: ascending);
      case SortProduct.byFat:
        return query.order('fat_g', ascending: ascending);
      case SortProduct.byWeight:
        return query.order('weight_g', ascending: ascending);
      case SortProduct.byRatingToPrice:
        return query.order('rating_per_price', ascending: ascending);
      case SortProduct.byProteinToPrice:
        return query.order('protein_per_price', ascending: ascending);
      case SortProduct.byWeightToPrice:
        return query.order('weight_per_price', ascending: ascending);
    }
  }
  

  Future<List<ProductListElementDto>> fetchProductList({
    SortProduct sortBy = SortProduct.byRating,
    bool sortAscending = false,
    required int page,
    int pageSize = 20
  }) async {
    if (page < 0){
      throw Exception("Page cannot be lower than 0");
    }
    if (pageSize < 0){
      throw Exception("Page size cannot be lower than 0");
    }
    if (pageSize > 100){
      throw Exception("Page size limit set to 100");
    }

    final minPrice = Decimal.parse(filters.minPrice.toString());
    final maxPrice = Decimal.parse(filters.maxPrice.toString());

    final from = (page-1) * pageSize;
    final to = from + pageSize - 1;

    var query = _client.from('products')
      .select('''
        id,
        name,
        image_url,
        price,
        chains!inner( name ),
        tags!inner( name ),
        average_rating
      ''')
      .eq('is_deleted', false)
      .eq('is_active', true)
      .gte('price', minPrice.toDouble())
      .lte('price', maxPrice.toDouble())
      .gte('average_rating', filters.minRating);

    if (filters.tags.isNotEmpty){
      query = query.inFilter('tags.name', filters.tags);
    }
    if (filters.chains.isNotEmpty){
      query = query.inFilter('chains.name', filters.chains);
    }

    final data = await _applySorting(query, sortBy, ascending: sortAscending)
      .range(from, to);


    return (data as List).map((json) => ProductListElementDto.fromJson(json)).toList();
  }

}