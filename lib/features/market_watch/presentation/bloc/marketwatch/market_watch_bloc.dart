import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/market_item.dart';
import '../../../domain/usecases/add_market_item.dart';
import '../../../domain/usecases/delete_market_item.dart';
import '../../../domain/usecases/get_market_items.dart';
import 'market_watch_event.dart';
import 'market_watch_state.dart';

class MarketWatchBloc extends Bloc<MarketWatchEvent, MarketWatchState> {
  final GetMarketItems getMarketItems;
  final AddMarketItem addMarketItem;
  final DeleteMarketItem deleteMarketItem;
  MarketWatchBloc({
    required this.getMarketItems,
    required this.addMarketItem,
    required this.deleteMarketItem,
  }) : super(const MarketWatchInitial()) {
    on<LoadMarketItemsEvent>(_onLoadMarketItems);
    on<FilterByExchangeEvent>(_onFilterByExchange);
    on<FilterBySymbolEvent>(_onFilterBySymbol);
    on<FilterBySymbolsEvent>(_onFilterBySymbols);
    on<FilterByUserEvent>(_onFilterByUser);
    on<FilterByExpiryEvent>(_onFilterByExpiry);
    on<FilterByTypeEvent>(_onFilterByType);
    on<FilterByPriceEvent>(_onFilterByPrice);
    on<SelectMarketItemEvent>(_onSelectMarketItem);
    on<CopyMarketItemEvent>(_onCopyMarketItem);
    on<CutMarketItemEvent>(_onCutMarketItem);
    on<PasteMarketItemEvent>(_onPasteMarketItem);
    on<DeleteMarketItemEvent>(_onDeleteMarketItem);
    on<UndoActionEvent>(_onUndoAction);
    on<RedoActionEvent>(_onRedoAction);
    on<AddMarketItemEvent>(_onAddMarketItem);
    on<ClearFiltersEvent>(_onClearFilters);
    on<ToggleGridEvent>(_onToggleGrid);
    on<ReorderMarketItemsEvent>(_onReorderMarketItems);
  }
  Future<void> _onLoadMarketItems(
    LoadMarketItemsEvent event,
    Emitter<MarketWatchState> emit,
  ) async {
    emit(const MarketWatchLoading());
    final result = await getMarketItems(NoParams());
    result.fold(
      (failure) => emit(MarketWatchError(message: failure.message)),
      (items) => emit(MarketWatchLoaded(items: items, filteredItems: items)),
    );
  }

  void _onFilterByExchange(
    FilterByExchangeEvent event,
    Emitter<MarketWatchState> emit,
  ) {
    final currentState = _getLoadedState();
    if (currentState == null) return;
    var filtered = currentState.items.toList();
    if (event.exchange?.isNotEmpty == true) {
      filtered = filtered
          .where((item) => item.exchange == event.exchange)
          .toList();
    }
    if (currentState.selectedSymbols != null &&
        currentState.selectedSymbols!.isNotEmpty) {
      filtered = filtered
          .where((item) => currentState.selectedSymbols!.contains(item.symbol))
          .toList();
    } else if (currentState.selectedSymbol != null) {
      filtered = filtered
          .where((item) => item.symbol == currentState.selectedSymbol)
          .toList();
    }
    emit(
      currentState.copyWith(
        filteredItems: filtered,
        selectedExchange: event.exchange,
        clearExpiry: event.exchange != AppStrings.cePe,
        clearType: event.exchange != AppStrings.cePe,
        clearPrice: event.exchange != AppStrings.cePe,
      ),
    );
  }

  void _onFilterBySymbol(
    FilterBySymbolEvent event,
    Emitter<MarketWatchState> emit,
  ) {
    final currentState = _getLoadedState();
    if (currentState == null) return;
    var filtered = currentState.items.toList();
    if (event.symbol?.isNotEmpty == true) {
      filtered = filtered.where((item) => item.symbol == event.symbol).toList();
    }
    if (currentState.selectedExchange != null) {
      filtered = filtered
          .where((item) => item.exchange == currentState.selectedExchange)
          .toList();
    }
    emit(
      currentState.copyWith(
        filteredItems: filtered,
        selectedSymbol: event.symbol,
      ),
    );
  }

