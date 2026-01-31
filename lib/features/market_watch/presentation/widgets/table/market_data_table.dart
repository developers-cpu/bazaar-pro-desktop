import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../domain/entities/market_item.dart';
import '../../bloc/arrangesymbol/arrange_symbol_bloc.dart';
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
                final fontWeight =
                TableTextStyleHelper.getFontWeight(fontState.selectedFontStyle);

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
    final minWidth = TableColumnHelper.calculateMinWidth(visibleColumns, fontSize);

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
    final rowHeight = (fontSize * 3.2).clamp(48.0, 80.0);
    final headerHeight = (fontSize * 3.5).clamp(55.0, 85.0);

    return DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      minWidth: minWidth,
      headingRowHeight: headerHeight.h,
      dataRowHeight: rowHeight.h,
      headingRowColor: WidgetStateProperty.all(
        LightThemeColors.tableColumnHeadColor,
      ),
      dividerThickness: showGrid ? 1 : 0,
      border: showGrid
          ? TableBorder.all(
        color: isDark
            ? AppColors.white
            : AppColors.black,
        width: 1,
      )
          : const TableBorder(),
      sortColumnIndex: _sortColumnIndex,
      sortAscending: _sortAscending,
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
    return visibleColumns.map((column) {
      final label = TableColumnHelper.getLabel(column.id);
      final config = TableColumnHelper.getConfig(column.id);

      return DataColumn2(
        label: TableHeaderCell(
          title: label,
          isDark: isDark,
          fontFamily: fontFamily,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),

        size: _getColumnSize(column.id, visibleColumns.length),
        numeric: config?.isNumeric ?? false,
        onSort: _onSort,
      );
    }).toList();
  }

  ColumnSize _getColumnSize(String columnId, int visibleColumnCount) {
    if (visibleColumnCount <= 5) {
      return ColumnSize.L;
    } else if (visibleColumnCount <= 10) {
      return ColumnSize.M;
    }
    return ColumnSize.S;
  }

  void _onSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  List<DataRow2> _buildRows({
    required List<ColumnItem> visibleColumns,
    required bool isDark,
    required String fontFamily,
    required double fontSize,
    required FontWeight fontWeight,
  }) {
    return widget.state.filteredItems.map((item) {
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
      return DataCell(
        TableCellBuilder(
          columnId: column.id,
          item: item,
          isDark: isDark,
          fontFamily: fontFamily,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      );
    }).toList();
  }
}