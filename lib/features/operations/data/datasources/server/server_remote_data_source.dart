import '../../models/server/server_model.dart';

abstract class ServerRemoteDataSource {
  Future<List<ServerModel>> getServers();
  Future<void> updateServerStatus(String id, bool status);
  Future<void> addServer(String serverName, String logoPath);
  Future<void> editServer(String id, String serverName, String logoPath);
}