  void _onFilterBySymbols(
    FilterBySymbolsEvent event,
    Emitter<MarketWatchState> emit,
  ) {
    final currentState = _getLoadedState();
    if (currentState == null) return;
    var filtered = currentState.items.toList();
    if (event.symbols.isNotEmpty) {
      filtered = filtered
          .where((item) => event.symbols.contains(item.symbol))
          .toList();
    }
    if (currentState.selectedExchange != null) {
      filtered = filtered
          .where((item) => item.exchange == currentState.selectedExchange)
          .toList();
    }
    emit(
      currentState.copyWith(
        filteredItems: filtered,
        selectedSymbols: event.symbols.isEmpty ? null : event.symbols,
        clearSymbol: true,
      ),
    );
  }

  void _onFilterByUser(
    FilterByUserEvent event,
    Emitter<MarketWatchState> emit,
  ) {
    final currentState = _getLoadedState();
    if (currentState == null) return;
    emit(currentState.copyWith(selectedUser: event.user));
  }

  void _onFilterByExpiry(
    FilterByExpiryEvent event,
    Emitter<MarketWatchState> emit,
  ) {
    final currentState = _getLoadedState();
    if (currentState == null) return;
    final newState = currentState.copyWith(
      selectedExpiry: event.expiry,
      clearExpiry: event.expiry == null,
    );
    emit(
      newState.copyWith(filteredItems: _applyFilters(newState.items, newState)),
    );
  }

  void _onFilterByType(
    FilterByTypeEvent event,
    Emitter<MarketWatchState> emit,
  ) {
    final currentState = _getLoadedState();
    if (currentState == null) return;
    final newState = currentState.copyWith(
      selectedType: event.type,
      clearType: event.type == null,
    );
    emit(
      newState.copyWith(filteredItems: _applyFilters(newState.items, newState)),
    );
  }

  void _onFilterByPrice(
    FilterByPriceEvent event,
    Emitter<MarketWatchState> emit,
  ) {
    final currentState = _getLoadedState();
    if (currentState == null) return;
    final newState = currentState.copyWith(
      selectedPrice: event.price,
      clearPrice: event.price == null,
    );
    emit(
      newState.copyWith(filteredItems: _applyFilters(newState.items, newState)),
    );
  }

  void _onSelectMarketItem(
    SelectMarketItemEvent event,
    Emitter<MarketWatchState> emit,
  ) {
    final currentState = _getLoadedState();
    if (currentState == null) return;
    emit(currentState.copyWith(selectedItemId: event.itemId));
  }

  Future<void> _onCopyMarketItem(
    CopyMarketItemEvent event,
    Emitter<MarketWatchState> emit,
  ) async {
    final currentState = _getLoadedState();
    if (currentState == null) return;
    final newState = currentState.copyWith(
      clipboardItem: event.item,
      isClipboardCut: false,
    );
    emit(
      MarketWatchSuccess(
        message: AppStrings.itemCopied,
        previousState: newState,
      ),
    );
    await Future.delayed(const Duration(milliseconds: 100));
    emit(newState);
  }

  Future<void> _onCutMarketItem(
    CutMarketItemEvent event,
    Emitter<MarketWatchState> emit,
  ) async {
    final currentState = _getLoadedState();
    if (currentState == null) return;
    final newState = currentState.copyWith(
      clipboardItem: event.item,
      isClipboardCut: true,
    );
    emit(
      MarketWatchSuccess(message: AppStrings.itemCut, previousState: newState),
    );
    await Future.delayed(const Duration(milliseconds: 100));
    emit(newState);
  }

  Future<void> _onPasteMarketItem(
    PasteMarketItemEvent event,
    Emitter<MarketWatchState> emit,
  ) async {
    final currentState = _getLoadedState();
    if (currentState == null) return;
    if (currentState.clipboardItem == null) {
      emit(const MarketWatchError(message: AppStrings.noItemsToPaste));
      return;
    }
    final newItem = currentState.clipboardItem!.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    final result = await addMarketItem(AddMarketItemParams(item: newItem));
    final failure = result.fold((l) => l, (r) => null);
    if (failure != null) {
      emit(MarketWatchError(message: failure.message));
      return;
    }
    final addedItem = result.fold((l) => null, (r) => r)!;
    List<MarketItem> updatedItems = List<MarketItem>.from(currentState.items);
    int insertIndex = updatedItems.length;
    if (currentState.selectedItemId != null) {
      final selectedIndex = updatedItems.indexWhere(
        (item) => item.id == currentState.selectedItemId,
      );
      if (selectedIndex != -1) {
        insertIndex = selectedIndex;
      }
    }
    updatedItems.insert(insertIndex, addedItem);
    final filteredItems = _applyFilters(updatedItems, currentState);
    final newUndoStack = [
      ...currentState.undoStack,
      MarketWatchAction(
        type: MarketWatchActionType.paste,
        item: addedItem,
        index: insertIndex,
      ),
    ];
    final newState = currentState.copyWith(
      items: updatedItems,
      filteredItems: filteredItems,
      clipboardItem: currentState.isClipboardCut
          ? null
          : currentState.clipboardItem,
      isClipboardCut: false,
      undoStack: newUndoStack,
      redoStack: [],
      clearClipboard: currentState.isClipboardCut,
    );
    emit(
      MarketWatchSuccess(
        message: AppStrings.itemPasted,
        previousState: newState,
      ),
    );
    await Future.delayed(const Duration(milliseconds: 100));
    emit(newState);
  }

