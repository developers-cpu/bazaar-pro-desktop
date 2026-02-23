import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/server/get_servers.dart';
import '../../../domain/usecases/server/update_server_status.dart';
import '../../../domain/repositories/server/server_repository.dart';
import 'server_event.dart';
import 'server_state.dart';

class ServerBloc extends Bloc<ServerEvent, ServerState> {
  final GetServers getServers;
  final UpdateServerStatus updateServerStatus;
  final ServerRepository repository;

  ServerBloc({
    required this.getServers,
    required this.updateServerStatus,
    required this.repository,
  }) : super(const ServerState()) {
    on<LoadServersEvent>(_onLoadServers);
    on<UpdateServerStatusEvent>(_onUpdateServerStatus);
    on<AddServerEvent>(_onAddServer);
    on<EditServerEvent>(_onEditServer);
    on<SearchServerEvent>(_onSearchServer);
  }

  Future<void> _onLoadServers(
    LoadServersEvent event,
    Emitter<ServerState> emit,
  ) async {
    emit(state.copyWith(status: ServerStatus.loading));
    try {
      final servers = await getServers();
      emit(
        state.copyWith(
          status: ServerStatus.success,
          servers: servers,
          filteredServers: servers,
          searchQuery: '',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ServerStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onUpdateServerStatus(
    UpdateServerStatusEvent event,
    Emitter<ServerState> emit,
  ) async {
    try {
      await updateServerStatus(event.id, event.status);
      add(LoadServersEvent());
    } catch (e) {
      emit(
        state.copyWith(
          status: ServerStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onAddServer(
    AddServerEvent event,
    Emitter<ServerState> emit,
  ) async {
    emit(state.copyWith(status: ServerStatus.loading));
    try {
      await repository.addServer(event.serverName, event.logoPath);
      add(LoadServersEvent());
    } catch (e) {
      emit(
        state.copyWith(
          status: ServerStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onEditServer(
    EditServerEvent event,
    Emitter<ServerState> emit,
  ) async {
    emit(state.copyWith(status: ServerStatus.loading));
    try {
      await repository.editServer(event.id, event.serverName, event.logoPath);
      add(LoadServersEvent());
    } catch (e) {
      emit(
        state.copyWith(
          status: ServerStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onSearchServer(SearchServerEvent event, Emitter<ServerState> emit) {
    final query = event.query.toLowerCase();
    if (query.isEmpty) {
      emit(
        state.copyWith(
          filteredServers: state.servers,
          searchQuery: event.query,
        ),
      );
    } else {
      final filtered = state.servers.where((server) {
        return server.serverName.toLowerCase().contains(query);
      }).toList();
      emit(state.copyWith(filteredServers: filtered, searchQuery: event.query));
    }
  }
}
