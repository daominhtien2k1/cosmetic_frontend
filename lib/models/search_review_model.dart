import 'package:cosmetic_frontend/models/models.dart';

class SearchReviewList {
  final List<SearchReview> foundedReviews;
  final int founds;

  SearchReviewList({required this.foundedReviews, required this.founds});

  SearchReviewList.init(): foundedReviews = List<SearchReview>.empty(growable: true), founds = 0;

  SearchReviewList copyWith({List<SearchReview>? foundedReviews, int? founds}) {
    return SearchReviewList(
      foundedReviews: foundedReviews ?? this.foundedReviews,
      founds: founds ?? this.founds
    );
  }

  factory SearchReviewList.fromJson(Map<String, dynamic> json) {
    final foundedReviewsData = json["data"]["foundedReviews"] as List<dynamic>?;
    final foundedReviews = foundedReviewsData != null ? foundedReviewsData.map((fr) => SearchReview.fromJson(fr)).toList(): <SearchReview>[];
    return SearchReviewList(
        foundedReviews: foundedReviews,
        founds: json["data"]["founds"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "foundedReviews": foundedReviews.map((fr) => fr.toJson()).toList(),
      "founds": founds
    };
  }
}

class SearchReview {
  final String id;
  final ProductInDetailReview product;
  final String classification;
  final List<CharacteristicReviewCriteria>? characteristicReviews;
  final int? rating;
  final String? title;
  final String? content;
  final String createdAt;
  final String updatedAt;
  final int usefuls;
  final int replies;
  final AuthorReview author;
  final bool isSettedUseful;
  final bool isBlocked;
  final bool canEdit;
  final bool banned;
  final bool canReply;
  final List<AttachedReviewImage>? images;
  final AttachedReviewVideo? video;

  SearchReview({
    required this.id,
    required this.product,
    required this.classification,
    this.characteristicReviews,
    this.rating,
    this.title,
    this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.usefuls,
    required this.replies,
    required this.author,
    required this.isSettedUseful,
    required this.isBlocked,
    required this.canEdit,
    required this.banned,
    required this.canReply,
    this.images,
    this.video
  });

  SearchReview copyWith({
    String? id,
    ProductInDetailReview? product,
    String? classification,
    List<CharacteristicReviewCriteria>? characteristicReviews,
    int? rating,
    String? title,
    String? content,
    String? createdAt,
    String? updatedAt,
    int? usefuls,
    int? replies,
    AuthorReview? author,
    bool? isSettedUseful,
    bool? isBlocked,
    bool? canEdit,
    bool? banned,
    bool? canReply,
    List<AttachedReviewImage>? images,
    AttachedReviewVideo? video
  }) =>
      SearchReview(
          id: id ?? this.id,
          product: product ?? this.product,
          classification: classification ?? this.classification,
          characteristicReviews: characteristicReviews ?? this.characteristicReviews,
          rating: rating ?? this.rating,
          title: title ?? this.title,
          content: content ?? this.content,
          createdAt: createdAt ?? this.createdAt,
          updatedAt: updatedAt ?? this.updatedAt,
          usefuls: usefuls ?? this.usefuls,
          replies: replies ?? this.replies,
          author: author ?? this.author,
          isSettedUseful: isSettedUseful ?? this.isSettedUseful,
          isBlocked: isBlocked ?? this.isBlocked,
          canEdit: canEdit ?? this.canEdit,
          banned: banned ?? this.banned,
          canReply: canReply ?? this.canReply,
          images: images ?? this.images,
          video: video ?? this.video
      );

  factory SearchReview.fromJson(Map<String, dynamic> json) {
    final imagesData = json["images"] as List<dynamic>?;
    final images = imagesData != null ? imagesData.map((imageData) =>
        AttachedReviewImage.fromJson(imageData)).toList() : null;

    final videoData = json["video"] as Map<String, dynamic>?;
    final video = videoData != null ? AttachedReviewVideo.fromJson(videoData): null;
    return SearchReview(
      id: json["id"],
      product: ProductInDetailReview.fromJson(json["product"]),
      classification: json["classification"] as String,
      characteristicReviews: json["characteristic_reviews"] != null
          ? List<CharacteristicReviewCriteria>.from(
          json["characteristic_reviews"].map((x) =>
              CharacteristicReviewCriteria.fromJson(x)))
          : null,
      rating: json["rating"] as int?,
      title: json["title"] as String?,
      content: json["content"] as String?,
      createdAt: json["createdAt"] as String,
      updatedAt: json["updatedAt"] as String,
      usefuls: json["usefuls"] as int,
      replies: json["replies"] as int,
      author: AuthorReview.fromJson(json["author"]),
      isSettedUseful: json["is_setted_useful"],
      isBlocked: json["is_blocked"] as bool,
      canEdit: json["can_edit"] as bool,
      banned: json["banned"] as bool,
      canReply: json["can_reply"] as bool,
      images: images,
      video: video,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "product": product.toJson(),
    "classification": classification,
    if(characteristicReviews!= null) "characteristic_reviews": List<dynamic>.from(characteristicReviews!.map((x) => x.toJson())),
    if(rating != null) "rating": rating,
    if(title != null) "title": title,
    if(content != null) "content": content,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "usefuls": usefuls,
    "replies": replies,
    "author": author.toJson(),
    "is_setted_useful": isSettedUseful,
    "is_blocked": isBlocked,
    "can_edit": canEdit,
    "banned": banned,
    "can_reply": canReply,
    if(images != null) "images": images!.map((image) => image.toJson()).toList(),
    if(video != null) "video": video!.toJson(),
  };
}
