import 'package:equatable/equatable.dart';
import '../../../domain/entities/market_item.dart';
abstract class MarketWatchEvent extends Equatable {
  const MarketWatchEvent();
  @override
  List<Object?> get props => [];
}
class LoadMarketItemsEvent extends MarketWatchEvent {
  const LoadMarketItemsEvent();
}
class FilterByExchangeEvent extends MarketWatchEvent {
  final String? exchange;
  const FilterByExchangeEvent({this.exchange});
  @override
  List<Object?> get props => [exchange];
}
class FilterBySymbolEvent extends MarketWatchEvent {
  final String? symbol;
  const FilterBySymbolEvent({this.symbol});
  @override
  List<Object?> get props => [symbol];
}
class FilterBySymbolsEvent extends MarketWatchEvent {
  final List<String> symbols;
  const FilterBySymbolsEvent({required this.symbols});
  @override
  List<Object?> get props => [symbols];
}
class FilterByUserEvent extends MarketWatchEvent {
  final String? user;
  const FilterByUserEvent({this.user});
  @override
  List<Object?> get props => [user];
}
class SelectMarketItemEvent extends MarketWatchEvent {
  final String itemId;
  const SelectMarketItemEvent({required this.itemId});
  @override
  List<Object> get props => [itemId];
}
class CopyMarketItemEvent extends MarketWatchEvent {
  final MarketItem item;
  const CopyMarketItemEvent({required this.item});
  @override
  List<Object> get props => [item];
}
class CutMarketItemEvent extends MarketWatchEvent {
  final MarketItem item;
  const CutMarketItemEvent({required this.item});
  @override
  List<Object> get props => [item];
}
class PasteMarketItemEvent extends MarketWatchEvent {
  const PasteMarketItemEvent();
}
class DeleteMarketItemEvent extends MarketWatchEvent {
  final String itemId;
  const DeleteMarketItemEvent({required this.itemId});
  @override
  List<Object> get props => [itemId];
}
class UndoActionEvent extends MarketWatchEvent {
  const UndoActionEvent();
}
class RedoActionEvent extends MarketWatchEvent {
  const RedoActionEvent();
}
class AddMarketItemEvent extends MarketWatchEvent {
  final MarketItem item;
  const AddMarketItemEvent({required this.item});
  @override
  List<Object> get props => [item];
}
class ClearFiltersEvent extends MarketWatchEvent {
  const ClearFiltersEvent();
}
class ToggleGridEvent extends MarketWatchEvent {
  const ToggleGridEvent();
}
