import 'package:cosmetic_frontend/models/models.dart';

class SearchPostList {
  final List<Post> foundedPosts;
  final int founds;

  SearchPostList({required this.foundedPosts, required this.founds});

  SearchPostList.init(): foundedPosts = List<Post>.empty(growable: true), founds = 0;

  SearchPostList copyWith({List<Post>? foundedPosts, int? founds}) {
    return SearchPostList(
        foundedPosts: foundedPosts ?? this.foundedPosts,
        founds: founds ?? this.founds
    );
  }

  factory SearchPostList.fromJson(Map<String, dynamic> json) {
    final foundedPostsData = json["data"]["foundedPosts"] as List<dynamic>?;
    final foundedPosts = foundedPostsData != null ? foundedPostsData.map((fp) => Post.fromJson(fp)).toList(): <Post>[];
    return SearchPostList(
        foundedPosts: foundedPosts,
        founds: json["data"]["founds"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "foundedPosts": foundedPosts.map((fp) => fp.toJson()).toList(),
      "founds": founds
    };
  }
}