  Future<void> _onDeleteMarketItem(
    DeleteMarketItemEvent event,
    Emitter<MarketWatchState> emit,
  ) async {
    final currentState = _getLoadedState();
    if (currentState == null) return;
    final itemToDelete = currentState.items.firstWhere(
      (item) => item.id == event.itemId,
    );
    final itemIndex = currentState.items.indexOf(itemToDelete);
    final result = await deleteMarketItem(
      DeleteMarketItemParams(id: event.itemId),
    );
    final failure = result.fold((l) => l, (r) => null);
    if (failure != null) {
      emit(MarketWatchError(message: failure.message));
      return;
    }
    final updatedItems = currentState.items
        .where((item) => item.id != event.itemId)
        .toList();
    final filteredItems = _applyFilters(updatedItems, currentState);
    final newUndoStack = [
      ...currentState.undoStack,
      MarketWatchAction(
        type: MarketWatchActionType.delete,
        item: itemToDelete,
        index: itemIndex,
      ),
    ];
    final newState = currentState.copyWith(
      items: updatedItems,
      filteredItems: filteredItems,
      undoStack: newUndoStack,
      redoStack: [],
      clearSelectedItem: true,
    );
    emit(
      MarketWatchSuccess(
        message: AppStrings.itemDeleted,
        previousState: newState,
      ),
    );
    await Future.delayed(const Duration(milliseconds: 100));
    emit(newState);
  }

  Future<void> _onUndoAction(
    UndoActionEvent event,
    Emitter<MarketWatchState> emit,
  ) async {
    final currentState = _getLoadedState();
    if (currentState == null) return;
    if (currentState.undoStack.isEmpty) {
      emit(const MarketWatchError(message: AppStrings.noActionsToUndo));
      return;
    }
    final lastAction = currentState.undoStack.last;
    final newUndoStack = currentState.undoStack.sublist(
      0,
      currentState.undoStack.length - 1,
    );
    List<MarketItem> updatedItems;
    switch (lastAction.type) {
      case MarketWatchActionType.add:
      case MarketWatchActionType.paste:
        updatedItems = currentState.items
            .where((item) => item.id != lastAction.item!.id)
            .toList();
        break;
      case MarketWatchActionType.delete:
        updatedItems = [...currentState.items];
        final index = lastAction.index;
        if (index != null && index <= updatedItems.length) {
          updatedItems.insert(index, lastAction.item!);
        } else {
          updatedItems.add(lastAction.item!);
        }
        break;
    }
    final filteredItems = _applyFilters(updatedItems, currentState);
    final newRedoStack = [...currentState.redoStack, lastAction];
    final newState = currentState.copyWith(
      items: updatedItems,
      filteredItems: filteredItems,
      undoStack: newUndoStack,
      redoStack: newRedoStack,
    );
    emit(
      MarketWatchSuccess(
        message: AppStrings.actionUndone,
        previousState: newState,
      ),
    );
    await Future.delayed(const Duration(milliseconds: 100));
    emit(newState);
  }

  Future<void> _onRedoAction(
    RedoActionEvent event,
    Emitter<MarketWatchState> emit,
  ) async {
    final currentState = _getLoadedState();
    if (currentState == null) return;
    if (currentState.redoStack.isEmpty) {
      emit(const MarketWatchError(message: AppStrings.noActionsToRedo));
      return;
    }
    final lastAction = currentState.redoStack.last;
    final newRedoStack = currentState.redoStack.sublist(
      0,
      currentState.redoStack.length - 1,
    );
    List<MarketItem> updatedItems;
    switch (lastAction.type) {
      case MarketWatchActionType.add:
      case MarketWatchActionType.paste:
        updatedItems = [...currentState.items];
        final index = lastAction.index;
        if (index != null && index <= updatedItems.length) {
          updatedItems.insert(index, lastAction.item!);
        } else {
          updatedItems.add(lastAction.item!);
        }
        break;
      case MarketWatchActionType.delete:
        updatedItems = currentState.items
            .where((item) => item.id != lastAction.item!.id)
            .toList();
        break;
    }
    final filteredItems = _applyFilters(updatedItems, currentState);
    final newUndoStack = [...currentState.undoStack, lastAction];
    final newState = currentState.copyWith(
      items: updatedItems,
      filteredItems: filteredItems,
      undoStack: newUndoStack,
      redoStack: newRedoStack,
    );
    emit(
      MarketWatchSuccess(
        message: AppStrings.actionRedone,
        previousState: newState,
      ),
    );
    await Future.delayed(const Duration(milliseconds: 100));
    emit(newState);
  }

