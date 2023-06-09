import 'dart:io';
import 'dart:convert';
import 'package:cosmetic_frontend/utils/token.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';
import '../configuration.dart';


class UserInfoRepository {
  Future<UserInfo> fetchPersonalInfo() async {
    print("#!#4Bắt đầu thực hiện fetchPersonalInfo()");
    final url = Uri.http(Configuration.baseUrlConnect, '/account/get_user_info');

    var token = await Token.getToken();

    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: token,
    });
    switch (response.statusCode) {
      case 200: {
          final body = json.decode(response.body) as Map<String, dynamic>;
          final userInfo = UserInfo.fromJson(body);
          print("#!#7Kết thúc thực hiện xong fetchPersonalInfo()");
          return userInfo;
      }
      case 400:
        return UserInfo.initial();
      default:
        throw Exception('Error fetchPersonalInfo');
    }
  }

  Future<UserInfo?> fetchPersonalInfoOfAnotherUser(String id) async {
    final url = Uri.http(Configuration.baseUrlConnect, '/account/get_user_info', {
      'user_id': id,
    });

    var token = await Token.getToken();

    final response = await http.get(url, headers: <String, String>{
      HttpHeaders.authorizationHeader: token,
      'Content-Type': 'application/json; charset=UTF-8',
    });
    switch (response.statusCode) {
      case 200: {
          final body = json.decode(response.body) as Map<String, dynamic>;
          final userInfo = UserInfo.fromJson(body);
          return userInfo;
      }
      case 400:
        return UserInfo.initial();
      case 401:
        return null;
      default:
        throw Exception('Error fetchPersonalInfo');
    }
  }

  Future<void> setNameUser(String name) async {
    final url = Uri.http(Configuration.baseUrlConnect, '/account/set_user_info');

    var token = await Token.getToken();

    final response = await http.post(url,
        headers: <String, String>{
          HttpHeaders.authorizationHeader: token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{'username': name}));
  }

  Future<void> setGenderUser(String gender) async {
    final url = Uri.http(Configuration.baseUrlConnect, '/account/set_user_info');

    var token = await Token.getToken();

    final response = await http.post(url,
        headers: <String, String>{
          HttpHeaders.authorizationHeader: token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{'gender': gender}));
  }


  Future<void> setDescriptionUser(String description) async {
    final url =
        Uri.http(Configuration.baseUrlConnect, '/account/set_user_info');

    var token = await Token.getToken();

    final response = await http.post(url,
        headers: <String, String>{
          HttpHeaders.authorizationHeader: token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{'description': description}));
  }

  Future<void> setCityUser(String city) async {
    final url = Uri.http(Configuration.baseUrlConnect, '/account/set_user_info');

    var token = await Token.getToken();

    final response = await http.post(url,
        headers: <String, String>{
          HttpHeaders.authorizationHeader: token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{'city': city}));
  }

  Future<void> setCountryUser(String country) async {
    final url = Uri.http(Configuration.baseUrlConnect, '/account/set_user_info');

    var token = await Token.getToken();

    final response = await http.post(url,
        headers: <String, String>{
          HttpHeaders.authorizationHeader: token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{'country': country}));
  }

  Future<void> setSkinUser(Skin skin) async {
    final url = Uri.http(Configuration.baseUrlConnect, '/account/set_user_info');

    var token = await Token.getToken();

    final response = await http.post(url,
        headers: <String, String>{
          HttpHeaders.authorizationHeader: token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{'skin': skin.toJson()}));
  }

  Future<void> increasePointLevel({required int point}) async {
    final url = Uri.http(Configuration.baseUrlConnect, '/account/increase_point_level');

    var token = await Token.getToken();

    final response = await http.post(url,
        headers: <String, String>{
          HttpHeaders.authorizationHeader: token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{'point': point}));
  }

  Future<String?> getRelationshipWithPerson(String personId) async {
    final url = Uri.http(Configuration.baseUrlConnect, '/account/get_relationship_with_person', {
      'person_id': personId,
    });

    var token = await Token.getToken();

    final response = await http.get(url, headers: <String, String>{
      HttpHeaders.authorizationHeader: token,
      'Content-Type': 'application/json; charset=UTF-8',
    });

    switch (response.statusCode) {
      case 200: {
        final body = json.decode(response.body) as Map<String, dynamic>;
        final relationship = body["data"]["relationship"];
        return relationship;
      }
      case 400:
        return null;
      case 401:
        return null;
      default:
        throw Exception('Error fetch relationship');
    }
  }

}
