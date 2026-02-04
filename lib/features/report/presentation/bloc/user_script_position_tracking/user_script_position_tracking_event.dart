import 'package:equatable/equatable.dart';

abstract class UserScriptPositionTrackingEvent extends Equatable {
  const UserScriptPositionTrackingEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserScriptPositionTracking extends UserScriptPositionTrackingEvent {
  const LoadUserScriptPositionTracking();
}

class FilterUserScriptPositionTracking extends UserScriptPositionTrackingEvent {
  final String? startDate;
  final String? endDate;
  final String? userId;
  final String? exchange;
  final String? symbol;

  const FilterUserScriptPositionTracking({
    this.startDate,
    this.endDate,
    this.userId,
    this.exchange,
    this.symbol,
  });

  @override
  List<Object?> get props => [startDate, endDate, userId, exchange, symbol];
}

class ResetUserScriptPositionTrackingFilters
    extends UserScriptPositionTrackingEvent {
  const ResetUserScriptPositionTrackingFilters();
}
