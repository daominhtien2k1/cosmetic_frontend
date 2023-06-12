import '../../models/models.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState {
  SearchStatus searchStatus;
  List<SavedSearch> savedSearches;
  List<String> searchSuggestions;
  SearchPostList? searchPostList;
  SearchReviewList? searchReviewList;

  SearchState({
    required this.searchStatus,
    required this.savedSearches,
    required this.searchSuggestions ,
    this.searchPostList,
    this.searchReviewList
  });

  SearchState.initial()
      : searchStatus = SearchStatus.initial,
        savedSearches = List<SavedSearch>.empty(growable: true),
        searchSuggestions = List<String>.empty(growable: true),
        searchPostList = SearchPostList.init(),
        searchReviewList = SearchReviewList.init()
  ;

  SearchState copyWith(
      {SearchStatus? searchStatus,
        List<SavedSearch>? savedSearches,
        List<String>? searchSuggestions,
        SearchPostList? searchPostList,
        SearchReviewList? searchReviewList
      }) {
    return SearchState(
        searchStatus: searchStatus ?? this.searchStatus,
        savedSearches: savedSearches ?? this.savedSearches,
        searchSuggestions: searchSuggestions ?? this.searchSuggestions,
        searchPostList: searchPostList ?? this.searchPostList,
        searchReviewList: searchReviewList ?? this.searchReviewList
    );
  }
}
