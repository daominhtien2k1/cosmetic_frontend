class ReportedReview {
  final String status;
  final String subject;
  final String details;
  final String reviewId;
  final String productImage;
  final String productName;
  final String accountId;
  final String? reviewTitle;
  final double? reviewRating;
  final String? reviewContent;

  ReportedReview({
    required this.status,
    required this.subject,
    required this.details,
    required this.reviewId,
    required this.productImage,
    required this.productName,
    required this.accountId,
    this.reviewTitle,
    this.reviewRating,
    this.reviewContent,
  });

  ReportedReview copyWith({
    String? status,
    String? subject,
    String? details,
    String? reviewId,
    String? productImage,
    String? productName,
    String? accountId,
    String? reviewTitle,
    double? reviewRating,
    String? reviewContent,
  }) =>
      ReportedReview(
        status: status ?? this.status,
        subject: subject ?? this.subject,
        details: details ?? this.details,
        reviewId: reviewId ?? this.reviewId,
        productImage: productImage ?? this.productImage,
        productName: productName ?? this.productName,
        accountId: accountId ?? this.accountId,
        reviewTitle: reviewTitle ?? this.reviewTitle,
        reviewRating: reviewRating ?? this.reviewRating,
        reviewContent: reviewContent ?? this.reviewContent,
      );

  factory ReportedReview.fromJson(Map<String, dynamic> json) => ReportedReview(
    status: json["status"],
    subject: json["subject"],
    details: json["details"],
    reviewId: json["review_id"],
    productImage: json["productImage"],
    productName: json["productName"],
    accountId: json["account_id"],
    reviewTitle: json["reviewTitle"],
    reviewRating: json["reviewRating"].toDouble(),
    reviewContent: json["reviewContent"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "subject": subject,
    "details": details,
    "review_id": reviewId,
    "product_image": productImage,
    "product_name": productName,
    "account_id": accountId,
    if(reviewTitle != null) "reviewTitle": reviewTitle,
    if(reviewRating != null) "reviewRating": reviewRating,
    if(reviewContent != null) "reviewContent": reviewContent,
  };
}