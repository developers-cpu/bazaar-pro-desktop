import '../../entities/server/server_entity.dart';
import '../../repositories/server/server_repository.dart';
class GetServers {
  final ServerRepository repository;
  GetServers(this.repository);
  Future<List<ServerEntity>> call() async {
    return await repository.getServers();
  }
}
