import 'package:equatable/equatable.dart';

import '../../models/models.dart';

// đã xóa Equatable
enum PersonalInfoStatus {initial, loading, success, failure}
class PersonalInfoState {
  final PersonalInfoStatus? personalInfoStatus;
  final UserInfo userInfo;
  final String? relationship;

  PersonalInfoState({this.personalInfoStatus, required this.userInfo, this.relationship});

  PersonalInfoState.initial() : personalInfoStatus = PersonalInfoStatus.initial, userInfo = UserInfo.initial(), relationship = "Me";

  PersonalInfoState copyWith({PersonalInfoStatus? personalInfoStatus, UserInfo? userInfo, String? relationship}) {
    return PersonalInfoState(
      personalInfoStatus: personalInfoStatus ?? this.personalInfoStatus,
      userInfo: userInfo ?? this.userInfo,
      relationship: relationship ?? this.relationship
    );
  }
}
