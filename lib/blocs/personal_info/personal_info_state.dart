import 'package:equatable/equatable.dart';

import '../../models/models.dart';

class PersonalInfoState extends Equatable {
  late final UserInfo userInfo;

  PersonalInfoState(
      {
        required this.userInfo
      }
      );

  PersonalInfoState.initial()
      : userInfo = UserInfo.initial();

  PersonalInfoState copyWith({
    UserInfo? userInfo,
  }) {
    return PersonalInfoState(
      userInfo: userInfo??this.userInfo,
    );
  }

  @override
  String toString() {
    return 'RequestReceivedFriendState{RequestReceivedFriendList: $userInfo}';
  }

  @override
  List<Object?> get props => [userInfo];

}
