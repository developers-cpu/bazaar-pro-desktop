import '../../domain/entities/activity_report.dart';

class ActivityReportModel extends ActivityReport {
  const ActivityReportModel({
    required super.id,
    required super.activityName,
    required super.createdOn,
    required super.createdBy,
    required super.updatedOn,
    required super.updatedBy,
    super.userName,
    super.newEditUser,
    super.oldEditUser,
    super.newPhone,
    super.oldPhone,
    super.newGroupName,
    super.oldGroupName,
  });
  factory ActivityReportModel.fromJson(Map<String, dynamic> json) {
    return ActivityReportModel(
      id: json['id'] ?? '',
      activityName: json['activityName'] ?? '',
      createdOn: DateTime.tryParse(json['createdOn'] ?? '') ?? DateTime.now(),
      createdBy: json['createdBy'] ?? '',
      updatedOn: DateTime.tryParse(json['updatedOn'] ?? '') ?? DateTime.now(),
      updatedBy: json['updatedBy'] ?? '',
      userName: json['userName'] ?? '',
      newEditUser: json['newEditUser'],
      oldEditUser: json['oldEditUser'],
      newPhone: json['newPhone'],
      oldPhone: json['oldPhone'],
      newGroupName: json['newGroupName'],
      oldGroupName: json['oldGroupName'],
    );
  }
}