import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

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

  Future<List<Review>?> fetchInstructionReviews({required String productId, int startIndex = 0, String? last_id}) async {
    try {
      // print("Fetching posts");
      const _reviewLimit = 10;
      final url = last_id != null ? Uri.http(
          Configuration.baseUrlConnect, '/review/get_list_instruction_reviews', {
        'product_id': productId,
        'index': '$startIndex',
        'count': '$_reviewLimit',
        'last_id': '$last_id'
      })
          : Uri.http(Configuration.baseUrlConnect, '/review/get_list_instruction_reviews',
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

  Future<ReviewDetail?> addReview({
    required String productId,
    required classification,
    int? rating,
    String? title,
    String? content,
    List<XFile>? imageFileList,
    List<CharacteristicReviewCriteria>? characteristicReviews
  }) async {
    try {
      var token = await Token.getToken();
      final url = Uri.http(Configuration.baseUrlConnect, 'review/add_review', {'product_id': productId});
      List<File>? imageList;
      if (imageFileList != null) {
        imageList = imageFileList.map((image) {
          File file = File(image.path);
          return file;
        }).toList();
      }

      var request = http.MultipartRequest("POST", url);
      Map<String, String> headers = { HttpHeaders.authorizationHeader: token};
      request.headers.addAll(headers);
      request.fields["classification"] = classification;
      if(rating != null) request.fields["rating"] = rating.toString();
      if(title != null) request.fields["title"] = title;
      if(content != null) request.fields["content"] = content;

      // List<Map<String, dynamic>> characteristic_reviews = [
      //   {
      //     "characteristic_id": "6475d20319f32362c05956ec",
      //     "point": 5
      //   },
      //   {
      //     "characteristic_id": "6475d20319f32362c05956ed",
      //     "point": 5
      //   },
      //   {
      //     "characteristic_id": "6475d20319f32362c05956ee",
      //     "point": 5
      //   },
      //   {
      //     "characteristic_id": "6475d20319f32362c05956ef",
      //     "point": 5
      //   },
      //   {
      //     "characteristic_id": "6475d20319f32362c05956f0",
      //     "point": 5
      //   },
      //   {
      //     "characteristic_id": "6475d20319f32362c05956f1",
      //     "point": 5
      //   },
      //   {
      //     "characteristic_id": "6475d20319f32362c05956f2",
      //     "point": 5
      //   },
      //   {
      //     "characteristic_id": "6475d20319f32362c05956f3",
      //     "point": 5
      //   }
      // ];
      // print(jsonEncode(characteristic_reviews));
      // if(characteristicReviews != null) request.fields["characteristic_reviews"] = jsonEncode(characteristic_reviews);

      // thừa criteria vẫn chạy được
      if(characteristicReviews != null) request.fields["characteristic_reviews"] = jsonEncode(List<dynamic>.from(characteristicReviews.map((c) => c.toJson2())));

      if (imageList != null && imageList.length == 1) {
        // print(imageList[0].path);
        var ext = imageList[0].path.split('.').last;
        var pic = await http.MultipartFile.fromPath("image", imageList[0].path, contentType: MediaType('image', ext));
        request.files.add(pic);
      }

      var responseStreamedResponse = await request.send();
      var responseData = await responseStreamedResponse.stream.toBytes();
      var responseUTF8 = utf8.decode(responseData);

      if (responseStreamedResponse.statusCode == 201) {
        final body = json.decode(responseUTF8) as Map<String, dynamic>;
        final reviewDetail = ReviewDetail.fromJson(body["data"]);
        return reviewDetail;
      } else if (responseStreamedResponse.statusCode == 400) {
        return null;
      } else {
        return null;
      }
    } catch (error) {
      print(error);
      throw Exception('${error} - Error to add review');
    }
  }

  Future<ReviewDetail2?> fetchDetailReview({required String reviewId}) async {
    final url = Uri.http(Configuration.baseUrlConnect, '/review/get_review/$reviewId');

    var token = await Token.getToken();

    final response = await http.get(url,
        headers: {
          HttpHeaders.authorizationHeader: token,
        }
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final reviewDetail = ReviewDetail2.fromJson(body['data']);
      return reviewDetail;
    } else if (response.statusCode == 400) {
      return null;
    } else {
      // print(json.decode(response.body) as Map<String, dynamic>);
      return null;
    }
  }

  Future<RetrieveReview?> retrieveReview({required String productId}) async {
    final url = Uri.http(Configuration.baseUrlConnect, '/review/retrieve_review', {
          'product_id': productId
    });

    var token = await Token.getToken();

    final response = await http.get(url,
        headers: {
          HttpHeaders.authorizationHeader: token,
        }
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final retrieveReview = RetrieveReview.fromJson(body['data']);
      return retrieveReview;
    } else if (response.statusCode == 400) {
      return null;
    } else {
      return null;
    }
  }

}