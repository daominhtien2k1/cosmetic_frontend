import 'package:cosmetic_frontend/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class ProductBookmarkEvent {
  @override
  List<Object> get props => [];
}

class BookmarkedProductFetched extends ProductBookmarkEvent {

}

class ProductBookmarked extends ProductBookmarkEvent {
  final BookmarkedProduct bookmarkedProduct;
  ProductBookmarked({required this.bookmarkedProduct});
}

class ProductUnbookmarked extends ProductBookmarkEvent {
  final String productId;
  ProductUnbookmarked({required this.productId});
}