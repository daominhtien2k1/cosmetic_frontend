import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

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
    on<SetDescriptionUser>(_onSetDescriptionUser);
    on<SetCityUser>(_onSetCityUser);
    on<SetCountryUser>(_onSetCountryUser);
  }

  Future<void> _onPersonalInfoFetched(PersonalInfoFetched event, Emitter<PersonalInfoState> emit) async {
    try {
      final userInfoData = await userInfoRepository.fetchPersonalInfo();
      emit(PersonalInfoState(userInfo: userInfoData));
    } catch (_) {
      emit(state.copyWith());
    }
  }

  Future<void> _onPersonalInfoOfAnotherUserFerched(PersonalInfoOfAnotherUserFetched event, Emitter<PersonalInfoState> emit) async {
    try {
      final String id = event.id;
      final userInfoData =
      await userInfoRepository.fetchPersonalInfoOfAnotherUser(id);
      emit(PersonalInfoState(userInfo: userInfoData));
    } catch (_) {
      emit(state.copyWith());
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
  //   super.onChange(change);
  // }

}
