import 'package:equatable/equatable.dart';

class Group extends Equatable {
  final String id;
  final String exchange;
  final String groupName;
  final String count;
  final String updatedOn;
  final String updatedBy;
  final bool isDefault;
  const Group({
    required this.id,
    required this.exchange,
    required this.groupName,
    required this.count,
    required this.updatedOn,
    required this.updatedBy,
    required this.isDefault,
  });
  @override
  List<Object?> get props => [
    id,
    exchange,
    groupName,
    count,
    updatedOn,
    updatedBy,
    isDefault,
  ];
}