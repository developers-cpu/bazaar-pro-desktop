import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../bloc/market_watch_bloc.dart';
import '../bloc/market_watch_event.dart';
import '../bloc/market_watch_state.dart';
import '../widgets/context_menu_widget.dart';
import '../widgets/market_filtter.dart';
import '../widgets/market_table.dart';
import '../widgets/market_watch_app_bar.dart';
import 'dummy/dashboard_page.dart';
import 'dummy/file_page.dart';
import 'dummy/report_page.dart';
import 'dummy/tools_page.dart';
import 'dummy/view_page.dart';

/// Main page for market watch application
/// Displays table of market items with filtering and context menu operations
class MarketWatchPage extends StatefulWidget {
  const MarketWatchPage({Key? key}) : super(key: key);

  @override
  State<MarketWatchPage> createState() => _MarketWatchPageState();
}

class _MarketWatchPageState extends State<MarketWatchPage> {
  Offset? _contextMenuPosition;
  final FocusNode _focusNode = FocusNode();

  // Current selected tab index
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<MarketWatchBloc>().add(const LoadMarketItemsEvent());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  /// Handle tab selection from AppBar
  void _onTabSelected(int index) {
    setState(() {
      _selectedTabIndex = index;
      _contextMenuPosition = null;
    });
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
          onTap: () => _focusNode.requestFocus(),
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: MarketWatchAppBar(
              selectedIndex: _selectedTabIndex,
              onTabSelected: _onTabSelected,
            ),
            body: _buildBodyContent(),
          ),
        ),
      ),
    );
  }

  /// Build body content based on selected tab
  Widget _buildBodyContent() {
    switch (_selectedTabIndex) {
      case 0:
        return BlocConsumer<MarketWatchBloc, MarketWatchState>(
          listener: _handleStateChange,
          builder: _buildMarketWatchBody,
        );
      case 1:
        return const DashboardPage();
      case 2:
        return const FilePage();
      case 3:
        return const ViewPage();
      case 4:
        return const ReportPage();
      case 5:
        return const ToolsPage();
      default:
        return const Center(child: Text('Unknown Page'));
    }
  }

  /// Handle state changes for success and error messages
  void _handleStateChange(BuildContext context, MarketWatchState state) {
    if (state is MarketWatchSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          duration: const Duration(seconds: 2),
          backgroundColor: AppColors.successColor,
        ),
      );
    }

    if (state is MarketWatchError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          duration: const Duration(seconds: 3),
          backgroundColor: AppColors.errorColor,
        ),
      );
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          context.read<MarketWatchBloc>().add(const LoadMarketItemsEvent());
        }
      });
    }
  }

  /// Build Market Watch body based on current state
  Widget _buildMarketWatchBody(BuildContext context, MarketWatchState state) {
    if (state is MarketWatchInitial || state is MarketWatchLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is MarketWatchError) {
      return _buildErrorState(state);
    }

    final MarketWatchLoaded loadedState = _getLoadedState(state);

    return Stack(
      children: [
        Column(
          children: [
            // Filter Section
            MarketFilters(state: loadedState),

            // Data Table using data_table_2 package
            Expanded(
              child: MarketDataTable(
                state: loadedState,
                onRightClick: (position) {
                  setState(() => _contextMenuPosition = position);
                },
              ),
            ),
          ],
        ),
        if (_contextMenuPosition != null) _buildContextMenu(loadedState),
      ],
    );
  }

  /// Build error state with retry button
  Widget _buildErrorState(MarketWatchError state) {
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

  /// Get loaded state from current state
  MarketWatchLoaded _getLoadedState(MarketWatchState state) {
    if (state is MarketWatchSuccess) {
      return state.previousState;
    } else if (state is MarketWatchLoaded) {
      return state;
    }
    throw Exception('Unknown state');
  }

  /// Build context menu overlay
  Widget _buildContextMenu(MarketWatchLoaded state) {
    final selectedItem = state.selectedItemId != null
        ? state.filteredItems.firstWhere(
          (item) => item.id == state.selectedItemId,
      orElse: () => state.filteredItems.first,
    )
        : state.filteredItems.first;

    return GestureDetector(
      onTap: _closeContextMenu,
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned(
              left: _contextMenuPosition!.dx,
              top: _contextMenuPosition!.dy,
              child: ContextMenuWidget(
                position: Offset.zero,
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
                  context
                      .read<MarketWatchBloc>()
                      .add(const PasteMarketItemEvent());
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

    if (event.logicalKey == LogicalKeyboardKey.escape) {
      if (_contextMenuPosition != null) {
        _closeContextMenu();
      }
      return;
    }

    if (_selectedTabIndex != 0) return;

    final state = context.read<MarketWatchBloc>().state;
    final MarketWatchLoaded? loadedState = state is MarketWatchSuccess
        ? state.previousState
        : (state is MarketWatchLoaded ? state : null);

    if (loadedState == null) return;

    final isControlPressed = HardwareKeyboard.instance.isControlPressed ||
        HardwareKeyboard.instance.isMetaPressed;

    final selectedItem = _getSelectedItem(loadedState);

    if (event.logicalKey == LogicalKeyboardKey.delete &&
        selectedItem != null &&
        !isControlPressed) {
      context.read<MarketWatchBloc>().add(
        DeleteMarketItemEvent(itemId: selectedItem.id),
      );
      return;
    }

    if (!isControlPressed) return;

    _handleControlKeyPress(event, selectedItem);
  }

  /// Get currently selected item
  dynamic _getSelectedItem(MarketWatchLoaded loadedState) {
    if (loadedState.selectedItemId == null) return null;

    try {
      return loadedState.filteredItems.firstWhere(
            (item) => item.id == loadedState.selectedItemId,
        orElse: () => loadedState.filteredItems.isNotEmpty
            ? loadedState.filteredItems.first
            : throw Exception('No items available'),
      );
    } catch (e) {
      return null;
    }
  }

  /// Handle control key press shortcuts
  void _handleControlKeyPress(KeyEvent event, dynamic selectedItem) {
    if (event.logicalKey == LogicalKeyboardKey.keyX && selectedItem != null) {
      context
          .read<MarketWatchBloc>()
          .add(CutMarketItemEvent(item: selectedItem));
    } else if (event.logicalKey == LogicalKeyboardKey.keyC &&
        selectedItem != null) {
      context
          .read<MarketWatchBloc>()
          .add(CopyMarketItemEvent(item: selectedItem));
    } else if (event.logicalKey == LogicalKeyboardKey.keyV) {
      context.read<MarketWatchBloc>().add(const PasteMarketItemEvent());
    } else if (event.logicalKey == LogicalKeyboardKey.keyZ) {
      context.read<MarketWatchBloc>().add(const UndoActionEvent());
    } else if (event.logicalKey == LogicalKeyboardKey.keyY) {
      context.read<MarketWatchBloc>().add(const RedoActionEvent());
    }
  }

  void _closeContextMenu() {
    setState(() => _contextMenuPosition = null);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}