import '../../models/ban_script_model.dart';
import '../../../../../core/errors/exceptions.dart';

abstract class BanScriptRemoteDataSource {
  Future<List<BanScriptModel>> getBanScripts({String? exchange, String? banType});
}

class BanScriptRemoteDataSourceImpl implements BanScriptRemoteDataSource {
  static const List<BanScriptModel> _mockData = [
    BanScriptModel(id: '1', exchange: 'NSE', symbol: 'NIFTY', startTime: '09:15 AM', banTime: '03:20 PM', banType: 'exchange'),
    BanScriptModel(id: '2', exchange: 'NSE', symbol: 'BANK NIFTY', startTime: '09:15 AM', banTime: '03:25 PM', banType: 'exchange'),
    BanScriptModel(id: '3', exchange: 'NSE', symbol: 'FINNIFTY', startTime: '09:15 AM', banTime: '03:25 PM', banType: 'exchange'),
    BanScriptModel(id: '4', exchange: 'MCX', symbol: 'GOLD', startTime: '09:00 AM', banTime: '11:30 PM', banType: 'exchange'),
    BanScriptModel(id: '5', exchange: 'MCX', symbol: 'SILVER', startTime: '09:00 AM', banTime: '11:30 PM', banType: 'exchange'),
    BanScriptModel(id: '6', exchange: 'MCX', symbol: 'CRUDE OIL', startTime: '09:00 AM', banTime: '11:30 PM', banType: 'exchange'),
    BanScriptModel(id: '7', exchange: 'NSE', symbol: 'NIFTY MIDCAP', startTime: '09:15 AM', banTime: '01:00 PM', banType: 'admin'),
    BanScriptModel(id: '8', exchange: 'NSE', symbol: 'BANK NIFTY', startTime: '09:15 AM', banTime: '01:30 PM', banType: 'admin'),
    BanScriptModel(id: '9', exchange: 'MCX', symbol: 'COPPER', startTime: '09:00 AM', banTime: '10:00 PM', banType: 'admin'),
    BanScriptModel(id: '10', exchange: 'MCX', symbol: 'ALUMINIUM', startTime: '09:00 AM', banTime: '10:00 PM', banType: 'admin'),
    BanScriptModel(id: '11', exchange: 'CE/PE', symbol: 'NIFTY24800CE', startTime: '09:15 AM', banTime: '03:20 PM', banType: 'exchange'),
    BanScriptModel(id: '12', exchange: 'CE/PE', symbol: 'BANKNIFTY49000CE', startTime: '09:15 AM', banTime: '03:25 PM', banType: 'exchange'),
    BanScriptModel(id: '13', exchange: 'CE/PE', symbol: 'NIFTY24500PE', startTime: '09:15 AM', banTime: '12:00 PM', banType: 'admin'),
    BanScriptModel(id: '14', exchange: 'NSE', symbol: 'NIFTYIT', startTime: '09:15 AM', banTime: '02:00 PM', banType: 'admin'),
    BanScriptModel(id: '15', exchange: 'MCX', symbol: 'NATURAL GAS', startTime: '09:00 AM', banTime: '11:30 PM', banType: 'exchange'),
  ];

  @override
  Future<List<BanScriptModel>> getBanScripts({String? exchange, String? banType}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      var result = _mockData;

      if (exchange != null && exchange.trim().isNotEmpty && exchange.toUpperCase() != 'ALL') {
        result = result.where((item) => item.exchange.toUpperCase() == exchange.toUpperCase()).toList();
      }

      if (banType != null && banType.trim().isNotEmpty) {
        result = result.where((item) => item.banType.toLowerCase() == banType.toLowerCase()).toList();
      }

      return result;
    } catch (e) {
      throw ServerException('Failed to fetch ban script data: $e');
    }
  }
}
