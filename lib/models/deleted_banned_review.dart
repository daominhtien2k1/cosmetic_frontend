class DeletedBannedReview {
  final String subject;
  final String details;
  final String reviewId;
  final String classification;
  final String productImage;
  final String productName;
  final double? rating;
  final String title;
  final String content;

  DeletedBannedReview({
    required this.subject,
    required this.details,
    required this.reviewId,
    required this.classification,
    required this.productImage,
    required this.productName,
    this.rating,
    required this.title,
    required this.content,
  });

  DeletedBannedReview copyWith({
    String? subject,
    String? details,
    String? reviewId,
    String? classification,
    String? productImage,
    String? productName,
    double? rating,
    String? title,
    String? content,
  }) =>
      DeletedBannedReview(
        subject: subject ?? this.subject,
        details: details ?? this.details,
        reviewId: reviewId ?? this.reviewId,
        classification: classification ?? this.classification,
        productImage: productImage ?? this.productImage,
        productName: productName ?? this.productName,
        rating: rating ?? this.rating,
        title: title ?? this.title,
        content: content ?? this.content,
      );

  factory DeletedBannedReview.fromJson(Map<String, dynamic> json) => DeletedBannedReview(
    subject: json["subject"],
    details: json["details"],
    reviewId: json["review_id"],
    classification: json["classification"],
    productImage: json["productImage"],
    productName: json["productName"],
    rating: json["rating"]?.toDouble(),
    title: json["title"],
    content: json["content"],
  );

  Map<String, dynamic> toJson() => {
    "subject": subject,
    "details": details,
    "review_id": reviewId,
    "classification": classification,
    "productImage": productImage,
    "productName": productName,
    if(rating != null) "rating": rating,
    "title": title,
    "content": content,
  };
}
