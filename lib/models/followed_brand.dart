class FollowedBrand {
  final String id;
  final String slug;
  final String name;
  final String image;
  final bool isFollowed;

  FollowedBrand({
    required this.id,
    required this.slug,
    required this.name,
    required this.image,
    required this.isFollowed,
  });

  FollowedBrand copyWith({
    String? id,
    String? slug,
    String? name,
    String? image,
    bool? isFollowed,
  }) =>
      FollowedBrand(
        id: id ?? this.id,
        slug: slug ?? this.slug,
        name: name ?? this.name,
        image: image ?? this.image,
        isFollowed: isFollowed ?? this.isFollowed,
      );

  factory FollowedBrand.fromJson(Map<String, dynamic> json) => FollowedBrand(
    id: json["id"],
    slug: json["slug"],
    name: json["name"],
    image: json["image"],
    isFollowed: json["is_followed"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "slug": slug,
    "name": name,
    "image": image,
    "is_followed": isFollowed,
  };
}