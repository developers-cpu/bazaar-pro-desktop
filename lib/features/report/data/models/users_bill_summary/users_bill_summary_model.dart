import '../../../domain/entities/users_bill_summary/users_bill_summary_entity.dart';

class UsersBillSummaryModel extends UsersBillSummaryEntity {
  const UsersBillSummaryModel({
    required String puName,
    required String uName,
    required double netPL,
  }) : super(puName: puName, uName: uName, netPL: netPL);
  factory UsersBillSummaryModel.fromJson(Map<String, dynamic> json) {
    return UsersBillSummaryModel(
      puName: json['puName'] ?? '',
      uName: json['uName'] ?? '',
      netPL: (json['netPL'] ?? 0.0).toDouble(),
    );
  }
  Map<String, dynamic> toJson() {
    return {'puName': puName, 'uName': uName, 'netPL': netPL};
  }
}