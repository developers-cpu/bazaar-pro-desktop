import 'package:equatable/equatable.dart';

abstract class ServerEvent extends Equatable {
  const ServerEvent();
  @override
  List<Object?> get props => [];
}

class LoadServersEvent extends ServerEvent {}

class UpdateServerStatusEvent extends ServerEvent {
  final String id;
  final bool status;

  const UpdateServerStatusEvent({required this.id, required this.status});

  @override
  List<Object?> get props => [id, status];
}

class AddServerEvent extends ServerEvent {
  final String serverName;
  final String logoPath;

  const AddServerEvent({required this.serverName, required this.logoPath});

  @override
  List<Object?> get props => [serverName, logoPath];
}

class EditServerEvent extends ServerEvent {
  final String id;
  final String serverName;
  final String logoPath;

  const EditServerEvent({
    required this.id,
    required this.serverName,
    required this.logoPath,
  });

  @override
  List<Object?> get props => [id, serverName, logoPath];
}

class SearchServerEvent extends ServerEvent {
  final String query;

  const SearchServerEvent(this.query);

  @override
  List<Object?> get props => [query];
}
