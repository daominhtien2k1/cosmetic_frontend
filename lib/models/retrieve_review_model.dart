import 'package:cosmetic_frontend/models/review_model.dart';

// add review
class RetrieveReview {
  final String id;
  final String classification;
  final List<CharacteristicReviewCriteria>? characteristicReviews;
  final int? rating;
  final String? title;
  final String? content;
  final List<AttachedReviewImage>? images;
  final AttachedReviewVideo? video;

  RetrieveReview({
    required this.id,
    required this.classification,
    this.characteristicReviews,
    this.rating,
    this.title,
    this.content,
    this.images,
    this.video
  });

  RetrieveReview copyWith({
    String? id,
    String? classification,
    List<CharacteristicReviewCriteria>? characteristicReviews,
    int? rating,
    String? title,
    String? content,
    List<AttachedReviewImage>? images,
    AttachedReviewVideo? video
  }) {
    return RetrieveReview(
        id: id ?? this.id,
        classification: classification ?? this.classification,
        characteristicReviews: characteristicReviews ?? this.characteristicReviews,
        rating: rating ?? this.rating,
        title: title ?? this.title,
        content: content ?? this.content,
        images: images ?? this.images,
        video: video ?? this.video
    );
  }

  factory RetrieveReview.fromJson(Map<String, dynamic> json) {
    final imagesData = json["images"] as List<dynamic>?;
    final images = imagesData != null ? imagesData.map((imageData) =>
        AttachedReviewImage.fromJson(imageData)).toList() : null;

    final videoData = json["video"] as Map<String, dynamic>?;
    final video = videoData != null ? AttachedReviewVideo.fromJson(videoData): null;

    return RetrieveReview(
      id: json["id"] as String,
      classification: json["classification"] as String,
      characteristicReviews: json["characteristic_reviews"] != null ? List<CharacteristicReviewCriteria>.from(json["characteristic_reviews"].map((x) => CharacteristicReviewCriteria.fromJson(x))) : null,
      rating: json["rating"] as int?,
      title: json["title"] as String?,
      content: json["content"] as String?,
      images: images,
      video: video,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "classification": classification,
      if(characteristicReviews!= null) "characteristic_reviews": List<dynamic>.from(characteristicReviews!.map((x) => x.toJson())),
      if(rating != null) "rating": rating,
      if(title != null) "title": title,
      if(content != null) "content": content,
      if(images != null) "images": images!.map((image) => image.toJson()).toList(),
      if(video != null) "video": video!.toJson(),
    };
  }
}
