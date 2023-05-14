import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';
import '../configuration.dart';

class FriendRequestReceivedRepository {
  Future<FriendRequestReceivedList> fetchRequestReceivedFriends() async {
    final url = Uri.http(
        Configuration.baseUrlConnect, '/account/get_requested_friends');

    // get token from local storage/cache
    final prefs = await SharedPreferences.getInstance();
    String userPref = prefs.getString('user') ?? '{"token": "No userdata"}';
    Map<String, dynamic> userMap = jsonDecode(userPref) as Map<String, dynamic>;
    // print("#Post_repository: " + userMap.toString());
    final token = userMap['token'] != 'No userdata'
        ? userMap['token']
        : Configuration.token;
    // print("#Post_repository: " +  token.toString());

    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: token,
    });
    switch (response.statusCode) {
      case 200:
        {
          final body = json.decode(response.body) as Map<String, dynamic>;
          final friendRequestReceivedList =
              FriendRequestReceivedList.fromJson(body);
          return friendRequestReceivedList;
        }
      case 400:
        return FriendRequestReceivedList.initial();
      default:
        throw Exception('Error fetchRequestReceivedFriends');
    }
  }

  Future<FriendRequestReceivedList> acceptRequestReceivedFriends(String fromUser) async {
    final url = Uri.http(
        Configuration.baseUrlConnect, '/account/set_accept_friend');

    // get token from local storage/cache
    final prefs = await SharedPreferences.getInstance();
    String userPref = prefs.getString('user') ?? '{"token": "No userdata"}';
    Map<String, dynamic> userMap = jsonDecode(userPref) as Map<String, dynamic>;
    // print("#Post_repository: " + userMap.toString());
    final token = userMap['token'] != 'No userdata'
        ? userMap['token']
        : Configuration.token;
    // print("#Post_repository: " +  token.toString());

    final response = await http.post(url,
        headers: <String, String>{
          HttpHeaders.authorizationHeader: token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'sent_id': fromUser
        })
    );
    switch (response.statusCode) {
      case 200:
        {
          return fetchRequestReceivedFriends();
        }
      case 400:
        return FriendRequestReceivedList.initial();
      default:
        throw Exception('Error acceptRequestReceivedFriends');
    }
  }

  Future<FriendRequestReceivedList> deleteRequestReceivedFriends(String fromUser) async {
    final url = Uri.http(
        Configuration.baseUrlConnect, '/account/del_request_friend');

    // get token from local storage/cache
    final prefs = await SharedPreferences.getInstance();
    String userPref = prefs.getString('user') ?? '{"token": "No userdata"}';
    Map<String, dynamic> userMap = jsonDecode(userPref) as Map<String, dynamic>;
    // print("#Post_repository: " + userMap.toString());
    final token = userMap['token'] != 'No userdata'
        ? userMap['token']
        : Configuration.token;
    // print("#Post_repository: " +  token.toString());

    final response = await http.post(url,
        headers: <String, String>{
          HttpHeaders.authorizationHeader: token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'sent_id': fromUser
        })
    );
    switch (response.statusCode) {
      case 200:
        {
          return fetchRequestReceivedFriends();
        }
      case 400:
        return FriendRequestReceivedList.initial();
      default:
        throw Exception('Error deleteRequestReceivedFriends');
    }
  }
}
