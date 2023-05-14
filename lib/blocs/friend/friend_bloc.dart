import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../models/models.dart';
import '../../repositories/repositories.dart';
import 'friend_event.dart';
import 'friend_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class FriendBloc extends Bloc<FriendEvent, FriendState> {
  late final FriendRepository friendRepository;

  FriendBloc() : super(FriendState.initial()) {
    friendRepository = FriendRepository();
    on<FriendFetched>(
      _onFriendFetched,
      transformer: throttleDroppable(throttleDuration),
    );

    on<FriendOfAnotherUserFetched>(
      _onFriendOfAnotherUserFetched,
      transformer: throttleDroppable(throttleDuration),
    );

    on<FriendDelete>(
      _onFriendDelete,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  Future<void> _onFriendFetched(
      FriendFetched event, Emitter<FriendState> emit) async {
    try {
      final friendListData = await friendRepository.friendsFetch();
      state.listFriendState.listFriend = friendListData.listFriend;
      emit(state.copyWith(
          listFriend: friendListData));
    } catch (_) {
      emit(state.copyWith());
    }
  }

  Future<void> _onFriendOfAnotherUserFetched(
      FriendOfAnotherUserFetched event, Emitter<FriendState> emit) async {
    try {
      final String id = event.id;
      final friendListData = await friendRepository.friendOfAnotherUserFetched(id);
      state.listFriendState.listFriend = friendListData.listFriend;
      emit(state.copyWith(
          listFriend: state.listFriendState));
    } catch (_) {
      emit(state.copyWith());
    }
  }

  Future<void> _onFriendDelete(FriendDelete event,
      Emitter<FriendState> emit) async {
    try {
      final Friend friend =
          event.friend;
      final friendListData =
      await friendRepository
          .deleteFriends(friend.friend);

      final listFriendState = state.listFriendState;
      final listFriend = listFriendState.listFriend;
      int index = listFriend.indexOf(friend);
      state.listFriendState.listFriend.removeAt(index);
      emit(FriendState(listFriendState: ListFriend(listFriend: listFriend)));
    } catch (_) {
      emit(state.copyWith());
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    // print('#FRIEND BLOC OBSERVER: $error');
  }

  @override
  void onEvent(FriendEvent event) {
    super.onEvent(event);
    // print('#FRIEND BLOC OBSERVER: $event');
  }
}
