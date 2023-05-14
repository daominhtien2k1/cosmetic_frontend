import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/models.dart';
import '../../routes.dart';

import '../../blocs/request_received_friend/request_received_friend_bloc.dart';
import '../../blocs/request_received_friend/request_received_friend_event.dart';
import '../../blocs/request_received_friend/request_received_friend_state.dart';

import './widgets/friend_widgets.dart';

class RequestFriendScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<RequestReceivedFriendBloc>(context)
        .add(RequestReceivedFriendFetched());
    return RequestFriendScreenContent();
  }
}

class RequestFriendScreenContent extends StatefulWidget {
  const RequestFriendScreenContent({
    Key? key,
  }) : super(key: key);

  @override
  State<RequestFriendScreenContent> createState() => _RequestFriendScreenContent();
}

class _RequestFriendScreenContent extends State<RequestFriendScreenContent> {
  @override
  Widget build(BuildContext context) {
    print("#POST OBSERVER: Rebuild");
    return Container(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
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
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.grey.shade300),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(18.0)))),
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.unknow_people_screen);
                          },
                          child: Text('Gợi ý'),
                        )),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                        child: OutlinedButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.grey.shade300),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(18.0)))),
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.friend_screen);
                          },
                          child: Text('Tất cả bạn bè'),
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
                        children: [
                          Text("Lời mời kết bạn  ",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          NumberOfFriendRequests(),
                        ],
                      )),
            ),
          ),
          FriendRequestList(),
        ],
      ),
    );
  }
}

class NumberOfFriendRequests extends StatelessWidget {
  const NumberOfFriendRequests({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestReceivedFriendBloc, RequestReceivedFriendState>(
        builder: (context, state) {
      final friendRequestReceivedList = state.friendRequestReceivedList;
      return Text(
          friendRequestReceivedList.requestReceivedFriendList.length.toString(),
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red));
    });
  }
}

class FriendRequests extends StatelessWidget {
  final RequestReceivedFriend requestReceivedFriend;
  const FriendRequests({Key? key, required this.requestReceivedFriend})
      : super(key: key);

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
                  child: RequestContainer(
                      requestReceivedFriend: requestReceivedFriend)),
            ]),
          ),
        ],
      ),
    );
  }
}

class FriendRequest extends State<FriendRequestList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestReceivedFriendBloc, RequestReceivedFriendState>(
        builder: (context, state) {
      final friendRequestReceivedList = state.friendRequestReceivedList;
      return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
        return index >=
                friendRequestReceivedList.requestReceivedFriendList.length
            ? const CircularProgressIndicator()
            : FriendRequests(
                requestReceivedFriend: friendRequestReceivedList
                    .requestReceivedFriendList[index] as RequestReceivedFriend);
      },
              childCount:
                  friendRequestReceivedList.requestReceivedFriendList.length));
    });
  }
}

class FriendRequestList extends StatefulWidget {
  const FriendRequestList({
    Key? key,
  }) : super(key: key);

  @override
  State<FriendRequestList> createState() => FriendRequest();
}
