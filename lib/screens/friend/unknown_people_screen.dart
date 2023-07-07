import 'package:cosmetic_frontend/blocs/personal_info/personal_info_bloc.dart';
import 'package:cosmetic_frontend/blocs/personal_info/personal_info_event.dart';
import 'package:cosmetic_frontend/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/unknown_people/unknown_people_bloc.dart';
import '../../blocs/unknown_people/unknown_people_event.dart';
import '../../blocs/unknown_people/unknown_people_state.dart';
import 'widgets/friend_widgets.dart';

class UnknownPeopleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<UnknownPeopleBloc>(context).add(ListUnknownPeopleFetched());
    return UnknowPeopleScreenContent();
  }
}

class UnknowPeopleScreenContent extends StatefulWidget {
  const UnknowPeopleScreenContent({
    Key? key,
  }) : super(key: key);

  @override
  State<UnknowPeopleScreenContent> createState() =>
      _UnknowPeopleScreenContent();
}

class _UnknowPeopleScreenContent extends State<UnknowPeopleScreenContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                }),
            title: const Text("Gợi ý bạn bè"),
            centerTitle: false,
            floating: true,
          ),
          SliverToBoxAdapter(
            child: Container(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Danh sách người bạn có thể biết:", style: Theme.of(context).textTheme.titleLarge),
                      ],
                    )
                )
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            sliver: UnknownPeopleList()
          ),
        ],
      ),
    );
  }
}

class UnknownPeopleList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UnknownPeopleBloc, UnknownPeopleState>(
      builder: (context, state) {
        switch (state.status) {
          case UnknownPeopleStatus.initial:
            return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
          case UnknownPeopleStatus.loading:
            return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
          case UnknownPeopleStatus.failure:
            return SliverToBoxAdapter(child: Text("Không có kết nối mạng"));
          case UnknownPeopleStatus.success: {
              final unknownPeopleList = state.unknownPeopleList;
              return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(Routes.personal_screen, arguments: unknownPeopleList.unknownPeople[index].id)
                              .then((value) {
                            // để an toàn thì cứ fetch lại PersonalInfo xem
                            BlocProvider.of<PersonalInfoBloc>(context).add(PersonalInfoFetched());
                            BlocProvider.of<UnknownPeopleBloc>(context).add(ListUnknownPeopleFetched());
                          });
                        },
                        child: UnknownPersonContainer(unknownPerson: unknownPeopleList.unknownPeople[index])
                      );
                    },
                    childCount: unknownPeopleList.unknownPeople.length
                  )
              );
            }
        }
      }
    );
  }
}

