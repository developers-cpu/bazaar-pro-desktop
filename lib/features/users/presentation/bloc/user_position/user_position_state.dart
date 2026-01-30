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

  const UserPositionLoaded({
    required this.allPositions,
    required this.filteredPositions,
    this.selectedExchange,
    this.selectedSymbol,
  });

  @override
  List<Object?> get props => [
    allPositions,
    filteredPositions,
    selectedExchange,
    selectedSymbol,
  ];

  UserPositionLoaded copyWith({
    List<UserPosition>? allPositions,
    List<UserPosition>? filteredPositions,
    String? selectedExchange,
    String? selectedSymbol,
  }) {
    return UserPositionLoaded(
      allPositions: allPositions ?? this.allPositions,
      filteredPositions: filteredPositions ?? this.filteredPositions,
      selectedExchange: selectedExchange ?? this.selectedExchange,
      selectedSymbol: selectedSymbol ?? this.selectedSymbol,
    );
  }
}

class UserPositionError extends UserPositionState {
  final String message;

  const UserPositionError(this.message);

  @override
  List<Object?> get props => [message];
}
