import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/market_item.dart';
import '../../domain/usecases/add_market_item.dart';
import '../../domain/usecases/delete_market_item.dart';
import '../../domain/usecases/get_market_items.dart';
import 'market_watch_event.dart';
import 'market_watch_state.dart';

/// BLoC for managing market watch state and business logic
/// Handles all user interactions and data operations
/// Uses clean architecture principles with dependency injection
class MarketWatchBloc extends Bloc<MarketWatchEvent, MarketWatchState> {
  final GetMarketItems getMarketItems;
  final AddMarketItem addMarketItem;
  final DeleteMarketItem deleteMarketItem;

  MarketWatchBloc({
    required this.getMarketItems,
    required this.addMarketItem,
    required this.deleteMarketItem,
  }) : super(const MarketWatchInitial()) {
    // Register event handlers
    on<LoadMarketItemsEvent>(_onLoadMarketItems);
    on<FilterByExchangeEvent>(_onFilterByExchange);
    on<FilterBySymbolEvent>(_onFilterBySymbol);
    on<SelectMarketItemEvent>(_onSelectMarketItem);
    on<CopyMarketItemEvent>(_onCopyMarketItem);
    on<CutMarketItemEvent>(_onCutMarketItem);
    on<PasteMarketItemEvent>(_onPasteMarketItem);
    on<DeleteMarketItemEvent>(_onDeleteMarketItem);
    on<UndoActionEvent>(_onUndoAction);
    on<RedoActionEvent>(_onRedoAction);
    on<AddMarketItemEvent>(_onAddMarketItem);
    on<ClearFiltersEvent>(_onClearFilters);
  }

  /// Handle loading market items from repository
  Future<void> _onLoadMarketItems(
      LoadMarketItemsEvent event,
      Emitter<MarketWatchState> emit,
      ) async {
    emit(const MarketWatchLoading());

    // Call use case to get market items
    final result = await getMarketItems(NoParams());

    // Handle result - either success or failure
    result.fold(
          (failure) => emit(MarketWatchError(message: failure.message)),
          (items) => emit(MarketWatchLoaded(
        items: items,
        filteredItems: items,
      )),
    );
  }

  /// Handle filtering by exchange
  void _onFilterByExchange(
      FilterByExchangeEvent event,
      Emitter<MarketWatchState> emit,
      ) {
    if (state is MarketWatchLoaded) {
      final currentState = state as MarketWatchLoaded;

      // Apply filter
      List<MarketItem> filtered = currentState.items;

      if (event.exchange != null && event.exchange!.isNotEmpty) {
        filtered = filtered
            .where((item) => item.exchange == event.exchange)
            .toList();
      }

      // Also apply symbol filter if active
      if (currentState.selectedSymbol != null) {
        filtered = filtered
            .where((item) => item.symbol == currentState.selectedSymbol)
            .toList();
      }

      emit(currentState.copyWith(
        filteredItems: filtered,
        selectedExchange: event.exchange,
      ));
    }
  }

  /// Handle filtering by symbol
  void _onFilterBySymbol(
      FilterBySymbolEvent event,
      Emitter<MarketWatchState> emit,
      ) {
    if (state is MarketWatchLoaded) {
      final currentState = state as MarketWatchLoaded;

      // Apply filter
      List<MarketItem> filtered = currentState.items;

      if (event.symbol != null && event.symbol!.isNotEmpty) {
        filtered = filtered
            .where((item) => item.symbol == event.symbol)
            .toList();
      }

      // Also apply exchange filter if active
      if (currentState.selectedExchange != null) {
        filtered = filtered
            .where((item) => item.exchange == currentState.selectedExchange)
            .toList();
      }

      emit(currentState.copyWith(
        filteredItems: filtered,
        selectedSymbol: event.symbol,
      ));
    }
  }

  /// Handle selecting a market item row
  void _onSelectMarketItem(
      SelectMarketItemEvent event,
      Emitter<MarketWatchState> emit,
      ) {
    if (state is MarketWatchLoaded) {
      final currentState = state as MarketWatchLoaded;
      emit(currentState.copyWith(selectedItemId: event.itemId));
    }
  }

