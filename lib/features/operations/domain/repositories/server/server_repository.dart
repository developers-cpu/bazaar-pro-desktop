import '../../entities/server/server_entity.dart';

abstract class ServerRepository {
  Future<List<ServerEntity>> getServers();
  Future<void> updateServerStatus(String id, bool status);
  Future<void> addServer(String serverName, String logoPath);
  Future<void> editServer(String id, String serverName, String logoPath);
}
