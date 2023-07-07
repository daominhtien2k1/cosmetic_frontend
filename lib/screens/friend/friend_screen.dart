import 'package:cosmetic_frontend/blocs/personal_info/personal_info_bloc.dart';
import 'package:cosmetic_frontend/blocs/personal_info/personal_info_event.dart';
import 'package:cosmetic_frontend/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/friend/friend_bloc.dart';
import '../../blocs/friend/friend_event.dart';
import '../../blocs/friend/friend_state.dart';

import 'widgets/friend_widgets.dart';
import '../../routes.dart';
import '../../models/models.dart';

class FriendScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<FriendBloc>(context).add(FriendsFetched());
    return FriendScreenContent();
  }
}

class FriendScreenContent extends StatefulWidget {
  const FriendScreenContent({
    Key? key,
  }) : super(key: key);

  @override
  State<FriendScreenContent> createState() => _FriendScreenContent();
}

class _FriendScreenContent extends State<FriendScreenContent> {
  @override
  Widget build(BuildContext context) {
    final hasPagePushed = Navigator.of(context).canPop();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: hasPagePushed ? BackButton() : IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Icon(Icons.menu)
              ),
              title: Text("Bạn bè"),
              actions: [
                IconButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchScreen()));
                }, 
                  icon: Icon(Icons.search)
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Container(
                child: Row(
                    children: [
                      Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 2, 0),
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, Routes.unknown_people_screen)
                                .then((value) {
                                  BlocProvider.of<PersonalInfoBloc>(context).add(PersonalInfoFetched());
                                  BlocProvider.of<FriendBloc>(context).add(FriendsFetched());
                              });

                            },
                            child: Text('Gợi ý'),
                          )),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, Routes.request_friend_screen)
                                .then((value) {
                                  BlocProvider.of<PersonalInfoBloc>(context).add(PersonalInfoFetched());
                                  BlocProvider.of<FriendBloc>(context).add(FriendsFetched());
                              });
                            },
                            child: Text('Lời mời kết bạn'),
                          )
                      ),
                    ]),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                      child: Row(
                        children: [
                          Text("Danh sách bạn bè", style: Theme.of(context).textTheme.titleLarge),
                        ],
                      ))),
            ),
            SliverPadding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                sliver: FriendList()
            ),
          ],
        ),
      ),
    );
  }
}

class FriendList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendBloc, FriendState>(
        builder: (context, state) {
          switch (state.status) {
            case FriendStatus.initial:
              return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
            case FriendStatus.loading:
              return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
            case FriendStatus.failure:
              return SliverToBoxAdapter(child: Text("Failed"));
            case FriendStatus.success: {
              final List<Friend> friends = state.friendList.friends;
              final count = state.friendList.count;
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.personal_screen, arguments: friends[index].friend)
                        .then((value) {
                          // để an toàn thì cứ fetch lại PersonalInfo xem
                          BlocProvider.of<PersonalInfoBloc>(context).add(PersonalInfoFetched());
                          BlocProvider.of<FriendBloc>(context).add(FriendsFetched());
                        });
                      },
                      child: FriendContainer(friend: friends[index])
                    );
                  },
                  childCount: count
                )
              );
            }
          }
      }
    );
  }
}

