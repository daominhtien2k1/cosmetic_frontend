import '../../models/models.dart';

enum ReplyStatus {initial, loading, success, failure }

class ReplyState{
  ReplyStatus replyStatus;
  List<Reply>? replies;

  ReplyState({required this.replyStatus, this.replies});
  ReplyState.initial(): replyStatus = ReplyStatus.initial, replies = List<Reply>.empty(growable: true);

  ReplyState copyWith({ReplyStatus? replyStatus, List<Reply>? replies}) {
    return ReplyState(
        replyStatus: replyStatus ?? this.replyStatus,
        replies: replies ?? this.replies
    );
  }

}