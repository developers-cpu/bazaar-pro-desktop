import '../../models/broker_list/broker_model.dart';
import '../../models/broker_list/broker_client_model.dart';

abstract class BrokerRemoteDataSource {
  Future<List<BrokerModel>> getBrokers();
  Future<List<BrokerClientModel>> getBrokerClients(String brokerName);
}

class BrokerRemoteDataSourceImpl implements BrokerRemoteDataSource {
  @override
  Future<List<BrokerModel>> getBrokers() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.generate(15, (index) {
      return BrokerModel(
        index: index + 1,
        createdAt: DateTime(2025, 11, 14, 16, 32, 16),
        name: 'DEMO Broker 1',
        clientsCount: 10,
        totalBrokerage: 500000000,
        updatedOn: DateTime(2025, 11, 14, 16, 32, 16),
      );
    });
  }

  @override
  Future<List<BrokerClientModel>> getBrokerClients(String brokerName) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.generate(13, (index) {
      return BrokerClientModel(
        name: 'Democlient${index + 1}',
        brokerage: index % 3 == 0 ? 800000 : (index % 2 == 0 ? 150000 : 100000),
      );
    });
  }
}