import 'package:equatable/equatable.dart';

abstract class SearchUserEvent extends Equatable {
  const SearchUserEvent();
  @override
  List<Object?> get props => [];
}

class LoadUserHierarchyEvent extends SearchUserEvent {
  final String? rootUserName;
  const LoadUserHierarchyEvent({this.rootUserName});
  @override
  List<Object?> get props => [rootUserName];
}

class ToggleNodeExpansionEvent extends SearchUserEvent {
  final String userId;
  const ToggleNodeExpansionEvent(this.userId);
  @override
  List<Object?> get props => [userId];
}

class SearchUserQueryEvent extends SearchUserEvent {
  final String query;
  const SearchUserQueryEvent(this.query);
  @override
  List<Object?> get props => [query];
}
