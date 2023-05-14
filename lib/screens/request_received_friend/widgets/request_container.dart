import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../blocs/request_received_friend/request_received_friend_bloc.dart';
import '../../../blocs/request_received_friend/request_received_friend_event.dart';
import '../../../models/models.dart';

class RequestContainer extends StatelessWidget {
  final RequestReceivedFriend requestReceivedFriend;
  const RequestContainer({Key? key, required this.requestReceivedFriend})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime dt1 = DateTime.now();
    DateTime dt2 = DateTime.parse(requestReceivedFriend.createdAt);
    final Duration diff = dt1.difference(dt2);
    final String timeAgo =
        diff.inDays == 0 ? "${diff.inHours}h" : "${diff.inDays}d";
    return Container(
      // color: Colors.white,
      height: 100,
      // child: IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 8, 5),
            child: CircleAvatar(
              radius: 50,
              backgroundImage:
                  CachedNetworkImageProvider(requestReceivedFriend.avatar),
            ),
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                        flex: 5,
                        child: Text(requestReceivedFriend.name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18))),
                    Flexible(
                        flex: 2,
                        child: Text(timeAgo,
                            overflow: TextOverflow.clip,
                            style: const TextStyle(
                                fontSize: 13, color: Colors.grey)))
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 6, 2),
                          child: OutlinedButton(
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.grey)),
                            onPressed: () {
                              acceptConfirmation(context);
                            },
                            child: Text('Chấp nhận',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ))
                      // OutlinedButton(
                      //   style: ButtonStyle(
                      //       foregroundColor:
                      //           MaterialStateProperty.all<Color>(
                      //               Colors.white),
                      //       backgroundColor:
                      //           MaterialStateProperty.all<Color>(
                      //               Palette.facebookBlue)),
                      //   onPressed: () {
                      //     acceptConfirmation(context);
                      //   },
                      //   child: Text('Chấp nhận',
                      //       style: TextStyle(fontWeight: FontWeight.bold)),
                      // ))
                      ),
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(6, 0, 0, 2),
                          child: OutlinedButton(
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.grey.shade200)),
                            onPressed: () {
                              rejectConfirmation(context);
                            },
                            child: Text('Xóa'),
                          ))),
                ],
              )
            ],
          ))
        ],
      ),
    );
  }

  void acceptConfirmation(BuildContext context) {
    void handleRequestReceivedFriendAccept() {
      BlocProvider.of<RequestReceivedFriendBloc>(context).add(
          RequestReceivedFriendAccept(
              requestReceivedFriend: requestReceivedFriend));
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Chấp nhận lời mời kết bạn?'),
            actions: [
              OutlinedButton(
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey)),
                onPressed: () {
                  //TODO: Xử lý sau
                  Navigator.pop(context);
                  handleRequestReceivedFriendAccept();
                },
                child: Text('Xác nhận',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              OutlinedButton(
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey.shade200)),
                onPressed: () {
                  //TODO: Xử lý sau
                  Navigator.pop(context);
                },
                child: Text('Hủy'),
              )
            ],
          );
        });
  }

  void rejectConfirmation(BuildContext context) {
    void handleRequestReceivedFriendDelete() {
      BlocProvider.of<RequestReceivedFriendBloc>(context).add(
          RequestReceivedFriendDelete(
              requestReceivedFriend: requestReceivedFriend));
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Xóa lời mời kết bạn?'),
            actions: [
              OutlinedButton(
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey.shade200)),
                onPressed: () {
                  Navigator.pop(context);
                  handleRequestReceivedFriendDelete();
                },
                child: Text('Xác nhận',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              OutlinedButton(
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey.shade200)),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Hủy'),
              )
            ],
          );
        });
  }
}
