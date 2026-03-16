import 'package:equatable/equatable.dart';
class MasterUser extends Equatable {
  final String id;
  final String name;
  const MasterUser({required this.id, required this.name});
  @override
  List<Object?> get props => [id, name];
}
class AssignedMaster extends Equatable {
  final String id;
  final String name;
  final double percentSharing;
  const AssignedMaster({
    required this.id,
    required this.name,
    required this.percentSharing,
  });
  @override
  List<Object?> get props => [id, name, percentSharing];
}
class MasterSharingEntry extends Equatable {
  final int index;
  final String userId;
  final String username;
  final int assignedMasterCount;
  final List<AssignedMaster> assignedMasters;
  const MasterSharingEntry({
    required this.index,
    required this.userId,
    required this.username,
    required this.assignedMasterCount,
    required this.assignedMasters,
  });
  @override
  List<Object?> get props => [
    index,
    userId,
    username,
    assignedMasterCount,
    assignedMasters,
  ];
}
class SettlementMasterSharingData extends Equatable {
  final List<MasterUser> masters;
  final List<MasterSharingEntry> entries;
  final int totalRecords;
  const SettlementMasterSharingData({
    required this.masters,
    required this.entries,
    required this.totalRecords,
  });
  @override
  List<Object?> get props => [masters, entries, totalRecords];
}
