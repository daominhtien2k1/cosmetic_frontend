import 'package:equatable/equatable.dart';

class FriendRequestReceivedList {
  List<RequestReceivedFriend> requestReceivedFriendList;

  FriendRequestReceivedList({
    required this.requestReceivedFriendList,
  });

  FriendRequestReceivedList.initial()
      : requestReceivedFriendList =
            List<RequestReceivedFriend>.empty(growable: true);

  FriendRequestReceivedList copyWith({
    List<RequestReceivedFriend>? requestReceivedFriend,
  }) =>
      FriendRequestReceivedList(
        requestReceivedFriendList:
            requestReceivedFriend ?? this.requestReceivedFriendList,
      );

  factory FriendRequestReceivedList.fromJson(Map<String, dynamic> json) =>
      FriendRequestReceivedList(
        requestReceivedFriendList: List<RequestReceivedFriend>.from(
            json["RequestReceivedFriend"]
                .map((x) => RequestReceivedFriend.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "RequestReceivedFriend": List<dynamic>.from(
            requestReceivedFriendList.map((x) => x.toJson())),
      };
}

class RequestReceivedFriend extends Equatable{
  RequestReceivedFriend({
    required this.fromUser,
    required this.name,
    required this.avatar,
    required this.createdAt,
  });

  String fromUser;
  String name;
  String avatar;
  String createdAt;

  RequestReceivedFriend copyWith({
    String? fromUser,
    String? name,
    String? avatar,
    String? createdAt,
  }) =>
      RequestReceivedFriend(
        fromUser: fromUser ?? this.fromUser,
        name: name ?? this.name,
        avatar: avatar ?? this.avatar,
        createdAt: createdAt ?? this.createdAt,
      );

  factory RequestReceivedFriend.fromJson(Map<String, dynamic> json) =>
      RequestReceivedFriend(
        fromUser: json["fromUser"],
        name: json["name"],
        avatar: json["avatar"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "fromUser": fromUser,
        "name": name,
        "avatar": avatar,
        "createdAt": createdAt,
      };

  @override
  List<Object?> get props => [fromUser, name, avatar, createdAt];
}
