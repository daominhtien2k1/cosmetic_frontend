import 'package:cosmetic_frontend/models/models.dart';

enum RetrieveReviewStatus {initial, loading, success, failure}

class RetrieveReviewState {
  RetrieveReviewStatus retrieveReviewStatus;
  RetrieveReview? retrieveReview;

  RetrieveReviewState({required this.retrieveReviewStatus, this.retrieveReview});

  RetrieveReviewState.init(): retrieveReviewStatus = RetrieveReviewStatus.initial, retrieveReview = null;

  RetrieveReviewState copyWith({RetrieveReviewStatus? retrieveReviewStatus, RetrieveReview? retrieveReview}) {
    return RetrieveReviewState(
      retrieveReviewStatus: retrieveReviewStatus ?? this.retrieveReviewStatus,
      retrieveReview: retrieveReview ?? this.retrieveReview
    );
  }

}
