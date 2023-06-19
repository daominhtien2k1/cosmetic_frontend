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
}