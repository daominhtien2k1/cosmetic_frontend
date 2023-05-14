import 'package:equatable/equatable.dart';

import '../../models/models.dart';

abstract class RequestReceivedFriendEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class RequestReceivedFriendFetched extends RequestReceivedFriendEvent {}

class RequestReceivedFriendAccept extends RequestReceivedFriendEvent {
  final RequestReceivedFriend requestReceivedFriend;
  RequestReceivedFriendAccept({required this.requestReceivedFriend});
}

class RequestReceivedFriendDelete extends RequestReceivedFriendEvent {
  final RequestReceivedFriend requestReceivedFriend;
  RequestReceivedFriendDelete({required this.requestReceivedFriend});
}