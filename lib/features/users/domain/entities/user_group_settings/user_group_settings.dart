import 'package:equatable/equatable.dart';

class UserGroupSettings extends Equatable {
  final String id;
  final String groupName;
  final bool isAllowed;
  final double maxQuantity;
  final DateTime? lastUpdated;
  const UserGroupSettings({
    required this.id,
    required this.groupName,
    required this.isAllowed,
    required this.maxQuantity,
    this.lastUpdated,
  });
  @override
  List<Object?> get props => [
    id,
    groupName,
    isAllowed,
    maxQuantity,
    lastUpdated,
  ];
}