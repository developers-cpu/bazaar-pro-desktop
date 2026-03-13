import '../../../domain/entities/broker_list/client_breakdown.dart';
import '../../../domain/repositories/broker_list/client_breakdown_repository.dart';
import '../../datasources/broker_list/client_breakdown_remote_datasource.dart';

class ClientBreakdownRepositoryImpl implements ClientBreakdownRepository {
  final ClientBreakdownRemoteDataSource remoteDataSource;

  ClientBreakdownRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ClientBreakdown> getClientBreakdown(String brokerId, String clientName) async {
    return await remoteDataSource.getClientBreakdown(brokerId, clientName);
  }
}
