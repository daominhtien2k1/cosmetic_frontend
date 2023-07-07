import 'package:equatable/equatable.dart';

import '../../models/models.dart';

// đã xóa Equatable
enum PersonalInfoStatus {initial, loading, success, failure}
class PersonalInfoState {
  final PersonalInfoStatus? personalInfoStatus;
  final UserInfo userInfo;

  PersonalInfoState({this.personalInfoStatus, required this.userInfo});

  PersonalInfoState.initial() : personalInfoStatus = PersonalInfoStatus.initial, userInfo = UserInfo.initial();

  PersonalInfoState copyWith({PersonalInfoStatus? personalInfoStatus, UserInfo? userInfo}) {
    return PersonalInfoState(
      personalInfoStatus: personalInfoStatus ?? this.personalInfoStatus,
      userInfo: userInfo ?? this.userInfo,
    );
  }
}
