import '../../domain/entities/activity_report.dart';

class ActivityReportModel extends ActivityReport {
  const ActivityReportModel({
    required super.id,
    required super.userName,
    super.newEditUser,
    super.oldEditUser,
    super.newPhone,
    super.oldPhone,
    super.newGroupName,
    super.oldGroupName,
    required super.updatedOn,
    required super.updatedBy,
  });

  factory ActivityReportModel.fromJson(Map<String, dynamic> json) {
    return ActivityReportModel(
      id: json['id'] ?? '',
      userName: json['userName'] ?? '',
      newEditUser: json['newEditUser'],
      oldEditUser: json['oldEditUser'],
      newPhone: json['newPhone'],
      oldPhone: json['oldPhone'],
      newGroupName: json['newGroupName'],
      oldGroupName: json['oldGroupName'],
      updatedOn: DateTime.tryParse(json['updatedOn'] ?? '') ?? DateTime.now(),
      updatedBy: json['updatedBy'] ?? '',
    );
  }
}
