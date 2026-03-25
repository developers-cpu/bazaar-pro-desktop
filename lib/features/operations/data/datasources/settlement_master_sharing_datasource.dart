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
  static final List<Map<String, dynamic>> _masters = List.generate(
    15,
    (i) => {'id': '${i + 1}', 'name': 'Master ${i + 1}'},
  );

  static final List<String> _userNames = [
    'AlphaTrader', 'BetaUser', 'GammaClient', 'DeltaMaster',
  ];

  @override
  Future<List<MasterUserModel>> getAvailableMasters() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _masters
        .map((m) => MasterUserModel(id: m['id'], name: m['name']))
        .toList();
  }

  @override
  Future<SettlementMasterSharingDataModel> getMasterSharingData({
    String? masterId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final assignedCounts = [5, 0, 3, 12];

      final entries = List.generate(_userNames.length, (i) {
        final count = assignedCounts[i];
        return {
          'index': i + 1,
          'userId': 'u${i + 1}',
          'username': _userNames[i],
          'assignedMasterCount': count,
          'assignedMasters': count == 0
              ? <Map<String, dynamic>>[]
              : List.generate(count, (j) => {
                  'id': '${j + 1}',
                  'name': _masters[j % _masters.length]['name'],
                  'percentSharing': (10 + j * 5).toDouble(),
                }),
        };
      });

      final mockResponse = {
        'masters': _masters,
        'entries': entries,
        'totalRecords': entries.length,
      };
      return SettlementMasterSharingDataModel.fromJson(mockResponse);
    } catch (e) {
      throw ServerException('Data parsing error: $e');
    }
  }
}

