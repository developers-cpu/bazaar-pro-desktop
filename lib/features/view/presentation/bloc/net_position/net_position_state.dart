import 'package:equatable/equatable.dart';
import '../../../domain/entities/net_postion/net_position.dart';
abstract class NetPositionState extends Equatable {
  const NetPositionState();
  @override
  List<Object?> get props => [];
}
class NetPositionInitial extends NetPositionState {
  const NetPositionInitial();
}
class NetPositionLoading extends NetPositionState {
  const NetPositionLoading();
}
class NetPositionLoaded extends NetPositionState {
  final List<NetPosition> positions;
  final List<NetPosition> filteredPositions;
  final int totalRecords;
  final String? selectedPositionId;
  final String? sortColumn;
  final bool sortAscending;
  final String? selectedUserType;
  final String? selectedClient;
  final String? selectedExchange;
  final String? selectedSymbol;
  final List<String> userTypes;
  final List<String> clients;
  final List<String> exchanges;
  final List<String> symbols;
  const NetPositionLoaded({
    required this.positions,
    required this.filteredPositions,
    required this.totalRecords,
    this.selectedPositionId,
    this.sortColumn,
    this.sortAscending = true,
    this.selectedUserType,
    this.selectedClient,
    this.selectedExchange,
    this.selectedSymbol,
    this.userTypes = const [],
    this.clients = const [],
    this.exchanges = const [],
    this.symbols = const [],
  });
  @override
  List<Object?> get props => [
    positions,
    filteredPositions,
    totalRecords,
    selectedPositionId,
    sortColumn,
    sortAscending,
    selectedUserType,
    selectedClient,
    selectedExchange,
    selectedSymbol,
    userTypes,
    clients,
    exchanges,
    symbols,
  ];
  NetPositionLoaded copyWith({
    List<NetPosition>? positions,
    List<NetPosition>? filteredPositions,
    int? totalRecords,
    String? selectedPositionId,
    String? sortColumn,
    bool? sortAscending,
    String? selectedUserType,
    String? selectedClient,
    String? selectedExchange,
    String? selectedSymbol,
    List<String>? userTypes,
    List<String>? clients,
    List<String>? exchanges,
    List<String>? symbols,
  }) {
    return NetPositionLoaded(
      positions: positions ?? this.positions,
      filteredPositions: filteredPositions ?? this.filteredPositions,
      totalRecords: totalRecords ?? this.totalRecords,
      selectedPositionId: selectedPositionId ?? this.selectedPositionId,
      sortColumn: sortColumn ?? this.sortColumn,
      sortAscending: sortAscending ?? this.sortAscending,
      selectedUserType: selectedUserType ?? this.selectedUserType,
      selectedClient: selectedClient ?? this.selectedClient,
      selectedExchange: selectedExchange ?? this.selectedExchange,
      selectedSymbol: selectedSymbol ?? this.selectedSymbol,
      userTypes: userTypes ?? this.userTypes,
      clients: clients ?? this.clients,
      exchanges: exchanges ?? this.exchanges,
      symbols: symbols ?? this.symbols,
    );
  }
}
class NetPositionError extends NetPositionState {
  final String message;
  const NetPositionError(this.message);
  @override
  List<Object?> get props => [message];
}
class NetPositionExportSuccess extends NetPositionState {
  final String message;
  final String filePath;
  const NetPositionExportSuccess({
    required this.message,
    required this.filePath,
  });
  @override
  List<Object?> get props => [message, filePath];
}
class PositionDetailsLoaded extends NetPositionState {
  final List<NetPosition> detailPositions;
  final String symbol;
  final String userName;
  const PositionDetailsLoaded({
    required this.detailPositions,
    required this.symbol,
    required this.userName,
  });
  @override
  List<Object?> get props => [detailPositions, symbol, userName];
}
class PositionDetailsLoading extends NetPositionState {
  const PositionDetailsLoading();
}
class PositionDetailsError extends NetPositionState {
  final String message;
  const PositionDetailsError(this.message);
  @override
  List<Object?> get props => [message];
}
