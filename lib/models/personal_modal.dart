class UserInfo {
  UserInfo({
    required this.avatar,
    required this.coverImage,
    required this.name,
    required this.gender,
    required this.phoneNumber,
    required this.description,
    required this.city,
    required this.country,
    required this.skin,
    required this.point,
    required this.level
  });

  final String avatar;
  final String coverImage;
  final String name;
  final String gender;
  final String phoneNumber;
  final String description;
  final String city;
  final String country;
  final Skin skin;
  final int point;
  final int level;

  UserInfo.initial()
      : avatar = "",
        coverImage = "",
        name = "",
        gender = "",
        phoneNumber = "",
        description = "",
        city = "",
        country = "",
        skin = Skin.init(),
        point = 0,
        level = 1;

  UserInfo copyWith({
    String? avatar,
    String? coverImage,
    String? name,
    String? gender,
    String? phoneNumber,
    String? description,
    String? city,
    String? country,
    Skin? skin,
    int? point,
    int? level
  }) =>
      UserInfo(
        avatar: avatar ?? this.avatar,
        coverImage: coverImage ?? this.coverImage,
        name: name ?? this.name,
        gender: gender ?? this.gender,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        description: description ?? this.description,
        city: city ?? this.city,
        country: country ?? this.country,
        skin: skin ?? this.skin,
        point: point ?? this.point,
        level: level ?? this.point
      );

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        avatar: json["avatar"] as String,
        coverImage: json["coverImage"] as String,
        name: json["name"] as String,
        gender: json["gender"] as String,
        phoneNumber: json["phoneNumber"] as String,
        description: json["description"] as String,
        city: json["city"] as String,
        country: json["country"] as String,
        skin: Skin.fromJson(json["skin"]),
        point: json["point"] as int,
        level: json["level"] as int
      );

  Map<String, dynamic> toJson() => {
        "avatar": avatar,
        "coverImage": coverImage,
        "name": name,
        "gender": gender,
        "phoneNumber": phoneNumber,
        "description": description,
        "city": city,
        "country": country,
        "skin": skin.toJson(),
        "point": point,
        "level": level
      };
}


class Skin {
  final Obstacle obstacle;
  final String type;

  Skin({
    required this.obstacle,
    required this.type,
  });

  Skin.init(): obstacle = Obstacle(isSensitive: false, hasAcne: false), type = "Da thường";

  Skin copyWith({
    Obstacle? obstacle,
    String? type,
  }) =>
      Skin(
        obstacle: obstacle ?? this.obstacle,
        type: type ?? this.type,
      );

  factory Skin.fromJson(Map<String, dynamic> json) => Skin(
    obstacle: Obstacle.fromJson(json["obstacle"]),
    type: json["type"] as String,
  );

  Map<String, dynamic> toJson() => {
    "obstacle": obstacle.toJson(),
    "type": type,
  };
}

class Obstacle {
  final bool isSensitive;
  final bool hasAcne;

  Obstacle({
    required this.isSensitive,
    required this.hasAcne,
  });

  Obstacle copyWith({
    bool? isSensitive,
    bool? hasAcne,
  }) =>
      Obstacle(
        isSensitive: isSensitive ?? this.isSensitive,
        hasAcne: hasAcne ?? this.hasAcne,
      );

  factory Obstacle.fromJson(Map<String, dynamic> json) => Obstacle(
    isSensitive: json["isSensitive"] as bool,
    hasAcne: json["hasAcne"] as bool,
  );

  Map<String, dynamic> toJson() => {
    "isSensitive": isSensitive,
    "hasAcne": hasAcne,
  };
}

