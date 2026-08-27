import 'package:strawa/domain/entities/review.dart';
import 'package:strawa/domain/repositories/repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReviewRepository implements Repository<Review> {
  final SupabaseClient _client = Supabase.instance.client;


  // ============ Basic CRUD ============

  @override
  Future<List<Review>> fetchAll() async {
    final data = await _client.from('reviews').select()
      .eq('is_deleted', false)
      .order('created_at');
    return (data as List)
            .map((json) => Review.fromJson(json))
            .toList();
  }

  @override
  Future<Review> fetchById(String id) async {
    final data = await _client.from('reviews').select()
      .eq('is_deleted', false)
      .eq('id', id)
      .limit(1);
    return (data as List)
            .map((json) => Review.fromJson(json))
            .first;
  }

  @override
  Future<void> insert(Review obj) async {
    await _client.from('reviews').insert(obj.toJson());
  }

  @override
  Future<void> update(Review obj) async {
    await _client.from('reviews').update(obj.toJson())
      .eq('is_deleted', false)
      .eq('id', obj.id);
  }

  @override
  Future<void> delete(String id) async {
    await _client.from('reviews').update({'is_deleted' : true}).eq('id', id);
  }

  // ============ CRUD END ============

}