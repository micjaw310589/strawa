import 'package:strawa/domain/dtos/product_list_element_dto.dart';
import 'package:strawa/domain/entities/product.dart';
import 'package:strawa/domain/repositories/repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductRepository implements Repository<Product>{
  final SupabaseClient _client = Supabase.instance.client;


  // ============ Basic CRUD ============

  @override
  Future<List<Product>> fetchAll() async {
    final data = await _client.from('products').select().eq('is_deleted', false).order('created_at');
    return (data as List)
            .map((json) => Product.fromJson(json))
            .toList();
  }

  @override
  Future<Product> fetchById(String id) async {
    final data = await _client.from('products').select().eq('is_deleted', false).eq('id', id).order('created_at').limit(1);
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
    await _client.from('products').update(obj.toJson()).eq('is_deleted', false).eq('id', obj.id);
  }

  @override
  Future<void> delete(String id) async {
    await _client.from('products').update({'is_deleted' : true}).eq('id', id);
  }

  // ============ CRUD END ============


  Future<List<ProductListElementDto>> getProductList() async {
    final data = await _client.from('products')
      .select('''
        id,
        name,
        image_url,
        price,
        chains( name ),
        tags( name ),
        average_rating
      ''')
      .eq('is_deleted', false);

    return (data as List).map((json) => ProductListElementDto.fromJson(json)).toList();
  }
}