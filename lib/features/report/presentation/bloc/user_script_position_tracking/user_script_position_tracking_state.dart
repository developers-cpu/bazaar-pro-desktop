import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_script_position_tracking.dart';
abstract class UserScriptPositionTrackingState extends Equatable {
  const UserScriptPositionTrackingState();
  @override
  List<Object?> get props => [];
}
class UserScriptPositionTrackingInitial
    extends UserScriptPositionTrackingState {}
class UserScriptPositionTrackingLoading
    extends UserScriptPositionTrackingState {}
class UserScriptPositionTrackingLoaded extends UserScriptPositionTrackingState {
  final List<UserScriptPositionTracking> reports;
  final List<String> userNames;
  final List<String> exchanges;
  final List<String> symbols;
  final String? selectedUser;
  final String? selectedExchange;
  final String? selectedSymbol;
  final String? startDate;
  final String? endDate;
  const UserScriptPositionTrackingLoaded({
    required this.reports,
    required this.userNames,
    required this.exchanges,
    required this.symbols,
    this.selectedUser,
    this.selectedExchange,
    this.selectedSymbol,
    this.startDate,
    this.endDate,
  });
  @override
  List<Object?> get props => [
    reports,
    userNames,
    exchanges,
    symbols,
    selectedUser,
    selectedExchange,
    selectedSymbol,
    startDate,
    endDate,
  ];
}
class UserScriptPositionTrackingError extends UserScriptPositionTrackingState {
  final String message;
  const UserScriptPositionTrackingError({required this.message});
  @override
  List<Object?> get props => [message];
}
