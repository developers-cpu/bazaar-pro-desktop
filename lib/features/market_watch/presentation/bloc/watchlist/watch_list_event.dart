import 'package:equatable/equatable.dart';


abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object?> get props => [];
}


class LoadWatchlistsEvent extends WatchlistEvent {
  const LoadWatchlistsEvent();
}


class AddWatchlistEvent extends WatchlistEvent {
  const AddWatchlistEvent();
}


class RemoveWatchlistEvent extends WatchlistEvent {
  final int index;

  const RemoveWatchlistEvent({required this.index});

  @override
  List<Object> get props => [index];
}


class SelectWatchlistEvent extends WatchlistEvent {
  final int index;

  const SelectWatchlistEvent({required this.index});

  @override
  List<Object> get props => [index];
}


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