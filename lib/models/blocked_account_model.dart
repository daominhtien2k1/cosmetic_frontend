class BlockedAccount {
  final String account;
  final String name;
  final String avatar;

  BlockedAccount({
    required this.account,
    required this.name,
    required this.avatar,
  });

  BlockedAccount copyWith({
    String? account,
    String? name,
    String? avatar,
  }) =>
      BlockedAccount(
        account: account ?? this.account,
        name: name ?? this.name,
        avatar: avatar ?? this.avatar,
      );

  factory BlockedAccount.fromJson(Map<String, dynamic> json) => BlockedAccount(
    account: json["account"],
    name: json["name"],
    avatar: json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "account": account,
    "name": name,
    "avatar": avatar,
  };
}