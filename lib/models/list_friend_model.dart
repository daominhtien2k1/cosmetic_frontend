import 'package:equatable/equatable.dart';

class ListFriend {
  List<Friend> listFriend;

  ListFriend({
    required this.listFriend,
  });


  ListFriend.initial() : listFriend = List<Friend>.empty(growable: true);

  ListFriend copyWith({
    required List<Friend> listFriends,
  }) =>
      ListFriend(
        listFriend: listFriend,
      );

  factory ListFriend.fromJson(Map<String, dynamic> json) => ListFriend(
        listFriend: List<Friend>.from(
            json["ListFriends"].map((x) => Friend.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ListFriends": List<dynamic>.from(listFriend.map((x) => x.toJson())),
      };
}

class Friend extends Equatable{
  Friend({
    required this.friend,
    required this.name,
    required this.avatar,
    required this.createdAt,
  });

  final String friend;
  final String name;
  final String avatar;
  final String createdAt;

  Friend copyWith({
    String? friend,
    String? name,
    String? avatar,
    String? createdAt,
  }) =>
      Friend(
        friend: friend ?? this.friend,
        name: name ?? this.name,
        avatar: avatar ?? this.avatar,
        createdAt: createdAt ?? this.createdAt,
      );

  factory Friend.fromJson(Map<String, dynamic> json) => Friend(
        friend: json["friend"],
        name: json["name"],
        avatar: json["avatar"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "friend": friend,
        "name": name,
        "avatar": avatar,
        "createdAt": createdAt,
      };

  @override
  List<Object?> get props => [friend, name, avatar, createdAt];
}
