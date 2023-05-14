import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/friend/friend_bloc.dart';
import '../../../blocs/friend/friend_event.dart';
import '../../../blocs/friend/friend_state.dart';
import './widgets/friend_container.dart';
import '../../../routes.dart';
import '../../../models/models.dart';

class FriendScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<FriendBloc>(context).add(FriendFetched());
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
    print("#POST OBSERVER: Rebuild");
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                }),
            backgroundColor: Colors.white,
            title: const Text("Bạn bè",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold)),
            centerTitle: false,
            floating: true,
            actions: [
              Container(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: IconButton(
                  icon: const Icon(Icons.search),
                  iconSize: 30,
                  color: Colors.black,
                  onPressed: () {},
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Row(children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 2, 0),
                    child: OutlinedButton(
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.grey.shade300),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(18.0)))),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                            context, Routes.unknow_people_screen);
                      },
                      child: Text('Gợi ý'),
                    )),
                Padding(
                    padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                    child: OutlinedButton(
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.grey.shade300),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(18.0)))),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Lời mời kết bạn'),
                    )),
              ]),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
                color: Colors.white,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text("Danh sách bạn bè   ",
                            style: TextStyle(fontSize: 20)),
                        NumberOfFriend(),
                      ],
                    ))),
          ),
          FriendList(),
        ],
      ),
    );
  }
}

class NumberOfFriend extends StatelessWidget {
  const NumberOfFriend({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendBloc, FriendState>(builder: (context, state) {
      final listFriend = state.listFriendState;
      return Text(listFriend.listFriend.length.toString(),
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red));
    });
  }
}

class _Friend extends StatelessWidget {
  final Friend friend;
  const _Friend({Key? key, required this.friend}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  child: FriendContainer(friend: friend)),
            ]),
          ),
        ],
      ),
    );
  }
}

class _FriendListState extends State<FriendList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendBloc, FriendState>(builder: (context, state) {
      final listFriend = state.listFriendState;
      return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
        return index >= listFriend.listFriend.length
            ? const CircularProgressIndicator()
            : _Friend(friend: listFriend.listFriend[index]);
      }, childCount: listFriend.listFriend.length));
    });
  }
}

class FriendList extends StatefulWidget {
  const FriendList({
    Key? key,
  }) : super(key: key);

  @override
  State<FriendList> createState() => _FriendListState();
}
