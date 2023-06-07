class Reply {
  final String id;
  final String reply;
  final String createdAt;
  final ReplyPoster poster;

  Reply({required this.id, required this.reply, required this.createdAt, required this.poster,});

  Reply copyWith({String? id, String? reply, String? created, ReplyPoster? poster}) {
    return Reply(
      id: id ?? this.id,
      reply: reply ?? this.reply,
      createdAt: created ?? this.createdAt,
      poster: poster ?? this.poster,
    );
  }

  factory Reply.fromJson(Map<String, dynamic> json) {
    return Reply(
      id: json["id"],
      reply: json["reply"],
      createdAt: json["createdAt"],
      poster: ReplyPoster.fromJson(json["poster"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "comment": reply,
      "createdAt": createdAt,
      "poster": poster.toJson(),
    };
  }
}

class ReplyPoster {
  final String id;
  final String name;
  final String avatar;

  ReplyPoster({required this.id, required this.name, required this.avatar});

  ReplyPoster copyWith({String? id, String? name, String? avatar}) {
    return ReplyPoster(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
    );
  }

  factory ReplyPoster.fromJson(Map<String, dynamic> json) {
    return ReplyPoster(
      id: json["id"],
      name: json["name"],
      avatar: json["avatar"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "avatar": avatar,
    };
  }

}
