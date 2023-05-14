import 'package:equatable/equatable.dart';

import '../../models/list_unknown_people_model.dart';

abstract class ListUnknownPeopleEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ListUnknownPeopleFetched extends ListUnknownPeopleEvent {}

class RequestSend extends ListUnknownPeopleEvent {
  final UnknownPerson unknownPerson;
  RequestSend({required this.unknownPerson});
}
