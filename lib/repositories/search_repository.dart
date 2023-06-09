import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/models.dart';
import '../configuration.dart';
import '../utils/token.dart';

class SearchRepository {
  Future<List<SavedSearch>> fetchSavedSearches() async {
    final url =
        Uri.http(Configuration.baseUrlConnect, '/search/get_saved_search');

    var token = await Token.getToken();

    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: token,
    });

    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final searchData = body["data"] as List<dynamic>?;
      List<SavedSearch> savedSearches = searchData != null ? searchData.map((ss) => SavedSearch.fromJson(ss)).toList() : <SavedSearch>[];
      return savedSearches;
    } else if (response.statusCode == 400) {
      return <SavedSearch>[];
    } else {
      return <SavedSearch>[];
    }
  }

  Future<List<String>> fetchSearchSuggestions({required String searchString}) async {
    final url =
    Uri.http(Configuration.baseUrlConnect, '/search/search_suggestions', {'searchString': searchString});

    var token = await Token.getToken();

    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: token,
    });

    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
   /*   // Unhandled Exception: type 'List<dynamic>' is not a subtype of type 'List<String>' in type cast
        final searchSuggestions = body["data"] as List<String>;

        List notStringList = ["aaa", "bbb"];
        print(notStringList.runtimeType); // List<dynamic>
     */
      final searchSuggestionsData = body["data"] as List<dynamic>;
      final List<String> searchSuggestions = searchSuggestionsData.map((s) => s.toString()).toList();
      return searchSuggestions;
    } else if (response.statusCode == 400) {
      return <String>[];
    } else {
      return <String>[];
    }
  }

  Future<SearchProductList?> searchSthByProduct({required String keyword}) async {
    try {
      final url = Uri.http(Configuration.baseUrlConnect, '/search/search_sth', {'keyword': keyword, 'searchBy': 'Product'});

      var token = await Token.getToken();
      final response = await http.post(url,
          headers: <String, String>{
            HttpHeaders.authorizationHeader: token,
            'Content-Type': 'application/json; charset=UTF-8',
          }
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        final searchProductList = SearchProductList.fromJson(body);
        return searchProductList;
      } else if (response.statusCode == 400) {
        return SearchProductList.init();
      } else {
        return SearchProductList.init();
      }
    } catch (error) {
      throw Exception('Error fetching search products');
    }
  }

  Future<SearchBrandList?> searchSthByBrand({required String keyword}) async {
    try {
      final url = Uri.http(Configuration.baseUrlConnect, '/search/search_sth', {'keyword': keyword, 'searchBy': 'Brand'});

      var token = await Token.getToken();
      final response = await http.post(url,
          headers: <String, String>{
            HttpHeaders.authorizationHeader: token,
            'Content-Type': 'application/json; charset=UTF-8',
          }
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        final searchBrandList = SearchBrandList.fromJson(body);
        return searchBrandList;
      } else if (response.statusCode == 400) {
        return SearchBrandList.init();
      } else {
        return SearchBrandList.init();
      }
    } catch (error) {
      throw Exception('Error fetching search brands');
    }
  }

  Future<SearchPostList?> searchSthByPost({required String keyword}) async {
    try {
      final url = Uri.http(Configuration.baseUrlConnect, '/search/search_sth', {'keyword': keyword, 'searchBy': 'Post'});

      var token = await Token.getToken();
      final response = await http.post(url,
          headers: <String, String>{
            HttpHeaders.authorizationHeader: token,
            'Content-Type': 'application/json; charset=UTF-8',
          }
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        final searchPostList = SearchPostList.fromJson(body);
        return searchPostList;
      } else if (response.statusCode == 400) {
        return SearchPostList.init();
      } else {
        return SearchPostList.init();
      }
    } catch (error) {
      throw Exception('Error fetching search posts');
    }
  }

  Future<SearchReviewList?> searchSthByReview({required String keyword}) async {
    try {
      final url = Uri.http(Configuration.baseUrlConnect, '/search/search_sth', {'keyword': keyword, 'searchBy': 'Review'});

      var token = await Token.getToken();
      final response = await http.post(url,
          headers: <String, String>{
            HttpHeaders.authorizationHeader: token,
            'Content-Type': 'application/json; charset=UTF-8',
          }
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        final searchReviewList = SearchReviewList.fromJson(body);
        return searchReviewList;
      } else if (response.statusCode == 400) {
        return SearchReviewList.init();
      } else {
        return SearchReviewList.init();
      }
    } catch (error) {
      throw Exception('Error fetching search reviews');
    }
  }

  Future<SearchAccountList?> searchSthByAccount({required String keyword}) async {
    try {
      final url = Uri.http(Configuration.baseUrlConnect, '/search/search_sth', {'keyword': keyword, 'searchBy': 'Account'});

      var token = await Token.getToken();
      final response = await http.post(url,
          headers: <String, String>{
            HttpHeaders.authorizationHeader: token,
            'Content-Type': 'application/json; charset=UTF-8',
          }
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        final searchAccountList = SearchAccountList.fromJson(body);
        return searchAccountList;
      } else if (response.statusCode == 400) {
        return SearchAccountList.init();
      } else {
        return SearchAccountList.init();
      }
    } catch (error) {
      throw Exception('Error fetching search accounts');
    }
  }

  Future<List<SavedSearch>> delSavedSearch({required String searchId}) async {
    final url = Uri.http(Configuration.baseUrlConnect, '/search/del_saved_search', {'id': searchId});

    var token = await Token.getToken();

    final response = await http.post(url, headers: {
      HttpHeaders.authorizationHeader: token,
    });

    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final searchData = body["data"] as List<dynamic>?;
      List<SavedSearch> savedSearches = searchData != null ? searchData.map((ss) => SavedSearch.fromJson(ss)).toList() : <SavedSearch>[];
      return savedSearches;
    } else if (response.statusCode == 400) {
      return <SavedSearch>[];
    } else {
      return <SavedSearch>[];
    }
  }

  Future<List<TopSearch>> fetchTopSearches() async {
    final url = Uri.http(Configuration.baseUrlConnect, '/search/get_list_top_searches');

    var token = await Token.getToken();

    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: token,
    });

    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final searchData = body["data"] as List<dynamic>?;
      List<TopSearch> topSearches = searchData != null ? searchData.map((ts) => TopSearch.fromJson(ts)).toList() : <TopSearch>[];
      return topSearches;
    } else if (response.statusCode == 400) {
      return <TopSearch>[];
    } else {
      return <TopSearch>[];
    }
  }
}
