import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cosmetic_frontend/blocs/review/review_event.dart';
import 'package:cosmetic_frontend/blocs/review/review_state.dart';
import '../../repositories/repositories.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  late final ReviewRepository reviewRepository;

  ReviewBloc({required this.reviewRepository}): super(ReviewState.init()) {
    on<StatisticStarReviewFetched>(_onStatisticStarReviewFetched);
    on<ReviewsFetched>(_onReviewFetched);
  }

  Future<void> _onStatisticStarReviewFetched(StatisticStarReviewFetched event, Emitter<ReviewState> emitter) async {
    try {
      final productId = event.productId;
      emit(state.copyWith(reviewStatus: ReviewStatus.loading));
      final statisticStar = await reviewRepository.fetchListReviewsStar(productId: productId);
      emit(state.copyWith(reviewStatus: ReviewStatus.success, statisticStar: statisticStar));
    } catch(error) {
      emit(state.copyWith(reviewStatus: ReviewStatus.failure));
    }
  }

  Future<void> _onReviewFetched(ReviewsFetched event, Emitter<ReviewState> emitter) async {
    try {
      final productId = event.productId;
      emit(state.copyWith(reviewStatus: ReviewStatus.loading));
      final reviews = await reviewRepository.fetchReviews(productId: productId);
      emit(state.copyWith(reviewStatus: ReviewStatus.success, reviews: reviews));
    } catch(error) {
      emit(state.copyWith(reviewStatus: ReviewStatus.failure));
    }
  }
}