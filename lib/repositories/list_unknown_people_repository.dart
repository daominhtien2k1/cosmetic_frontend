import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';
import '../configuration.dart';

class ListUnknownPeopleRepository {
  Future<ListUnknownPeople> listUnknownPeopleFetch() async {
    final url =
        Uri.http(Configuration.baseUrlConnect, '/account/get_list_unknown_people');

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
          final listUnknownPeopleList = ListUnknownPeople.fromJson(body);
          return listUnknownPeopleList;
        }
      case 400:
        return ListUnknownPeople.initial();
      default:
        throw Exception('Error fetchRequestReceivedFriends');
    }
  }

  Future<ListUnknownPeople> sendRequestFriend(String id) async {
    final url = Uri.http(
        Configuration.baseUrlConnect, '/account/set_request_friend');

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
          'received_id': id
        })
    );
    switch (response.statusCode) {
      case 200:
        {
          return listUnknownPeopleFetch();
        }
      case 400:
        return ListUnknownPeople.initial();
      default:
        throw Exception('Error acceptRequestReceivedFriends');
    }
  }

}
