import 'package:strawa/domain/dtos/product_list_element_dto.dart';
import 'package:strawa/domain/entities/product.dart';
import 'package:strawa/domain/repositories/repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductRepository implements Repository<Product>{
  final SupabaseClient _client = Supabase.instance.client;


  // ============ Basic CRUD ============

  @override
  Future<List<Product?>> getAll() async {
    final data = await _client.from('products').select().eq('is_deleted', false).order('created_at');
    return (data as List)
            .map((json) => Product.fromJson(json))
            .toList();
  }

  @override
  Future<Product?> getById(String id) async {
    final data = await _client.from('products').select().eq('is_deleted', false).eq('id', id).order('created_at').limit(1);
    return (data as List)
            .map((json) => Product.fromJson(json))
            .first;
  }

  @override
  Future<void> create(Product obj) async {
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


  Future<List<ProductListElementDto?>> getProductList() async {
    // TODO: fetch data using .rpc() method
    throw UnimplementedError();
  }
}