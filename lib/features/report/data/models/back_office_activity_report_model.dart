import '../../domain/entities/back_office_activity_report.dart';

class BackOfficeActivityReportModel extends BackOfficeActivityReport {
  const BackOfficeActivityReportModel({
    required super.id,
    required super.activityName,
    required super.createdOn,
    required super.createdBy,
    required super.updatedOn,
    required super.updatedBy,
  });
  factory BackOfficeActivityReportModel.fromJson(Map<String, dynamic> json) {
    return BackOfficeActivityReportModel(
      id: json['id'] ?? '',
      activityName: json['activityName'] ?? '',
      createdOn: DateTime.tryParse(json['createdOn'] ?? '') ?? DateTime.now(),
      createdBy: json['createdBy'] ?? '',
      updatedOn: DateTime.tryParse(json['updatedOn'] ?? '') ?? DateTime.now(),
      updatedBy: json['updatedBy'] ?? '',
    );
  }
}
