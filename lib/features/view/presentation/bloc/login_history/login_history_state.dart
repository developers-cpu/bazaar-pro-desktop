import 'package:equatable/equatable.dart';
import '../../../domain/entities/login_history/login_history.dart';

abstract class LoginHistoryState extends Equatable {
  const LoginHistoryState();
  @override
  List<Object?> get props => [];
}

class LoginHistoryInitial extends LoginHistoryState {
  final List<String> clients;
  final String? selectedClient;
  final String? selectedUserType;
  const LoginHistoryInitial({
    this.clients = const [],
    this.selectedClient,
    this.selectedUserType,
  });
  @override
  List<Object?> get props => [clients, selectedClient, selectedUserType];
}

class LoginHistoryLoading extends LoginHistoryState {
  final List<String> clients;
  final String? selectedClient;
  final String? selectedUserType;
  const LoginHistoryLoading({
    this.clients = const [],
    this.selectedClient,
    this.selectedUserType,
  });
  @override
  List<Object?> get props => [clients, selectedClient, selectedUserType];
}

class LoginHistoryLoaded extends LoginHistoryState {
  final List<LoginHistory> history;
  final String selectedClient;
  final String? selectedUserType;
  final int totalRecords;
  final String? sortColumn;
  final bool sortAscending;
  final List<String> clients;
  final bool showTable;
  const LoginHistoryLoaded({
    required this.history,
    required this.selectedClient,
    this.selectedUserType,
    required this.totalRecords,
    this.sortColumn,
    this.sortAscending = true,
    this.clients = const [],
    this.showTable = true,
  });
  @override
  List<Object?> get props => [
    history,
    selectedClient,
    selectedUserType,
    totalRecords,
    sortColumn,
    sortAscending,
    clients,
    showTable,
  ];
  LoginHistoryLoaded copyWith({
    List<LoginHistory>? history,
    String? selectedClient,
    String? selectedUserType,
    int? totalRecords,
    String? sortColumn,
    bool? sortAscending,
    List<String>? clients,
    bool? showTable,
  }) {
    return LoginHistoryLoaded(
      history: history ?? this.history,
      selectedClient: selectedClient ?? this.selectedClient,
      selectedUserType: selectedUserType ?? this.selectedUserType,
      totalRecords: totalRecords ?? this.totalRecords,
      sortColumn: sortColumn ?? this.sortColumn,
      sortAscending: sortAscending ?? this.sortAscending,
      clients: clients ?? this.clients,
      showTable: showTable ?? this.showTable,
    );
  }
}

class LoginHistoryError extends LoginHistoryState {
  final String message;
  final List<String> clients;
  final String? selectedClient;
  final String? selectedUserType;
  const LoginHistoryError(
    this.message, {
    this.clients = const [],
    this.selectedClient,
    this.selectedUserType,
  });
  @override
  List<Object?> get props => [
    message,
    clients,
    selectedClient,
    selectedUserType,
  ];
}

class LoginHistoryExportSuccess extends LoginHistoryState {
  final String message;
  final String filePath;
  const LoginHistoryExportSuccess({
    required this.message,
    required this.filePath,
  });
  @override
  List<Object?> get props => [message, filePath];
}
