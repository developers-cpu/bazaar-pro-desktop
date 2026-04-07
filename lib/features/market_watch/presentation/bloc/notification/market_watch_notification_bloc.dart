import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'market_watch_notification_event.dart';
part 'market_watch_notification_state.dart';

class MarketWatchNotificationBloc
    extends Bloc<MarketWatchNotificationEvent, MarketWatchNotificationState> {
  MarketWatchNotificationBloc() : super(MarketWatchNotificationLoading()) {
    on<LoadMarketWatchNotifications>(_onLoadNotifications);
  }

  Future<void> _onLoadNotifications(
    LoadMarketWatchNotifications event,
    Emitter<MarketWatchNotificationState> emit,
  ) async {
    emit(MarketWatchNotificationLoading());

    final notifications = [
      MarketWatchNotificationItem(
        id: 'mw-1',
        title: 'Watchlist Updated',
        body: 'BankNifty contracts were refreshed with the latest live prices.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
      MarketWatchNotificationItem(
        id: 'mw-2',
        title: 'Market Alert',
        body: 'NIFTY 50 has moved above your configured intraday range.',
        timestamp: DateTime.now().subtract(
          const Duration(hours: 1, minutes: 8),
        ),
      ),
      MarketWatchNotificationItem(
        id: 'mw-3',
        title: 'Connection Stable',
        body: 'Realtime market feed is active and receiving updates normally.',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      ),
      MarketWatchNotificationItem(
        id: 'mw-4',
        title: 'Watchlist Reminder',
        body: 'MCX instruments in Watchlist 2 are ready for review.',
        timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 2)),
      ),
    ];

    notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    emit(MarketWatchNotificationLoaded(notifications));
  }
}

class MarketWatchNotificationItem extends Equatable {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final bool isRead;

  const MarketWatchNotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
  });

  @override
  List<Object?> get props => [id, title, body, timestamp, isRead];
}