  /// Handle copying a market item to clipboard
  Future<void> _onCopyMarketItem(
      CopyMarketItemEvent event,
      Emitter<MarketWatchState> emit,
      ) async {
    if (state is MarketWatchLoaded) {
      final currentState = state as MarketWatchLoaded;

      // Store item in clipboard with copy flag
      final newState = currentState.copyWith(
        clipboardItem: event.item,
        isClipboardCut: false,
      );

      // Emit success which contains the loaded state
      emit(MarketWatchSuccess(
        message: 'Item copied',
        previousState: newState,
      ));

      // Wait a moment for the listener to process, then emit loaded state
      await Future.delayed(const Duration(milliseconds: 100));
      emit(newState);
    }
  }

  /// Handle cutting a market item to clipboard
  Future<void> _onCutMarketItem(
      CutMarketItemEvent event,
      Emitter<MarketWatchState> emit,
      ) async {
    if (state is MarketWatchLoaded) {
      final currentState = state as MarketWatchLoaded;

      // Store item in clipboard with cut flag
      final newState = currentState.copyWith(
        clipboardItem: event.item,
        isClipboardCut: true,
      );

      // Emit success which contains the loaded state
      emit(MarketWatchSuccess(
        message: 'Item cut',
        previousState: newState,
      ));

      // Wait a moment for the listener to process, then emit loaded state
      await Future.delayed(const Duration(milliseconds: 100));
      emit(newState);
    }
  }

