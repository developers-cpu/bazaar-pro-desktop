import '../../../domain/entities/server/server_entity.dart';

class ServerModel extends ServerEntity {
  const ServerModel({
    required super.id,
    required super.index,
    required super.serverName,
    required super.updatedOn,
    required super.updatedBy,
    required super.status,
  });
  factory ServerModel.fromJson(Map<String, dynamic> json, int index) {
    return ServerModel(
      id: json['id'] ?? '',
      index: index,
      serverName: json['serverName'] ?? '',
      updatedOn: json['updatedOn'] ?? '',
      updatedBy: json['updatedBy'] ?? '',
      status: json['status'] ?? false,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serverName': serverName,
      'updatedOn': updatedOn,
      'updatedBy': updatedBy,
      'status': status,
    };
  }
}