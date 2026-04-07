part of 'market_watch_notification_bloc.dart';

abstract class MarketWatchNotificationEvent extends Equatable {
  const MarketWatchNotificationEvent();

  @override
  List<Object?> get props => [];
}

class LoadMarketWatchNotifications extends MarketWatchNotificationEvent {}
