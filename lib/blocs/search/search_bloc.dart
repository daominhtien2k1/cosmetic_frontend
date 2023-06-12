import 'package:async/async.dart';
import 'package:cosmetic_frontend/models/models.dart';
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

      if (searchBy == "Post") {
        final searchPostList = await searchRepository.searchSthByPost(keyword: keyword);
        emit(state.copyWith(searchPostList: searchPostList));
      } else if (searchBy == "Review") {
        final searchReviewList = await searchRepository.searchSthByReview(keyword: keyword);
        emit(state.copyWith(searchReviewList: searchReviewList));
      }

    } catch (err) {
      emit(state.copyWith(searchStatus: SearchStatus.failure));
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
