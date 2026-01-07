import 'package:bazarpro/features/market_watch/presentation/bloc/symbolfont/symbol_font_event.dart';
import 'package:bazarpro/features/market_watch/presentation/bloc/symbolfont/symbol_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SymbolFontBloc extends Bloc<SymbolFontEvent, SymbolFontState> {
  // Default settings
  static const String _defaultFontFamily = 'Inter';
  static const String _defaultFontStyle = 'Regular';
  static const int _defaultFontSize = 14;

  static const List<String> _availableFontFamilies = [
    'Airal',
    'Gilroy',
    'Inter',
    'Lato',
    'Monrope',
    'Montserrat',
    'Nunito Sans',
    'Open Sans',
    'Poppins',
    'Roboto',
  ];

  static const List<String> _availableFontStyles = [
    'Thin',
    'Thin Italic',
    'Regular',
    'Regular Italic',
    'Semibold',
    'Semibold Italic',
    'Bold',
    'Bold Italic',
  ];

  static const List<int> _availableFontSizes = [
    11,
    12,
    14,
    16,
    18,
    20,
    22,
    24,
    28,
    32,
  ];

  // Saved settings (persisted)
  String _savedFontFamily = _defaultFontFamily;
  String _savedFontStyle = _defaultFontStyle;
  int _savedFontSize = _defaultFontSize;

  SymbolFontBloc() : super(const SymbolFontState()) {
    on<LoadFontSettingsEvent>(_onLoadFontSettings);
    on<SelectFontFamilyEvent>(_onSelectFontFamily);
    on<SelectFontStyleEvent>(_onSelectFontStyle);
    on<SelectFontSizeEvent>(_onSelectFontSize);
    on<SaveFontSettingsEvent>(_onSaveFontSettings);
    on<ResetFontSettingsEvent>(_onResetFontSettings);
  }

  void _onLoadFontSettings(
      LoadFontSettingsEvent event, Emitter<SymbolFontState> emit) {
    emit(state.copyWith(
      fontFamilies: _availableFontFamilies,
      fontStyles: _availableFontStyles,
      fontSizes: _availableFontSizes,
      selectedFontFamily: _savedFontFamily,
      selectedFontStyle: _savedFontStyle,
      selectedFontSize: _savedFontSize,
      isSaved: false,
    ));
  }

  void _onSelectFontFamily(
      SelectFontFamilyEvent event, Emitter<SymbolFontState> emit) {
    emit(state.copyWith(
      selectedFontFamily: event.fontFamily,
      isSaved: false,
    ));
  }

  void _onSelectFontStyle(
      SelectFontStyleEvent event, Emitter<SymbolFontState> emit) {
    emit(state.copyWith(
      selectedFontStyle: event.fontStyle,
      isSaved: false,
    ));
  }

  void _onSelectFontSize(
      SelectFontSizeEvent event, Emitter<SymbolFontState> emit) {
    emit(state.copyWith(
      selectedFontSize: event.fontSize,
      isSaved: false,
    ));
  }

  void _onSaveFontSettings(
      SaveFontSettingsEvent event, Emitter<SymbolFontState> emit) {
    _savedFontFamily = state.selectedFontFamily;
    _savedFontStyle = state.selectedFontStyle;
    _savedFontSize = state.selectedFontSize;
    emit(state.copyWith(isSaved: true));
  }

  void _onResetFontSettings(
      ResetFontSettingsEvent event, Emitter<SymbolFontState> emit) {
    _savedFontFamily = _defaultFontFamily;
    _savedFontStyle = _defaultFontStyle;
    _savedFontSize = _defaultFontSize;

    emit(state.copyWith(
      selectedFontFamily: _defaultFontFamily,
      selectedFontStyle: _defaultFontStyle,
      selectedFontSize: _defaultFontSize,
      isSaved: true,
    ));
  }

  // Getters for saved values
  String get savedFontFamily => _savedFontFamily;
  String get savedFontStyle => _savedFontStyle;
  int get savedFontSize => _savedFontSize;
}