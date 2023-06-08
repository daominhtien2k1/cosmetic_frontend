import 'package:cosmetic_frontend/blocs/retrieve_review/retrieve_review_event.dart';
import 'package:cosmetic_frontend/blocs/retrieve_review/retrieve_review_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/models.dart';
import '../../repositories/repositories.dart';

class RetrieveReviewBloc extends Bloc<RetrieveReviewEvent, RetrieveReviewState> {
  late final ReviewRepository reviewRepository;
  RetrieveReviewBloc({required this.reviewRepository}): super(RetrieveReviewState.init()) {
    on<ReviewRetrieved>(_onReviewRetrieved);
  }

  Future<void> _onReviewRetrieved(ReviewRetrieved event, Emitter<RetrieveReviewState> emit) async {
    try {
      final productId = event.productId;
      emit(state.copyWith(retrieveReviewStatus: RetrieveReviewStatus.loading));
      final retrieveReview = await reviewRepository.retrieveReview(productId: productId);

      if (retrieveReview != null) {
        // hóa ra copyWith với null cũng không ổn
        emit(state.copyWith(retrieveReviewStatus: RetrieveReviewStatus.success, retrieveReview: retrieveReview));
        } else {
        emit(RetrieveReviewState(retrieveReviewStatus: RetrieveReviewStatus.initial));
      }
    } catch (err) {
      emit(state.copyWith(retrieveReviewStatus: RetrieveReviewStatus.failure));
    }
  }
}