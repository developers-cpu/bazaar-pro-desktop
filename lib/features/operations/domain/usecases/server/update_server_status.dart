import '../../repositories/server/server_repository.dart';

class UpdateServerStatus {
  final ServerRepository repository;

  UpdateServerStatus(this.repository);

  Future<void> call(String id, bool status) async {
    return await repository.updateServerStatus(id, status);
  }
}
