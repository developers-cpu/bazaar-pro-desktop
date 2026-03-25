import '../../../domain/entities/symbol_settings/symbol_setting.dart';

abstract class SymbolSettingsEvent {}

class LoadSymbolSettingsEvent extends SymbolSettingsEvent {
  final String? exchange;
  LoadSymbolSettingsEvent({this.exchange});
}

class UpdateSymbolSettingEvent extends SymbolSettingsEvent {
  final String id;
  final SymbolSetting updated;
  UpdateSymbolSettingEvent({required this.id, required this.updated});
}

class UpdateSymbolTradeMarginEvent extends SymbolSettingsEvent {
  final String id;
  final String marginType;
  final String intradayMarginPercent;
  final String carryForwardMarginPercent;
  final String intradayMarginAmount;
  final String carryForwardMarginAmount;
  UpdateSymbolTradeMarginEvent({
    required this.id,
    required this.marginType,
    required this.intradayMarginPercent,
    required this.carryForwardMarginPercent,
    required this.intradayMarginAmount,
    required this.carryForwardMarginAmount,
  });
}
