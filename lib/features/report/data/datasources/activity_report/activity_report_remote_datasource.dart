import '../../models/activity_report_model.dart';

abstract class ActivityReportRemoteDataSource {
  Future<List<ActivityReportModel>> getActivityReport({
    String? user,
    DateTime? startDate,
    DateTime? endDate,
    String? editUserType,
  });
}

class ActivityReportRemoteDataSourceImpl
    implements ActivityReportRemoteDataSource {
  @override
  Future<List<ActivityReportModel>> getActivityReport({
    String? user,
    DateTime? startDate,
    DateTime? endDate,
    String? editUserType,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final List<ActivityReportModel> mockData = [
      ActivityReportModel(
        id: '1',
        activityName: 'Leverage',
        createdOn: DateTime(2025, 12, 26, 0, 0, 0),
        createdBy: 'DEMO4',
        updatedOn: DateTime(2025, 12, 26, 0, 0, 0),
        updatedBy: 'DEMO4',
      ),
      ActivityReportModel(
        id: '2',
        activityName: 'Allowed Exchange',
        createdOn: DateTime(2025, 12, 26, 0, 0, 0),
        createdBy: 'DEMO4',
        updatedOn: DateTime(2025, 12, 26, 0, 0, 0),
        updatedBy: 'DEMO4',
      ),
      ActivityReportModel(
        id: '3',
        activityName: 'Exchange Group',
        createdOn: DateTime(2025, 12, 26, 0, 0, 0),
        createdBy: 'DEMO4',
        updatedOn: DateTime(2025, 12, 26, 0, 0, 0),
        updatedBy: 'DEMO4',
      ),
      ActivityReportModel(
        id: '4',
        activityName: 'High Low Between Limit / SL',
        createdOn: DateTime(2025, 12, 26, 0, 0, 0),
        createdBy: 'DEMO4',
        updatedOn: DateTime(2025, 12, 26, 0, 0, 0),
        updatedBy: 'DEMO4',
      ),
      ActivityReportModel(
        id: '5',
        activityName: 'Fresh Order',
        createdOn: DateTime(2025, 12, 26, 0, 0, 0),
        createdBy: 'DEMO4',
        updatedOn: DateTime(2025, 12, 26, 0, 0, 0),
        updatedBy: 'DEMO4',
      ),
      ActivityReportModel(
        id: '6',
        activityName: 'Fifteen Days',
        createdOn: DateTime(2025, 12, 26, 0, 0, 0),
        createdBy: 'DEMO4',
        updatedOn: DateTime(2025, 12, 26, 0, 0, 0),
        updatedBy: 'DEMO4',
      ),
      ActivityReportModel(
        id: '7',
        activityName: 'Brokerage',
        createdOn: DateTime(2025, 12, 26, 0, 0, 0),
        createdBy: 'DEMO4',
        updatedOn: DateTime(2025, 12, 26, 0, 0, 0),
        updatedBy: 'DEMO4',
      ),
      ActivityReportModel(
        id: '8',
        activityName: 'Trade margin',
        createdOn: DateTime(2025, 12, 26, 0, 0, 0),
        createdBy: 'DEMO4',
        updatedOn: DateTime(2025, 12, 26, 0, 0, 0),
        updatedBy: 'DEMO4',
      ),
      ActivityReportModel(
        id: '9',
        activityName: 'Bet',
        createdOn: DateTime(2025, 12, 26, 0, 0, 0),
        createdBy: 'DEMO4',
        updatedOn: DateTime(2025, 12, 26, 0, 0, 0),
        updatedBy: 'DEMO4',
      ),
      ActivityReportModel(
        id: '10',
        activityName: 'Close Only',
        createdOn: DateTime(2025, 12, 26, 0, 0, 0),
        createdBy: 'DEMO4',
        updatedOn: DateTime(2025, 12, 26, 0, 0, 0),
        updatedBy: 'DEMO4',
      ),
      ActivityReportModel(
        id: '11',
        activityName: 'View Only',
        createdOn: DateTime(2025, 12, 26, 0, 0, 0),
        createdBy: 'DEMO4',
        updatedOn: DateTime(2025, 12, 26, 0, 0, 0),
        updatedBy: 'DEMO4',
      ),
      ActivityReportModel(
        id: '12',
        activityName: 'Stauts',
        createdOn: DateTime(2025, 12, 26, 0, 0, 0),
        createdBy: 'DEMO4',
        updatedOn: DateTime(2025, 12, 26, 0, 0, 0),
        updatedBy: 'DEMO4',
      ),
      ActivityReportModel(
        id: '13',
        activityName: 'Intraday Square off',
        createdOn: DateTime(2025, 12, 26, 0, 0, 0),
        createdBy: 'DEMO4',
        updatedOn: DateTime(2025, 12, 26, 0, 0, 0),
        updatedBy: 'DEMO4',
      ),
      ActivityReportModel(
        id: '14',
        activityName: 'Allow Chat with Super Admin',
        createdOn: DateTime(2025, 12, 26, 0, 0, 0),
        createdBy: 'DEMO4',
        updatedOn: DateTime(2025, 12, 26, 0, 0, 0),
        updatedBy: 'DEMO4',
      ),
      ActivityReportModel(
        id: '15',
        activityName: 'Profit Square off',
        createdOn: DateTime(2025, 12, 26, 0, 0, 0),
        createdBy: 'DEMO4',
        updatedOn: DateTime(2025, 12, 26, 0, 0, 0),
        updatedBy: 'DEMO4',
      ),
      ActivityReportModel(
        id: '16',
        activityName: 'Time Restriction for SL / Limit',
        createdOn: DateTime(2025, 12, 26, 0, 0, 0),
        createdBy: 'DEMO4',
        updatedOn: DateTime(2025, 12, 26, 0, 0, 0),
        updatedBy: 'DEMO4',
      ),
      ActivityReportModel(
        id: '17',
        activityName: 'Lock User',
        createdOn: DateTime(2025, 12, 26, 0, 0, 0),
        createdBy: 'DEMO4',
        updatedOn: DateTime(2025, 12, 26, 0, 0, 0),
        updatedBy: 'DEMO4',
      ),
    ];
    return mockData.where((item) {
      if (user != null &&
          user.isNotEmpty &&
          item.userName.toLowerCase() != user.toLowerCase()) {
        return false;
      }
      if (startDate != null && item.updatedOn.isBefore(startDate)) {
        return false;
      }
      if (endDate != null && item.updatedOn.isAfter(endDate)) {
        return false;
      }
      return true;
    }).toList();
  }
}
