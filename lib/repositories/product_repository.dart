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
}