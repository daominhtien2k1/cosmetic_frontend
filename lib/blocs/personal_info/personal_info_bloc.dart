import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/repositories.dart';
import 'personal_info_event.dart';
import 'personal_info_state.dart';


class PersonalInfoBloc extends Bloc<PersonalInfoEvent, PersonalInfoState> {
  late final UserInfoRepository userInfoRepository;
  late final FriendRepository friendRepository;
  late final FriendRequestReceivedRepository friendRequestReceivedRepository;
  late final UnknownPeopleRepository unknownPeopleRepository;
  late final BlockRepository blockRepository;

  PersonalInfoBloc() : super(PersonalInfoState.initial()) {
    userInfoRepository = UserInfoRepository();
    friendRepository = FriendRepository();
    friendRequestReceivedRepository = FriendRequestReceivedRepository();
    unknownPeopleRepository = UnknownPeopleRepository();
    blockRepository = BlockRepository();

    on<PersonalInfoFetched>(_onPersonalInfoFetched);

    on<PersonalInfoOfAnotherUserFetched>(_onPersonalInfoOfAnotherUserFetched);

    on<SetNameUser>(_onSetNameUser);
    on<SetGenderUser>(_onSetGenderUser);
    on<SetDescriptionUser>(_onSetDescriptionUser);
    on<SetCityUser>(_onSetCityUser);
    on<SetCountryUser>(_onSetCountryUser);
    on<SetSkinUser>(_onSetSkinUser);
    on<PointIncrease>(_onPointIncrease);

    on<RelationshipWithPersonFetched>(_onRelationshipWithPersonFetched);
    on<RelationshipWithPersonUpdate>(_onRelationshipWithPersonUpdate);

    on<FriendDeleted>(_onFriendDeleted);
    on<FriendAccept>(_onFriendAccept);
    on<FriendRequestDeleted>(_onFriendRequestDeleted);
    on<FriendRequestSend>(_onFriendRequestSend);
    on<PersonBlocked>(_onPersonBlocked);
  }

  Future<void> _onPersonalInfoFetched(PersonalInfoFetched event, Emitter<PersonalInfoState> emit) async {
    try {
      final userInfoData = await userInfoRepository.fetchPersonalInfo();
      emit(PersonalInfoState(personalInfoStatus: PersonalInfoStatus.success, userInfo: userInfoData));
    } catch (_) {
      emit(state.copyWith(personalInfoStatus: PersonalInfoStatus.failure));
    }
  }

  Future<void> _onPersonalInfoOfAnotherUserFetched(PersonalInfoOfAnotherUserFetched event, Emitter<PersonalInfoState> emit) async {
    try {
      final String id = event.id;
      final userInfoData = await userInfoRepository.fetchPersonalInfoOfAnotherUser(id);
      if (userInfoData != null) {
        // emit(PersonalInfoState(personalInfoStatus: PersonalInfoStatus.success, userInfo: userInfoData));
        emit(state.copyWith(personalInfoStatus: PersonalInfoStatus.success, userInfo: userInfoData));
      } else {
        // hình như do Equatable nên không emit cái mới
        emit(state.copyWith(personalInfoStatus: PersonalInfoStatus.failure));
      }

    } catch (_) {
      emit(state.copyWith(personalInfoStatus: PersonalInfoStatus.failure));
    }
  }

  Future<void> _onSetNameUser(SetNameUser event, Emitter<PersonalInfoState> emit) async {
    try {
      final String name = event.name;
      await userInfoRepository.setNameUser(name);
    } catch (_) {
      emit(state.copyWith());
    }
  }

  Future<void> _onSetGenderUser(SetGenderUser event, Emitter<PersonalInfoState> emit) async {
    try {
      final String gender = event.gender;
      await userInfoRepository.setGenderUser(gender);
    } catch (_) {
      emit(state.copyWith());
    }
  }
  
  
  Future<void> _onSetDescriptionUser(SetDescriptionUser event, Emitter<PersonalInfoState> emit) async {
    try {
      final String description = event.description;
      await userInfoRepository.setDescriptionUser(description);
    } catch (_) {
      emit(state.copyWith());
    }
  }


