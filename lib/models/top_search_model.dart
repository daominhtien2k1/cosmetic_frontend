class TopSearch {
  final String keyword;
  final int count;

  TopSearch({
    required this.keyword,
    required this.count,
  });

  TopSearch copyWith({
    String? keyword,
    int? count,
  }) =>
      TopSearch(
        keyword: keyword ?? this.keyword,
        count: count ?? this.count,
      );

  factory TopSearch.fromJson(Map<String, dynamic> json) => TopSearch(
    keyword: json["keyword"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "keyword": keyword,
    "count": count,
  };
}