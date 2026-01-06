import 'package:equatable/equatable.dart';
import '../../../domain/entities/market_item.dart';

abstract class MarketWatchState extends Equatable {
  const MarketWatchState();

  @override
  List<Object?> get props => [];
}

class MarketWatchInitial extends MarketWatchState {
  const MarketWatchInitial();
}

class MarketWatchLoading extends MarketWatchState {
  const MarketWatchLoading();
}

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
  final bool showGrid;

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
    this.showGrid = false,
  });

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
    bool? showGrid,
    bool clearExchange = false,
    bool clearSymbol = false,
    bool clearSelectedItem = false,
    bool clearClipboard = false,
  }) {
    return MarketWatchLoaded(
      items: items ?? this.items,
      filteredItems: filteredItems ?? this.filteredItems,
      selectedExchange: clearExchange ? null : (selectedExchange ?? this.selectedExchange),
      selectedSymbol: clearSymbol ? null : (selectedSymbol ?? this.selectedSymbol),
      selectedItemId: clearSelectedItem ? null : (selectedItemId ?? this.selectedItemId),
      clipboardItem: clearClipboard ? null : (clipboardItem ?? this.clipboardItem),
      isClipboardCut: isClipboardCut ?? this.isClipboardCut,
      undoStack: undoStack ?? this.undoStack,
      redoStack: redoStack ?? this.redoStack,
      showGrid: showGrid ?? this.showGrid,
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
    showGrid,
  ];
}

class MarketWatchError extends MarketWatchState {
  final String message;

  const MarketWatchError({required this.message});

  @override
  List<Object> get props => [message];
}

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

enum MarketWatchActionType {
  add,
  delete,
  paste,
}