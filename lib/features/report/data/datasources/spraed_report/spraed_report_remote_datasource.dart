import '../../models/spraed_report_model.dart';
import '../../../../../core/errors/exceptions.dart';

abstract class SpraedReportRemoteDataSource {
  Future<List<SpraedReportModel>> getSpraedReport({String? exchange});
}

class SpraedReportRemoteDataSourceImpl implements SpraedReportRemoteDataSource {
  static const List<SpraedReportModel> _mockData = [
    SpraedReportModel(id: '1', exchange: 'NSE', symbol: 'NIFTY', spreadPercentage: '1'),
    SpraedReportModel(id: '2', exchange: 'NSE', symbol: 'BANK NIFTY', spreadPercentage: '0.05'),
    SpraedReportModel(id: '3', exchange: 'NSE', symbol: 'NIFTY', spreadPercentage: '0.25'),
    SpraedReportModel(id: '4', exchange: 'NSE', symbol: 'BANK NIFTY', spreadPercentage: '0.05'),
    SpraedReportModel(id: '5', exchange: 'NSE', symbol: 'NIFTY', spreadPercentage: '0.05'),
    SpraedReportModel(id: '6', exchange: 'NSE', symbol: 'BANK NIFTY', spreadPercentage: '1'),
    SpraedReportModel(id: '7', exchange: 'NSE', symbol: 'NIFTY', spreadPercentage: '0.05'),
    SpraedReportModel(id: '8', exchange: 'NSE', symbol: 'BANK NIFTY', spreadPercentage: '0.25'),
    SpraedReportModel(id: '9', exchange: 'NSE', symbol: 'NIFTY', spreadPercentage: '0.05'),
    SpraedReportModel(id: '10', exchange: 'NSE', symbol: 'BANK NIFTY', spreadPercentage: '1'),
    SpraedReportModel(id: '11', exchange: 'NSE', symbol: 'NIFTY', spreadPercentage: '0.25'),
    SpraedReportModel(id: '12', exchange: 'NSE', symbol: 'BANK NIFTY', spreadPercentage: '0.05'),
    SpraedReportModel(id: '13', exchange: 'MCX', symbol: 'GOLD', spreadPercentage: '1'),
    SpraedReportModel(id: '14', exchange: 'MCX', symbol: 'SILVER', spreadPercentage: '0.50'),
    SpraedReportModel(id: '15', exchange: 'CE/PE', symbol: 'NIFTY24800CE', spreadPercentage: '0.05'),
  ];

  @override
  Future<List<SpraedReportModel>> getSpraedReport({String? exchange}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (exchange == null || exchange.trim().isEmpty || exchange.toUpperCase() == 'ALL') {
        return _mockData;
      }
      
      return _mockData
          .where((item) => item.exchange.toUpperCase() == exchange.toUpperCase())
          .toList();
    } catch (e) {
      throw ServerException('Failed to fetch spraed report data: $e');
    }
  }
}
