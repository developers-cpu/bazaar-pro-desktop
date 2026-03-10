import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../../core/widget/app_bar_section.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart';
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
import '../widgets/order/common_order_dialog.dart';
import '../widgets/symbo_info_dialog.dart';
import '../widgets/symbol_font_dialog.dart';
import '../widgets/market_depth_dialog.dart';
import '../widgets/watchlist_widget.dart';
import '../../../tools/presentation/widgets/messages/messages_dialog.dart';
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
  final Map<String, int> _expandedRowCounts = {};
  final GlobalKey<AppBarSectionState> _appBarKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    context.read<MarketWatchBloc>().add(const LoadMarketItemsEvent());
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _focusNode.requestFocus(),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    final hasDropdown = _appBarKey.currentState?.hasDropdown(index) ?? false;
    if (!hasDropdown) {
      setState(() {
        _selectedTabIndex = index;
        _contextMenuPosition = null;
      });
    }
  }

  void _onReload() {
    context.read<MarketWatchBloc>().add(const LoadMarketItemsEvent());
  }

  void _onExportPdf() {
    _showMessage('Exporting to PDF...');
  }

  void _onExportExcel() {
    _showMessage('Exporting to Excel...');
  }

  void _handleViewAction(String action) {
    _showMessage('View: $action');
  }

  void _handleUserAction(String action) {
    _showMessage('User: $action');
  }

  void _handleReportAction(String action) {
    _showMessage('Report: $action');
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
    context.read<SymbolFontBloc>().add(const ResetFontSettingsEvent());
    context.read<ArrangeSymbolBloc>().add(const ResetColumnsEvent());
    _showMessage('Reset to default size');
  }

  void _openBuyOrderDialog() => CommonOrderDialog.showBuyOrder(context);
  void _openSellOrderDialog() => CommonOrderDialog.showSellOrder(context);
  void _openMarketDepthDialog() => MarketDepthDialog.show(context);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String? userRole;
        if (state is AuthAuthenticated) {
          userRole = state.user.role;
        }
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
                appBar: AppBarSection(
                  key: _appBarKey,
                  selectedTabIndex: _selectedTabIndex,
                  userRole: userRole,
                  onTabSelected: _onTabSelected,
                  onReload: _onReload,
                  onExportPdf: _onExportPdf,
                  onExportExcel: _onExportExcel,
                  onViewAction: _handleViewAction,
                  onUserAction: _handleUserAction,
                  onReportAction: _handleReportAction,
                  showExportByDefault: false,
                ),
                body: _buildBodyContent(userRole),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBodyContent(String? userRole) {
    switch (_selectedTabIndex) {
      case 0:
        return BlocConsumer<MarketWatchBloc, MarketWatchState>(
          listener: _handleStateChange,
          builder: (context, state) =>
              _buildMarketWatchBody(context, state, userRole),
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

  Widget _buildMarketWatchBody(
    BuildContext context,
    MarketWatchState state,
    String? userRole,
  ) {
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
            MarketFilters(state: loadedState, userRole: userRole),
            Expanded(
              child: MarketDataTable(
                state: loadedState,
                expandedRowCounts: _expandedRowCounts,
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
    final screenSize = MediaQuery.of(context).size;
    const menuWidth = 160.0;
    const menuHeight = 480.0;
    final clampedX = _contextMenuPosition!.dx.clamp(
      10.0,
      screenSize.width - menuWidth - 10,
    );
    final clampedY = _contextMenuPosition!.dy.clamp(
      10.0,
      screenSize.height - menuHeight - 10,
    );
    return GestureDetector(
      onTap: _closeContextMenu,
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: AppColors.transparent,
        child: Stack(
          children: [
            Positioned(
              left: clampedX,
              top: clampedY,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _contextMenuPosition = Offset(
                      _contextMenuPosition!.dx + details.delta.dx,
                      _contextMenuPosition!.dy + details.delta.dy,
                    );
                  });
                },
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
                    context.read<MarketWatchBloc>().add(
                      const ToggleGridEvent(),
                    );
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
                    context.read<MarketWatchBloc>().add(
                      const PasteMarketItemEvent(),
                    );
                  },
                  onUndo: () {
                    _closeContextMenu();
                    context.read<MarketWatchBloc>().add(
                      const UndoActionEvent(),
                    );
                  },
                  onRedo: () {
                    _closeContextMenu();
                    context.read<MarketWatchBloc>().add(
                      const RedoActionEvent(),
                    );
                  },
                  onDelete: () {
                    _closeContextMenu();
                    context.read<MarketWatchBloc>().add(
                      DeleteMarketItemEvent(itemId: selectedItem.id),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      if (_contextMenuPosition != null) _closeContextMenu();
      return;
    }
    if (event.logicalKey == LogicalKeyboardKey.f1) {
      _openBuyOrderDialog();
      return;
    }
    if (event.logicalKey == LogicalKeyboardKey.f2) {
      _openSellOrderDialog();
      return;
    }
    if (event.logicalKey == LogicalKeyboardKey.f3) {
      Navigator.of(context).pushReplacementNamed('/pending_order-orders');
      return;
    }
    if (event.logicalKey == LogicalKeyboardKey.f5) {
      _openMarketDepthDialog();
      return;
    }
    if (event.logicalKey == LogicalKeyboardKey.f6) {
      Navigator.of(context).pushReplacementNamed('/net-position');
      return;
    }
    if (event.logicalKey == LogicalKeyboardKey.f8) {
      Navigator.of(context).pushReplacementNamed('/trades');
      return;
    }
    if (event.logicalKey == LogicalKeyboardKey.f9) {
      Navigator.of(context).pushReplacementNamed('/deals');
      return;
    }
    if (event.logicalKey == LogicalKeyboardKey.f10) {
      MessagesDialog.show(context);
      return;
    }
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter) {
      if (_selectedTabIndex == 0) {
        final state = context.read<MarketWatchBloc>().state;
        final loadedState = state is MarketWatchSuccess
            ? state.previousState
            : (state is MarketWatchLoaded ? state : null);
        if (loadedState != null && loadedState.selectedItemId != null) {
          setState(() {
            final id = loadedState.selectedItemId!;
            _expandedRowCounts[id] = (_expandedRowCounts[id] ?? 0) + 1;
          });
        }
      }
      return;
    }
    if (_selectedTabIndex != 0) return;
    final state = context.read<MarketWatchBloc>().state;
    final loadedState = state is MarketWatchSuccess
        ? state.previousState
        : (state is MarketWatchLoaded ? state : null);
    if (loadedState == null) return;
    final isMac = defaultTargetPlatform == TargetPlatform.macOS;
    final isCtrlPressed = isMac
        ? HardwareKeyboard.instance.isMetaPressed
        : HardwareKeyboard.instance.isControlPressed;
    final selectedItem = _getSelectedItem(loadedState);

    if ((event.logicalKey == LogicalKeyboardKey.delete ||
            event.logicalKey == LogicalKeyboardKey.backspace) &&
        selectedItem != null &&
        !isCtrlPressed) {
      final id = selectedItem.id as String;
      final currentCount = _expandedRowCounts[id] ?? 0;
      if (currentCount > 0) {
        setState(() {
          if (currentCount <= 1) {
            _expandedRowCounts.remove(id);
          } else {
            _expandedRowCounts[id] = currentCount - 1;
          }
        });
        return;
      }

      context.read<MarketWatchBloc>().add(DeleteMarketItemEvent(itemId: id));
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
    if (event.logicalKey.keyLabel.isEmpty) return;
    final bloc = context.read<MarketWatchBloc>();
    final keyLabel = event.logicalKey.keyLabel.toLowerCase();
    switch (keyLabel) {
      case 'x':
        if (selectedItem != null) {
          bloc.add(CutMarketItemEvent(item: selectedItem));
        }
        break;
      case 'c':
        if (selectedItem != null) {
          bloc.add(CopyMarketItemEvent(item: selectedItem));
        }
        break;
      case 'v':
        bloc.add(const PasteMarketItemEvent());
        break;
      case 'z':
        bloc.add(const UndoActionEvent());
        break;
      case 'y':
        bloc.add(const RedoActionEvent());
        break;
      case 'g':
        bloc.add(const ToggleGridEvent());
        break;
    }
  }
}
