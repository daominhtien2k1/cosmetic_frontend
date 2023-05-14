import 'package:equatable/equatable.dart';

import '../../models/list_unknown_people_model.dart';

class ListUnknownPeopleState extends Equatable {
  final ListUnknownPeople listUnknownPeopleState;

  ListUnknownPeopleState(
      {
        required this.listUnknownPeopleState
      }
      );

  ListUnknownPeopleState.initial()
      : listUnknownPeopleState = ListUnknownPeople.initial();

  ListUnknownPeopleState copyWith({
    ListUnknownPeople? listUnknownPeople,
  }) {
    return ListUnknownPeopleState(
      listUnknownPeopleState: listUnknownPeopleState,
    );
  }

  @override
  String toString() {
    return 'RequestReceivedFriendState{RequestReceivedFriendList: $listUnknownPeopleState}';
  }

  @override
  List<Object> get props => [listUnknownPeopleState];
}
