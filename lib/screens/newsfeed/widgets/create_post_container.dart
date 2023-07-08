import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../routes.dart';
import '../../../blocs/personal_info/personal_info_bloc.dart';
import '../../../blocs/personal_info/personal_info_event.dart';
import '../../../blocs/personal_info/personal_info_state.dart';

class CreatePostContainer extends StatelessWidget {
  const CreatePostContainer({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.pinkAccent,
          width: 1.0,
          style: BorderStyle.solid,
        ),
      ),
      // height: 200,
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 10.0),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.create_post_screen);
                  },
                  child: Container(
                    child: Text('Bạn đang nghĩ gì?', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),
              TextButton.icon(
                  onPressed: () {print("image");},
                  icon: Icon(Icons.photo_library, color: Colors.green),
                  label: Text('Ảnh', style: TextStyle(color: Colors.black87)),
              )
            ]
          )
        ]
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<PersonalInfoBloc>().add(PersonalInfoFetched());
    return BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
        builder: (context, state) {
          final userInfo = state.userInfo;
          return CircleAvatar(
            radius: 20.0,
            backgroundColor: Colors.grey[200],
            backgroundImage: CachedNetworkImageProvider(userInfo.avatar),
          );
        });
  }
}
