import 'package:async/async.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/repositories.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  late final SearchRepository searchRepository;
  late CancelableOperation<void> _cancellableOperation;

  SearchBloc() : super(SearchState.initial()) {
    searchRepository = SearchRepository();

    on<SavedSearchFetched>(_onGetSavedSearch);

    _startCancelFuture();
    on<SearchSuggestionsFetched>(_onSearchSuggestionsFetched);

    on<Search>(_onSearch);
    on<SavedSearchDelete>(_onSavedSearchDelete);

    on<StatusFriendInSearchAccountUpdated>(_onStatusFriendInSearchAccountUpdated);
    on<IsFollowedInSearchBrandUpdated>(_onIsFollowedInSearchBrandUpdated);
  }

  void _startCancelFuture() {
    // initialize
    _cancellableOperation = CancelableOperation.fromFuture(

      // Time delay after when type text search
      Future.delayed(Duration(milliseconds: 200)), onCancel: () {
        // print('Canceled');
      }
    );
  }

  Future<void> _onGetSavedSearch(SavedSearchFetched event, Emitter<SearchState> emit) async {
    try {
      final savedSearches = await searchRepository.fetchSavedSearches();
      emit(state.copyWith(searchStatus: SearchStatus.success, savedSearches: savedSearches));
    } catch (_) {
      emit(state.copyWith(searchStatus: SearchStatus.failure));
    }
  }

  Future<void> _onSearchSuggestionsFetched(SearchSuggestionsFetched event, Emitter<SearchState> emit) async {
    try {
      // print("Call");
      // cancel CancelableOperation trước đó, nếu có
      _cancellableOperation.cancel();
      _startCancelFuture();
      await _cancellableOperation.value.whenComplete(() {
       // print("Complete");
      });
      final searchSuggestions = await searchRepository.fetchSearchSuggestions(searchString: event.searchString);
      emit(state.copyWith(searchStatus: SearchStatus.success, searchSuggestions: searchSuggestions));

    } catch (err) {
      // print(err);
      emit(state.copyWith(searchStatus: SearchStatus.failure));
    }
  }

  Future<void> _onSearch(Search event, Emitter<SearchState> emitter) async {
    try {
      final String keyword = event.keyword;
      final String searchBy = event.searchBy;

      if (searchBy == "Product") {
        final searchProductList = await searchRepository.searchSthByProduct(keyword: keyword);
        emit(state.copyWith(searchProductList: searchProductList));
      } else if (searchBy == "Brand") {
        final searchBrandList = await searchRepository.searchSthByBrand(keyword: keyword);
        emit(state.copyWith(searchBrandList: searchBrandList));
      } else if (searchBy == "Post") {
        final searchPostList = await searchRepository.searchSthByPost(keyword: keyword);
        emit(state.copyWith(searchPostList: searchPostList));
      } else if (searchBy == "Review") {
        final searchReviewList = await searchRepository.searchSthByReview(keyword: keyword);
        emit(state.copyWith(searchReviewList: searchReviewList));
      } else if (searchBy == "Account") {
        final searchAccountList = await searchRepository.searchSthByAccount(keyword: keyword);
        emit(state.copyWith(searchAccountList: searchAccountList));
      }

    } catch (err) {
      emit(state.copyWith(searchStatus: SearchStatus.failure));
    }
  }

  Future<void> _onStatusFriendInSearchAccountUpdated(StatusFriendInSearchAccountUpdated event, Emitter<SearchState> emit) async {
    try {
      final searchAccount = event.searchAccount;
      final newStatusFriend = event.newStatusFriend;
      final searchAccountList = state.searchAccountList;
      // print(searchAccountList?.foundedAccounts.first.statusFriend);
      if (searchAccountList != null) {
        final indexSearchAccountToReplace = searchAccountList.foundedAccounts.indexOf(searchAccount);
        final newSearchAccount = searchAccount.copyWith(statusFriend: newStatusFriend);
        if (indexSearchAccountToReplace != -1) {
          searchAccountList?.foundedAccounts?..removeAt(indexSearchAccountToReplace)..insert(indexSearchAccountToReplace, newSearchAccount);
        }
        // print(searchAccountList?.foundedAccounts.first.statusFriend);
        emit(state.copyWith(searchAccountList: searchAccountList));
      }

    } catch (err) {

    }
  }

  Future<void> _onIsFollowedInSearchBrandUpdated(IsFollowedInSearchBrandUpdated event, Emitter<SearchState> emit) async {
    try {
      final searchBrand = event.searchBrand;
      final newIsFollowed = event.newIsFollowed;
      final searchBrandList = state.searchBrandList;
      if (searchBrandList != null) {
        final indexSearchBrandToReplace = searchBrandList.foundedBrands.indexOf(searchBrand);
        final newSearchBrand = searchBrand.copyWith(isFollowed: newIsFollowed);
        if (indexSearchBrandToReplace != -1) {
          searchBrandList?.foundedBrands?..removeAt(indexSearchBrandToReplace)..insert(indexSearchBrandToReplace, newSearchBrand);
        }
        emit(state.copyWith(searchBrandList: searchBrandList));
      }
    } catch (err) {

    }
  }

  Future<void> _onSavedSearchDelete(SavedSearchDelete event, Emitter<SearchState> emit) async {
    try {
      final String searchId = event.searchId;
      final savedSearches = state.savedSearches;
      final searchToRemoveIndex = savedSearches.indexWhere((s) => s.id == searchId);
      savedSearches.removeAt(searchToRemoveIndex);
      emit(state.copyWith(savedSearches: savedSearches));
      final savedSearchesReload = await searchRepository.delSavedSearch(searchId: searchId);
      emit(state.copyWith(searchStatus: SearchStatus.success, savedSearches: savedSearchesReload));

    } catch (err) {
      emit(state.copyWith(searchStatus: SearchStatus.failure));
    }
  }

}
