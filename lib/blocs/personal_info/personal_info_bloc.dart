import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/repositories.dart';
import 'personal_info_event.dart';
import 'personal_info_state.dart';


class PersonalInfoBloc extends Bloc<PersonalInfoEvent, PersonalInfoState> {
  late final UserInfoRepository userInfoRepository;

  PersonalInfoBloc() : super(PersonalInfoState.initial()) {
    userInfoRepository = UserInfoRepository();
    on<PersonalInfoFetched>(_onPersonalInfoFetched);

    on<PersonalInfoOfAnotherUserFetched>(_onPersonalInfoOfAnotherUserFerched);

    on<SetNameUser>(_onSetNameUser);
    on<SetGenderUser>(_onSetGenderUser);
    on<SetDescriptionUser>(_onSetDescriptionUser);
    on<SetCityUser>(_onSetCityUser);
    on<SetCountryUser>(_onSetCountryUser);
    on<SetSkinUser>(_onSetSkinUser);
    on<PointIncrease>(_onPointIncrease);
  }

  Future<void> _onPersonalInfoFetched(PersonalInfoFetched event, Emitter<PersonalInfoState> emit) async {
    try {
      final userInfoData = await userInfoRepository.fetchPersonalInfo();
      emit(PersonalInfoState(personalInfoStatus: PersonalInfoStatus.success, userInfo: userInfoData));
    } catch (_) {
      emit(state.copyWith(personalInfoStatus: PersonalInfoStatus.failure));
    }
  }

  Future<void> _onPersonalInfoOfAnotherUserFerched(PersonalInfoOfAnotherUserFetched event, Emitter<PersonalInfoState> emit) async {
    try {
      final String id = event.id;
      final userInfoData = await userInfoRepository.fetchPersonalInfoOfAnotherUser(id);
      if (userInfoData != null) {
        emit(PersonalInfoState(personalInfoStatus: PersonalInfoStatus.success, userInfo: userInfoData));
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
  @override
  void onChange(Change<PersonalInfoState> change) {
    print("#Block: ${change.currentState.personalInfoStatus}");
    super.onChange(change);
  }

}
