import '../models/group_model.dart';

abstract class OperationRemoteDataSource {
  Future<List<GroupModel>> getGroups();
  Future<bool> addGroup({
    required String exchange,
    required String groupName,
    required bool isDefault,
  });
}
