import 'package:strawa/domain/entities/review.dart';

abstract class ReviewRepository {
  Future<List<Review?>> getAllReviews();
  Future<Review?> getReviewById(String id);
  Future<void> createReview(Review tag);
  Future<void> updateReview(Review tag);
  Future<void> deleteReview(String id);
}