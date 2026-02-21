import 'package:equatable/equatable.dart';
abstract class WatchlistState extends Equatable {
  const WatchlistState();
  @override
  List<Object?> get props => [];
}
class WatchlistInitial extends WatchlistState {
  const WatchlistInitial();
}
class WatchlistLoaded extends WatchlistState {
  final List<String> watchlists;
  final int selectedIndex;
  const WatchlistLoaded({
    required this.watchlists,
    this.selectedIndex = -1,
  });
  WatchlistLoaded copyWith({
    List<String>? watchlists,
    int? selectedIndex,
  }) {
    return WatchlistLoaded(
      watchlists: watchlists ?? this.watchlists,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
  @override
  List<Object?> get props => [watchlists, selectedIndex];
}
class WatchlistError extends WatchlistState {
  final String message;
  const WatchlistError({required this.message});
  @override
  List<Object> get props => [message];
}
class WatchlistSuccess extends WatchlistState {
  final String message;
  final WatchlistLoaded previousState;
  const WatchlistSuccess({
    required this.message,
    required this.previousState,
  });
  @override
  List<Object> get props => [message, previousState];
}
