import 'package:strawa/domain/entities/tag.dart';
import 'package:strawa/domain/repositories/repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TagRepository implements Repository<Tag> {
  final SupabaseClient _client = Supabase.instance.client;


  // ============ Basic CRUD ============

  @override
  Future<List<Tag>> fetchAll() async {
    final data = await _client.from('tags').select()
      .eq('is_deleted', false);
    return (data as List)
            .map((json) => Tag.fromJson(json))
            .toList();
  }

  @override
  Future<Tag> fetchById(String id) async {
    final data = await _client.from('tags').select()
      .eq('is_deleted', false)
      .eq('id', id)
      .limit(1);
    return (data as List)
            .map((json) => Tag.fromJson(json))
            .first;
  }

  @override
  Future<void> insert(Tag obj) async {
    await _client.from('tags').insert(obj.toJson());
  }

  @override
  Future<void> update(Tag obj) async {
    await _client.from('tags').update(obj.toJson())
      .eq('is_deleted', false)
      .eq('id', obj.id);
  }

  @override
  Future<void> delete(String id) async {
    await _client.from('tags').update({'is_deleted' : true}).eq('id', id);
  }

  // ============ CRUD END ============


  Future<List<String>> fetchTagNamesOnly() async {
    final data = await _client.from('tags').select('name')
      .eq('is_deleted', false);  
    return (data as List)
        .map((json) => json['name'] as String)
        .toList();
  }
}