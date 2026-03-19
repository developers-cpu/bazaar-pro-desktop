import '../../../domain/repositories/broker_list/broker_repository.dart';
import '../../../domain/entities/broker_list/broker.dart';
import '../../../domain/entities/broker_list/broker_client.dart';
import '../../datasources/broker_list/broker_remote_data_source.dart';

class BrokerRepositoryImpl implements BrokerRepository {
  final BrokerRemoteDataSource remoteDataSource;
  BrokerRepositoryImpl({required this.remoteDataSource});
  @override
  Future<List<Broker>> getBrokers() async {
    final models = await remoteDataSource.getBrokers();
    return models.map((e) => e as Broker).toList();
  }

  @override
  Future<List<BrokerClient>> getBrokerClients(String brokerName) async {
    final models = await remoteDataSource.getBrokerClients(brokerName);
    return models.map((e) => e as BrokerClient).toList();
  }
}