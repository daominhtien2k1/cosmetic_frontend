class DeletedBannedPost {
  final String subject;
  final String details;
  final String postId;
  final String accountId;
  final String postDescribed;

  DeletedBannedPost({
    required this.subject,
    required this.details,
    required this.postId,
    required this.accountId,
    required this.postDescribed,
  });

  DeletedBannedPost copyWith({
    String? status,
    String? subject,
    String? details,
    String? postId,
    String? accountId,
    String? postDescribed,
  }) =>
      DeletedBannedPost(
        subject: subject ?? this.subject,
        details: details ?? this.details,
        postId: postId ?? this.postId,
        accountId: accountId ?? this.accountId,
        postDescribed: postDescribed ?? this.postDescribed,
      );

  factory DeletedBannedPost.fromJson(Map<String, dynamic> json) => DeletedBannedPost(
    subject: json["subject"],
    details: json["details"],
    postId: json["post_id"],
    accountId: json["account_id"],
    postDescribed: json["postDescribed"],
  );

  Map<String, dynamic> toJson() => {
    "subject": subject,
    "details": details,
    "post_id": postId,
    "account_id": accountId,
    "postDescribed": postDescribed,
  };
}