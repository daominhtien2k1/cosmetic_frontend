import 'package:equatable/equatable.dart';

class ListUnknownPeople {
  List<UnknownPerson> listUnknownPeople;

  ListUnknownPeople({
    required this.listUnknownPeople,
  });


  ListUnknownPeople.initial() : listUnknownPeople = List<UnknownPerson>.empty(growable: true);

  ListUnknownPeople copyWith({
    List<UnknownPerson>? listUnknownPeople,
  }) =>
      ListUnknownPeople(
        listUnknownPeople: listUnknownPeople ?? this.listUnknownPeople,
      );

  factory ListUnknownPeople.fromJson(Map<String, dynamic> json) => ListUnknownPeople(
    listUnknownPeople: List<UnknownPerson>.from(json["ListUnknownPeople"].map((x) => UnknownPerson.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ListUnknownPeople": List<dynamic>.from(listUnknownPeople.map((x) => x.toJson())),
  };
}

class UnknownPerson extends Equatable{
  UnknownPerson({
    required this.id,
    required this.name,
    required this.avatar,
  });

  final String id;
  final String name;
  final String avatar;

  UnknownPerson copyWith({
    String? id,
    String? name,
    String? avatar,
  }) =>
      UnknownPerson(
        id: id ?? this.id,
        name: name ?? this.name,
        avatar: avatar ?? this.avatar,
      );

  factory UnknownPerson.fromJson(Map<String, dynamic> json) => UnknownPerson(
    id: json["id"],
    name: json["name"],
    avatar: json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "avatar": avatar,
  };

  @override
  List<Object?> get props => [id, name, avatar];
}
