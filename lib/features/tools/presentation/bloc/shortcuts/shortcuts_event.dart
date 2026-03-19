import 'package:equatable/equatable.dart';

abstract class ShortcutsEvent extends Equatable {
  const ShortcutsEvent();
  @override
  List<Object> get props => [];
}

class GetShortcutsEvent extends ShortcutsEvent {}