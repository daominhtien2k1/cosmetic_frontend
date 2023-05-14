import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../models/models.dart';
import '../../repositories/repositories.dart';
import 'request_received_friend_event.dart';
import 'request_received_friend_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class RequestReceivedFriendBloc
    extends Bloc<RequestReceivedFriendEvent, RequestReceivedFriendState> {
  late final FriendRequestReceivedRepository friendRequestReceivedRepository;

  RequestReceivedFriendBloc() : super(RequestReceivedFriendState.initial()) {
    friendRequestReceivedRepository = FriendRequestReceivedRepository();
    on<RequestReceivedFriendFetched>(
      _onRequestReceivedFriendFetched,
      transformer: throttleDroppable(throttleDuration),
    );

    on<RequestReceivedFriendAccept>(
      _onRequestReceivedFriendAccept,
      transformer: throttleDroppable(throttleDuration),
    );

    on<RequestReceivedFriendDelete>(
      _onRequestReceivedFriendDelete,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  Future<void> _onRequestReceivedFriendFetched(
      RequestReceivedFriendFetched event,
      Emitter<RequestReceivedFriendState> emit) async {
    try {
      final friendRequestReceivedListData =
          await friendRequestReceivedRepository.fetchRequestReceivedFriends();
      state.friendRequestReceivedList.requestReceivedFriendList =
          friendRequestReceivedListData.requestReceivedFriendList;
      emit(state.copyWith(
          requestReceivedFriendList: state.friendRequestReceivedList));
    } catch (_) {
      emit(state.copyWith());
    }
  }

  Future<void> _onRequestReceivedFriendAccept(RequestReceivedFriendAccept event,
      Emitter<RequestReceivedFriendState> emit) async {
    try {
      final RequestReceivedFriend requestReceivedFriend =
          event.requestReceivedFriend;
      final friendRequestReceivedListData =
      await friendRequestReceivedRepository
          .acceptRequestReceivedFriends(requestReceivedFriend.fromUser);

      final friendRequestReceivedList = state.friendRequestReceivedList as FriendRequestReceivedList;
      final friendRequestReceiveds = friendRequestReceivedList.requestReceivedFriendList as List<RequestReceivedFriend>;
      int index = friendRequestReceiveds.indexOf(requestReceivedFriend);
      state.friendRequestReceivedList.requestReceivedFriendList.removeAt(index);
      emit(RequestReceivedFriendState(friendRequestReceivedList: FriendRequestReceivedList(requestReceivedFriendList: friendRequestReceivedListData.requestReceivedFriendList)));
    } catch (_) {
      emit(state.copyWith());
    }
  }

  Future<void> _onRequestReceivedFriendDelete(RequestReceivedFriendDelete event,
      Emitter<RequestReceivedFriendState> emit) async {
    try {
      final RequestReceivedFriend requestReceivedFriend =
          event.requestReceivedFriend;
      final friendRequestReceivedListData =
          await friendRequestReceivedRepository
              .deleteRequestReceivedFriends(requestReceivedFriend.fromUser);

      final friendRequestReceivedList = state.friendRequestReceivedList as FriendRequestReceivedList;
      final friendRequestReceiveds = friendRequestReceivedList.requestReceivedFriendList as List<RequestReceivedFriend>;
      int index = friendRequestReceiveds.indexOf(requestReceivedFriend);
      state.friendRequestReceivedList.requestReceivedFriendList.removeAt(index);
      emit(RequestReceivedFriendState(friendRequestReceivedList: FriendRequestReceivedList(requestReceivedFriendList: friendRequestReceivedListData.requestReceivedFriendList)));
    } catch (_) {
      emit(state.copyWith());
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    print('#POST OBSERVER: $error');
  }

  @override
  void onEvent(RequestReceivedFriendEvent event) {
    super.onEvent(event);
    print('#POST OBSERVER 123: $event');
  }
}
