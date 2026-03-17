import '../../models/back_office_activity_report_model.dart';

abstract class BackOfficeActivityReportRemoteDataSource {
  Future<List<BackOfficeActivityReportModel>> getBackOfficeActivityReport();
}

class BackOfficeActivityReportRemoteDataSourceImpl
    implements BackOfficeActivityReportRemoteDataSource {
  @override
  Future<List<BackOfficeActivityReportModel>>
  getBackOfficeActivityReport() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final List<BackOfficeActivityReportModel> mockData = [
      BackOfficeActivityReportModel(
        id: '1',
        activityName: 'Exchange Settings',
        createdOn: DateTime(2025, 12, 26, 12, 0, 0),
        createdBy: 'DEMO4',
        updatedOn: DateTime(2025, 12, 26, 12, 0, 0),
        updatedBy: 'DEMO4',
      ),
      BackOfficeActivityReportModel(
        id: '2',
        activityName: 'Group',
        createdOn: DateTime(2025, 12, 26, 12, 0, 0),
        createdBy: 'DEMO4',
        updatedOn: DateTime(2025, 12, 26, 12, 0, 0),
        updatedBy: 'DEMO4',
      ),
      BackOfficeActivityReportModel(
        id: '3',
        activityName: 'Trade Setting',
        createdOn: DateTime(2025, 12, 26, 12, 0, 0),
        createdBy: 'DEMO4',
        updatedOn: DateTime(2025, 12, 26, 12, 0, 0),
        updatedBy: 'DEMO4',
      ),
      BackOfficeActivityReportModel(
        id: '4',
        activityName: 'Date Setting',
        createdOn: DateTime(2025, 12, 26, 12, 0, 0),
        createdBy: 'DEMO4',
        updatedOn: DateTime(2025, 12, 26, 12, 0, 0),
        updatedBy: 'DEMO4',
      ),
      BackOfficeActivityReportModel(
        id: '5',
        activityName: 'Script Setting',
        createdOn: DateTime(2025, 12, 26, 12, 0, 0),
        createdBy: 'DEMO4',
        updatedOn: DateTime(2025, 12, 26, 12, 0, 0),
        updatedBy: 'DEMO4',
      ),
      BackOfficeActivityReportModel(
        id: '6',
        activityName: 'Bulk Order',
        createdOn: DateTime(2025, 12, 26, 12, 0, 0),
        createdBy: 'DEMO4',
        updatedOn: DateTime(2025, 12, 26, 12, 0, 0),
        updatedBy: 'DEMO4',
      ),
      BackOfficeActivityReportModel(
        id: '7',
        activityName: 'VPN Restriction',
        createdOn: DateTime(2025, 12, 26, 12, 0, 0),
        createdBy: 'DEMO4',
        updatedOn: DateTime(2025, 12, 26, 12, 0, 0),
        updatedBy: 'DEMO4',
      ),
      BackOfficeActivityReportModel(
        id: '8',
        activityName: 'Message',
        createdOn: DateTime(2025, 12, 26, 12, 0, 0),
        createdBy: 'DEMO4',
        updatedOn: DateTime(2025, 12, 26, 12, 0, 0),
        updatedBy: 'DEMO4',
      ),
      BackOfficeActivityReportModel(
        id: '9',
        activityName: 'Settlement Progress',
        createdOn: DateTime(2025, 12, 26, 12, 0, 0),
        createdBy: 'DEMO4',
        updatedOn: DateTime(2025, 12, 26, 12, 0, 0),
        updatedBy: 'DEMO4',
      ),
      BackOfficeActivityReportModel(
        id: '10',
        activityName: 'Server',
        createdOn: DateTime(2025, 12, 26, 12, 0, 0),
        createdBy: 'DEMO4',
        updatedOn: DateTime(2025, 12, 26, 12, 0, 0),
        updatedBy: 'DEMO4',
      ),
      BackOfficeActivityReportModel(
        id: '11',
        activityName: 'Bill Comparision',
        createdOn: DateTime(2025, 12, 26, 12, 0, 0),
        createdBy: 'DEMO4',
        updatedOn: DateTime(2025, 12, 26, 12, 0, 0),
        updatedBy: 'DEMO4',
      ),
      BackOfficeActivityReportModel(
        id: '12',
        activityName: 'Inactivity Management',
        createdOn: DateTime(2025, 12, 26, 12, 0, 0),
        createdBy: 'DEMO4',
        updatedOn: DateTime(2025, 12, 26, 12, 0, 0),
        updatedBy: 'DEMO4',
      ),
    ];
    return mockData;
  }
}
