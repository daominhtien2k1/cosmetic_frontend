class SearchBrandList {
  final List<SearchBrand> foundedBrands;
  final int founds;

  SearchBrandList({required this.foundedBrands, required this.founds});

  SearchBrandList.init(): foundedBrands = List<SearchBrand>.empty(growable: true), founds = 0;

  SearchBrandList copyWith({List<SearchBrand>? foundedBrands, int? founds}) {
    return SearchBrandList(
        foundedBrands: foundedBrands ?? this.foundedBrands,
        founds: founds ?? this.founds
    );
  }

  factory SearchBrandList.fromJson(Map<String, dynamic> json) {
    final foundedBrandsData = json["data"]["foundedBrands"] as List<dynamic>?;
    final foundedBrands = foundedBrandsData != null ? foundedBrandsData.map((fa) => SearchBrand.fromJson(fa)).toList(): <SearchBrand>[];
    return SearchBrandList(
        foundedBrands: foundedBrands,
        founds: json["data"]["founds"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "foundedBrands": foundedBrands.map((fa) => fa.toJson()).toList(),
      "founds": founds
    };
  }
}

class SearchBrand {
  final String id;
  final String slug;
  final String name;
  final String image;
  final bool isFollowed;

  SearchBrand({
    required this.id,
    required this.slug,
    required this.name,
    required this.image,
    required this.isFollowed,
  });

  SearchBrand copyWith({
    String? id,
    String? slug,
    String? name,
    String? image,
    bool? isFollowed,
  }) =>
      SearchBrand(
        id: id ?? this.id,
        slug: slug ?? this.slug,
        name: name ?? this.name,
        image: image ?? this.image,
        isFollowed: isFollowed ?? this.isFollowed,
      );

  factory SearchBrand.fromJson(Map<String, dynamic> json) => SearchBrand(
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