import '../../../domain/entities/server/server_entity.dart';
import '../../../domain/repositories/server/server_repository.dart';
import '../../datasources/server/server_remote_data_source.dart';

class ServerRepositoryImpl implements ServerRepository {
  final ServerRemoteDataSource remoteDataSource;

  ServerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ServerEntity>> getServers() async {
    return await remoteDataSource.getServers();
  }

  @override
  Future<void> updateServerStatus(String id, bool status) async {
    return await remoteDataSource.updateServerStatus(id, status);
  }

  @override
  Future<void> addServer(String serverName, String logoPath) async {
    return await remoteDataSource.addServer(serverName, logoPath);
  }

  @override
  Future<void> editServer(String id, String serverName, String logoPath) async {
    return await remoteDataSource.editServer(id, serverName, logoPath);
  }
}
