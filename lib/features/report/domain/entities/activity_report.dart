import 'package:equatable/equatable.dart';
class ActivityReport extends Equatable {
  final String id;
  final String userName;
  final String? newEditUser;
  final String? oldEditUser;
  final String? newPhone;
  final String? oldPhone;
  final String? newGroupName;
  final String? oldGroupName;
  final String activityName;
  final DateTime createdOn;
  final String createdBy;
  final DateTime updatedOn;
  final String updatedBy;
  const ActivityReport({
    required this.id,
    required this.activityName,
    required this.createdOn,
    required this.createdBy,
    required this.updatedOn,
    required this.updatedBy,
    this.userName = '',
    this.newEditUser,
    this.oldEditUser,
    this.newPhone,
    this.oldPhone,
    this.newGroupName,
    this.oldGroupName,
  });
  @override
  List<Object?> get props => [
    id,
    activityName,
    createdOn,
    createdBy,
    userName,
    newEditUser,
    oldEditUser,
    newPhone,
    oldPhone,
    newGroupName,
    oldGroupName,
    updatedOn,
    updatedBy,
  ];
}
