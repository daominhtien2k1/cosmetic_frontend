import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';
import '../configuration.dart';

class FriendRepository {
  Future<ListFriend> friendsFetch() async {
    print("#!#5Bắt đầu thực hiện friendsFetch()");
    final url =
        Uri.http(Configuration.baseUrlConnect, '/account/get_list_friends');

    final prefs = await SharedPreferences.getInstance();
    String userPref = prefs.getString('user') ?? '{"token": "No userdata"}';
    Map<String, dynamic> userMap = jsonDecode(userPref) as Map<String, dynamic>;
    final token = userMap['token'] != 'No userdata'
        ? userMap['token']
        : Configuration.token;
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: token,
    });

    switch (response.statusCode) {
      case 200:
        {
          final body = json.decode(response.body) as Map<String, dynamic>;
          final friendList = ListFriend.fromJson(body);
          print("#!#6Kết thúc thực hiện xong friendsFetch()");
          return friendList;
        }
      case 400:
        return ListFriend.initial();
      default:
        throw Exception('Error fetchRequestReceivedFriends');
    }
  }

  Future<ListFriend> friendOfAnotherUserFetched(String id) async {
    final url =
        Uri.http(Configuration.baseUrlConnect, '/account/get_list_friends', {
      'user_id': id,
    });

    final prefs = await SharedPreferences.getInstance();
    String userPref = prefs.getString('user') ?? '{"token": "No userdata"}';
    Map<String, dynamic> userMap = jsonDecode(userPref) as Map<String, dynamic>;
    final token = userMap['token'] != 'No userdata'
        ? userMap['token']
        : Configuration.token;
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: token,
    });
    switch (response.statusCode) {
      case 200:
        {
          final body = json.decode(response.body) as Map<String, dynamic>;
          final friendList = ListFriend.fromJson(body);
          return friendList;
        }
      case 400:
        return ListFriend.initial();
      default:
        throw Exception('Error fetchRequestReceivedFriends');
    }
  }

  Future<Object> deleteFriends(String id) async {
    final url = Uri.http(Configuration.baseUrlConnect, '/account/del_friend');

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
        body: jsonEncode(<String, dynamic>{'sent_id': id}));

    switch (response.statusCode) {
      case 200:
        {
          return friendsFetch();
        }
      case 400:
        return ListFriend.initial();
      default:
        throw Exception('Error deleteRequestReceivedFriends');
    }
  }
}
