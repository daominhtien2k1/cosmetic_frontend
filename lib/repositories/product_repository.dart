import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/models.dart';
import '../configuration.dart';
import '../utils/token.dart';

class ProductRepository {
  Future<List<Carousel>?> fetchProductCarousel() async {
    final url = Uri.http(Configuration.baseUrlConnect, '/product/get_list_carousels');

    var token = await Token.getToken();

    final response = await http.get(url,
        headers: {
          HttpHeaders.authorizationHeader: token,
        }
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final carouselsData = body["data"]["carouselList"] as List<dynamic>?;
      List<Carousel>? carousels = carouselsData?.map((crl) => Carousel.fromJson(crl)).toList();
      return carousels;
    } else if (response.statusCode == 400) {
      return null;
    } else {
      return null;
    }
  }

  Future<List<Product>?> fetchPopularProducts() async {
    final url = Uri.http(Configuration.baseUrlConnect, '/product/get_popular_products');

    var token = await Token.getToken();

    final response = await http.get(url,
        headers: {
          HttpHeaders.authorizationHeader: token,
        }
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final popularProductsData = body["data"] as List<dynamic>?;
      List<Product>? popularProducts = popularProductsData?.map((p) => Product.fromJson(p)).toList();
      return popularProducts;
    } else if (response.statusCode == 400) {
      return null;
    } else {
      return null;
    }
  }

  Future<ProductDetail?> fetchDetailProduct({required String productId}) async {
    final url = Uri.http(Configuration.baseUrlConnect, '/product/get_product/$productId');

    var token = await Token.getToken();

    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: token,
    });

    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final productDetail = ProductDetail.fromJson(body['data']);
      return productDetail;
    } else if (response.statusCode == 400) {
      return null;
    } else {
      return null;
    }
  }

  Future<List<RelateProduct>?> fetchRelateProducts({required String productId}) async {
    final url = Uri.http(Configuration.baseUrlConnect, '/product/get_relate_products', {'product_id': productId});

    var token = await Token.getToken();

    final response = await http.get(url,
        headers: {
          HttpHeaders.authorizationHeader: token,
        }
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final relateProductsData = body["data"] as List<dynamic>?;
      List<RelateProduct>? relateProducts = relateProductsData?.map((p) => RelateProduct.fromJson(p)).toList();
      return relateProducts;
    } else if (response.statusCode == 400) {
      return null;
    } else {
      return null;
    }
  }

  Future<List<CharacteristicReviewCriteria>?> fetchCharacteristics({required String productId}) async {
    final url = Uri.http(Configuration.baseUrlConnect, '/product/get_list_characteristics', {'product_id': productId});

    var token = await Token.getToken();

    final response = await http.get(url,
        headers: {
          HttpHeaders.authorizationHeader: token,
        }
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final characteristicCriterias = List<CharacteristicReviewCriteria>.from(body["data"]["characteristic_reviews"].map((c) => CharacteristicReviewCriteria.fromJson(c)));
      return characteristicCriterias;
    } else if (response.statusCode == 400) {
      return null;
    } else {
      return null;
    }
  }

  Future<void> loveProduct({required String productId}) async {
    final url = Uri.http(Configuration.baseUrlConnect, '/product/love_product');

    var token = await Token.getToken();

    final response = await http.post(url,
        headers: {
          HttpHeaders.authorizationHeader: token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "id": productId
        })
    );
  }

  Future<void> unloveProduct({required String productId}) async {
    final url = Uri.http(Configuration.baseUrlConnect, '/product/unlove_product');

    var token = await Token.getToken();

    final response = await http.post(url,
        headers: {
          HttpHeaders.authorizationHeader: token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "id": productId
        })
    );
  }

  Future<void> viewProduct({required String productId}) async {
    final url = Uri.http(Configuration.baseUrlConnect, '/product/view_product');

    var token = await Token.getToken();

    final response = await http.post(url,
        headers: {
          HttpHeaders.authorizationHeader: token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "id": productId
        })
    );
  }

  Future<List<LovedProduct>?> fetchLovedProducts() async {
    final url = Uri.http(Configuration.baseUrlConnect, '/product/get_loved_products');

    var token = await Token.getToken();

    final response = await http.get(url,
        headers: {
          HttpHeaders.authorizationHeader: token,
        }
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final lovedProductsData = body["data"] as List<dynamic>?;
      List<LovedProduct>? lovedProducts = lovedProductsData?.map((p) => LovedProduct.fromJson(p)).toList();
      return lovedProducts;
    } else if (response.statusCode == 400) {
      return null;
    } else {
      return null;
    }
  }

  Future<List<ViewedProduct>?> fetchViewedProducts() async {
    final url = Uri.http(Configuration.baseUrlConnect, '/product/get_viewed_products');

    var token = await Token.getToken();

    final response = await http.get(url,
        headers: {
          HttpHeaders.authorizationHeader: token,
        }
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final viewedProductsData = body["data"] as List<dynamic>?;
      List<ViewedProduct>? viewedProducts = viewedProductsData?.map((p) => ViewedProduct.fromJson(p)).toList();
      return viewedProducts;
    } else if (response.statusCode == 400) {
      return null;
    } else {
      return null;
    }
  }

}