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
  final List<String>? selectedSymbols;
  final String? selectedUser;
  final String? selectedItemId;
  final DateTime? selectedExpiry;
  final String? selectedType;
  final double? selectedPrice;

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
    this.selectedSymbols,
    this.selectedUser,
    this.selectedItemId,
    this.selectedExpiry,
    this.selectedType,
    this.selectedPrice,
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
    List<String>? selectedSymbols,
    String? selectedUser,
    String? selectedItemId,
    DateTime? selectedExpiry,
    String? selectedType,
    double? selectedPrice,
    MarketItem? clipboardItem,
    bool? isClipboardCut,
    List<MarketWatchAction>? undoStack,
    List<MarketWatchAction>? redoStack,
    bool? showGrid,
    bool clearExchange = false,
    bool clearSymbol = false,
    bool clearSymbols = false,
    bool clearUser = false,
    bool clearSelectedItem = false,
    bool clearExpiry = false,
    bool clearType = false,
    bool clearPrice = false,
    bool clearClipboard = false,
  }) {
    return MarketWatchLoaded(
      items: items ?? this.items,
      filteredItems: filteredItems ?? this.filteredItems,
      selectedExchange: clearExchange
          ? null
          : (selectedExchange ?? this.selectedExchange),
      selectedSymbol: clearSymbol
          ? null
          : (selectedSymbol ?? this.selectedSymbol),
      selectedSymbols: clearSymbols
          ? null
          : (selectedSymbols ?? this.selectedSymbols),
      selectedUser: clearUser ? null : (selectedUser ?? this.selectedUser),
      selectedItemId: clearSelectedItem
          ? null
          : (selectedItemId ?? this.selectedItemId),
      selectedExpiry: clearExpiry
          ? null
          : (selectedExpiry ?? this.selectedExpiry),
      selectedType: clearType ? null : (selectedType ?? this.selectedType),
      selectedPrice: clearPrice ? null : (selectedPrice ?? this.selectedPrice),
      clipboardItem: clearClipboard
          ? null
          : (clipboardItem ?? this.clipboardItem),
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
    selectedSymbols,
    selectedUser,
    selectedItemId,
    selectedExpiry,
    selectedType,
    selectedPrice,
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
  const MarketWatchAction({required this.type, this.item, this.index});
  @override
  List<Object?> get props => [type, item, index];
}

enum MarketWatchActionType { add, delete, paste }
