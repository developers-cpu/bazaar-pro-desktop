import '../../models/brokerage/brokerage_model.dart';

abstract class BrokerageRemoteDataSource {
  Future<List<BrokerageModel>> getBrokerages({String? exchange});
}

class BrokerageRemoteDataSourceImpl implements BrokerageRemoteDataSource {
  @override
  Future<List<BrokerageModel>> getBrokerages({String? exchange}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final List<BrokerageModel> mockData = [
      const BrokerageModel(
        exchange: 'NSE',
        symbol: 'NIFTY25N0425550CE',
        brokeragePercentage: 95,
        brokerageAmount: 95,
      ),
      const BrokerageModel(
        exchange: 'NSE',
        symbol: 'NIFTY25N0425550CE',
        brokeragePercentage: 178,
        brokerageAmount: 178,
      ),
      const BrokerageModel(
        exchange: 'NSE',
        symbol: 'NIFTY25N0425550CE',
        brokeragePercentage: 50,
        brokerageAmount: 50,
      ),
      const BrokerageModel(
        exchange: 'NSE',
        symbol: 'NIFTY25N0425550CE',
        brokeragePercentage: 29,
        brokerageAmount: 29,
      ),
      const BrokerageModel(
        exchange: 'NSE',
        symbol: 'RELIANCE',
        brokeragePercentage: 5000,
        brokerageAmount: 5000,
      ),
      const BrokerageModel(
        exchange: 'NSE',
        symbol: 'TCS',
        brokeragePercentage: 3000,
        brokerageAmount: 3000,
      ),
      const BrokerageModel(
        exchange: 'MCX',
        symbol: 'GOLD',
        brokeragePercentage: 125,
        brokerageAmount: 125,
      ),
      const BrokerageModel(
        exchange: 'MCX',
        symbol: 'GOLD',
        brokeragePercentage: 30003,
        brokerageAmount: 30003,
      ),
      const BrokerageModel(
        exchange: 'MCX',
        symbol: 'GOLD05DEC',
        brokeragePercentage: 3000,
        brokerageAmount: 3000,
      ),
      const BrokerageModel(
        exchange: 'MCX',
        symbol: 'GOLD05DEC',
        brokeragePercentage: 2000,
        brokerageAmount: 2000,
      ),
      const BrokerageModel(
        exchange: 'MCX',
        symbol: 'SILVER',
        brokeragePercentage: 4000,
        brokerageAmount: 4000,
      ),
      const BrokerageModel(
        exchange: 'MCX',
        symbol: 'CRUDEOIL20OCT',
        brokeragePercentage: 10000,
        brokerageAmount: 10000,
      ),
      const BrokerageModel(
        exchange: 'MCX',
        symbol: 'SILVER05DEC',
        brokeragePercentage: 500,
        brokerageAmount: 500,
      ),
      const BrokerageModel(
        exchange: 'CE/PE',
        symbol: 'NIFTY25N0425550CE',
        brokeragePercentage: 645,
        brokerageAmount: 645,
      ),
      const BrokerageModel(
        exchange: 'CE/PE',
        symbol: 'SILVER05DEC',
        brokeragePercentage: 500,
        brokerageAmount: 500,
      ),
      const BrokerageModel(
        exchange: 'OTHERS',
        symbol: 'SILVER',
        brokeragePercentage: 75,
        brokerageAmount: 75,
      ),
    ];
    if (exchange != null && exchange.isNotEmpty && exchange != 'All') {
      return mockData.where((item) => item.exchange == exchange).toList();
    }
    return mockData;
  }
}