  /// Handle pasting a market item from clipboard
  Future<void> _onPasteMarketItem(
      PasteMarketItemEvent event,
      Emitter<MarketWatchState> emit,
      ) async {
    if (state is MarketWatchLoaded) {
      final currentState = state as MarketWatchLoaded;

      if (currentState.clipboardItem == null) {
        emit(const MarketWatchError(message: 'No item to paste'));
        return;
      }

      // Create new item with unique ID
      final newItem = currentState.clipboardItem!.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
      );

      // Add item using use case
      final result = await addMarketItem(AddMarketItemParams(item: newItem));

      // Handle failure case
      final failure = result.fold((l) => l, (r) => null);
      if (failure != null) {
        emit(MarketWatchError(message: failure.message));
        return;
      }

      // Handle success case
      final addedItem = result.fold((l) => null, (r) => r)!;
      final updatedItems = List<MarketItem>.from(currentState.items)..add(addedItem);

      // Apply current filters
      List<MarketItem> filteredItems = updatedItems;
      if (currentState.selectedExchange != null) {
        filteredItems = filteredItems
            .where((item) => item.exchange == currentState.selectedExchange)
            .toList();
      }
      if (currentState.selectedSymbol != null) {
        filteredItems = filteredItems
            .where((item) => item.symbol == currentState.selectedSymbol)
            .toList();
      }

      // Add to undo stack
      final newUndoStack = List<MarketWatchAction>.from(currentState.undoStack)
        ..add(MarketWatchAction(
          type: MarketWatchActionType.paste,
          item: addedItem,
        ));

      final newState = currentState.copyWith(
        items: updatedItems,
        filteredItems: filteredItems,
        clipboardItem: currentState.isClipboardCut ? null : currentState.clipboardItem,
        isClipboardCut: false,
        undoStack: newUndoStack,
        redoStack: [], // Clear redo stack on new action
        clearClipboard: currentState.isClipboardCut,
      );

      // Emit success which contains the loaded state
      emit(MarketWatchSuccess(
        message: 'Item pasted',
        previousState: newState,
      ));

      // Wait a moment for the listener to process, then emit loaded state
      await Future.delayed(const Duration(milliseconds: 100));
      emit(newState);
    }
  }

  /// Handle deleting a market item
  Future<void> _onDeleteMarketItem(
      DeleteMarketItemEvent event,
      Emitter<MarketWatchState> emit,
      ) async {
    if (state is MarketWatchLoaded) {
      final currentState = state as MarketWatchLoaded;

      // Find the item to delete
      final itemToDelete = currentState.items.firstWhere(
            (item) => item.id == event.itemId,
      );
      final itemIndex = currentState.items.indexOf(itemToDelete);

      // Delete using use case
      final result = await deleteMarketItem(
        DeleteMarketItemParams(id: event.itemId),
      );

      // Handle failure case
      final failure = result.fold((l) => l, (r) => null);
      if (failure != null) {
        emit(MarketWatchError(message: failure.message));
        return;
      }

      // Handle success case
      final updatedItems = List<MarketItem>.from(currentState.items)
        ..removeWhere((item) => item.id == event.itemId);

      // Apply current filters
      List<MarketItem> filteredItems = updatedItems;
      if (currentState.selectedExchange != null) {
        filteredItems = filteredItems
            .where((item) => item.exchange == currentState.selectedExchange)
            .toList();
      }
      if (currentState.selectedSymbol != null) {
        filteredItems = filteredItems
            .where((item) => item.symbol == currentState.selectedSymbol)
            .toList();
      }

      // Add to undo stack
      final newUndoStack = List<MarketWatchAction>.from(currentState.undoStack)
        ..add(MarketWatchAction(
          type: MarketWatchActionType.delete,
          item: itemToDelete,
          index: itemIndex,
        ));

      final newState = currentState.copyWith(
        items: updatedItems,
        filteredItems: filteredItems,
        undoStack: newUndoStack,
        redoStack: [], // Clear redo stack on new action
        clearSelectedItem: true,
      );

      // Emit success which contains the loaded state
      emit(MarketWatchSuccess(
        message: 'Item deleted',
        previousState: newState,
      ));

      // Wait a moment for the listener to process, then emit loaded state
      await Future.delayed(const Duration(milliseconds: 100));
      emit(newState);
    }
  }

  /// Handle undo action
  Future<void> _onUndoAction(
      UndoActionEvent event,
      Emitter<MarketWatchState> emit,
      ) async {
    if (state is MarketWatchLoaded) {
      final currentState = state as MarketWatchLoaded;

      if (currentState.undoStack.isEmpty) {
        emit(const MarketWatchError(message: 'No actions to undo'));
        return;
      }

      // Get last action from undo stack
      final lastAction = currentState.undoStack.last;
      final newUndoStack = List<MarketWatchAction>.from(currentState.undoStack)
        ..removeLast();

      // Reverse the action based on type
      List<MarketItem> updatedItems;
      switch (lastAction.type) {
        case MarketWatchActionType.add:
        case MarketWatchActionType.paste:
        // Remove the added item
          updatedItems = List<MarketItem>.from(currentState.items)
            ..removeWhere((item) => item.id == lastAction.item!.id);
          break;

        case MarketWatchActionType.delete:
        // Re-add the deleted item at its original position
          updatedItems = List<MarketItem>.from(currentState.items);
          if (lastAction.index != null && lastAction.index! <= updatedItems.length) {
            updatedItems.insert(lastAction.index!, lastAction.item!);
          } else {
            updatedItems.add(lastAction.item!);
          }
          break;
      }

      // Apply current filters
      List<MarketItem> filteredItems = updatedItems;
      if (currentState.selectedExchange != null) {
        filteredItems = filteredItems
            .where((item) => item.exchange == currentState.selectedExchange)
            .toList();
      }
      if (currentState.selectedSymbol != null) {
        filteredItems = filteredItems
            .where((item) => item.symbol == currentState.selectedSymbol)
            .toList();
      }

      // Add to redo stack
      final newRedoStack = List<MarketWatchAction>.from(currentState.redoStack)
        ..add(lastAction);

      final newState = currentState.copyWith(
        items: updatedItems,
        filteredItems: filteredItems,
        undoStack: newUndoStack,
        redoStack: newRedoStack,
      );

      // Emit success which contains the loaded state
      emit(MarketWatchSuccess(
        message: 'Action undone',
        previousState: newState,
      ));

      // Wait a moment for the listener to process, then emit loaded state
      await Future.delayed(const Duration(milliseconds: 100));
      emit(newState);
    }
  }

  /// Handle redo action
  Future<void> _onRedoAction(
      RedoActionEvent event,
      Emitter<MarketWatchState> emit,
      ) async {
    if (state is MarketWatchLoaded) {
      final currentState = state as MarketWatchLoaded;

      if (currentState.redoStack.isEmpty) {
        emit(const MarketWatchError(message: 'No actions to redo'));
        return;
      }

      // Get last action from redo stack
      final lastAction = currentState.redoStack.last;
      final newRedoStack = List<MarketWatchAction>.from(currentState.redoStack)
        ..removeLast();

      // Redo the action based on type
      List<MarketItem> updatedItems;
      switch (lastAction.type) {
        case MarketWatchActionType.add:
        case MarketWatchActionType.paste:
        // Re-add the item
          updatedItems = List<MarketItem>.from(currentState.items)
            ..add(lastAction.item!);
          break;

        case MarketWatchActionType.delete:
        // Remove the item again
          updatedItems = List<MarketItem>.from(currentState.items)
            ..removeWhere((item) => item.id == lastAction.item!.id);
          break;
      }

      // Apply current filters
      List<MarketItem> filteredItems = updatedItems;
      if (currentState.selectedExchange != null) {
        filteredItems = filteredItems
            .where((item) => item.exchange == currentState.selectedExchange)
            .toList();
      }
      if (currentState.selectedSymbol != null) {
        filteredItems = filteredItems
            .where((item) => item.symbol == currentState.selectedSymbol)
            .toList();
      }

      // Add back to undo stack
      final newUndoStack = List<MarketWatchAction>.from(currentState.undoStack)
        ..add(lastAction);

      final newState = currentState.copyWith(
        items: updatedItems,
        filteredItems: filteredItems,
        undoStack: newUndoStack,
        redoStack: newRedoStack,
      );

      // Emit success which contains the loaded state
      emit(MarketWatchSuccess(
        message: 'Action redone',
        previousState: newState,
      ));

      // Wait a moment for the listener to process, then emit loaded state
      await Future.delayed(const Duration(milliseconds: 100));
      emit(newState);
    }
  }

  /// Handle adding a market item
  Future<void> _onAddMarketItem(
      AddMarketItemEvent event,
      Emitter<MarketWatchState> emit,
      ) async {
    if (state is MarketWatchLoaded) {
      final currentState = state as MarketWatchLoaded;

      // Add item using use case
      final result = await addMarketItem(AddMarketItemParams(item: event.item));

      result.fold(
            (failure) => emit(MarketWatchError(message: failure.message)),
            (addedItem) {
          final updatedItems = List<MarketItem>.from(currentState.items)..add(addedItem);

          // Apply current filters
          List<MarketItem> filteredItems = updatedItems;
          if (currentState.selectedExchange != null) {
            filteredItems = filteredItems
                .where((item) => item.exchange == currentState.selectedExchange)
                .toList();
          }
          if (currentState.selectedSymbol != null) {
            filteredItems = filteredItems
                .where((item) => item.symbol == currentState.selectedSymbol)
                .toList();
          }

          // Add to undo stack
          final newUndoStack = List<MarketWatchAction>.from(currentState.undoStack)
            ..add(MarketWatchAction(
              type: MarketWatchActionType.add,
              item: addedItem,
            ));

          emit(currentState.copyWith(
            items: updatedItems,
            filteredItems: filteredItems,
            undoStack: newUndoStack,
            redoStack: [], // Clear redo stack on new action
          ));
        },
      );
    }
  }

  /// Handle clearing all filters
  void _onClearFilters(
      ClearFiltersEvent event,
      Emitter<MarketWatchState> emit,
      ) {
    if (state is MarketWatchLoaded) {
      final currentState = state as MarketWatchLoaded;
      emit(currentState.copyWith(
        filteredItems: currentState.items,
        clearExchange: true,
        clearSymbol: true,
      ));
    }
  }
}