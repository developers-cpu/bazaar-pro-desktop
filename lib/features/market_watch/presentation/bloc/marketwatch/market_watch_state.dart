import 'package:equatable/equatable.dart';
import '../../../domain/entities/market_item.dart';

/// Base class for all market watch states
/// Uses Equatable for state comparison and rebuild optimization
abstract class MarketWatchState extends Equatable {
  const MarketWatchState();

  @override
  List<Object?> get props => [];
}

/// Initial state when the BLoC is created
class MarketWatchInitial extends MarketWatchState {
  const MarketWatchInitial();
}

/// State when loading data
class MarketWatchLoading extends MarketWatchState {
  const MarketWatchLoading();
}

/// State when data is loaded successfully
class MarketWatchLoaded extends MarketWatchState {
  final List<MarketItem> items;
  final List<MarketItem> filteredItems;
  final String? selectedExchange;
  final String? selectedSymbol;
  final String? selectedItemId;
  final MarketItem? clipboardItem;
  final bool isClipboardCut;
  final List<MarketWatchAction> undoStack;
  final List<MarketWatchAction> redoStack;

  const MarketWatchLoaded({
    required this.items,
    required this.filteredItems,
    this.selectedExchange,
    this.selectedSymbol,
    this.selectedItemId,
    this.clipboardItem,
    this.isClipboardCut = false,
    this.undoStack = const [],
    this.redoStack = const [],
  });

  /// Create a copy of this state with updated fields
  MarketWatchLoaded copyWith({
    List<MarketItem>? items,
    List<MarketItem>? filteredItems,
    String? selectedExchange,
    String? selectedSymbol,
    String? selectedItemId,
    MarketItem? clipboardItem,
    bool? isClipboardCut,
    List<MarketWatchAction>? undoStack,
    List<MarketWatchAction>? redoStack,
    bool clearExchange = false,
    bool clearSymbol = false,
    bool clearSelectedItem = false,
    bool clearClipboard = false,
  }) {
    return MarketWatchLoaded(
      items: items ?? this.items,
      filteredItems: filteredItems ?? this.filteredItems,
      selectedExchange:
      clearExchange ? null : (selectedExchange ?? this.selectedExchange),
      selectedSymbol:
      clearSymbol ? null : (selectedSymbol ?? this.selectedSymbol),
      selectedItemId:
      clearSelectedItem ? null : (selectedItemId ?? this.selectedItemId),
      clipboardItem:
      clearClipboard ? null : (clipboardItem ?? this.clipboardItem),
      isClipboardCut: isClipboardCut ?? this.isClipboardCut,
      undoStack: undoStack ?? this.undoStack,
      redoStack: redoStack ?? this.redoStack,
    );
  }

  @override
  List<Object?> get props => [
    items,
    filteredItems,
    selectedExchange,
    selectedSymbol,
    selectedItemId,
    clipboardItem,
    isClipboardCut,
    undoStack,
    redoStack,
  ];
}

/// State when an error occurs
class MarketWatchError extends MarketWatchState {
  final String message;

  const MarketWatchError({required this.message});

  @override
  List<Object> get props => [message];
}

/// State when showing a success message
class MarketWatchSuccess extends MarketWatchState {
  final String message;
  final MarketWatchLoaded previousState;

  const MarketWatchSuccess({
    required this.message,
    required this.previousState,
  });

  @override
  List<Object> get props => [message, previousState];
}

/// Represents an action that can be undone or redone
class MarketWatchAction extends Equatable {
  final MarketWatchActionType type;
  final MarketItem? item;
  final int? index;

  const MarketWatchAction({
    required this.type,
    this.item,
    this.index,
  });

  @override
  List<Object?> get props => [type, item, index];
}

/// Types of actions that can be performed
enum MarketWatchActionType {
  add,
  delete,
  paste,
}