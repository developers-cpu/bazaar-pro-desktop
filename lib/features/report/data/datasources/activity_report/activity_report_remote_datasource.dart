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
        userName: 'PATIL01',
        newEditUser: 'PATIL',
        oldEditUser: 'PATIL',
        newPhone: '8421415118',
        oldPhone: '8421415118',
        updatedOn: DateTime.now().subtract(const Duration(days: 1)),
        updatedBy: 'DEMO4',
      ),
      ActivityReportModel(
        id: '2',
        userName: 'DEMO23',
        oldGroupName: 'MCX 2X',
        updatedOn: DateTime.now().subtract(const Duration(days: 2)),
        updatedBy: 'DEMO4',
      ),
      ActivityReportModel(
        id: '3',
        userName: 'DEMO',
        newEditUser: 'DEMO',
        oldEditUser: 'DEMO',
        newPhone: '8456946514',
        oldPhone: '8456946514',
        updatedOn: DateTime.now().subtract(const Duration(days: 3)),
        updatedBy: 'DEMO4',
      ),
      ActivityReportModel(
        id: '4',
        userName: 'DEMO1',
        oldGroupName: 'GIFT 3X',
        updatedOn: DateTime.now().subtract(const Duration(days: 4)),
        updatedBy: 'DEMO4',
      ),
      ActivityReportModel(
        id: '5',
        userName: 'DEMO1',
        oldGroupName: 'COMEX 2X',
        updatedOn: DateTime.now().subtract(const Duration(days: 5)),
        updatedBy: 'DEMO4',
      ),
      ActivityReportModel(
        id: '6',
        userName: 'DEMO1',
        oldGroupName: 'CRYPTO 3X',
        updatedOn: DateTime.now().subtract(const Duration(days: 6)),
        updatedBy: 'DEMO4',
      ),
      ActivityReportModel(
        id: '7',
        userName: 'DEMO1',
        newEditUser: 'DEMO1',
        oldEditUser: 'DEMO1',
        newPhone: '3654789847',
        oldPhone: '3654789847',
        oldGroupName: 'US-STOCK 3X',
        updatedOn: DateTime.now().subtract(const Duration(days: 7)),
        updatedBy: 'DEMO4',
      ),
      ActivityReportModel(
        id: '8',
        userName: 'DEMO1',
        newEditUser: 'DEMO01',
        oldEditUser: 'DEMO01',
        newPhone: '9989718319',
        oldPhone: '9989718319',
        oldGroupName: 'FOREX 3X',
        updatedOn: DateTime.now().subtract(const Duration(days: 8)),
        updatedBy: 'DEMO4',
      ),
      ActivityReportModel(
        id: '9',
        userName: 'DEMO1',
        newEditUser: 'DEMO01',
        oldEditUser: 'DEMO01',
        newPhone: '9989718319',
        oldPhone: '9989718319',
        updatedOn: DateTime.now().subtract(const Duration(days: 9)),
        updatedBy: 'DEMO4',
      ),
      ActivityReportModel(
        id: '10',
        userName: 'DEMO1',
        newEditUser: 'DEMO01',
        oldEditUser: 'DEMO01',
        newPhone: '3654789847',
        oldPhone: '3654789847',
        oldGroupName: 'NSE 1X',
        updatedOn: DateTime.now().subtract(const Duration(days: 10)),
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
