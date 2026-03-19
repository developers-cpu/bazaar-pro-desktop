import 'package:equatable/equatable.dart';

abstract class SymbolFontEvent extends Equatable {
  const SymbolFontEvent();
  @override
  List<Object?> get props => [];
}

class LoadFontSettingsEvent extends SymbolFontEvent {
  const LoadFontSettingsEvent();
}

class SelectFontFamilyEvent extends SymbolFontEvent {
  final String fontFamily;
  const SelectFontFamilyEvent({required this.fontFamily});
  @override
  List<Object?> get props => [fontFamily];
}

class SelectFontStyleEvent extends SymbolFontEvent {
  final String fontStyle;
  const SelectFontStyleEvent({required this.fontStyle});
  @override
  List<Object?> get props => [fontStyle];
}

class SelectFontSizeEvent extends SymbolFontEvent {
  final int fontSize;
  const SelectFontSizeEvent({required this.fontSize});
  @override
  List<Object?> get props => [fontSize];
}

class SaveFontSettingsEvent extends SymbolFontEvent {
  const SaveFontSettingsEvent();
}

class ResetFontSettingsEvent extends SymbolFontEvent {
  const ResetFontSettingsEvent();
}