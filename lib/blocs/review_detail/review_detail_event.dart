import 'package:equatable/equatable.dart';

abstract class ReviewDetailEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ReviewDetailFetched extends ReviewDetailEvent {
  final String reviewId;

  ReviewDetailFetched({required this.reviewId});
}

class ReviewDetailReload extends ReviewDetailEvent {
  final String reviewId;

  ReviewDetailReload({required this.reviewId});
}

class ReviewDetailSettedUseful extends ReviewDetailEvent {
  final String reviewId;

  ReviewDetailSettedUseful({required this.reviewId});
}