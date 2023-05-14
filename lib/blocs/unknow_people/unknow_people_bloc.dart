import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../models/models.dart';
import '../../repositories/repositories.dart';
import 'unknow_people_event.dart';
import 'unknow_people_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class ListUnknownPeopleBloc extends Bloc<ListUnknownPeopleEvent, ListUnknownPeopleState> {
  late final ListUnknownPeopleRepository listUnknownPeopleRepository;

  ListUnknownPeopleBloc() : super(ListUnknownPeopleState.initial()) {
    listUnknownPeopleRepository = ListUnknownPeopleRepository();
    on<ListUnknownPeopleFetched>(
      _onListUnknownPeopleFetched,
      transformer: throttleDroppable(throttleDuration),
    );

    on<RequestSend>(
      _onRequestSend,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  Future<void> _onListUnknownPeopleFetched(
      ListUnknownPeopleFetched event, Emitter<ListUnknownPeopleState> emit) async {
    try {
      final listUnknownPeopleData = await listUnknownPeopleRepository.listUnknownPeopleFetch();
      print(listUnknownPeopleData.toJson());
      state.listUnknownPeopleState.listUnknownPeople = listUnknownPeopleData.listUnknownPeople;
      emit(state.copyWith(
          listUnknownPeople: state.listUnknownPeopleState));
    } catch (_) {
      emit(state.copyWith());
    }
  }

  Future<void> _onRequestSend(RequestSend event,
      Emitter<ListUnknownPeopleState> emit) async {
    try {
      final UnknownPerson unknownPerson =
          event.unknownPerson;
      final listUnknownPeopleData = await listUnknownPeopleRepository.sendRequestFriend(unknownPerson.id);

      final listUnknownPeople = state.listUnknownPeopleState;
      final _listUnknownPeople = listUnknownPeople.listUnknownPeople;
      int index = _listUnknownPeople.indexOf(unknownPerson);
      state.listUnknownPeopleState.listUnknownPeople.removeAt(index);
      emit(ListUnknownPeopleState(listUnknownPeopleState: ListUnknownPeople(listUnknownPeople: _listUnknownPeople)));
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
  void onEvent(ListUnknownPeopleEvent event) {
    super.onEvent(event);
    print('#POST OBSERVER 123: $event');
  }
}
