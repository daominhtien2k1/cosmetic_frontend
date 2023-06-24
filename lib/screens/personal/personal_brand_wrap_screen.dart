import 'package:cosmetic_frontend/blocs/personal_info/personal_info_state.dart';
import 'package:cosmetic_frontend/models/models.dart';
import 'package:cosmetic_frontend/screens/personal/brand_official_screen.dart';
import 'package:cosmetic_frontend/screens/personal/personal_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/personal_info/personal_info_bloc.dart';
import '../../blocs/personal_info/personal_info_event.dart';

class PersonalBrandWrapScreen extends StatefulWidget {
  final String? accountId;
  PersonalBrandWrapScreen({this.accountId});

  @override
  State<PersonalBrandWrapScreen> createState() => _PersonalBrandWrapScreenState();
}

class _PersonalBrandWrapScreenState extends State<PersonalBrandWrapScreen> {
  // late final bool isBrand;
  late final AuthUser authUser;
  late final String? accountId;
  late final String userId; // dùng chung cho cả mình và người khác
  late final bool isMe;

  @override
  void initState() {
    authUser = BlocProvider.of<AuthBloc>(context).state.authUser;
    accountId = widget.accountId;
    userId = accountId ?? authUser.id;
    isMe = accountId != null ? false : true;
    if (isMe) {
      context.read<PersonalInfoBloc>().add(PersonalInfoFetched());
    } else {
      context.read<PersonalInfoBloc>().add(PersonalInfoOfAnotherUserFetched(id: accountId.toString()));
    }
    print("isMe: $isMe");
    // lỗi isBrand is not initialize
    // Future.delayed(Duration(milliseconds: 500)).then((_) {
    //   isBrand = BlocProvider.of<PersonalInfoBloc>(context).state.userInfo.isBrand;
    // });
    // print("isBrand: $isBrand");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return BlocSelector<PersonalInfoBloc, PersonalInfoState, bool>(
      selector: (state) {
        return state.userInfo.isBrand;
      },
      builder: (context, isBrand) {
        return isBrand ? BrandOfficialScreen(accountId: widget.accountId) :
          PersonalScreen(accountId: widget.accountId);
      },
    );

  }
}
