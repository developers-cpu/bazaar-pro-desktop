import 'package:equatable/equatable.dart';

class BackOfficeActivityReport extends Equatable {
  final String id;
  final String activityName;
  final DateTime createdOn;
  final String createdBy;
  final DateTime updatedOn;
  final String updatedBy;
  const BackOfficeActivityReport({
    required this.id,
    required this.activityName,
    required this.createdOn,
    required this.createdBy,
    required this.updatedOn,
    required this.updatedBy,
  });
  @override
  List<Object?> get props => [
    id,
    activityName,
    createdOn,
    createdBy,
    updatedOn,
    updatedBy,
  ];
}