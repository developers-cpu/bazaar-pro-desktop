import 'package:equatable/equatable.dart';

/// Base class for all watchlist events
abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load initial watchlists
class LoadWatchlistsEvent extends WatchlistEvent {
  const LoadWatchlistsEvent();
}

/// Event to add a new watchlist
class AddWatchlistEvent extends WatchlistEvent {
  const AddWatchlistEvent();
}

/// Event to remove a watchlist
class RemoveWatchlistEvent extends WatchlistEvent {
  final int index;

  const RemoveWatchlistEvent({required this.index});

  @override
  List<Object> get props => [index];
}

/// Event to select a watchlist
class SelectWatchlistEvent extends WatchlistEvent {
  final int index;

  const SelectWatchlistEvent({required this.index});

  @override
  List<Object> get props => [index];
}

/// Event to rename a watchlist
class RenameWatchlistEvent extends WatchlistEvent {
  final int index;
  final String newName;

  const RenameWatchlistEvent({
    required this.index,
    required this.newName,
  });

  @override
  List<Object> get props => [index, newName];
}