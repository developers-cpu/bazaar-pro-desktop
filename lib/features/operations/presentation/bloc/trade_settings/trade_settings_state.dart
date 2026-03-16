import 'package:equatable/equatable.dart';
import '../../../domain/entities/trade_settings/trade_setting.dart';
abstract class TradeSettingsState extends Equatable {
  const TradeSettingsState();
  @override
  List<Object> get props => [];
}
class TradeSettingsInitial extends TradeSettingsState {}
class TradeSettingsLoading extends TradeSettingsState {}
class TradeSettingsLoaded extends TradeSettingsState {
  final List<TradeSetting> settings;
  const TradeSettingsLoaded(this.settings);
  @override
  List<Object> get props => [settings];
}
class TradeSettingsError extends TradeSettingsState {
  final String message;
  const TradeSettingsError(this.message);
  @override
  List<Object> get props => [message];
}
class TradeSettingsUpdateSuccess extends TradeSettingsState {
  final String message;
  const TradeSettingsUpdateSuccess(this.message);
  @override
  List<Object> get props => [message];
}
