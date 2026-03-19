import '../models/settlement_master_sharing_model.dart';
import '../../../../core/errors/exceptions.dart';

abstract class SettlementMasterSharingDataSource {
  Future<SettlementMasterSharingDataModel> getMasterSharingData({
    String? masterId,
  });
  Future<List<MasterUserModel>> getAvailableMasters();
}

class SettlementMasterSharingDataSourceImpl
    implements SettlementMasterSharingDataSource {
  @override
  Future<List<MasterUserModel>> getAvailableMasters() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.generate(
      5,
      (i) => MasterUserModel(id: '${i + 1}', name: 'User ${i + 1}'),
    );
  }

  @override
  Future<SettlementMasterSharingDataModel> getMasterSharingData({
    String? masterId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final mockResponse = {
        "masters": List.generate(
          5,
          (i) => {"id": "${i + 1}", "name": "User ${i + 1}"},
        ),
        "entries": [
          {
            "index": 1,
            "userId": "u1",
            "username": "User 1",
            "assignedMasterCount": 9,
            "assignedMasters": List.generate(
              9,
              (i) => {
                "id": "${i + 1}",
                "name": "User ${i + 1}",
                "percentSharing": 20.0,
              },
            ),
          },
          {
            "index": 2,
            "userId": "u2",
            "username": "User 2",
            "assignedMasterCount": 0,
            "assignedMasters": <Map<String, dynamic>>[],
          },
        ],
        "totalRecords": 12550,
      };
      return SettlementMasterSharingDataModel.fromJson(mockResponse);
    } catch (e) {
      throw ServerException('Data parsing error: $e');
    }
  }
}