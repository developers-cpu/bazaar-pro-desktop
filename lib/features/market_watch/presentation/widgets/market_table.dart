import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../../../core/widget/svg_icon.dart';
import '../../domain/entities/market_item.dart';
import '../bloc/marketwatch/market_watch_bloc.dart';
import '../bloc/marketwatch/market_watch_event.dart';
import '../bloc/marketwatch/market_watch_state.dart';
import '../bloc/theme/theme_bloc.dart';
import '../bloc/theme/theme_state.dart' show ThemeState;


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
        final isDark = themeState.isDarkMode;
        final showGrid = widget.state.showGrid;

        if (widget.state.filteredItems.isEmpty) {
          return _buildEmptyState(isDark);
        }
        return Container(
          margin: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: isDark ? DarkThemeColors.backgroundColor : LightThemeColors.backgroundColor,
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
            child: DataTable2(
            columnSpacing: 0,
            horizontalMargin: 0,
            minWidth: 1600,
            headingRowHeight: 55.h,
            headingRowColor: WidgetStateProperty.all(
            LightThemeColors.tableColumnHeadColor,
            ),

            dividerThickness: showGrid ? 2 : 0,
            border: showGrid
                ? TableBorder.all(
              color: isDark
                  ? DarkThemeColors.dividerColor
                  : LightThemeColors.dividerColor,
              width: 1,
            )
                : const TableBorder(),
            sortColumnIndex: _sortColumnIndex,
            sortAscending: _sortAscending,
            columns: _buildColumns(isDark),
            rows: _buildRows(isDark, showGrid),
          ),

        ),
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

  List<DataColumn2> _buildColumns(bool isDark) {
    return [
      _buildColumn(AppStrings.exchange, 120, isDark, onSort: _onSort),
      _buildColumn(AppStrings.symbol, 100, isDark, onSort: _onSort),
      _buildColumn(AppStrings.buyQty, 100, isDark, onSort: _onSort, numeric: true),
      _buildColumn(AppStrings.buyPrice, 110, isDark, onSort: _onSort, numeric: true),
      _buildColumn(AppStrings.sellPrice, 110, isDark, onSort: _onSort, numeric: true),
      _buildColumn(AppStrings.sellQty, 100, isDark, onSort: _onSort, numeric: true),
      _buildColumn(AppStrings.netChange, 110, isDark, onSort: _onSort, numeric: true),
      _buildColumn(AppStrings.high, 90, isDark, onSort: _onSort, numeric: true),
      _buildColumn(AppStrings.low, 90, isDark, onSort: _onSort, numeric: true),
      _buildColumn(AppStrings.open, 90, isDark, onSort: _onSort, numeric: true),
      _buildColumn(AppStrings.close, 90, isDark, onSort: _onSort, numeric: true),
      _buildColumn(AppStrings.ltp, 100, isDark, onSort: _onSort, numeric: true),
      _buildColumn(AppStrings.netChangePercent, 120, isDark, onSort: _onSort, numeric: true),
      _buildColumn(AppStrings.expiry, 100, isDark, onSort: _onSort),
      _buildColumn(AppStrings.lut, 160, isDark, onSort: _onSort),
    ];
  }

  DataColumn2 _buildColumn(
      String label,
      double width,
      bool isDark, {
        bool numeric = false,
        Function(int, bool)? onSort,
      }) {
    return DataColumn2(
      label: _buildHeaderCell(label, isDark),
      size: ColumnSize.S,
      fixedWidth: width,
      numeric: numeric,
      onSort: onSort,
    );
  }

  Widget _buildHeaderCell(String title, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              title,
              style: GoogleFonts.openSans(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: LightThemeColors.textColor,
                letterSpacing: 0.15,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 4.w),
          SvgIcon(
            assetPath: AppImages.sortIcon,
            isActive: isDark,
            size: 14.sp,
          ),
        ],
      ),
    );
  }

  void _onSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  List<DataRow2> _buildRows(bool isDark, bool showGrid) {
    return widget.state.filteredItems.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
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
        onTap: () {
          context.read<MarketWatchBloc>().add(
            SelectMarketItemEvent(itemId: item.id),
          );
        },
        onSecondaryTap: () {},
        onSecondaryTapDown: (details) {
          widget.onRightClick(details.globalPosition);
          context.read<MarketWatchBloc>().add(
            SelectMarketItemEvent(itemId: item.id),
          );
        },
        cells: _buildCells(item, isDark),
      );
    }).toList();
  }

  List<DataCell> _buildCells(MarketItem item, bool isDark) {
    return [
      // Exchange with trend icon
      DataCell(_buildExchangeCell(item.exchange, item.netChange, isDark)),
      // Symbol
      DataCell(_buildTextCell(item.symbol, isDark, isBold: true)),
      // Buy Qty
      DataCell(_buildTextCell(NumberFormatter.formatQuantity(item.buyQty), isDark)),
      // Buy Price
      DataCell(_buildTextCell(NumberFormatter.formatPrice(item.buyPrice), isDark)),
      // Sell Price
      DataCell(_buildTextCell(NumberFormatter.formatPrice(item.sellPrice), isDark)),
      // Sell Qty
      DataCell(_buildTextCell(NumberFormatter.formatQuantity(item.sellQty), isDark)),
      // Net Change
      DataCell(_buildTextCell(
        NumberFormatter.formatChange(item.netChange),
        isDark,
        color: item.netChange > 0
            ? (isDark ? DarkThemeColors.positiveTextColor : LightThemeColors.positiveTextColor)
            : (item.netChange < 0
            ? (isDark ? DarkThemeColors.negativeTextColor : LightThemeColors.negativeTextColor)
            : null),
      )),
      // High
      DataCell(_buildTextCell(NumberFormatter.formatPrice(item.high), isDark)),
      // Low
      DataCell(_buildTextCell(NumberFormatter.formatPrice(item.low), isDark)),
      // Open
      DataCell(_buildTextCell(NumberFormatter.formatPrice(item.open), isDark)),
      // Close
      DataCell(_buildTextCell(NumberFormatter.formatPrice(item.close), isDark)),
      // LTP
      DataCell(_buildTextCell(NumberFormatter.formatPrice(item.ltp), isDark)),
      // Net Change %
      DataCell(_buildTextCell(
        NumberFormatter.formatPercentage(item.netChangePercent),
        isDark,
        color: item.netChangePercent > 0
            ? (isDark ? DarkThemeColors.positiveTextColor : LightThemeColors.positiveTextColor)
            : (item.netChangePercent < 0
            ? (isDark ? DarkThemeColors.negativeTextColor : LightThemeColors.negativeTextColor)
            : null),
      )),
      // Expiry
      DataCell(_buildTextCell(
        item.expiry != null
            ? DateFormatter.formatToShortDate(item.expiry!)
            : AppStrings.dashPlaceholder,
        isDark,
      )),
      // LUT
      DataCell(_buildTextCell(DateFormatter.formatToDateTimeWithAmPm(item.lut), isDark)),
    ];
  }

  Widget _buildExchangeCell(String exchange, double netChange, bool isDark) {
    final isPositive = netChange > 0;
    final isNegative = netChange < 0;

    Color iconColor;
    if (isPositive) {
      iconColor = isDark
          ? DarkThemeColors.positiveTextColor
          : LightThemeColors.positiveTextColor;
    } else if (isNegative) {
      iconColor = isDark
          ? DarkThemeColors.negativeTextColor
          : LightThemeColors.negativeTextColor;
    } else {
      iconColor = isDark
          ? DarkThemeColors.textColor
          : LightThemeColors.textColor;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.trending_up : Icons.trending_down,
            size: 16.sp,
            color: iconColor,
          ),
          SizedBox(width: 6.w),
          Flexible(
            child: Text(
              exchange,
              style: GoogleFonts.openSans(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: isDark
                    ? DarkThemeColors.textColor
                    : LightThemeColors.textColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextCell(
      String text,
      bool isDark, {
        bool isBold = false,
        Color? color,
      }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: GoogleFonts.openSans(
          fontSize: 13.sp,
          fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
          color: color ??
              (isDark ? DarkThemeColors.textColor : LightThemeColors.textColor),
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}