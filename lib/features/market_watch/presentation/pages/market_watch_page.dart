import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../bloc/arrangesymbol/arrange_symbol_bloc.dart';
import '../bloc/arrangesymbol/arrange_symbol_event.dart';
import '../bloc/marketwatch/market_watch_bloc.dart';
import '../bloc/marketwatch/market_watch_event.dart';
import '../bloc/marketwatch/market_watch_state.dart';
import '../bloc/symbolfont/symbol_font_bloc.dart';
import '../bloc/symbolfont/symbol_font_event.dart';
import '../widgets/arrange_symbol_dialog.dart';
import '../widgets/ban_trade_info.dart';
import '../widgets/context_menu_widget.dart';
import '../widgets/table/market_data_table.dart';
import '../widgets/market_filtter.dart';
import '../widgets/market_watch_app_bar.dart';
import '../widgets/order/common_order_dialog.dart';
import '../widgets/symbo_info_dialog.dart';
import '../widgets/symbol_font_dialog.dart';
import '../widgets/market_depth_dialog.dart';
import '../widgets/watchlist_widget.dart';
import 'dummy/dashboard_page.dart';
import 'dummy/file_page.dart';
import 'dummy/report_page.dart';
import 'dummy/tools_page.dart';
import 'dummy/view_page.dart';

class MarketWatchPage extends StatefulWidget {
  const MarketWatchPage({Key? key}) : super(key: key);

  @override
  State<MarketWatchPage> createState() => _MarketWatchPageState();
}

class _MarketWatchPageState extends State<MarketWatchPage> {
  Offset? _contextMenuPosition;
  final _focusNode = FocusNode();
  int _selectedTabIndex = 0;
  int _selectedWatchlistIndex = -1;

