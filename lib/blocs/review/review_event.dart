import 'package:equatable/equatable.dart';

abstract class ReviewEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class StatisticStarReviewFetched extends ReviewEvent {
  final String productId;

  StatisticStarReviewFetched({required this.productId});
}

class ReviewsFetched extends ReviewEvent {
  final String productId;

  ReviewsFetched({required this.productId});
}