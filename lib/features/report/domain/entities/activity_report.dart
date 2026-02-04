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
  final DateTime updatedOn;
  final String updatedBy;
  const ActivityReport({
    required this.id,
    required this.userName,
    this.newEditUser,
    this.oldEditUser,
    this.newPhone,
    this.oldPhone,
    this.newGroupName,
    this.oldGroupName,
    required this.updatedOn,
    required this.updatedBy,
  });
  @override
  List<Object?> get props => [
    id,
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
