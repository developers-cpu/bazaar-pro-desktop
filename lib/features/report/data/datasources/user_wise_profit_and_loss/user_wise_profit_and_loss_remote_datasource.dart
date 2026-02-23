import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../models/user_wise_profit_and_loss_report_model.dart';

abstract class UserWiseProfitAndLossRemoteDataSource {
  Future<Either<Failure, List<UserWiseProfitAndLossReportModel>>>
  getUserWiseProfitAndLossReport({
    String? userId,
    String? startDate,
    String? endDate,
  });
}

class UserWiseProfitAndLossRemoteDataSourceImpl
    implements UserWiseProfitAndLossRemoteDataSource {
  @override
  Future<Either<Failure, List<UserWiseProfitAndLossReportModel>>>
  getUserWiseProfitAndLossReport({
    String? userId,
    String? startDate,
    String? endDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final List<UserWiseProfitAndLossReportModel> mockData = [
      UserWiseProfitAndLossReportModel(
        id: '1',
        userName: 'DEMO02',
        parentUser: 'Demo01',
        mtm: 0,
        releasedPL: 124191.00,
        brokerage: 2,
        netPL: 1700105,
        credit: 2699000.00,
        equity: 2699000.00,
        margin: 8097000,
        usedMargin: -19467.57,
        freeMargin: 8293746,
        standingVolume: 0,
        marginLevelPercentage: 0,
        createdBy: 'Demo01',
        createdDate: DateTime.now(),
      ),
      UserWiseProfitAndLossReportModel(
        id: '2',
        userName: 'DEMO32',
        parentUser: 'Demo01',
        mtm: 425,
        releasedPL: 124191.00,
        brokerage: 13,
        netPL: 425,
        credit: 50000000,
        equity: 50000000,
        margin: 1500000,
        usedMargin: 16708,
        freeMargin: 148391,
        standingVolume: 238695,
        marginLevelPercentage: 8977,
        createdBy: 'Demo01',
        createdDate: DateTime.now(),
      ),
      UserWiseProfitAndLossReportModel(
        id: '3',
        userName: 'DEMO001',
        parentUser: 'Demo01',
        mtm: 0,
        releasedPL: -256,
        brokerage: 506,
        netPL: 56550,
        credit: 5000000,
        equity: 5000000,
        margin: 150000,
        usedMargin: 0,
        freeMargin: 1500000,
        standingVolume: 0,
        marginLevelPercentage: 0,
        createdBy: 'Demo01',
        createdDate: DateTime.now(),
      ),
      UserWiseProfitAndLossReportModel(
        id: '4',
        userName: 'DEMO34',
        parentUser: 'Demo01',
        mtm: -87775.56,
        releasedPL: 124191.00,
        brokerage: 736,
        netPL: -75864,
        credit: 565479,
        equity: 565479,
        margin: 21721.00,
        usedMargin: 354349,
        freeMargin: 2645650,
        standingVolume: 31933334,
        marginLevelPercentage: 846.60,
        createdBy: 'Demo01',
        createdDate: DateTime.now(),
      ),
    ];
    if (userId != null && userId.isNotEmpty) {
      return Right(
        mockData
            .where(
              (element) =>
                  element.userName.toLowerCase().contains(userId.toLowerCase()),
            )
            .toList(),
      );
    }
    return Right(mockData);
  }
}
