import 'package:cosmetic_frontend/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class RetrieveReviewEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ReviewRetrieved extends RetrieveReviewEvent {
  final String productId;

  ReviewRetrieved({required this.productId});
}