class ReportedReview {
  final String status;
  final String subject;
  final String details;
  final String reviewId;
  final String accountId;
  final String? reviewTitle;
  final double? reviewRating;
  final String? reviewContent;

  ReportedReview({
    required this.status,
    required this.subject,
    required this.details,
    required this.reviewId,
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
    "account_id": accountId,
    if(reviewTitle != null) "reviewTitle": reviewTitle,
    if(reviewRating != null) "reviewRating": reviewRating,
    if(reviewContent != null) "reviewContent": reviewContent,
  };
}