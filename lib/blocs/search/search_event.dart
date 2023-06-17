import 'package:cosmetic_frontend/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class Search extends SearchEvent {
  final String keyword;
  final String searchBy;

  Search({required this.keyword, required this.searchBy});
}

class SavedSearchFetched extends SearchEvent {}

class SearchSuggestionsFetched extends SearchEvent {
  final String searchString;

  SearchSuggestionsFetched({required this.searchString});
}

class SavedSearchDelete extends SearchEvent {
  final String searchId;

  SavedSearchDelete({required this.searchId});
}

class StatusFriendInSearchAccountUpdated extends SearchEvent {
  final SearchAccount searchAccount;
  final String newStatusFriend;
  StatusFriendInSearchAccountUpdated({required this.searchAccount, required this.newStatusFriend});
}