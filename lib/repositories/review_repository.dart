import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/models.dart';
import '../configuration.dart';
import '../utils/token.dart';

class ReviewRepository {
  Future<StatisticStar?> fetchListReviewsStar({required String productId}) async {
    final url = Uri.http(Configuration.baseUrlConnect, '/review/get_list_reviews_star', {'product_id': productId});

    var token = await Token.getToken();

    final response = await http.get(url,
        headers: {
          HttpHeaders.authorizationHeader: token,
        }
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final statisticStar = StatisticStar.fromJson(body['data']);
      return statisticStar;
    } else if (response.statusCode == 400) {
      return null;
    } else {
      return null;
    }
  }

  Future<ProductCharacteristic?> fetchProductCharacteristicStatistics({required String productId}) async {
    final url = Uri.http(Configuration.baseUrlConnect, '/review/product_characteristic_statistics', {'product_id': productId});

    var token = await Token.getToken();

    final response = await http.get(url,
        headers: {
          HttpHeaders.authorizationHeader: token,
        }
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final productCharacteristic = ProductCharacteristic.fromJson(body['data']);
      return productCharacteristic;
    } else if (response.statusCode == 400) {
      return null;
    } else {
      return null;
    }
  }

  Future<List<Review>?> fetchReviews({required String productId, int startIndex = 0, String? last_id}) async {
    try {
      // print("Fetching posts");
      const _reviewLimit = 10;
      final url = last_id != null ? Uri.http(
          Configuration.baseUrlConnect, '/review/get_list_reviews', {
        'product_id': productId,
        'index': '$startIndex',
        'count': '$_reviewLimit',
        'last_id': '$last_id'
      })
          : Uri.http(Configuration.baseUrlConnect, '/review/get_list_reviews',
          {'product_id': productId, 'index': '$startIndex', 'count': '$_reviewLimit'});

      var token = await Token.getToken();

      final response = await http.get(url, headers: {
        HttpHeaders.authorizationHeader: token,
      });

      if (response.statusCode == 200) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        final reviews = List<Review>.from(body["data"]["reviews"].map((r) => Review.fromJson(r)));
        return reviews;
      } else if (response.statusCode == 400) {
        return null;
      } else {
        return null;
      }
    } catch(error) {
      throw Exception('Error fetching reviews');
    }

  }
}