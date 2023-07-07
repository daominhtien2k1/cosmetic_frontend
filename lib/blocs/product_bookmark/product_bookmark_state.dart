import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../models/models.dart';

enum ProductBookmarkStatus {initial, loading, success, failure}

// không rebuild lại list khi extends Equatable (hình như vậy)
class ProductBookmarkState extends Equatable {
  final ProductBookmarkStatus productBookmarkStatus;
  final List<BookmarkedProduct>? bookmarkedProducts;

  ProductBookmarkState({required this.productBookmarkStatus, required this.bookmarkedProducts});

  ProductBookmarkState.initial(): productBookmarkStatus = ProductBookmarkStatus.initial, bookmarkedProducts = List<BookmarkedProduct>.empty(growable: true);

  ProductBookmarkState copyWith({ProductBookmarkStatus? productBookmarkStatus, List<BookmarkedProduct>? bookmarkedProducts}) {
    return ProductBookmarkState(
      productBookmarkStatus: productBookmarkStatus ?? this.productBookmarkStatus,
      bookmarkedProducts: bookmarkedProducts ?? this.bookmarkedProducts
    );
  }

  factory ProductBookmarkState.fromJson(Map<String, dynamic> json) {
    return ProductBookmarkState(
      productBookmarkStatus: (json["productBookmarkStatus"] as String).toEnum2() ?? ProductBookmarkStatus.initial,
      bookmarkedProducts: json["bookmarkedProducts"] != null ? List<BookmarkedProduct>.from(json["bookmarkedProducts"].map((p) => BookmarkedProduct.fromJson(p))) : null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "productBookmarkStatus": productBookmarkStatus.toEnumString2(),
      if (bookmarkedProducts!= null) "bookmarkedProducts": List<dynamic>.from(bookmarkedProducts!.map((bp) => bp.toJson()))
    };
  }

  @override
  List<Object?> get props => [productBookmarkStatus, bookmarkedProducts];
}

extension StringToEnumProductBookmarkStatus on String {
  ProductBookmarkStatus toEnum1() => ProductBookmarkStatus.values.byName(this); // không thể nhận null được
  ProductBookmarkStatus? toEnum2() => ProductBookmarkStatus.values.asNameMap()[this];
  ProductBookmarkStatus? toEnum3() {
    // ProductBookmarkStatus.values.firstWhere((element) => element.toString() == 'ProductBookmarkStatus.' + this, orElse: () => null); // error

   /*   final List<int?> arr = [1,2,3];
        int? x = arr.firstWhere((e) => e == 4, orElse: () => null);
        print(x);
    */

    final List<ProductBookmarkStatus?> productBookmarkStatusArray = ProductBookmarkStatus.values;
    // không hiểu sao run-time lỗi:  Expected a value of type '(() => ProductBookmarkStatus)?', but got one of type '() => Null'
    // return productBookmarkStatusArray.firstWhere((element) => element.toString() == 'ProductBookmarkStatus.' + this, orElse: () => null); // error
    return productBookmarkStatusArray.firstWhere((element) => element.toString() == 'ProductBookmarkStatus.' + 'loading', orElse: () => ProductBookmarkStatus.initial);
  }


}

extension EnumToStringProductBookmarkStatus on ProductBookmarkStatus {
  String toEnumString1() => this.toString().split('.').last;
  String toEnumString2() => this.name;
  String toEnumString3() => describeEnum(this);
}