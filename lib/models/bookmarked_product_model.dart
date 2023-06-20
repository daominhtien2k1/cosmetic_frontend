import 'package:cosmetic_frontend/models/models.dart';

class BookmarkedProduct {
  final String id;
  final String slug;
  final String name;
  final ProductImage image;
  final int reviews;
  final double rating;
  final int loves;
  final bool isBookmarked;

  BookmarkedProduct({
    required this.id,
    required this.slug,
    required this.name,
    required this.image,
    required this.reviews,
    required this.rating,
    required this.loves,
    required this.isBookmarked
  });

  BookmarkedProduct copyWith({String? id, String? slug, String? name, ProductImage? image, int? reviews, double? rating, int? loves, bool? isBookmarked}) {
    return BookmarkedProduct(
        id: id ?? this.id,
        slug: slug ?? this.slug,
        name: name ?? this.name,
        image: image ?? this.image,
        reviews: reviews ?? this.reviews,
        rating: rating ?? this.rating,
        loves: loves ?? this.loves,
        isBookmarked: isBookmarked ?? this.isBookmarked
    );
  }
  
}
