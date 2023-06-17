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
