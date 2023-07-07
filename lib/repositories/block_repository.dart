import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/models.dart';
import '../configuration.dart';
import '../utils/token.dart';

class BlockRepository {
  Future<List<BlockedAccount>?> fetchBlockedAccounts() async {
    final url = Uri.http(Configuration.baseUrlConnect, '/account/get_list_blocked_accounts');

    var token = await Token.getToken();

    final response = await http.get(url,
        headers: {
          HttpHeaders.authorizationHeader: token,
        }
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final blockedAccounts = List<BlockedAccount>.from(body["data"]["blockedAccounts"].map((ba) => BlockedAccount.fromJson(ba)));
      return blockedAccounts;
    } else if (response.statusCode == 400) {
      return null;
    } else {
      return null;
    }
  }

  Future<bool> removeBlockedAccount({required String personId}) async {
    final url = Uri.http(Configuration.baseUrlConnect, '/account/remove_blocked_account');

    var token = await Token.getToken();

    try {
      final response = await http.post(url,
          headers: <String, String>{
            HttpHeaders.authorizationHeader: token,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{'person_id': personId}));

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 400) {
        return false;
      } else {
        return false;
      }
    } catch(error) {
      throw Exception('${error} - Error to remove blocked account');
    }
  }
}