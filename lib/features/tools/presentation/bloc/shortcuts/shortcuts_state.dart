import 'package:equatable/equatable.dart';
import '../../../domain/entities/shortcut_entity.dart';

abstract class ShortcutsState extends Equatable {
  const ShortcutsState();
  @override
  List<Object> get props => [];
}

class ShortcutsInitial extends ShortcutsState {}

class ShortcutsLoading extends ShortcutsState {}

class ShortcutsLoaded extends ShortcutsState {
  final List<ShortcutEntity> shortcuts;
  const ShortcutsLoaded(this.shortcuts);
  @override
  List<Object> get props => [shortcuts];
}

class ShortcutsError extends ShortcutsState {
  final String message;
  const ShortcutsError(this.message);
  @override
  List<Object> get props => [message];
}
