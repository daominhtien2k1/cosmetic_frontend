import '../../models/models.dart';

enum SearchStatus {initial, loading, success, failure}

class SearchState {
  SearchStatus searchStatus;
  List<SavedSearch> savedSearches;
  List<String> searchSuggestions;
  SearchProductList? searchProductList;
  SearchBrandList? searchBrandList;
  SearchPostList? searchPostList;
  SearchReviewList? searchReviewList;
  SearchAccountList? searchAccountList;
  List<TopSearch> topSearches;

  SearchState({
    required this.searchStatus,
    required this.savedSearches,
    required this.searchSuggestions ,
    this.searchProductList,
    this.searchBrandList,
    this.searchPostList,
    this.searchReviewList,
    this.searchAccountList,
    required this.topSearches
  });

  SearchState.initial()
      : searchStatus = SearchStatus.initial,
        savedSearches = List<SavedSearch>.empty(growable: true),
        searchSuggestions = List<String>.empty(growable: true),
        searchProductList = SearchProductList.init(),
        searchBrandList = SearchBrandList.init(),
        searchPostList = SearchPostList.init(),
        searchReviewList = SearchReviewList.init(),
        searchAccountList = SearchAccountList.init(),
        topSearches = List<TopSearch>.empty(growable: true)
  ;

  SearchState copyWith(
      {SearchStatus? searchStatus,
        List<SavedSearch>? savedSearches,
        List<String>? searchSuggestions,
        SearchProductList? searchProductList,
        SearchBrandList? searchBrandList,
        SearchPostList? searchPostList,
        SearchReviewList? searchReviewList,
        SearchAccountList? searchAccountList,
        List<TopSearch>? topSearches
      }) {
    return SearchState(
        searchStatus: searchStatus ?? this.searchStatus,
        savedSearches: savedSearches ?? this.savedSearches,
        searchSuggestions: searchSuggestions ?? this.searchSuggestions,
        searchProductList: searchProductList ?? this.searchProductList,
        searchBrandList: searchBrandList ?? this.searchBrandList,
        searchPostList: searchPostList ?? this.searchPostList,
        searchReviewList: searchReviewList ?? this.searchReviewList,
        searchAccountList: searchAccountList ?? this.searchAccountList,
        topSearches: topSearches ?? this.topSearches
    );
  }
}
