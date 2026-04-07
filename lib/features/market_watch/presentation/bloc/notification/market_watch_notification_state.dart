part of 'market_watch_notification_bloc.dart';

abstract class MarketWatchNotificationState extends Equatable {
  const MarketWatchNotificationState();

  @override
  List<Object?> get props => [];
}

class MarketWatchNotificationLoading extends MarketWatchNotificationState {}

class MarketWatchNotificationLoaded extends MarketWatchNotificationState {
  final List<MarketWatchNotificationItem> notifications;

  const MarketWatchNotificationLoaded(this.notifications);

  @override
  List<Object?> get props => [notifications];
}

class MarketWatchNotificationError extends MarketWatchNotificationState {
  final String message;

  const MarketWatchNotificationError(this.message);

  @override
  List<Object?> get props => [message];
}
