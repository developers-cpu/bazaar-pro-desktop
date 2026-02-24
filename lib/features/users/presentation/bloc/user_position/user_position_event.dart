part of 'user_position_bloc.dart';

abstract class UserPositionEvent extends Equatable {
  const UserPositionEvent();
  @override
  List<Object?> get props => [];
}

class LoadUserPositions extends UserPositionEvent {
  final String userId;
  const LoadUserPositions(this.userId);
  @override
  List<Object?> get props => [userId];
}

class FilterUserPositions extends UserPositionEvent {
  final String? exchange;
  final String? symbol;
  const FilterUserPositions({this.exchange, this.symbol});
  @override
  List<Object?> get props => [exchange, symbol];
}
