import 'package:bazarpro/features/users/domain/entities/user.dart';
import 'package:equatable/equatable.dart';
class UserHierarchyNode extends Equatable {
  final User user;
  final List<UserHierarchyNode> children;
  final bool isExpanded;
  final bool isVisible;
  const UserHierarchyNode({
    required this.user,
    this.children = const [],
    this.isExpanded = false,
    this.isVisible = true,
  });
  UserHierarchyNode copyWith({
    User? user,
    List<UserHierarchyNode>? children,
    bool? isExpanded,
    bool? isVisible,
  }) {
    return UserHierarchyNode(
      user: user ?? this.user,
      children: children ?? this.children,
      isExpanded: isExpanded ?? this.isExpanded,
      isVisible: isVisible ?? this.isVisible,
    );
  }
  @override
  List<Object?> get props => [user, children, isExpanded, isVisible];
}
