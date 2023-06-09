import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/models.dart';
import '../configuration.dart';
import '../utils/token.dart';

class BrandRepository {
  Future<BrandDetail?> fetchDetailBrand({required String brandId}) async {
    final url = Uri.http(Configuration.baseUrlConnect, '/brand/get_brand/$brandId');

    var token = await Token.getToken();

    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: token,
    });

    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final brandDetail = BrandDetail.fromJson(body['data']);
      return brandDetail;
    } else if (response.statusCode == 400) {
      return null;
    } else {
      return null;
    }
  }

  Future<void> followBrand({required String brandId}) async {
    final url = Uri.http(Configuration.baseUrlConnect, '/brand/follow_brand');

    var token = await Token.getToken();

    final response = await http.post(url,
        headers: {
          HttpHeaders.authorizationHeader: token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "id": brandId
        })
    );
  }

  Future<void> unfollowBrand({required String brandId}) async {
    final url = Uri.http(Configuration.baseUrlConnect, '/brand/unfollow_brand');

    var token = await Token.getToken();

    final response = await http.post(url,
        headers: {
          HttpHeaders.authorizationHeader: token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "id": brandId
        })
    );
  }

  Future<List<FollowedBrand>?> fetchFollowedBrand() async {
    try {
      final url = Uri.http(Configuration.baseUrlConnect, '/brand/get_followed_brands');

      var token = await Token.getToken();
      final response = await http.get(url, headers: {
        HttpHeaders.authorizationHeader: token,
      });

      if (response.statusCode == 200) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        final followedBrands = List<FollowedBrand>.from(body['data'].map((x) => FollowedBrand.fromJson(x)));
        return followedBrands;
      } else if (response.statusCode == 400) {
        return null;
      } else {
        return null;
      }
    } catch (error) {
      throw Exception('Error fetching followed brands');
    }
  }
}