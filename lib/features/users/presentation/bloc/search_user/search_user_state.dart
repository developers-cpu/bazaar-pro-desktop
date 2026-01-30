import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_hierarchy_node.dart';

abstract class SearchUserState extends Equatable {
  const SearchUserState();

  @override
  List<Object?> get props => [];
}

class SearchUserInitial extends SearchUserState {
  const SearchUserInitial();
}

class SearchUserLoading extends SearchUserState {
  const SearchUserLoading();
}

class SearchUserLoaded extends SearchUserState {
  final List<UserHierarchyNode> nodes;
  final String searchQuery;

  const SearchUserLoaded({required this.nodes, this.searchQuery = ''});

  SearchUserLoaded copyWith({
    List<UserHierarchyNode>? nodes,
    String? searchQuery,
  }) {
    return SearchUserLoaded(
      nodes: nodes ?? this.nodes,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [nodes, searchQuery];
}

class SearchUserError extends SearchUserState {
  final String message;

  const SearchUserError(this.message);

  @override
  List<Object?> get props => [message];
}
