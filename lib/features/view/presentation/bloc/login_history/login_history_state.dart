import 'package:equatable/equatable.dart';
import '../../../domain/entities/login_history/login_history.dart';

abstract class LoginHistoryState extends Equatable {
  const LoginHistoryState();
  @override
  List<Object?> get props => [];
}

class LoginHistoryInitial extends LoginHistoryState {
  final List<String> clients;
  const LoginHistoryInitial({this.clients = const []});
  @override
  List<Object?> get props => [clients];
}

class LoginHistoryLoading extends LoginHistoryState {
  const LoginHistoryLoading();
}

class LoginHistoryLoaded extends LoginHistoryState {
  final List<LoginHistory> history;
  final String selectedClient;
  final int totalRecords;
  final String? sortColumn;
  final bool sortAscending;
  final List<String> clients;
  const LoginHistoryLoaded({
    required this.history,
    required this.selectedClient,
    required this.totalRecords,
    this.sortColumn,
    this.sortAscending = true,
    this.clients = const [],
  });
  @override
  List<Object?> get props => [
    history,
    selectedClient,
    totalRecords,
    sortColumn,
    sortAscending,
    clients,
  ];
  LoginHistoryLoaded copyWith({
    List<LoginHistory>? history,
    String? selectedClient,
    int? totalRecords,
    String? sortColumn,
    bool? sortAscending,
    List<String>? clients,
  }) {
    return LoginHistoryLoaded(
      history: history ?? this.history,
      selectedClient: selectedClient ?? this.selectedClient,
      totalRecords: totalRecords ?? this.totalRecords,
      sortColumn: sortColumn ?? this.sortColumn,
      sortAscending: sortAscending ?? this.sortAscending,
      clients: clients ?? this.clients,
    );
  }
}

class LoginHistoryError extends LoginHistoryState {
  final String message;
  const LoginHistoryError(this.message);
  @override
  List<Object?> get props => [message];
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
