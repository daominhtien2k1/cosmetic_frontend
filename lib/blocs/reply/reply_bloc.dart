import 'package:cosmetic_frontend/blocs/reply/reply_event.dart';
import 'package:cosmetic_frontend/blocs/reply/reply_state.dart';
import 'package:cosmetic_frontend/repositories/reply_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/models.dart';
import '../../repositories/repositories.dart';

class ReplyBloc extends Bloc<ReplyEvent, ReplyState> {
  late final ReplyRepository replyRepository;

  ReplyBloc(): super(ReplyState.initial()) {
    replyRepository = ReplyRepository();

    on<ReplyFetched>(_onReplyFetched);
    on<ReplySet>(_onReplySet);
  }

  Future<void> _onReplyFetched(ReplyFetched event, Emitter<ReplyState> emit) async {
    try {
      final reviewId = event.reviewId;
      emit(state.copyWith(replyStatus: ReplyStatus.loading));
      final replies = await replyRepository.fetchReplies(reviewId: reviewId);
      if (replies != null) {
        emit(state.copyWith(replyStatus: ReplyStatus.success, replies: replies));
      }
    } catch (err) {
      emit(state.copyWith(replyStatus: ReplyStatus.failure));
    }
  }

  Future<void> _onReplySet(ReplySet event, Emitter<ReplyState> emit) async {
    try {
      final reviewId = event.reviewId;
      final reply = event.reply;
      final newReply = await replyRepository.setReply(reviewId: reviewId, reply: reply);
      if (newReply != null) {
        final replies = state.replies;
        replies?.add(newReply);
        emit(state.copyWith(replies: state.replies));
      }
    } catch (err) {

    }
  }

}