  Future<void> _onAddMarketItem(
    AddMarketItemEvent event,
    Emitter<MarketWatchState> emit,
  ) async {
    final currentState = _getLoadedState();
    if (currentState == null) return;
    final result = await addMarketItem(AddMarketItemParams(item: event.item));
    result.fold((failure) => emit(MarketWatchError(message: failure.message)), (
      addedItem,
    ) {
      final updatedItems = [...currentState.items, addedItem];
      final filteredItems = _applyFilters(updatedItems, currentState);
      final newUndoStack = [
        ...currentState.undoStack,
        MarketWatchAction(type: MarketWatchActionType.add, item: addedItem),
      ];
      emit(
        currentState.copyWith(
          items: updatedItems,
          filteredItems: filteredItems,
          undoStack: newUndoStack,
          redoStack: [],
        ),
      );
    });
  }

  void _onClearFilters(
    ClearFiltersEvent event,
    Emitter<MarketWatchState> emit,
  ) {
    final currentState = _getLoadedState();
    if (currentState == null) return;
    emit(
      currentState.copyWith(
        filteredItems: currentState.items,
        clearExchange: true,
        clearSymbol: true,
      ),
    );
  }

  void _onToggleGrid(ToggleGridEvent event, Emitter<MarketWatchState> emit) {
    final currentState = _getLoadedState();
    if (currentState == null) return;
    emit(currentState.copyWith(showGrid: !currentState.showGrid));
  }

  MarketWatchLoaded? _getLoadedState() {
    if (state is MarketWatchLoaded) return state as MarketWatchLoaded;
    if (state is MarketWatchSuccess)
      return (state as MarketWatchSuccess).previousState;
    return null;
  }

  List<MarketItem> _applyFilters(
    List<MarketItem> items,
    MarketWatchLoaded currentState,
  ) {
    var filtered = items.toList();
    if (currentState.selectedExchange != null) {
      filtered = filtered
          .where((item) => item.exchange == currentState.selectedExchange)
          .toList();
    }
    if (currentState.selectedSymbol != null) {
      filtered = filtered
          .where((item) => item.symbol == currentState.selectedSymbol)
          .toList();
    }
    if (currentState.selectedSymbols != null &&
        currentState.selectedSymbols!.isNotEmpty) {
      filtered = filtered
          .where((item) => currentState.selectedSymbols!.contains(item.symbol))
          .toList();
    }
    if (currentState.selectedExchange == AppStrings.cePe) {
      if (currentState.selectedExpiry != null) {
        filtered = filtered
            .where((item) => item.expiry == currentState.selectedExpiry)
            .toList();
      }
      if (currentState.selectedType != null) {
        filtered = filtered.where((item) {
          final isCall = item.symbol.endsWith('CE');
          final isPut = item.symbol.endsWith('PE');
          if (currentState.selectedType == 'CALL') return isCall;
          if (currentState.selectedType == 'PUT') return isPut;
          return true;
        }).toList();
      }
      if (currentState.selectedPrice != null) {
        filtered = filtered
            .where((item) => item.strikePrice == currentState.selectedPrice)
            .toList();
      }
    }
    return filtered;
  }

  void _onReorderMarketItems(
    ReorderMarketItemsEvent event,
    Emitter<MarketWatchState> emit,
  ) {
    final currentState = _getLoadedState();
    if (currentState == null) return;
    final updatedItems = List<MarketItem>.from(currentState.items);
    final oldIndex = updatedItems.indexWhere(
      (item) => item.id == event.fromItemId,
    );
    final newIndex = updatedItems.indexWhere(
      (item) => item.id == event.toItemId,
    );
    if (oldIndex != -1 && newIndex != -1) {
      final item = updatedItems.removeAt(oldIndex);
      updatedItems.insert(newIndex, item);
      final filteredItems = _applyFilters(updatedItems, currentState);
      emit(
        currentState.copyWith(
          items: updatedItems,
          filteredItems: filteredItems,
        ),
      );
    }
  }
}
