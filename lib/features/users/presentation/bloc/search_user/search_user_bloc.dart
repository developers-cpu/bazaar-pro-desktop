import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/entities/user_hierarchy_node/user_hierarchy_node.dart';
import '../../../domain/usecases/user/get_users.dart';
import 'search_user_event.dart';
import 'search_user_state.dart';

class SearchUserBloc extends Bloc<SearchUserEvent, SearchUserState> {
  final GetUsers getUsers;
  SearchUserBloc({required this.getUsers}) : super(const SearchUserInitial()) {
    on<LoadUserHierarchyEvent>(_onLoadHierarchy);
    on<ToggleNodeExpansionEvent>(_onToggleExpansion);
    on<SearchUserQueryEvent>(_onSearchQuery);
  }
  Future<void> _onLoadHierarchy(
    LoadUserHierarchyEvent event,
    Emitter<SearchUserState> emit,
  ) async {
    emit(const SearchUserLoading());
    final result = await getUsers(NoParams());
    result.fold((failure) => emit(SearchUserError(failure.message)), (users) {
      final nodes = _buildHierarchy(users);
      emit(SearchUserLoaded(nodes: nodes));
    });
  }

  List<UserHierarchyNode> _buildHierarchy(List<User> users) {
    final childrenMap = <String, List<User>>{};
    for (var user in users) {
      if (!childrenMap.containsKey(user.parentUser)) {
        childrenMap[user.parentUser] = [];
      }
      childrenMap[user.parentUser]!.add(user);
    }
    final allUserNames = users.map((u) => u.userName).toSet();
    final rootUsers = users
        .where((u) => !allUserNames.contains(u.parentUser))
        .toList();
    return rootUsers.map((user) => _mapUserToNode(user, childrenMap)).toList();
  }

  UserHierarchyNode _mapUserToNode(
    User user,
    Map<String, List<User>> childrenMap, {
    Set<String>? ancestors,
  }) {
    final currentAncestors = Set<String>.from(ancestors ?? {});
    if (currentAncestors.contains(user.id)) {
      return UserHierarchyNode(
        user: user,
        children: const [],
        isExpanded: false,
      );
    }
    currentAncestors.add(user.id);
    final children = childrenMap[user.userName] ?? [];
    return UserHierarchyNode(
      user: user,
      isExpanded: true,
      children: children
          .map(
            (c) => _mapUserToNode(c, childrenMap, ancestors: currentAncestors),
          )
          .toList(),
    );
  }

  void _onToggleExpansion(
    ToggleNodeExpansionEvent event,
    Emitter<SearchUserState> emit,
  ) {
    if (state is SearchUserLoaded) {
      final currentState = state as SearchUserLoaded;
      final newNodes = _toggleNodeRecursive(currentState.nodes, event.userId);
      emit(currentState.copyWith(nodes: newNodes));
    }
  }

  List<UserHierarchyNode> _toggleNodeRecursive(
    List<UserHierarchyNode> nodes,
    String userId,
  ) {
    return nodes.map((node) {
      if (node.user.id == userId) {
        return node.copyWith(isExpanded: !node.isExpanded);
      }
      return node.copyWith(
        children: _toggleNodeRecursive(node.children, userId),
      );
    }).toList();
  }

  void _onSearchQuery(
    SearchUserQueryEvent event,
    Emitter<SearchUserState> emit,
  ) {
    if (state is SearchUserLoaded) {
      final currentState = state as SearchUserLoaded;
      final newNodes = _filterNodes(
        currentState.nodes,
        event.query.toLowerCase(),
      );
      emit(currentState.copyWith(nodes: newNodes, searchQuery: event.query));
    }
  }

  List<UserHierarchyNode> _filterNodes(
    List<UserHierarchyNode> nodes,
    String query,
  ) {
    if (query.isEmpty) {
      return _resetVisibility(nodes);
    }
    List<UserHierarchyNode> processedNodes = [];
    for (var node in nodes) {
      final children = _filterNodes(node.children, query);
      final bool matches =
          node.user.userName.toLowerCase().contains(query) ||
          node.user.name.toLowerCase().contains(query);
      final bool hasVisibleChildren = children.any((c) => c.isVisible);
      if (matches || hasVisibleChildren) {
        processedNodes.add(
          node.copyWith(
            children: children,
            isVisible: true,
            isExpanded: hasVisibleChildren || matches,
          ),
        );
      } else {
        processedNodes.add(
          node.copyWith(
            children: children,
            isVisible: false,
            isExpanded: false,
          ),
        );
      }
    }
    return processedNodes;
  }

  List<UserHierarchyNode> _resetVisibility(List<UserHierarchyNode> nodes) {
    return nodes.map((n) {
      return n.copyWith(
        isVisible: true,
        children: _resetVisibility(n.children),
      );
    }).toList();
  }
}
