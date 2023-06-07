import 'package:equatable/equatable.dart';

abstract class ReplyEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ReplyFetched extends ReplyEvent {
  final String reviewId;

  ReplyFetched({required this.reviewId});
}

class ReplySet extends ReplyEvent {
  final String reviewId;
  final String reply;

  ReplySet({required this.reviewId, required this.reply});
}

