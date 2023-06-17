class SearchAccountList {
  final List<SearchAccount> foundedAccounts;
  final int founds;

  SearchAccountList({required this.foundedAccounts, required this.founds});

  SearchAccountList.init(): foundedAccounts = List<SearchAccount>.empty(growable: true), founds = 0;

  SearchAccountList copyWith({List<SearchAccount>? foundedAccounts, int? founds}) {
    return SearchAccountList(
        foundedAccounts: foundedAccounts ?? this.foundedAccounts,
        founds: founds ?? this.founds
    );
  }

  factory SearchAccountList.fromJson(Map<String, dynamic> json) {
    final foundedAccountsData = json["data"]["foundedAccounts"] as List<dynamic>?;
    final foundedAccounts = foundedAccountsData != null ? foundedAccountsData.map((fa) => SearchAccount.fromJson(fa)).toList(): <SearchAccount>[];
    return SearchAccountList(
        foundedAccounts: foundedAccounts,
        founds: json["data"]["founds"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "foundedAccounts": foundedAccounts.map((fa) => fa.toJson()).toList(),
      "founds": founds
    };
  }
}

class SearchAccount {
  final String id;
  final String avatar;
  final String name;
  final int level;
  // dù không sử dụng final nhưng vẫn không được
  final String statusFriend;

  SearchAccount({
    required this.id,
    required this.avatar,
    required this.name,
    required this.level,
    required this.statusFriend,
  });

  SearchAccount copyWith({
    String? id,
    String? avatar,
    String? name,
    int? level,
    String? statusFriend,
  }) =>
      SearchAccount(
        id: id ?? this.id,
        avatar: avatar ?? this.avatar,
        name: name ?? this.name,
        level: level ?? this.level,
        statusFriend: statusFriend ?? this.statusFriend,
      );

  factory SearchAccount.fromJson(Map<String, dynamic> json) => SearchAccount(
    id: json["id"],
    avatar: json["avatar"],
    name: json["name"],
    level: json["level"],
    statusFriend: json["statusFriend"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "avatar": avatar,
    "name": name,
    "level": level,
    "statusFriend": statusFriend,
  };
}