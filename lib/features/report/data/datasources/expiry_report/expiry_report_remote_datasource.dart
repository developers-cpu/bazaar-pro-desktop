import 'package:bazarpro/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import '../../models/expiry_report_model.dart';
import 'package:intl/intl.dart';

abstract class ExpiryReportRemoteDataSource {
  Future<Either<Failure, List<ExpiryReportModel>>> getExpiryReport({
    String? exchange,
    String? month,
  });
}

class ExpiryReportRemoteDataSourceImpl implements ExpiryReportRemoteDataSource {
  @override
  Future<Either<Failure, List<ExpiryReportModel>>> getExpiryReport({
    String? exchange,
    String? month,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    List<ExpiryReportModel> mockData = _generateDummyData();
    
    if (exchange != null && exchange.isNotEmpty) {
      mockData = mockData.where((element) => element.exchange.toLowerCase() == exchange.toLowerCase()).toList();
    }

    if (month != null && month.isNotEmpty) {
      mockData = mockData.where((element) {
        final monthName = DateFormat('MMMM').format(element.expiry);
        return monthName.toLowerCase() == month.toLowerCase();
      }).toList();
    }
    
    return Right(mockData);
  }

  List<ExpiryReportModel> _generateDummyData() {
    final List<String> exchanges = ['NSE', 'MCX'];
    final List<String> symbols = [
      'GOLDPETAL', 'NIFTY', 'BANKNIFTY', 'RELIANCE', 
      'TCS', 'INFY', 'SILVERMIC', 'CRUDEOIL', 'COPPER'
    ];
    
    final List<ExpiryReportModel> list = [];
    final now = DateTime.now();
    
    for (int i = 1; i <= 35; i++) {
      final String exch = exchanges[i % exchanges.length];
      final String sym = symbols[i % symbols.length];
      
      final expiryDate = now.add(Duration(days: i * 2));
      final closeDate = expiryDate.subtract(const Duration(days: 1));
      final cutDate = expiryDate.subtract(const Duration(minutes: 30));
      
      final formatter = DateFormat('dd/MM/yyyy HH:mm:ss');
      
      list.add(
        ExpiryReportModel(
          exchange: exch,
          symbol: '$sym-${i + 100}',
          expiry: expiryDate,
          closeDate: closeDate,
          cutDate: cutDate,
        )
      );
    }
    return list;
  }
}
