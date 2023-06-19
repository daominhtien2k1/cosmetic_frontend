import 'package:cosmetic_frontend/models/product_model.dart';

class BrandDetail {
  final String id;
  final String name;
  final String slug;
  final String origin;
  final String description;
  final BrandDetailImage image;
  final int products;
  final int followers;
  final int reviews;
  final double rating;
  final List<Product> productList;
  final bool isFollowed;

  BrandDetail({
    required this.id,
    required this.name,
    required this.slug,
    required this.origin,
    required this.description,
    required this.image,
    required this.productList,
    required this.products,
    required this.followers,
    required this.reviews,
    required this.rating,
    required this.isFollowed,
  });

  BrandDetail copyWith({
    String? id,
    String? name,
    String? slug,
    String? origin,
    String? description,
    BrandDetailImage? image,
    int? products,
    int? followers,
    int? reviews,
    double? rating,
    List<Product>? productList,
    bool? isFollowed
  }) =>
      BrandDetail(
        id: id ?? this.id,
        name: name ?? this.name,
        slug: slug ?? this.slug,
        origin: origin ?? this.origin,
        description: description ?? this.description,
        image: image ?? this.image,
        products: products ?? this.products,
        followers: followers ?? this.followers,
        reviews: reviews ?? this.reviews,
        rating: rating ?? this.rating,
        productList: productList ?? this.productList,
        isFollowed: isFollowed ?? this.isFollowed,
      );

  factory BrandDetail.fromJson(Map<String, dynamic> json) => BrandDetail(
    id: json["id"] as String,
    name: json["name"] as String,
    slug: json["slug"] as String,
    origin: json["origin"] as String,
    description: json["description"] as String,
    image: BrandDetailImage.fromJson(json["image"]),
    products: json["products"] as int,
    followers: json["followers"] as int,
    reviews: json["reviews"] as int,
    rating: json["rating"].toDouble(),
    productList: List<Product>.from(json["productList"].map((x) => Product.fromJson(x))),
    isFollowed: json["is_followed"] as bool
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "origin": origin,
    "description": description,
    "image": image.toJson(),
    "products": products,
    "followers": followers,
    "reviews": reviews,
    "rating": rating,
    "productList": List<dynamic>.from(productList.map((x) => x.toJson())),
    "is_followed": isFollowed
  };
}

class BrandDetailImage {
  final String? filename;
  final String url;
  final String? publicId;

  BrandDetailImage({this.filename, required this.url, this.publicId});

  BrandDetailImage copyWith({String? filename, String? url, String? publicId}) {
    return BrandDetailImage(
      filename: filename ?? this.filename,
      url: url ?? this.url,
      publicId: publicId ?? this.publicId,
    );
  }

  factory BrandDetailImage.fromJson(Map<String, dynamic> json) {
    return BrandDetailImage(
        filename: json['filename'] as String?,
        url: json['url'] as String,
        publicId: json['publicId'] as String?
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if(filename != null) 'filename': filename,
      'url': url,
      if(publicId != null) 'publicId': publicId
    };
  }
}

