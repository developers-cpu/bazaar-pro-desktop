import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../bloc/market_watch_bloc.dart';
import '../bloc/market_watch_event.dart';
import '../bloc/market_watch_state.dart';
import '../widgets/context_menu_widget.dart';
import '../widgets/exchange_filter.dart';
import '../widgets/market_table_header.dart';
import '../widgets/market_table_row.dart';
import '../widgets/symbol_filter.dart';

/// Main page for market watch application
/// Displays table of market items with filtering and context menu operations
/// Implements keyboard shortcuts for cut, copy, paste, undo, redo
class MarketWatchPage extends StatefulWidget {
  const MarketWatchPage({Key? key}) : super(key: key);

  @override
  State<MarketWatchPage> createState() => _MarketWatchPageState();
}

class _MarketWatchPageState extends State<MarketWatchPage> {
  Offset? _contextMenuPosition;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Load market items when page initializes
    context.read<MarketWatchBloc>().add(const LoadMarketItemsEvent());

    // Request focus after build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
      print('Focus requested on init');
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      child: KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: _handleKeyEvent,
        child: GestureDetector(
          onTap: () {
            // Request focus when user taps anywhere
            _focusNode.requestFocus();
          },
          child: Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: _buildAppBar(),
            body: BlocConsumer<MarketWatchBloc, MarketWatchState>(
              listener: (context, state) {
                // Show success messages and transition back to loaded state
                if (state is MarketWatchSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      duration: const Duration(seconds: 2),
                      backgroundColor: AppColors.successColor,
                    ),
                  );
                }

                // Show error messages
                if (state is MarketWatchError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      duration: const Duration(seconds: 3),
                      backgroundColor: AppColors.errorColor,
                    ),
                  );
                  // Reload data after error
                  Future.delayed(const Duration(seconds: 3), () {
                    if (mounted) {
                      context.read<MarketWatchBloc>().add(const LoadMarketItemsEvent());
                    }
                  });
                }
              },
              builder: (context, state) {
                if (state is MarketWatchInitial || state is MarketWatchLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is MarketWatchError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.message,
                          style: const TextStyle(
                            fontSize: AppDimensions.fontSizeL,
                            color: AppColors.errorColor,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.marginL),
                        ElevatedButton(
                          onPressed: () {
                            context.read<MarketWatchBloc>().add(const LoadMarketItemsEvent());
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                // Handle both MarketWatchLoaded and MarketWatchSuccess states
                final MarketWatchLoaded loadedState;
                if (state is MarketWatchSuccess) {
                  loadedState = state.previousState;
                } else if (state is MarketWatchLoaded) {
                  loadedState = state;
                } else {
                  return const Center(child: Text('Unknown state'));
                }

                return Stack(
                  children: [
                    Column(
                      children: [
                        _buildFilters(loadedState),
                        const MarketTableHeader(),
                        Expanded(
                          child: _buildTableBody(loadedState),
                        ),
                      ],
                    ),
                    if (_contextMenuPosition != null)
                      _buildContextMenu(loadedState),
                  ],
                );
              },
            ),
          ), // Close Scaffold
        ), // Close GestureDetector
      ), // Close KeyboardListener
    ); // Close Focus
  }

  /// Build app bar with title and actions
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          const Text(
            AppStrings.appTitle,
            style: TextStyle(
              fontSize: AppDimensions.fontSizeXL,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 16),
          // Focus indicator - updates on rebuild
          AnimatedBuilder(
            animation: _focusNode,
            builder: (context, child) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _focusNode.hasFocus ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _focusNode.hasFocus ? 'FOCUSED' : 'NOT FOCUSED',
                  style: const TextStyle(fontSize: 10, color: Colors.white),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: AppColors.primaryBlue,
      elevation: 2,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          tooltip: 'Refresh',
          onPressed: () {
            context.read<MarketWatchBloc>().add(const LoadMarketItemsEvent());
          },
        ),
        IconButton(
          icon: const Icon(Icons.filter_alt_off),
          tooltip: 'Clear Filters',
          onPressed: () {
            context.read<MarketWatchBloc>().add(const ClearFiltersEvent());
          },
        ),
      ],
    );
  }

  /// Build filter row with exchange and symbol dropdowns
  Widget _buildFilters(MarketWatchLoaded state) {
    // Extract unique symbols from all items
    final availableSymbols = state.items.map((item) => item.symbol).toSet().toList();

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderColor,
            width: AppDimensions.borderWidthThin,
          ),
        ),
      ),
      child: Row(
        children: [
          ExchangeFilter(
            selectedExchange: state.selectedExchange,
            onChanged: (exchange) {
              context.read<MarketWatchBloc>().add(
                FilterByExchangeEvent(exchange: exchange),
              );
            },
          ),
          const SizedBox(width: AppDimensions.marginL),
          SymbolFilter(
            selectedSymbol: state.selectedSymbol,
            onChanged: (symbol) {
              context.read<MarketWatchBloc>().add(
                FilterBySymbolEvent(symbol: symbol),
              );
            },
            availableSymbols: availableSymbols,
          ),
        ],
      ),
    );
  }

  /// Build table body with scrollable list of rows
  Widget _buildTableBody(MarketWatchLoaded state) {
    if (state.filteredItems.isEmpty) {
      return const Center(
        child: Text(
          AppStrings.noDataAvailable,
          style: TextStyle(
            fontSize: AppDimensions.fontSizeL,
            color: AppColors.secondaryTextColor,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: state.filteredItems.length,
      itemBuilder: (context, index) {
        final item = state.filteredItems[index];
        final isSelected = state.selectedItemId == item.id;

        return MarketTableRow(
          item: item,
          isSelected: isSelected,
          index: index,
          onTap: () {
            context.read<MarketWatchBloc>().add(
              SelectMarketItemEvent(itemId: item.id),
            );
          },
          onRightClick: (position) {
            setState(() {
              _contextMenuPosition = position;
            });
            // Also select the item when right-clicked
            context.read<MarketWatchBloc>().add(
              SelectMarketItemEvent(itemId: item.id),
            );
          },
        );
      },
    );
  }

  /// Build context menu overlay
  Widget _buildContextMenu(MarketWatchLoaded state) {
    // Find selected item, or use first item if none selected
    final selectedItem = state.selectedItemId != null
        ? state.filteredItems.firstWhere(
          (item) => item.id == state.selectedItemId,
      orElse: () => state.filteredItems.first,
    )
        : state.filteredItems.first;

    return GestureDetector(
      onTap: () {
        _closeContextMenu();
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned(
              left: _contextMenuPosition!.dx,
              top: _contextMenuPosition!.dy,
              child: ContextMenuWidget(
                position: Offset.zero, // Position handled by Positioned
                canPaste: state.clipboardItem != null,
                canUndo: state.undoStack.isNotEmpty,
                canRedo: state.redoStack.isNotEmpty,
                onViewChart: () {
                  _closeContextMenu();
                  _showMessage('View Chart clicked');
                },
                onArrangeSymbol: () {
                  _closeContextMenu();
                  _showMessage('Arrange Symbol clicked');
                },
                onSetSymbolFont: () {
                  _closeContextMenu();
                  _showMessage('Set Symbol Font clicked');
                },
                onFitToSize: () {
                  _closeContextMenu();
                  _showMessage('Fit to Size clicked');
                },
                onSymbolInfo: () {
                  _closeContextMenu();
                  _showMessage('Symbol Info clicked');
                },
                onGrid: () {
                  _closeContextMenu();
                  _showMessage('Grid clicked');
                },
                onCut: () {
                  _closeContextMenu();
                  context.read<MarketWatchBloc>().add(
                    CutMarketItemEvent(item: selectedItem),
                  );
                },
                onCopy: () {
                  _closeContextMenu();
                  context.read<MarketWatchBloc>().add(
                    CopyMarketItemEvent(item: selectedItem),
                  );
                },
                onPaste: () {
                  _closeContextMenu();
                  context.read<MarketWatchBloc>().add(const PasteMarketItemEvent());
                },
                onUndo: () {
                  _closeContextMenu();
                  context.read<MarketWatchBloc>().add(const UndoActionEvent());
                },
                onRedo: () {
                  _closeContextMenu();
                  context.read<MarketWatchBloc>().add(const RedoActionEvent());
                },
                onDelete: () {
                  _closeContextMenu();
                  context.read<MarketWatchBloc>().add(
                    DeleteMarketItemEvent(itemId: selectedItem.id),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Handle keyboard shortcuts
  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    // Debug: Print key events
    print('Key pressed: ${event.logicalKey.keyLabel}');
    print('Control: ${HardwareKeyboard.instance.isControlPressed}');
    print('Meta (Command): ${HardwareKeyboard.instance.isMetaPressed}');

    // Handle Escape key to close context menu
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      if (_contextMenuPosition != null) {
        _closeContextMenu();
      }
      return;
    }

    final state = context.read<MarketWatchBloc>().state;
    print('Current state: ${state.runtimeType}');

    // Handle MarketWatchSuccess state
    final MarketWatchLoaded? loadedState;
    if (state is MarketWatchSuccess) {
      loadedState = state.previousState;
    } else if (state is MarketWatchLoaded) {
      loadedState = state;
    } else {
      print('State is not loaded, returning');
      return;
    }

    final isControlPressed = HardwareKeyboard.instance.isControlPressed ||
        HardwareKeyboard.instance.isMetaPressed;

    final selectedItem = loadedState!.selectedItemId != null
        ? loadedState.filteredItems.firstWhere(
          (item) => item.id == loadedState?.selectedItemId,
      orElse: () => loadedState!.filteredItems.isNotEmpty
          ? loadedState.filteredItems.first
          : throw Exception('No items available'),
    )
        : null;

    print('Selected item: ${selectedItem?.id}');
    print('Is control/command pressed: $isControlPressed');

    // Handle Delete key (without Ctrl/Command)
    if (event.logicalKey == LogicalKeyboardKey.delete &&
        selectedItem != null &&
        !isControlPressed) {
      print('Deleting item: ${selectedItem.id}');
      context.read<MarketWatchBloc>().add(DeleteMarketItemEvent(itemId: selectedItem.id));
      return;
    }

    // Only process Ctrl+Key or Command+Key combinations below this point
    if (!isControlPressed) return;

    // Handle Ctrl/Command+X (Cut)
    if (event.logicalKey == LogicalKeyboardKey.keyX && selectedItem != null) {
      print('Cutting item: ${selectedItem.id}');
      context.read<MarketWatchBloc>().add(CutMarketItemEvent(item: selectedItem));
    }

    // Handle Ctrl/Command+C (Copy)
    else if (event.logicalKey == LogicalKeyboardKey.keyC && selectedItem != null) {
      print('Copying item: ${selectedItem.id}');
      context.read<MarketWatchBloc>().add(CopyMarketItemEvent(item: selectedItem));
    }

    // Handle Ctrl/Command+V (Paste)
    else if (event.logicalKey == LogicalKeyboardKey.keyV) {
      print('Pasting item');
      context.read<MarketWatchBloc>().add(const PasteMarketItemEvent());
    }

    // Handle Ctrl/Command+Z (Undo)
    else if (event.logicalKey == LogicalKeyboardKey.keyZ) {
      print('Undoing action');
      context.read<MarketWatchBloc>().add(const UndoActionEvent());
    }

    // Handle Ctrl/Command+Y (Redo)
    else if (event.logicalKey == LogicalKeyboardKey.keyY) {
      print('Redoing action');
      context.read<MarketWatchBloc>().add(const RedoActionEvent());
    }
  }

  /// Close context menu
  void _closeContextMenu() {
    setState(() {
      _contextMenuPosition = null;
    });
  }

  /// Show info message
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}