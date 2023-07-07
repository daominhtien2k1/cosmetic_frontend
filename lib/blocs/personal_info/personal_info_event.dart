import 'package:equatable/equatable.dart';

import '../../models/personal_modal.dart';

abstract class PersonalInfoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PersonalInfoFetched extends PersonalInfoEvent {}

class PersonalInfoOfAnotherUserFetched extends PersonalInfoEvent {
  final String id;
  PersonalInfoOfAnotherUserFetched({required this.id});
}

class SetNameUser extends PersonalInfoEvent {
  final String name;
  SetNameUser({required this.name});
}

class SetGenderUser extends PersonalInfoEvent {
  final String gender;
  SetGenderUser({required this.gender});
}

class SetDescriptionUser extends PersonalInfoEvent {
  final String description;
  SetDescriptionUser({required this.description});
}

class SetCityUser extends PersonalInfoEvent {
  final String city;
  SetCityUser({required this.city});
}

class SetCountryUser extends PersonalInfoEvent {
  final String country;
  SetCountryUser({required this.country});
}

class SetSkinUser extends PersonalInfoEvent {
  final Skin skin;
  SetSkinUser({required this.skin});
}

class PointIncrease extends PersonalInfoEvent {
  final int point;
  PointIncrease({required this.point});
}

class RelationshipWithPersonFetched extends PersonalInfoEvent {
  final String personId;

  RelationshipWithPersonFetched({required this.personId});
}

class RelationshipWithPersonUpdate extends PersonalInfoEvent {
  final String newRelationship;

  RelationshipWithPersonUpdate({required this.newRelationship});
}

class FriendDeleted extends PersonalInfoEvent {
  final String personId;

  FriendDeleted({required this.personId});
}

class FriendAccept extends PersonalInfoEvent {
  final String personId;
  FriendAccept({required this.personId});
}

class FriendRequestDeleted extends PersonalInfoEvent {
  final String senderId;
  FriendRequestDeleted({required this.senderId});
}

class FriendRequestSend extends PersonalInfoEvent {
  final String receiverId;
  FriendRequestSend({required this.receiverId});
}

class PersonBlocked extends PersonalInfoEvent {
  final String personId;
  PersonBlocked({required this.personId});
}