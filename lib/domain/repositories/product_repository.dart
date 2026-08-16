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
    List<String> tagNames = const [],
    List<String> chainNames = const [],
    Decimal? minPrice,
    Decimal? maxPrice,
    double minRating = 0.0,
    double maxRating = 5.0
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

    minPrice = minPrice ?? Decimal.zero;
    maxPrice = maxPrice ?? Decimal.fromInt(100);

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
      .gte('average_rating', minRating)
      .lte('average_rating', maxRating);

    if (tagNames.isNotEmpty){
      query = query.inFilter('tags.name', tagNames);
    }
    if (chainNames.isNotEmpty){
      query = query.inFilter('chains.name', chainNames);
    }

    final data = await query
      .order('average_rating', ascending: false)
      .range(from, to);


    return (data as List).map((json) => ProductListElementDto.fromJson(json)).toList();
  }
}