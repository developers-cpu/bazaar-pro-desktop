import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/login_history/login_history.dart';
import '../../../domain/usecases/login_history/login_history_usecases.dart';
import 'login_history_event.dart';
import 'login_history_state.dart';
class LoginHistoryBloc extends Bloc<LoginHistoryEvent, LoginHistoryState> {
  final GetLoginHistory getLoginHistory;
  final GetLoginHistoryClients getClients;
  final ExportLoginHistoryToPdf exportToPdf;
  final ExportLoginHistoryToExcel exportToExcel;
  LoginHistoryBloc({
    required this.getLoginHistory,
    required this.getClients,
    required this.exportToPdf,
    required this.exportToExcel,
  }) : super(const LoginHistoryInitial()) {
    on<LoadClientsEvent>(_onLoadClients);
    on<SelectClientEvent>(_onSelectClient);
    on<ViewLoginHistoryEvent>(_onViewHistory);
    on<ResetLoginHistoryEvent>(_onResetHistory);
    on<SortLoginHistoryByColumnEvent>(_onSortByColumn);
    on<ExportLoginHistoryToPdfEvent>(_onExportToPdf);
    on<ExportLoginHistoryToExcelEvent>(_onExportToExcel);
  }
  Future<void> _onLoadClients(
    LoadClientsEvent event,
    Emitter<LoginHistoryState> emit,
  ) async {
    try {
      final result = await getClients(NoParams());
      result.fold(
        (failure) => emit(LoginHistoryError(failure.message)),
        (clients) => emit(LoginHistoryInitial(clients: clients)),
      );
    } catch (e) {
      emit(LoginHistoryError(e.toString()));
    }
  }
  void _onSelectClient(
    SelectClientEvent event,
    Emitter<LoginHistoryState> emit,
  ) {
    if (state is LoginHistoryInitial) {
      final currentState = state as LoginHistoryInitial;
      emit(
        LoginHistoryInitial(
          clients: currentState.clients,
          selectedClient: event.client,
        ),
      );
    } else if (state is LoginHistoryLoaded) {
      final currentState = state as LoginHistoryLoaded;
      emit(
        currentState.copyWith(selectedClient: event.client, showTable: false),
      );
    }
  }
  Future<void> _onViewHistory(
    ViewLoginHistoryEvent event,
    Emitter<LoginHistoryState> emit,
  ) async {
    String? clientToFetch;
    List<String> clients = [];
    if (state is LoginHistoryInitial) {
      clientToFetch = (state as LoginHistoryInitial).selectedClient;
      clients = (state as LoginHistoryInitial).clients;
    } else if (state is LoginHistoryLoaded) {
      clientToFetch = (state as LoginHistoryLoaded).selectedClient;
      clients = (state as LoginHistoryLoaded).clients;
    }
    if (clientToFetch == null || clientToFetch.isEmpty) {
      return;
    }
    emit(const LoginHistoryLoading());
    try {
      final historyResult = await getLoginHistory(clientToFetch);
      historyResult.fold(
        (failure) => emit(LoginHistoryError(failure.message)),
        (history) => emit(
          LoginHistoryLoaded(
            history: history,
            selectedClient: clientToFetch!,
            totalRecords: history.length,
            clients: clients,
            showTable: true,
          ),
        ),
      );
    } catch (e) {
      emit(LoginHistoryError(e.toString()));
    }
  }
  void _onResetHistory(
    ResetLoginHistoryEvent event,
    Emitter<LoginHistoryState> emit,
  ) {
    List<String> clients = [];
    if (state is LoginHistoryInitial) {
      clients = (state as LoginHistoryInitial).clients;
    } else if (state is LoginHistoryLoaded) {
      clients = (state as LoginHistoryLoaded).clients;
    }
    emit(LoginHistoryInitial(clients: clients, selectedClient: null));
  }
  void _onSortByColumn(
    SortLoginHistoryByColumnEvent event,
    Emitter<LoginHistoryState> emit,
  ) {
    if (state is! LoginHistoryLoaded) return;
    final currentState = state as LoginHistoryLoaded;
    final sortedHistory = List<LoginHistory>.from(currentState.history);
    sortedHistory.sort((a, b) {
      int comparison = 0;
      switch (event.columnId) {
        case 'index':
          comparison = a.index.compareTo(b.index);
          break;
        case 'loginTime':
          comparison = a.loginTime.compareTo(b.loginTime);
          break;
        case 'userName':
          comparison = a.userName.compareTo(b.userName);
          break;
        case 'userType':
          comparison = a.userType.compareTo(b.userType);
          break;
        case 'ipAddress':
          comparison = a.ipAddress.compareTo(b.ipAddress);
          break;
        case 'deviceId':
          comparison = a.deviceId.compareTo(b.deviceId);
          break;
        default:
          comparison = 0;
      }
      return event.ascending ? comparison : -comparison;
    });
    emit(
      currentState.copyWith(
        history: sortedHistory,
        sortColumn: event.columnId,
        sortAscending: event.ascending,
      ),
    );
  }
  Future<void> _onExportToPdf(
    ExportLoginHistoryToPdfEvent event,
    Emitter<LoginHistoryState> emit,
  ) async {
    if (state is! LoginHistoryLoaded) return;
    final currentState = state as LoginHistoryLoaded;
    final result = await exportToPdf(currentState.history);
    result.fold((failure) => emit(LoginHistoryError(failure.message)), (path) {
      emit(
        LoginHistoryExportSuccess(
          message: 'PDF exported successfully',
          filePath: path,
        ),
      );
      emit(currentState);
    });
  }
  Future<void> _onExportToExcel(
    ExportLoginHistoryToExcelEvent event,
    Emitter<LoginHistoryState> emit,
  ) async {
    if (state is! LoginHistoryLoaded) return;
    final currentState = state as LoginHistoryLoaded;
    final result = await exportToExcel(currentState.history);
    result.fold((failure) => emit(LoginHistoryError(failure.message)), (path) {
      emit(
        LoginHistoryExportSuccess(
          message: 'Excel exported successfully',
          filePath: path,
        ),
      );
      emit(currentState);
    });
  }
}
