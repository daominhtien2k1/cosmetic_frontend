import 'package:cosmetic_frontend/models/models.dart';

enum ReviewStatus {initial, loading, success, failure }

class ReviewState {
  ReviewStatus reviewStatus;
  List<Review>? reviews;
  StatisticStar? statisticStar;
  ReviewState({required this.reviewStatus, this.reviews, this.statisticStar});

  ReviewState.init(): reviewStatus = ReviewStatus.initial, reviews = null, statisticStar = null;

  ReviewState copyWith({ReviewStatus? reviewStatus, List<Review>? reviews, StatisticStar? statisticStar}) {
    return ReviewState(
      reviewStatus: reviewStatus ?? this.reviewStatus,
      reviews: reviews ?? this.reviews,
      statisticStar: statisticStar ?? this.statisticStar
    );
  }
}
