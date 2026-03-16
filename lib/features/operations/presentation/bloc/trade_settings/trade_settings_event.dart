import 'package:equatable/equatable.dart';
import '../../../domain/entities/trade_settings/trade_setting.dart';
abstract class TradeSettingsEvent extends Equatable {
  const TradeSettingsEvent();
  @override
  List<Object> get props => [];
}
class LoadTradeSettingsEvent extends TradeSettingsEvent {}
class UpdateTradeSettingsEvent extends TradeSettingsEvent {
  final List<String> ids;
  final TradeSetting? details;
  const UpdateTradeSettingsEvent({required this.ids, this.details});
  @override
  List<Object> get props => [ids];
}
