import 'package:equatable/equatable.dart';

abstract class ArrangeSymbolEvent extends Equatable {
  const ArrangeSymbolEvent();
  @override
  List<Object?> get props => [];
}

class LoadColumnsEvent extends ArrangeSymbolEvent {
  const LoadColumnsEvent();
}

class ToggleColumnEvent extends ArrangeSymbolEvent {
  final String columnId;
  const ToggleColumnEvent({required this.columnId});
  @override
  List<Object?> get props => [columnId];
}

class ReorderColumnEvent extends ArrangeSymbolEvent {
  final int oldIndex;
  final int newIndex;
  const ReorderColumnEvent({required this.oldIndex, required this.newIndex});
  @override
  List<Object?> get props => [oldIndex, newIndex];
}

class SaveColumnsEvent extends ArrangeSymbolEvent {
  const SaveColumnsEvent();
}

class ResizeColumnEvent extends ArrangeSymbolEvent {
  final String columnId;
  final double width;
  const ResizeColumnEvent({required this.columnId, required this.width});
  @override
  List<Object?> get props => [columnId, width];
}

class ResetColumnsEvent extends ArrangeSymbolEvent {
  const ResetColumnsEvent();
}

class ResetColumnSizesEvent extends ArrangeSymbolEvent {
  const ResetColumnSizesEvent();
}