import 'package:cosmetic_frontend/models/models.dart';

class SearchProductList {
  final List<Product> foundedProducts;
  final int founds;

  SearchProductList({required this.foundedProducts, required this.founds});

  SearchProductList.init(): foundedProducts = List<Product>.empty(growable: true), founds = 0;

  SearchProductList copyWith({List<Product>? foundedProducts, int? founds}) {
    return SearchProductList(
        foundedProducts: foundedProducts ?? this.foundedProducts,
        founds: founds ?? this.founds
    );
  }

  factory SearchProductList.fromJson(Map<String, dynamic> json) {
    final foundedProductsData = json["data"]["foundedProducts"] as List<dynamic>?;
    final foundedProducts = foundedProductsData != null ? foundedProductsData.map((fp) => Product.fromJson(fp)).toList(): <Product>[];
    return SearchProductList(
        foundedProducts: foundedProducts,
        founds: json["data"]["founds"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "foundedProducts": foundedProducts.map((fp) => fp.toJson()).toList(),
      "founds": founds
    };
  }
}