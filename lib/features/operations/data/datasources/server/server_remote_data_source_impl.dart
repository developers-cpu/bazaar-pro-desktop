import '../../models/server/server_model.dart';
import 'server_remote_data_source.dart';
class ServerRemoteDataSourceImpl implements ServerRemoteDataSource {
  final List<ServerModel> _mockServers = List.generate(
    10,
    (index) => ServerModel(
      id: 'server_$index',
      index: index + 1,
      serverName: 'NFO',
      updatedOn: '26/12/25 | 12:00:00 AM',
      updatedBy: 'DEMO4',
      status: true,
    ),
  );
  @override
  Future<List<ServerModel>> getServers() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _mockServers;
  }
  @override
  Future<void> updateServerStatus(String id, bool status) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _mockServers.indexWhere((s) => s.id == id);
    if (index != -1) {
      final old = _mockServers[index];
      _mockServers[index] = ServerModel(
        id: old.id,
        index: old.index,
        serverName: old.serverName,
        updatedOn: old.updatedOn,
        updatedBy: old.updatedBy,
        status: status,
      );
    }
  }
  @override
  Future<void> addServer(String serverName, String logoPath) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _mockServers.add(
      ServerModel(
        id: 'server_${_mockServers.length}',
        index: _mockServers.length + 1,
        serverName: serverName,
        updatedOn: '26/12/25 | 12:00:00 AM',
        updatedBy: 'DEMO4',
        status: true,
      ),
    );
  }
  @override
  Future<void> editServer(String id, String serverName, String logoPath) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final index = _mockServers.indexWhere((s) => s.id == id);
    if (index != -1) {
      final old = _mockServers[index];
      _mockServers[index] = ServerModel(
        id: old.id,
        index: old.index,
        serverName: serverName,
        updatedOn: old.updatedOn,
        updatedBy: old.updatedBy,
        status: old.status,
      );
    }
  }
}
