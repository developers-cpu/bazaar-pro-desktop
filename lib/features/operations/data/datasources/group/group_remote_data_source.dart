import '../../models/group/group_model.dart';
abstract class GroupRemoteDataSource {
  Future<List<GroupModel>> getGroups();
  Future<bool> addGroup({
    required String exchange,
    required String groupName,
    required bool isDefault,
  });
}