  @override
  void initState() {
    super.initState();
    context.read<MarketWatchBloc>().add(const LoadMarketItemsEvent());
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedTabIndex = index;
      _contextMenuPosition = null;
    });
  }

  void _onWatchlistSelected(int index) {
    setState(() => _selectedWatchlistIndex = index);
  }

  void _closeContextMenu() {
    setState(() => _contextMenuPosition = null);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  void _onFitToSize() {
    // Reset font settings to default
    context.read<SymbolFontBloc>().add(const ResetFontSettingsEvent());
    // Reset column arrangement to default
    context.read<ArrangeSymbolBloc>().add(const ResetColumnsEvent());
    _showMessage('Reset to default size');
  }

  void _openBuyOrderDialog() {
    CommonOrderDialog.showBuyOrder(context);
  }

  void _openSellOrderDialog() {
    CommonOrderDialog.showSellOrder(context);
  }

  void _openMarketDepthDialog() {
    MarketDepthDialog.show(context);
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
            backgroundColor: AppColors.white,
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
        return Center(child: Text(AppStrings.unknownPage));
    }
  }

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

  Widget _buildMarketWatchBody(BuildContext context, MarketWatchState state) {
    if (state is MarketWatchInitial || state is MarketWatchLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is MarketWatchError) {
      return _buildErrorState(state);
    }

    final loadedState = _getLoadedState(state);

    return Stack(
      children: [
        Column(
          children: [
            MarketFilters(state: loadedState),
            Expanded(
              child: MarketDataTable(
                state: loadedState,
                onRightClick: (position) {
                  setState(() => _contextMenuPosition = position);
                },
              ),
            ),
            Container(height: 1.h, color: AppColors.greyBorder),
            WatchlistWidget(onWatchlistSelected: _onWatchlistSelected),
            const BanForTradeNotice(),
          ],
        ),
        if (_contextMenuPosition != null) _buildContextMenu(loadedState),
      ],
    );
  }

  Widget _buildErrorState(MarketWatchError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            state.message,
            style: TextStyle(
              fontSize: AppDimensions.fontSizeL.sp,
              color: AppColors.errorColor,
            ),
          ),
          SizedBox(height: AppDimensions.marginL.h),
          ElevatedButton(
            onPressed: () {
              context.read<MarketWatchBloc>().add(const LoadMarketItemsEvent());
            },
            child: const Text(AppStrings.retry),
          ),
        ],
      ),
    );
  }

  MarketWatchLoaded _getLoadedState(MarketWatchState state) {
    if (state is MarketWatchSuccess) return state.previousState;
    if (state is MarketWatchLoaded) return state;
    throw Exception('Unknown state');
  }

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
        color: AppColors.transparent,
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
                onBuyOrder: () {
                  _closeContextMenu();
                  _openBuyOrderDialog();
                },
                onSellOrder: () {
                  _closeContextMenu();
                  _openSellOrderDialog();
                },
                onMarketDepth: () {
                  _closeContextMenu();
                  _openMarketDepthDialog();
                },
                onViewChart: () {
                  _closeContextMenu();
                  _showMessage(AppStrings.viewChart);
                },
                onArrangeSymbol: () {
                  _closeContextMenu();
                  ArrangeSymbolDialog.show(context);
                },
                onSetSymbolFont: () {
                  _closeContextMenu();
                  SymbolFontDialog.show(context);
                },
                onFitToSize: () {
                  _closeContextMenu();
                  _onFitToSize();
                },
                onSymbolInfo: () {
                  _closeContextMenu();
                  SymbolInfoDialog.show(context, selectedItem);
                },
                onGrid: () {
                  _closeContextMenu();
                  context.read<MarketWatchBloc>().add(const ToggleGridEvent());
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

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    // Handle Escape key
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      if (_contextMenuPosition != null) _closeContextMenu();
      return;
    }

    // Handle F1 - Buy Order
    if (event.logicalKey == LogicalKeyboardKey.f1) {
      _openBuyOrderDialog();
      return;
    }

    // Handle F2 - Sell Order
    if (event.logicalKey == LogicalKeyboardKey.f2) {
      _openSellOrderDialog();
      return;
    }

    // Handle F5 - Market Depth
    if (event.logicalKey == LogicalKeyboardKey.f5) {
      _openMarketDepthDialog();
      return;
    }

    if (_selectedTabIndex != 0) return;

    final state = context.read<MarketWatchBloc>().state;
    final loadedState = state is MarketWatchSuccess
        ? state.previousState
        : (state is MarketWatchLoaded ? state : null);

    if (loadedState == null) return;

    final isCtrlPressed = HardwareKeyboard.instance.isControlPressed ||
        HardwareKeyboard.instance.isMetaPressed;

    final selectedItem = _getSelectedItem(loadedState);

    if (event.logicalKey == LogicalKeyboardKey.delete &&
        selectedItem != null &&
        !isCtrlPressed) {
      context.read<MarketWatchBloc>().add(
        DeleteMarketItemEvent(itemId: selectedItem.id),
      );
      return;
    }

    if (!isCtrlPressed) return;

    _handleCtrlShortcut(event, selectedItem);
  }

  dynamic _getSelectedItem(MarketWatchLoaded state) {
    if (state.selectedItemId == null) return null;

    try {
      return state.filteredItems.firstWhere(
            (item) => item.id == state.selectedItemId,
        orElse: () => state.filteredItems.isNotEmpty
            ? state.filteredItems.first
            : throw Exception('No items'),
      );
    } catch (_) {
      return null;
    }
  }

  void _handleCtrlShortcut(KeyEvent event, dynamic selectedItem) {
    final bloc = context.read<MarketWatchBloc>();

    switch (event.logicalKey) {
      case LogicalKeyboardKey.keyX:
        if (selectedItem != null) {
          bloc.add(CutMarketItemEvent(item: selectedItem));
        }
        break;
      case LogicalKeyboardKey.keyC:
        if (selectedItem != null) {
          bloc.add(CopyMarketItemEvent(item: selectedItem));
        }
        break;
      case LogicalKeyboardKey.keyV:
        bloc.add(const PasteMarketItemEvent());
        break;
      case LogicalKeyboardKey.keyZ:
        bloc.add(const UndoActionEvent());
        break;
      case LogicalKeyboardKey.keyY:
        bloc.add(const RedoActionEvent());
        break;
      case LogicalKeyboardKey.keyG:
        bloc.add(const ToggleGridEvent());
        break;
    }
  }
}