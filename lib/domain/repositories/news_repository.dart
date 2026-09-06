import 'package:strawa/domain/entities/news.dart';
import 'package:strawa/domain/repositories/repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NewsRepository implements Repository<News>{
  final SupabaseClient _client = Supabase.instance.client;


  // ============ Basic CRUD ============

  @override
  Future<List<News>> fetchAll() async {
    final data = await _client.from('news').select()
      .eq('is_deleted', false)
      .eq('is_active', true)
      .order('published_at');
    return (data as List)
            .map((json) => News.fromJson(json))
            .toList();
  }

  @override
  Future<News> fetchById(String id) async {
    final data = await _client.from('news').select()
      .eq('is_deleted', false)
      .eq('is_active', true)
      .eq('id', id)
      .limit(1);
    return (data as List)
            .map((json) => News.fromJson(json))
            .first;
  }

  @override
  Future<void> insert(News obj) async {
    await _client.from('news').insert(obj.toJson());
  }

  @override
  Future<void> update(News obj) async {
    await _client.from('news').update(obj.toJson())
      .eq('is_deleted', false)
      .eq('id', obj.id);
  }

  @override
  Future<void> delete(String id) async {
    await _client.from('news').update({'is_deleted' : true}).eq('id', id);
  }

  // ============ CRUD END ============

}