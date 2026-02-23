import '../models/group_model.dart';
import 'operation_remote_data_source.dart';

class OperationRemoteDataSourceImpl implements OperationRemoteDataSource {
  List<GroupModel> _mockGroups = [
    GroupModel(
      id: '1',
      exchange: 'MCX',
      groupName: 'X | 2X | 3X | 4X | 5X | 6X | NSE_Mini',
      count: '09',
      updatedOn: '26/12/25 | 12:00:00 AM',
      updatedBy: 'DEMO4',
      isDefault: true,
    ),
    GroupModel(
      id: '2',
      exchange: 'NSE',
      groupName: 'X | 2X | 3X | 4X | 5X',
      count: '05',
      updatedOn: '26/12/25 | 12:00:00 AM',
      updatedBy: 'DEMO4',
      isDefault: false,
    ),
    GroupModel(
      id: '3',
      exchange: 'CE/PE',
      groupName: 'X',
      count: '01',
      updatedOn: '26/12/25 | 12:00:00 AM',
      updatedBy: 'DEMO4',
      isDefault: false,
    ),
    GroupModel(
      id: '4',
      exchange: 'GIFT',
      groupName: 'X | 2X',
      count: '02',
      updatedOn: '26/12/25 | 12:00:00 AM',
      updatedBy: 'DEMO4',
      isDefault: false,
    ),
    GroupModel(
      id: '5',
      exchange: 'OTHERS',
      groupName: 'X | 2X | 3X | 4X | 5X | 6X',
      count: '06',
      updatedOn: '26/12/25 | 12:00:00 AM',
      updatedBy: 'DEMO4',
      isDefault: false,
    ),
    GroupModel(
      id: '6',
      exchange: 'CRYPTO',
      groupName: 'X | 2X',
      count: '02',
      updatedOn: '26/12/25 | 12:00:00 AM',
      updatedBy: 'DEMO4',
      isDefault: false,
    ),
    GroupModel(
      id: '7',
      exchange: 'COMEX',
      groupName: 'X | 2X | 3X',
      count: '03',
      updatedOn: '26/12/25 | 12:00:00 AM',
      updatedBy: 'DEMO4',
      isDefault: false,
    ),
    GroupModel(
      id: '8',
      exchange: 'FOREX',
      groupName: 'X | 2X | 3X | 4X | 5X',
      count: '05',
      updatedOn: '26/12/25 | 12:00:00 AM',
      updatedBy: 'DEMO4',
      isDefault: false,
    ),
    GroupModel(
      id: '9',
      exchange: 'USSTOCK',
      groupName: 'X | 2X',
      count: '02',
      updatedOn: '26/12/25 | 12:00:00 AM',
      updatedBy: 'DEMO4',
      isDefault: false,
    ),
  ];

  @override
  Future<List<GroupModel>> getGroups() async {
    return _mockGroups;
  }

  @override
  Future<bool> addGroup({
    required String exchange,
    required String groupName,
    required bool isDefault,
  }) async {
    final newGroup = GroupModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      exchange: exchange,
      groupName: groupName,
      count: '00',
      updatedOn: 'Now',
      updatedBy: 'ME',
      isDefault: isDefault,
    );
    _mockGroups.insert(0, newGroup);
    return true;
  }
}
