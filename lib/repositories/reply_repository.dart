import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/models.dart';
import '../configuration.dart';
import '../utils/token.dart';

class ReplyRepository {
  Future<List<Reply>?> fetchReplies({required String reviewId}) async {
    final url = Uri.http(Configuration.baseUrlConnect, '/reply/get_reply', {'id': reviewId});

    var token = await Token.getToken();

    final response = await http.get(url,
        headers: {
          HttpHeaders.authorizationHeader: token,
        }
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final repliesData = body["data"]["replies"] as List<dynamic>?;
      List<Reply>? replies= repliesData?.map((r) => Reply.fromJson(r)).toList();
      return replies;
    } else if (response.statusCode == 400) {
      return null;
    } else {
      return null;
    }
  }

  Future<Reply?> setReply({required String reviewId, required String reply}) async {
    final url = Uri.http(Configuration.baseUrlConnect, '/reply/set_reply');

    var token = await Token.getToken();

    final response = await http.post(url,
        headers: {
          HttpHeaders.authorizationHeader: token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'id': reviewId,
          'reply': reply
        })
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final reply = Reply.fromJson(body["data"]);
      return reply;
    } else if (response.statusCode == 400) {
      return null;
    } else {
      return null;
    }
  }

}