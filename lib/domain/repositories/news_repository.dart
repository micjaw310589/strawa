import 'package:strawa/domain/entities/news.dart';

abstract class NewsRepository {
  Future<List<News?>> getAllNews();
  Future<News?> getNewsById(String id);
  Future<void> createNews(News tag);
  Future<void> updateNews(News tag);
  Future<void> deleteNews(String id);
}