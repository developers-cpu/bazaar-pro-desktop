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
    final List<UserWiseProfitAndLossReportModel> mockData = _generateDummyUserWiseProfitAndLossReports();

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

  List<UserWiseProfitAndLossReportModel> _generateDummyUserWiseProfitAndLossReports() {
    final List<String> userNames = ['DEMO02', 'DEMO32', 'DEMO001', 'DEMO34', 'PATIL', 'ADMIN', 'MASTER'];
    final List<UserWiseProfitAndLossReportModel> list = [];
    final DateTime now = DateTime.now();

    for (int i = 1; i <= 35; i++) {
      final double mtm = (i % 3 == 0) ? -(i * 1000.50) : (i * 425.0);
      final double relPL = 124191.00 + (i * 100);
      final double brk = (i * 5).toDouble();
      final double netPL = relPL + mtm - brk;
      final double credit = 5000000.0 + (i * 10000);

      list.add(
        UserWiseProfitAndLossReportModel(
          id: i.toString(),
          userName: '${userNames[i % userNames.length]}_$i',
          parentUser: 'Demo01',
          mtm: mtm,
          releasedPL: relPL,
          brokerage: brk,
          netPL: netPL,
          credit: credit,
          equity: credit * 0.95,
          margin: credit * 0.2,
          usedMargin: credit * 0.05,
          freeMargin: credit * 0.15,
          standingVolume: (i * 1000).toDouble(),
          marginLevelPercentage: 100.0 + (i * 5),
          createdBy: 'Demo01',
          createdDate: now.subtract(Duration(days: i)),
        ),
      );
    }
    return list;
  }
}