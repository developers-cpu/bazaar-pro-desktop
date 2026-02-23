import 'package:equatable/equatable.dart';
import '../../../domain/entities/server/server_entity.dart';

enum ServerStatus { initial, loading, success, failure }

class ServerState extends Equatable {
  final List<ServerEntity> servers;
  final List<ServerEntity> filteredServers;
  final ServerStatus status;
  final String? errorMessage;
  final String searchQuery;

  const ServerState({
    this.servers = const [],
    this.filteredServers = const [],
    this.status = ServerStatus.initial,
    this.errorMessage,
    this.searchQuery = '',
  });

  ServerState copyWith({
    List<ServerEntity>? servers,
    List<ServerEntity>? filteredServers,
    ServerStatus? status,
    String? errorMessage,
    String? searchQuery,
  }) {
    return ServerState(
      servers: servers ?? this.servers,
      filteredServers: filteredServers ?? this.filteredServers,
      status: status ?? this.status,
      errorMessage: errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
    servers,
    filteredServers,
    status,
    errorMessage,
    searchQuery,
  ];
}
