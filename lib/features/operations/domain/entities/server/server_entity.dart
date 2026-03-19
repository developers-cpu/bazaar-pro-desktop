import 'package:equatable/equatable.dart';

class ServerEntity extends Equatable {
  final String id;
  final int index;
  final String serverName;
  final String updatedOn;
  final String updatedBy;
  final bool status;
  const ServerEntity({
    required this.id,
    required this.index,
    required this.serverName,
    required this.updatedOn,
    required this.updatedBy,
    required this.status,
  });
  @override
  List<Object?> get props => [
    id,
    index,
    serverName,
    updatedOn,
    updatedBy,
    status,
  ];
}