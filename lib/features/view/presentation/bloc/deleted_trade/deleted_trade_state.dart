import 'package:equatable/equatable.dart';
import '../../../domain/entities/deleted_trade/deleted_trade.dart';

abstract class DeletedTradeState extends Equatable {
  const DeletedTradeState();

  @override
  List<Object?> get props => [];
}

class DeletedTradeInitial extends DeletedTradeState {
  const DeletedTradeInitial();
}

class DeletedTradeLoading extends DeletedTradeState {
  const DeletedTradeLoading();
}

class DeletedTradeLoaded extends DeletedTradeState {
  final List<DeletedTrade> trades;
  final List<DeletedTrade> filteredTrades;
  final int totalRecords;
  final String? sortColumn;
  final bool sortAscending;
  final String? selectedUserType;
  final String? selectedUser;
  final String? selectedExchange;
  final String? selectedSymbol;
  final List<String> userTypes;
  final List<String> users;
  final List<String> exchanges;
  final List<String> symbols;

  const DeletedTradeLoaded({
    required this.trades,
    required this.filteredTrades,
    required this.totalRecords,
    this.sortColumn,
    this.sortAscending = true,
    this.selectedUserType,
    this.selectedUser,
    this.selectedExchange,
    this.selectedSymbol,
    this.userTypes = const [],
    this.users = const [],
    this.exchanges = const [],
    this.symbols = const [],
  });

  @override
  List<Object?> get props => [
    trades,
    filteredTrades,
    totalRecords,
    sortColumn,
    sortAscending,
    selectedUserType,
    selectedUser,
    selectedExchange,
    selectedSymbol,
    userTypes,
    users,
    exchanges,
    symbols,
  ];

  DeletedTradeLoaded copyWith({
    List<DeletedTrade>? trades,
    List<DeletedTrade>? filteredTrades,
    int? totalRecords,
    String? sortColumn,
    bool? sortAscending,
    String? selectedUserType,
    String? selectedUser,
    String? selectedExchange,
    String? selectedSymbol,
    List<String>? userTypes,
    List<String>? users,
    List<String>? exchanges,
    List<String>? symbols,
  }) {
    return DeletedTradeLoaded(
      trades: trades ?? this.trades,
      filteredTrades: filteredTrades ?? this.filteredTrades,
      totalRecords: totalRecords ?? this.totalRecords,
      sortColumn: sortColumn ?? this.sortColumn,
      sortAscending: sortAscending ?? this.sortAscending,
      selectedUserType: selectedUserType ?? this.selectedUserType,
      selectedUser: selectedUser ?? this.selectedUser,
      selectedExchange: selectedExchange ?? this.selectedExchange,
      selectedSymbol: selectedSymbol ?? this.selectedSymbol,
      userTypes: userTypes ?? this.userTypes,
      users: users ?? this.users,
      exchanges: exchanges ?? this.exchanges,
      symbols: symbols ?? this.symbols,
    );
  }
}

class DeletedTradeError extends DeletedTradeState {
  final String message;

  const DeletedTradeError(this.message);

  @override
  List<Object?> get props => [message];
}

class DeletedTradeExportSuccess extends DeletedTradeState {
  final String message;
  final String filePath;

  const DeletedTradeExportSuccess({
    required this.message,
    required this.filePath,
  });

  @override
  List<Object?> get props => [message, filePath];
}
