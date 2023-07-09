import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cosmetic_frontend/blocs/review/review_event.dart';
import 'package:cosmetic_frontend/blocs/review/review_state.dart';
import '../../repositories/repositories.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  late final ReviewRepository reviewRepository;

  ReviewBloc({required this.reviewRepository}): super(ReviewState.init()) {
    on<StatisticStarReviewFetched>(_onStatisticStarReviewFetched);
    on<ReviewsFetched>(_onReviewFetched);
    on<InstructionReviewsFetched>(_onInstructionReviewsFetched);
    on<QuickReviewAdd>(_onQuickReviewAdd);
    on<StandardReviewAdd>(_onStandardReviewAdd);
    on<InstructionReviewAdd>(_onInstructionReviewAdd);
    on<DetailReviewAdd>(_onDetailReviewAdd);
    on<InstructionReviewEdit>(_onInstructionReviewEdit);
    on<ReviewReport>(_onReviewReport);

    on<ReviewSettedUseful>(_onReviewSettedUseful);

  }

  Future<void> _onStatisticStarReviewFetched(StatisticStarReviewFetched event, Emitter<ReviewState> emit) async {
    try {
      final productId = event.productId;
      emit(state.copyWith(reviewStatus: ReviewStatus.loading));
      final statisticStar = await reviewRepository.fetchListReviewsStar(productId: productId);
      emit(state.copyWith(reviewStatus: ReviewStatus.success, statisticStar: statisticStar));
    } catch(error) {
      emit(state.copyWith(reviewStatus: ReviewStatus.failure));
    }
  }

  Future<void> _onReviewFetched(ReviewsFetched event, Emitter<ReviewState> emit) async {
    try {
      final productId = event.productId;
      emit(state.copyWith(reviewStatus: ReviewStatus.loading));
      final mustFilteredReviews = await reviewRepository.fetchReviews(productId: productId);
      mustFilteredReviews?.retainWhere((review) => review.banned == false && review.isBlocked == false);
      if (mustFilteredReviews != null)
        emit(state.copyWith(reviewStatus: ReviewStatus.success, reviews: mustFilteredReviews));
      else
        emit(state.copyWith(reviewStatus: ReviewStatus.success, reviews: []));
    } catch(error) {
      emit(state.copyWith(reviewStatus: ReviewStatus.failure));
    }
  }

  Future<void> _onInstructionReviewsFetched(InstructionReviewsFetched event, Emitter<ReviewState> emit) async {
    try {
      final productId = event.productId;
      final mustFilteredInstructionReviews = await reviewRepository.fetchInstructionReviews(productId: productId);
      mustFilteredInstructionReviews?.retainWhere((review) => review.banned == false && review.isBlocked == false);
      if (mustFilteredInstructionReviews != null) {
        emit(state.copyWith(reviewStatus: ReviewStatus.success, instructionReviews: mustFilteredInstructionReviews));
      } else {
        emit(state.copyWith(reviewStatus: ReviewStatus.success, instructionReviews: []));
      }
    } catch(error) {
      // emit(state.copyWith(reviewStatus: ReviewStatus.failure));
    }
  }

  Future<void> _onQuickReviewAdd(QuickReviewAdd event, Emitter<ReviewState> emit) async {
    try {
      final String productId = event.productId;
      final String classification = event.classification;
      final int rating = event.rating;
      final newQuickReview = await reviewRepository.addReview(
          productId: productId, classification: classification, rating: rating);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onStandardReviewAdd(StandardReviewAdd event, Emitter<ReviewState> emit) async {
    try {
      final String productId = event.productId;
      final String classification = event.classification;
      final int rating = event.rating;
      final String title = event.title;
      final String content = event.content;
      final newStandardReview = await reviewRepository.addReview(
          productId: productId, classification: classification, rating: rating, title: title, content: content);

    } catch (e) {
      print(e);
    }
  }

  Future<void> _onInstructionReviewAdd(InstructionReviewAdd event, Emitter<ReviewState> emit) async {
    try {
      final String productId = event.productId;
      final String classification = event.classification;
      final String title = event.title;
      final String content = event.content;
      final newInstructionReview = await reviewRepository.addReview(
          productId: productId, classification: classification, title: title, content: content);

    } catch (e) {
      print(e);
    }
  }

  Future<void> _onDetailReviewAdd(DetailReviewAdd event, Emitter<ReviewState> emit) async {
    try {
      final String productId = event.productId;
      final String classification = event.classification;
      final int rating = event.rating;
      final String title = event.title;
      final String content = event.content;
      final characteristicReviews = event.characteristicReviews;
      final newDetailReview = await reviewRepository.addReview(
          productId: productId, classification: classification, rating: rating, title: title, content: content, characteristicReviews: characteristicReviews);

    } catch (e) {
      print(e);
    }
  }

  Future<void> _onInstructionReviewEdit(InstructionReviewEdit event, Emitter<ReviewState> emit) async {
    try {
      final String reviewId = event.reviewId;
      final String title = event.title;
      final String content = event.content;
      final updateInstructionReview = await reviewRepository.editInstructionReview(reviewId: reviewId, title: title, content: content);

    } catch (e) {

    }
  }

  Future<void> _onReviewReport(ReviewReport event, Emitter<ReviewState> emit) async {
    final String reviewId = event.reviewId;
    final String subject = event.subject;
    final String details = event.details;
    try {
      await reviewRepository.reportReview(reviewId: reviewId, subject: subject, details: details);
    } catch (_) {

    }
  }

  Future<void> _onReviewSettedUseful(ReviewSettedUseful event, Emitter<ReviewState> emit) async {
    final mustUpdateReview = event.review;
    final reviews = state.reviews; // standard, detail
    final instructionReviews = state.instructionReviews;

    int? indexOfMustUpdateReview;

    if (mustUpdateReview.classification != "Instruction") {
      indexOfMustUpdateReview = reviews?.indexOf(mustUpdateReview);
    } else {
      indexOfMustUpdateReview = instructionReviews?.indexOf(mustUpdateReview);
    }

    if(indexOfMustUpdateReview == null || indexOfMustUpdateReview == -1) {
      return;
    }

    int usefuls = mustUpdateReview.isSettedUseful ? mustUpdateReview.usefuls - 1 : mustUpdateReview.usefuls + 1;
    final newUpdateReview = mustUpdateReview.copyWith(usefuls: usefuls, isSettedUseful: !mustUpdateReview.isSettedUseful);

    if (mustUpdateReview.classification != "Instruction") {
      reviews?..remove(mustUpdateReview)..insert(indexOfMustUpdateReview, newUpdateReview);
      emit(state.copyWith(reviews: reviews));
    } else {
      instructionReviews?..remove(mustUpdateReview)..insert(indexOfMustUpdateReview, newUpdateReview);
      emit(state.copyWith(instructionReviews: instructionReviews));
    }

    if(mustUpdateReview.isSettedUseful) {
      await reviewRepository.unsettedUseful(id: mustUpdateReview.id);
    }
    if(!mustUpdateReview.isSettedUseful) {
      await reviewRepository.settedUseful(id: mustUpdateReview.id);
    }

  }
}