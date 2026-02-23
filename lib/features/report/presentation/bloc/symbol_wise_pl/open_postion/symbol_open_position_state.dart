import 'package:equatable/equatable.dart';
import '../../../../domain/entities/symbol_open_position.dart';
abstract class SymbolOpenPositionState extends Equatable {
  const SymbolOpenPositionState();
  @override
  List<Object?> get props => [];
}
class SymbolOpenPositionInitial extends SymbolOpenPositionState {}
class SymbolOpenPositionLoading extends SymbolOpenPositionState {}
class SymbolOpenPositionLoaded extends SymbolOpenPositionState {
  final List<SymbolOpenPosition> positions;
  const SymbolOpenPositionLoaded(this.positions);
  @override
  List<Object?> get props => [positions];
}
class SymbolOpenPositionError extends SymbolOpenPositionState {
  final String message;
  const SymbolOpenPositionError(this.message);
  @override
  List<Object?> get props => [message];
}
