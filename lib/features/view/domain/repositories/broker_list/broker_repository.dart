import '../../entities/broker_list/broker.dart';
import '../../entities/broker_list/broker_client.dart';

abstract class BrokerRepository {
  Future<List<Broker>> getBrokers();
  Future<List<BrokerClient>> getBrokerClients(String brokerName);
}