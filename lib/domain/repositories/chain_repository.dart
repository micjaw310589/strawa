import 'package:strawa/domain/entities/chain.dart';
import 'package:strawa/domain/repositories/repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChainRepository implements Repository<Chain> {
  final SupabaseClient _client = Supabase.instance.client;


  // ============ Basic CRUD ============

  @override
  Future<List<Chain>> fetchAll() async {
    final data = await _client.from('chains').select()
      .eq('is_deleted', false);
    return (data as List)
            .map((json) => Chain.fromJson(json))
            .toList();
  }

  @override
  Future<Chain> fetchById(String id) async {
    final data = await _client.from('chains').select()
      .eq('is_deleted', false)
      .eq('id', id)
      .limit(1);
    return (data as List)
            .map((json) => Chain.fromJson(json))
            .first;
  }

  @override
  Future<void> insert(Chain obj) async {
    await _client.from('chains').insert(obj.toJson());
  }

  @override
  Future<void> update(Chain obj) async {
    await _client.from('chains').update(obj.toJson())
      .eq('is_deleted', false)
      .eq('id', obj.id);
  }

  @override
  Future<void> delete(String id) async {
    await _client.from('chains').update({'is_deleted' : true}).eq('id', id);
  }

  // ============ CRUD END ============


  Future<List<String>> fetchChainNamesOnly() async {
    final data = await _client.from('chains').select('name')
      .eq('is_deleted', false);  
    return (data as List)
        .map((json) => json['name'] as String)
        .toList();
  }
}