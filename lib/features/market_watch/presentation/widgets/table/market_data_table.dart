import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../domain/entities/market_item.dart';
import '../../bloc/arrangesymbol/arrange_symbol_bloc.dart';
import '../../bloc/arrangesymbol/arrange_symbol_event.dart';
import '../../bloc/arrangesymbol/arrange_symbol_state.dart';
import '../../bloc/marketwatch/market_watch_bloc.dart';
import '../../bloc/marketwatch/market_watch_event.dart';
import '../../bloc/marketwatch/market_watch_state.dart';
import '../../bloc/symbolfont/symbol_font_bloc.dart';
import '../../bloc/symbolfont/symbol_state.dart';
import '../../bloc/theme/theme_bloc.dart';
import '../../bloc/theme/theme_state.dart' show ThemeState;
import 'table_cell_builder.dart';
import 'table_column_helper.dart';
import 'table_header_cell.dart';
import 'table_text_style_helper.dart';

class MarketDataTable extends StatefulWidget {
  final MarketWatchLoaded state;
  final Function(Offset) onRightClick;
  const MarketDataTable({
    Key? key,
    required this.state,
    required this.onRightClick,
  }) : super(key: key);
  @override
  State<MarketDataTable> createState() => _MarketDataTableState();
}

class _MarketDataTableState extends State<MarketDataTable> {
  int? _sortColumnIndex;
  bool _sortAscending = true;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<ArrangeSymbolBloc, ArrangeSymbolState>(
          builder: (context, arrangeState) {
            return BlocBuilder<SymbolFontBloc, SymbolFontState>(
              builder: (context, fontState) {
                final isDark = themeState.isDarkMode;
                final showGrid = widget.state.showGrid;
                var visibleColumns = arrangeState.columns.isEmpty
                    ? TableColumnHelper.getDefaultColumns()
                    : arrangeState.columns
                          .where((c) => c.isVisible && c.id != 'arrow')
                          .toList();
                if (visibleColumns.isEmpty) {
                  visibleColumns = TableColumnHelper.getDefaultColumns();
                }
                final fontFamily = fontState.selectedFontFamily.isNotEmpty
                    ? fontState.selectedFontFamily
                    : 'Open Sans';
                final fontSize = fontState.selectedFontSize > 0
                    ? fontState.selectedFontSize.toDouble()
                    : 13.0;
                final fontWeight = TableTextStyleHelper.getFontWeight(
                  fontState.selectedFontStyle,
                );
                if (widget.state.filteredItems.isEmpty) {
                  return _buildEmptyState(isDark);
                }
                return _buildTableContainer(
                  isDark: isDark,
                  showGrid: showGrid,
                  visibleColumns: visibleColumns,
                  fontFamily: fontFamily,
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Container(
      color: isDark
          ? DarkThemeColors.backgroundColor
          : LightThemeColors.backgroundColor,
      child: Center(
        child: Text(
          AppStrings.noDataAvailable,
          style: GoogleFonts.openSans(
            fontSize: 16.sp,
            color: isDark
                ? DarkThemeColors.supportiveTextColor
                : LightThemeColors.supportiveTextColor,
          ),
        ),
      ),
    );
  }

  Widget _buildTableContainer({
    required bool isDark,
    required bool showGrid,
    required List<ColumnItem> visibleColumns,
    required String fontFamily,
    required double fontSize,
    required FontWeight fontWeight,
  }) {
    final minWidth = TableColumnHelper.calculateMinWidth(
      visibleColumns,
      fontSize,
    );
    return Container(
      margin: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: isDark
            ? DarkThemeColors.backgroundColor
            : LightThemeColors.backgroundColor,
        border: showGrid
            ? Border.all(
                color: isDark
                    ? DarkThemeColors.dividerColor
                    : LightThemeColors.dividerColor,
                width: 1,
              )
            : null,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: _buildDataTable(
          isDark: isDark,
          showGrid: showGrid,
          visibleColumns: visibleColumns,
          fontFamily: fontFamily,
          fontSize: fontSize,
          fontWeight: fontWeight,
          minWidth: minWidth,
        ),
      ),
    );
  }

  Widget _buildDataTable({
    required bool isDark,
    required bool showGrid,
    required List<ColumnItem> visibleColumns,
    required String fontFamily,
    required double fontSize,
    required FontWeight fontWeight,
    required double minWidth,
  }) {
    final rowHeight = (fontSize * 1.8).clamp(28.0, 40.0);
    final headerHeight = (fontSize * 2.8).clamp(40.0, 60.0);
    return DataTable2(
      key: ValueKey(visibleColumns.map((c) => c.id).join('-')),
      columnSpacing: 0,
      horizontalMargin: 0,
      minWidth: minWidth,
      headingRowHeight: headerHeight.h,
      dataRowHeight: rowHeight.h,
      headingRowColor: WidgetStateProperty.all(
        LightThemeColors.tableColumnHeadColor,
      ),
      dividerThickness: showGrid ? 1 : 0,
      border: showGrid
          ? TableBorder.all(
              color: isDark ? AppColors.white : AppColors.black,
              width: 1,
            )
          : const TableBorder(),
      columns: _buildColumns(
        visibleColumns: visibleColumns,
        isDark: isDark,
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      rows: _buildRows(
        visibleColumns: visibleColumns,
        isDark: isDark,
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }

  List<DataColumn2> _buildColumns({
    required List<ColumnItem> visibleColumns,
    required bool isDark,
    required String fontFamily,
    required double fontSize,
    required FontWeight fontWeight,
  }) {
    return visibleColumns.asMap().entries.map((entry) {
      final index = entry.key;
      final column = entry.value;
      final label = TableColumnHelper.getLabel(column.id);
      final config = TableColumnHelper.getConfig(column.id);

      final isLut = column.id == 'lut';
      final baseWidth = config?.baseWidth ?? 100;
      ColumnSize size = ColumnSize.M;
      if (baseWidth >= 150) {
        size = ColumnSize.L;
      } else if (baseWidth <= 100) {
        size = ColumnSize.S;
      }

      return DataColumn2(
        label: TableHeaderCell(
          title: label,
          columnId: column.id,
          isDark: isDark,
          fontFamily: fontFamily,
          fontSize: fontSize,
          fontWeight: fontWeight,
          isLast: index == visibleColumns.length - 1,
          onColumnReorder: (fromId, toId) {
            _onColumnReorder(fromId, toId, visibleColumns);
          },
        ),
        fixedWidth: isLut ? config?.getWidth(fontSize) : null,
        size: size,
        numeric: config?.isNumeric ?? false,
        onSort: _onSort,
        isResizable: true,
        minWidth: config?.minWidth ?? 60,
      );
    }).toList();
  }

  void _onColumnReorder(
    String fromColumnId,
    String toColumnId,
    List<ColumnItem> visibleColumns,
  ) {
    if (fromColumnId == toColumnId) return;
    final bloc = context.read<ArrangeSymbolBloc>();
    if (bloc.state.columns.isEmpty) {
      bloc.add(const LoadColumnsEvent());
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _performReorder(fromColumnId, toColumnId);
      });
    } else {
      _performReorder(fromColumnId, toColumnId);
    }
  }

  void _performReorder(String fromColumnId, String toColumnId) {
    final bloc = context.read<ArrangeSymbolBloc>();
    final allColumns = bloc.state.columns;
    if (allColumns.isEmpty) return;
    final oldIndex = allColumns.indexWhere((c) => c.id == fromColumnId);
    final newIndex = allColumns.indexWhere((c) => c.id == toColumnId);
    if (oldIndex == -1 || newIndex == -1 || oldIndex == newIndex) return;
    bloc.add(
      ReorderColumnEvent(
        oldIndex: oldIndex,
        newIndex: newIndex > oldIndex ? newIndex + 1 : newIndex,
      ),
    );
    bloc.add(const SaveColumnsEvent());
  }

  void _onSort(int columnIndex, bool ascending) {
    setState(() {
      if (_sortColumnIndex == columnIndex) {
        _sortAscending = !_sortAscending;
      } else {
        _sortColumnIndex = columnIndex;
        _sortAscending = true;
      }
    });
  }

  Comparable? _getColumnValue(MarketItem item, String columnId) {
    switch (columnId) {
      case 'exchange':
        return item.exchange.toLowerCase();
      case 'symbol':
        return item.symbol.toLowerCase();
      case 'buyQty':
        return item.buyQty;
      case 'buyPrice':
        return item.buyPrice;
      case 'sellPrice':
        return item.sellPrice;
      case 'sellQty':
        return item.sellQty;
      case 'netChange':
        return item.netChange;
      case 'high':
        return item.high;
      case 'low':
        return item.low;
      case 'open':
        return item.open;
      case 'close':
        return item.close;
      case 'ltp':
        return item.ltp;
      case 'netChangePercent':
        return item.netChangePercent;
      case 'expiry':
        return item.expiry?.millisecondsSinceEpoch ?? 0;
      case 'lut':
        return item.lut.millisecondsSinceEpoch;
      default:
        return null;
    }
  }

  List<MarketItem> _getSortedItems({required List<ColumnItem> visibleColumns}) {
    final items = List<MarketItem>.from(widget.state.filteredItems);
    if (_sortColumnIndex == null ||
        _sortColumnIndex! >= visibleColumns.length) {
      return items;
    }
    final columnId = visibleColumns[_sortColumnIndex!].id;
    items.sort((a, b) {
      final aValue = _getColumnValue(a, columnId);
      final bValue = _getColumnValue(b, columnId);
      if (aValue == null && bValue == null) return 0;
      if (aValue == null) return 1;
      if (bValue == null) return -1;
      final result = aValue.compareTo(bValue);
      return _sortAscending ? result : -result;
    });
    return items;
  }

  List<DataRow2> _buildRows({
    required List<ColumnItem> visibleColumns,
    required bool isDark,
    required String fontFamily,
    required double fontSize,
    required FontWeight fontWeight,
  }) {
    final sortedItems = _getSortedItems(visibleColumns: visibleColumns);
    return sortedItems.map((item) {
      final isSelected = widget.state.selectedItemId == item.id;
      return DataRow2(
        selected: isSelected,
        color: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            return isDark
                ? DarkThemeColors.selectedRowBackground
                : LightThemeColors.selectedRowBackground;
          }
          return isDark
              ? DarkThemeColors.backgroundColor
              : LightThemeColors.backgroundColor;
        }),
        onTap: () => _onRowTap(item.id),
        onSecondaryTap: () {},
        onSecondaryTapDown: (details) => _onRowRightClick(details, item.id),
        cells: _buildCells(
          visibleColumns: visibleColumns,
          item: item,
          isDark: isDark,
          fontFamily: fontFamily,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      );
    }).toList();
  }

  void _onRowTap(String itemId) {
    context.read<MarketWatchBloc>().add(SelectMarketItemEvent(itemId: itemId));
  }

  void _onRowRightClick(TapDownDetails details, String itemId) {
    widget.onRightClick(details.globalPosition);
    context.read<MarketWatchBloc>().add(SelectMarketItemEvent(itemId: itemId));
  }

  List<DataCell> _buildCells({
    required List<ColumnItem> visibleColumns,
    required MarketItem item,
    required bool isDark,
    required String fontFamily,
    required double fontSize,
    required FontWeight fontWeight,
  }) {
    return visibleColumns.map((column) {
      final cellContent = TableCellBuilder(
        columnId: column.id,
        item: item,
        isDark: isDark,
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
      );

      return DataCell(
        DragTarget<String>(
          onWillAcceptWithDetails: (details) {
            return details.data != item.id;
          },
          onAcceptWithDetails: (details) {
            context.read<MarketWatchBloc>().add(
              ReorderMarketItemsEvent(
                fromItemId: details.data,
                toItemId: item.id,
              ),
            );
          },
          builder: (context, candidateData, rejectedData) {
            final isHovered = candidateData.isNotEmpty;
            return Container(
              decoration: isHovered
                  ? BoxDecoration(
                      border: Border(
                        top: BorderSide(color: AppColors.blue, width: 2.0),
                      ),
                    )
                  : null,
              child: LongPressDraggable<String>(
                data: item.id,
                axis: Axis.vertical,
                delay: const Duration(milliseconds: 300),
                feedback: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(8.r),
                  color: isDark
                      ? DarkThemeColors.backgroundColor
                      : LightThemeColors.backgroundColor,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.blue, width: 1.5),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      item.symbol,
                      style: TextStyle(
                        fontFamily: fontFamily,
                        fontSize: fontSize.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.white : AppColors.black,
                      ),
                    ),
                  ),
                ),
                childWhenDragging: Opacity(opacity: 0.3, child: cellContent),
                child: cellContent,
              ),
            );
          },
        ),
      );
    }).toList();
  }
}
