import 'package:equatable/equatable.dart';


abstract class LoginHistoryEvent extends Equatable {
  const LoginHistoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadClientsEvent extends LoginHistoryEvent {
  const LoadClientsEvent();
}

class SelectClientEvent extends LoginHistoryEvent {
  final String client;

  const SelectClientEvent(this.client);

  @override
  List<Object?> get props => [client];
}

class SortLoginHistoryByColumnEvent extends LoginHistoryEvent {
  final String columnId;
  final bool ascending;

  const SortLoginHistoryByColumnEvent({
    required this.columnId,
    required this.ascending,
  });

  @override
  List<Object?> get props => [columnId, ascending];
}

class ExportLoginHistoryToPdfEvent extends LoginHistoryEvent {
  const ExportLoginHistoryToPdfEvent();
}

class ExportLoginHistoryToExcelEvent extends LoginHistoryEvent {
  const ExportLoginHistoryToExcelEvent();
}