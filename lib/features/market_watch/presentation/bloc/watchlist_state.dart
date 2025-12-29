import 'package:equatable/equatable.dart';

/// Base class for all watchlist states
abstract class WatchlistState extends Equatable {
  const WatchlistState();

  @override
  List<Object?> get props => [];
}

/// Initial state when the BLoC is created
class WatchlistInitial extends WatchlistState {
  const WatchlistInitial();
}

/// State when watchlists are loaded
class WatchlistLoaded extends WatchlistState {
  final List<String> watchlists;
  final int selectedIndex; // -1 means "All" is selected

  const WatchlistLoaded({
    required this.watchlists,
    this.selectedIndex = -1,
  });

  /// Create a copy of this state with updated fields
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

/// State when an error occurs
class WatchlistError extends WatchlistState {
  final String message;

  const WatchlistError({required this.message});

  @override
  List<Object> get props => [message];
}

/// State for showing success messages
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