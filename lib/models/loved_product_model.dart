import 'package:cosmetic_frontend/models/models.dart';

class LovedProduct {
  final String id;
  final String slug;
  final String name;
  final ProductImage image;
  final int reviews;
  final double rating;
  final int loves;
  final bool isLoved;

  LovedProduct({
    required this.id,
    required this.slug,
    required this.name,
    required this.image,
    required this.reviews,
    required this.rating,
    required this.loves,
    required this.isLoved
  });

  LovedProduct copyWith({String? id, String? slug, String? name, ProductImage? image, int? reviews, double? rating, int? loves, bool? isLoved}) {
    return LovedProduct(
        id: id ?? this.id,
        slug: slug ?? this.slug,
        name: name ?? this.name,
        image: image ?? this.image,
        reviews: reviews ?? this.reviews,
        rating: rating ?? this.rating,
        loves: loves ?? this.loves,
        isLoved: isLoved ?? this.isLoved
    );
  }

  factory LovedProduct.fromJson(Map<String, dynamic> json) {
    return LovedProduct(
        id: json["id"] as String,
        slug: json["slug"] as String,
        name: json["name"] as String,
        image: ProductImage.fromJson(json["image"]),
        reviews: json["reviews"] as int,
        rating: json["rating"].toDouble(),
        loves: json["loves"] as int,
        isLoved: json["isLoved"] as bool
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "slug": slug,
      "name": name,
      "image": image.toJson(),
      "reviews": reviews,
      "rating": rating,
      "loves": loves,
      "isLoved": isLoved
    };
  }

}
