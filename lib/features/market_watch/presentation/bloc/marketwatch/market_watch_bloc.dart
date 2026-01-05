import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/market_item.dart';
import '../../../domain/usecases/add_market_item.dart';
import '../../../domain/usecases/delete_market_item.dart';
import '../../../domain/usecases/get_market_items.dart';
import 'market_watch_event.dart';
import 'market_watch_state.dart';

/// BLoC for managing market watch state and business logic
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


    final result = await getMarketItems(NoParams());

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

      List<MarketItem> filtered = currentState.items;

      if (event.symbol != null && event.symbol!.isNotEmpty) {
        filtered = filtered
            .where((item) => item.symbol == event.symbol)
            .toList();
      }

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

  void _onSelectMarketItem(
      SelectMarketItemEvent event,
      Emitter<MarketWatchState> emit,
      ) {
    if (state is MarketWatchLoaded) {
      final currentState = state as MarketWatchLoaded;
      emit(currentState.copyWith(selectedItemId: event.itemId));
    }
  }

  Future<void> _onCopyMarketItem(
      CopyMarketItemEvent event,
      Emitter<MarketWatchState> emit,
      ) async {
    if (state is MarketWatchLoaded) {
      final currentState = state as MarketWatchLoaded;


      final newState = currentState.copyWith(
        clipboardItem: event.item,
        isClipboardCut: false,
      );

      emit(MarketWatchSuccess(
        message: AppStrings.itemCopied,
        previousState: newState,
      ));

      await Future.delayed(const Duration(milliseconds: 100));
      emit(newState);
    }
  }


  Future<void> _onCutMarketItem(
      CutMarketItemEvent event,
      Emitter<MarketWatchState> emit,
      ) async {
    if (state is MarketWatchLoaded) {
      final currentState = state as MarketWatchLoaded;

      final newState = currentState.copyWith(
        clipboardItem: event.item,
        isClipboardCut: true,
      );

      emit(MarketWatchSuccess(
        message: AppStrings.itemCut,
        previousState: newState,
      ));

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
      final updatedItems = List<MarketItem>.from(currentState.items)
        ..add(addedItem);

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

      final newUndoStack = List<MarketWatchAction>.from(currentState.undoStack)
        ..add(MarketWatchAction(
          type: MarketWatchActionType.paste,
          item: addedItem,
        ));

      final newState = currentState.copyWith(
        items: updatedItems,
        filteredItems: filteredItems,
        clipboardItem:
        currentState.isClipboardCut ? null : currentState.clipboardItem,
        isClipboardCut: false,
        undoStack: newUndoStack,
        redoStack: [],
        clearClipboard: currentState.isClipboardCut,
      );

      emit(MarketWatchSuccess(
        message: AppStrings.itemPasted,
        previousState: newState,
      ));

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

      final updatedItems = List<MarketItem>.from(currentState.items)
        ..removeWhere((item) => item.id == event.itemId);

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
        redoStack: [],
        clearSelectedItem: true,
      );

      emit(MarketWatchSuccess(
        message: AppStrings.itemDeleted,
        previousState: newState,
      ));

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
        emit(const MarketWatchError(message: AppStrings.noActionsToUndo));
        return;
      }


      final lastAction = currentState.undoStack.last;
      final newUndoStack = List<MarketWatchAction>.from(currentState.undoStack)
        ..removeLast();

      List<MarketItem> updatedItems;
      switch (lastAction.type) {
        case MarketWatchActionType.add:
        case MarketWatchActionType.paste:
          updatedItems = List<MarketItem>.from(currentState.items)
            ..removeWhere((item) => item.id == lastAction.item!.id);
          break;

        case MarketWatchActionType.delete:
          updatedItems = List<MarketItem>.from(currentState.items);
          if (lastAction.index != null &&
              lastAction.index! <= updatedItems.length) {
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

      final newRedoStack = List<MarketWatchAction>.from(currentState.redoStack)
        ..add(lastAction);

      final newState = currentState.copyWith(
        items: updatedItems,
        filteredItems: filteredItems,
        undoStack: newUndoStack,
        redoStack: newRedoStack,
      );

      emit(MarketWatchSuccess(
        message: AppStrings.actionUndone,
        previousState: newState,
      ));

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
        emit(const MarketWatchError(message: AppStrings.noActionsToRedo));
        return;
      }

      final lastAction = currentState.redoStack.last;
      final newRedoStack = List<MarketWatchAction>.from(currentState.redoStack)
        ..removeLast();

      List<MarketItem> updatedItems;
      switch (lastAction.type) {
        case MarketWatchActionType.add:
        case MarketWatchActionType.paste:
          updatedItems = List<MarketItem>.from(currentState.items)
            ..add(lastAction.item!);
          break;

        case MarketWatchActionType.delete:
          updatedItems = List<MarketItem>.from(currentState.items)
            ..removeWhere((item) => item.id == lastAction.item!.id);
          break;
      }

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

      final newUndoStack = List<MarketWatchAction>.from(currentState.undoStack)
        ..add(lastAction);

      final newState = currentState.copyWith(
        items: updatedItems,
        filteredItems: filteredItems,
        undoStack: newUndoStack,
        redoStack: newRedoStack,
      );

      emit(MarketWatchSuccess(
        message: AppStrings.actionRedone,
        previousState: newState,
      ));
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
          final updatedItems = List<MarketItem>.from(currentState.items)
            ..add(addedItem);

          // Apply current filters
          List<MarketItem> filteredItems = updatedItems;
          if (currentState.selectedExchange != null) {
            filteredItems = filteredItems
                .where(
                    (item) => item.exchange == currentState.selectedExchange)
                .toList();
          }
          if (currentState.selectedSymbol != null) {
            filteredItems = filteredItems
                .where((item) => item.symbol == currentState.selectedSymbol)
                .toList();
          }

          // Add to undo stack
          final newUndoStack =
          List<MarketWatchAction>.from(currentState.undoStack)
            ..add(MarketWatchAction(
              type: MarketWatchActionType.add,
              item: addedItem,
            ));

          emit(currentState.copyWith(
            items: updatedItems,
            filteredItems: filteredItems,
            undoStack: newUndoStack,
            redoStack: [],
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