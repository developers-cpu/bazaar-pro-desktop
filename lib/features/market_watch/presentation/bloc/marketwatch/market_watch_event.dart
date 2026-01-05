import 'package:equatable/equatable.dart';
import '../../../domain/entities/market_item.dart';

/// Base class for all market watch events
abstract class MarketWatchEvent extends Equatable {
  const MarketWatchEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all market items
class LoadMarketItemsEvent extends MarketWatchEvent {
  const LoadMarketItemsEvent();
}

/// Event to filter market items by exchange
class FilterByExchangeEvent extends MarketWatchEvent {
  final String? exchange;

  const FilterByExchangeEvent({this.exchange});

  @override
  List<Object?> get props => [exchange];
}

/// Event to filter market items by symbol
class FilterBySymbolEvent extends MarketWatchEvent {
  final String? symbol;

  const FilterBySymbolEvent({this.symbol});

  @override
  List<Object?> get props => [symbol];
}

/// Event to select a market item row
class SelectMarketItemEvent extends MarketWatchEvent {
  final String itemId;

  const SelectMarketItemEvent({required this.itemId});

  @override
  List<Object> get props => [itemId];
}

/// Event to copy selected market item
class CopyMarketItemEvent extends MarketWatchEvent {
  final MarketItem item;

  const CopyMarketItemEvent({required this.item});

  @override
  List<Object> get props => [item];
}

/// Event to cut selected market item
class CutMarketItemEvent extends MarketWatchEvent {
  final MarketItem item;

  const CutMarketItemEvent({required this.item});

  @override
  List<Object> get props => [item];
}

/// Event to paste copied or cut market item
class PasteMarketItemEvent extends MarketWatchEvent {
  const PasteMarketItemEvent();
}

/// Event to delete selected market item
class DeleteMarketItemEvent extends MarketWatchEvent {
  final String itemId;

  const DeleteMarketItemEvent({required this.itemId});

  @override
  List<Object> get props => [itemId];
}

/// Event to undo last action
class UndoActionEvent extends MarketWatchEvent {
  const UndoActionEvent();
}

/// Event to redo last undone action
class RedoActionEvent extends MarketWatchEvent {
  const RedoActionEvent();
}

/// Event to add a new market item
class AddMarketItemEvent extends MarketWatchEvent {
  final MarketItem item;

  const AddMarketItemEvent({required this.item});

  @override
  List<Object> get props => [item];
}

/// Event to clear all filters
class ClearFiltersEvent extends MarketWatchEvent {
  const ClearFiltersEvent();
}