import 'package:decimal/decimal.dart';
import 'package:strawa/domain/dtos/product_list_element_dto.dart';
import 'package:strawa/domain/entities/product.dart';
import 'package:strawa/domain/repositories/repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductRepository implements Repository<Product>{
  final SupabaseClient _client = Supabase.instance.client;


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
      .order('created_at')
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



  Future<List<ProductListElementDto>> fetchProductList({
    required int page,
    int pageSize = 20,
    String tagName = '*',
    String chainName = '*',
    Decimal? minPrice,
    Decimal? maxPrice,
    double? minRating,
    double? maxRating
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

    minRating = (minRating == null) ? 0.0 : minRating;
    maxRating = (maxRating == null) ? 9999.9 : maxRating;

    if (maxRating < minRating){
      throw Exception("Max rating can't be lower than min rating");
    }

    minPrice = (minPrice == null) ? Decimal.zero : minPrice;
    maxPrice = (maxPrice == null) ? Decimal.parse(9999.99.toString()) : maxPrice;

    if (maxPrice < minPrice){
      throw Exception("Max price can't be lower than min price");
    }

    final from = (page-1) * pageSize;
    final to = from + pageSize - 1;

    final data = await _client.from('products')
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
      .like('tags.name', tagName)
      .like('chains.name', chainName)
      .gte('price', minPrice.toDouble())
      .lte('price', maxPrice.toDouble())
      .gte('average_rating', minRating)
      .lte('average_rating', maxRating)
      .order('average_rating', ascending: false)
      .range(from, to);

    return (data as List).map((json) => ProductListElementDto.fromJson(json)).toList();
  }
}