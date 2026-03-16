import '../../domain/entities/settlement_master_sharing.dart';

class MasterUserModel extends MasterUser {
  const MasterUserModel({required super.id, required super.name});
  factory MasterUserModel.fromJson(Map<String, dynamic> json) {
    return MasterUserModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}

class AssignedMasterModel extends AssignedMaster {
  const AssignedMasterModel({
    required super.id,
    required super.name,
    required super.percentSharing,
  });
  factory AssignedMasterModel.fromJson(Map<String, dynamic> json) {
    return AssignedMasterModel(
      id: json['id'] as String,
      name: json['name'] as String,
      percentSharing: (json['percentSharing'] as num).toDouble(),
    );
  }
}

class MasterSharingEntryModel extends MasterSharingEntry {
  const MasterSharingEntryModel({
    required super.index,
    required super.userId,
    required super.username,
    required super.assignedMasterCount,
    required super.assignedMasters,
  });
  factory MasterSharingEntryModel.fromJson(Map<String, dynamic> json) {
    return MasterSharingEntryModel(
      index: json['index'] as int,
      userId: json['userId'] as String,
      username: json['username'] as String,
      assignedMasterCount: json['assignedMasterCount'] as int,
      assignedMasters: (json['assignedMasters'] as List)
          .map((e) => AssignedMasterModel.fromJson(e))
          .toList(),
    );
  }
}

class SettlementMasterSharingDataModel extends SettlementMasterSharingData {
  const SettlementMasterSharingDataModel({
    required super.masters,
    required super.entries,
    required super.totalRecords,
  });
  factory SettlementMasterSharingDataModel.fromJson(Map<String, dynamic> json) {
    return SettlementMasterSharingDataModel(
      masters: (json['masters'] as List)
          .map((e) => MasterUserModel.fromJson(e))
          .toList(),
      entries: (json['entries'] as List)
          .map((e) => MasterSharingEntryModel.fromJson(e))
          .toList(),
      totalRecords: json['totalRecords'] as int,
    );
  }
}
