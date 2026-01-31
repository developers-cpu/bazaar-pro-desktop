part of 'user_position_bloc.dart';

abstract class UserPositionState extends Equatable {
  const UserPositionState();

  @override
  List<Object?> get props => [];
}

class UserPositionInitial extends UserPositionState {}

class UserPositionLoading extends UserPositionState {}

class UserPositionLoaded extends UserPositionState {
  final List<UserPosition> allPositions;
  final List<UserPosition> filteredPositions;
  final String? selectedExchange;
  final String? selectedSymbol;

  final List<String> exchanges;
  final List<String> symbols;

  const UserPositionLoaded({
    required this.allPositions,
    required this.filteredPositions,
    this.selectedExchange,
    this.selectedSymbol,
    this.exchanges = const [],
    this.symbols = const [],
  });

  UserPositionLoaded copyWith({
    List<UserPosition>? allPositions,
    List<UserPosition>? filteredPositions,
    String? selectedExchange,
    String? selectedSymbol,
    List<String>? exchanges,
    List<String>? symbols,
  }) {
    return UserPositionLoaded(
      allPositions: allPositions ?? this.allPositions,
      filteredPositions: filteredPositions ?? this.filteredPositions,
      selectedExchange: selectedExchange ?? this.selectedExchange,
      selectedSymbol: selectedSymbol ?? this.selectedSymbol,
      exchanges: exchanges ?? this.exchanges,
      symbols: symbols ?? this.symbols,
    );
  }

  @override
  List<Object?> get props => [
    allPositions,
    filteredPositions,
    selectedExchange,
    selectedSymbol,
    exchanges,
    symbols,
  ];
}

class UserPositionError extends UserPositionState {
  final String message;

  const UserPositionError(this.message);

  @override
  List<Object?> get props => [message];
}