  Future<void> _onSetCityUser(SetCityUser event, Emitter<PersonalInfoState> emit) async {
    try {
      final String city = event.city;
      await userInfoRepository.setCityUser(city);
    } catch (_) {
      emit(state.copyWith());
    }
  }

  Future<void> _onSetCountryUser(SetCountryUser event, Emitter<PersonalInfoState> emit) async {
    try {
      final String country = event.country;
      await userInfoRepository.setCountryUser(country);
    } catch (_) {
      emit(state.copyWith());
    }
  }

  Future<void> _onSetSkinUser(SetSkinUser event, Emitter<PersonalInfoState> emit) async {
    try {
      final skin = event.skin;
      await userInfoRepository.setSkinUser(skin);
    } catch (_) {
      emit(state.copyWith());
    }
  }

  Future<void> _onPointIncrease(PointIncrease event, Emitter<PersonalInfoState> emit) async {
    try {
      final point = event.point;
      await userInfoRepository.increasePointLevel(point: point);

    } catch (_) {

    }
  }

  Future<void> _onRelationshipWithPersonFetched(RelationshipWithPersonFetched event, Emitter<PersonalInfoState> emit) async {
    try {
      final String personId = event.personId;
      final relationship = await userInfoRepository.getRelationshipWithPerson(personId);
      if (relationship != null) {
        emit(state.copyWith(relationship: relationship));
      } else {
        emit(state.copyWith());
      }

    } catch (_) {
      emit(state.copyWith());
    }
  }

  Future<void> _onRelationshipWithPersonUpdate(RelationshipWithPersonUpdate event, Emitter<PersonalInfoState> emit) async {
    try {
      final newRelationship = event.newRelationship;
      emit(state.copyWith(relationship: newRelationship));
    } catch (_) {
      emit(state.copyWith());
    }
  }

  Future<void> _onFriendDeleted(FriendDeleted event, Emitter<PersonalInfoState> emit) async {
    try {
      final personId = event.personId;
      await friendRepository.deleteFriend(personId: personId);
    } catch (_) {
      emit(state.copyWith());
    }
  }

  Future<void> _onFriendAccept(FriendAccept event, Emitter<PersonalInfoState> emit) async {
    try {
      final personId = event.personId;
      await friendRequestReceivedRepository.setAcceptFriend(senderId: personId);
    } catch (_) {
      emit(state.copyWith());
    }
  }

  Future<void> _onFriendRequestDeleted(FriendRequestDeleted event, Emitter<PersonalInfoState> emit) async {
    try {
      final senderId = event.senderId;
      await friendRequestReceivedRepository.delRequestFriend(senderId: senderId);
    } catch (_) {
      emit(state.copyWith());
    }
  }

  Future<void> _onFriendRequestSend(FriendRequestSend event, Emitter<PersonalInfoState> emit) async {
    try {
      final receiverId = event.receiverId;
      await unknownPeopleRepository.setRequestFriend(receiverId: receiverId);
    } catch (_) {
      emit(state.copyWith());
    }
  }

  Future<void> _onPersonBlocked(PersonBlocked event, Emitter<PersonalInfoState> emit) async {
    try {
      final personId = event.personId;
      await blockRepository.blockPerson(personId: personId);
    } catch (_) {
      emit(state.copyWith());
    }
  }



  // @override
  // void onError(Object error, StackTrace stackTrace) {
  //   super.onError(error, stackTrace);
  // }
  //
  // @override
  // void onEvent(PersonalInfoEvent event) {
  //   super.onEvent(event);
  // }
  //
  // @override
  // void onChange(Change<PersonalInfoState> change) {
  //   // print("#Block: ${change.currentState.personalInfoStatus}");
  //   super.onChange(change);
  // }

}
