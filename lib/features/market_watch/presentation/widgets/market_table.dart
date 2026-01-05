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
  // Sorting state
  int? _sortColumnIndex;
  bool _sortAscending = true;

  @override
  Widget build(BuildContext context) {
    if (widget.state.filteredItems.isEmpty) {
      return Center(
        child: Text(
          AppStrings.noDataAvailable,
          style: GoogleFonts.openSans(
            fontSize: 16.sp,
            color: AppColors.primaryBlue.withOpacity(0.6),
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.tableBorderColor, width: 1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: DataTable2(
          // Table configuration
          columnSpacing: 0,
          horizontalMargin: 0,
          minWidth: 1600,
          scrollController: ScrollController(),
          isHorizontalScrollBarVisible: true,
          isVerticalScrollBarVisible: true,

          // Header styling
          headingRowHeight: 55.h,
          headingRowColor: WidgetStateProperty.all(
            AppColors.headerBgColor,
          ),
          headingTextStyle: GoogleFonts.openSans(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryBlue,
            letterSpacing: 0.15,
          ),

          // Row styling
          dataRowHeight: 45.h,
          dataTextStyle: GoogleFonts.openSans(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.primaryBlue,
            letterSpacing: 0.1,
          ),

          // Border
          border: TableBorder(
            horizontalInside:
            BorderSide(color: AppColors.tableRowBackground, width: 1),
            verticalInside: BorderSide(
                color: AppColors.tableRowBackground.withOpacity(0.5), width: 1),
          ),

          // Sorting
          sortColumnIndex: _sortColumnIndex,
          sortAscending: _sortAscending,

          // Columns
          columns: _buildColumns(),

          // Rows
          rows: _buildRows(),
        ),
      ),
    );
  }

  /// Build table columns with sort icons
  List<DataColumn2> _buildColumns() {
    return [
      _buildColumn(AppStrings.exchange, 120, onSort: _onSort),
      _buildColumn(AppStrings.symbol, 100, onSort: _onSort),
      _buildColumn(AppStrings.buyQty, 100, onSort: _onSort, numeric: true),
      _buildColumn(AppStrings.buyPrice, 110, onSort: _onSort, numeric: true),
      _buildColumn(AppStrings.sellPrice, 110, onSort: _onSort, numeric: true),
      _buildColumn(AppStrings.sellQty, 100, onSort: _onSort, numeric: true),
      _buildColumn(AppStrings.netChange, 110, onSort: _onSort, numeric: true),
      _buildColumn(AppStrings.high, 90, onSort: _onSort, numeric: true),
      _buildColumn(AppStrings.low, 90, onSort: _onSort, numeric: true),
      _buildColumn(AppStrings.open, 90, onSort: _onSort, numeric: true),
      _buildColumn(AppStrings.close, 90, onSort: _onSort, numeric: true),
      _buildColumn(AppStrings.ltp, 100, onSort: _onSort, numeric: true),
      _buildColumn(AppStrings.netChangePercent, 120,
          onSort: _onSort, numeric: true),
      _buildColumn(AppStrings.expiry, 100, onSort: _onSort),
      _buildColumn(AppStrings.lut, 160, onSort: _onSort),
    ];
  }

  /// Build individual column with custom header
  DataColumn2 _buildColumn(
      String label,
      double width, {
        bool numeric = false,
        Function(int, bool)? onSort,
      }) {
    return DataColumn2(
      label: _buildHeaderCell(label),
      size: ColumnSize.S,
      fixedWidth: width,
      numeric: numeric,
      onSort: onSort,
    );
  }

  /// Build header cell with sort icon
  Widget _buildHeaderCell(String title) {
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
                color: AppColors.primaryBlue,
                letterSpacing: 0.15,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 4.w),
          SvgIcon(
            assetPath: AppImages.sortIcon,
            isActive: false,
            size: 14.sp,
            activeColor: AppColors.primaryBlue,
            inactiveColor: AppColors.primaryBlue.withOpacity(0.7),
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

  /// Build table rows
  List<DataRow2> _buildRows() {
    return widget.state.filteredItems.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final isSelected = widget.state.selectedItemId == item.id;

      return DataRow2(
        selected: isSelected,
        color: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.selectedRowBackground;
          }
          return index % 2 == 0
              ? AppColors.tableRowBackground
              : AppColors.altRowBgColor;
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
        cells: _buildCells(item),
      );
    }).toList();
  }

  /// Build cells for a row
  List<DataCell> _buildCells(MarketItem item) {
    return [
      // Exchange with trend icon
      DataCell(_buildExchangeCell(item.exchange, item.netChange)),
      // Symbol
      DataCell(_buildTextCell(item.symbol, isBold: true)),
      // Buy Qty
      DataCell(_buildTextCell(NumberFormatter.formatQuantity(item.buyQty))),
      // Buy Price
      DataCell(_buildTextCell(NumberFormatter.formatPrice(item.buyPrice))),
      // Sell Price
      DataCell(_buildTextCell(NumberFormatter.formatPrice(item.sellPrice))),
      // Sell Qty
      DataCell(_buildTextCell(NumberFormatter.formatQuantity(item.sellQty))),
      // Net Change
      DataCell(_buildTextCell(
        NumberFormatter.formatChange(item.netChange),
        color: item.netChange > 0
            ? AppColors.positiveColor
            : (item.netChange < 0 ? AppColors.negativeColor : null),
      )),
      // High
      DataCell(_buildTextCell(NumberFormatter.formatPrice(item.high))),
      // Low
      DataCell(_buildTextCell(NumberFormatter.formatPrice(item.low))),
      // Open
      DataCell(_buildTextCell(NumberFormatter.formatPrice(item.open))),
      // Close
      DataCell(_buildTextCell(NumberFormatter.formatPrice(item.close))),
      // LTP
      DataCell(_buildTextCell(NumberFormatter.formatPrice(item.ltp))),
      // Net Change %
      DataCell(_buildTextCell(
        NumberFormatter.formatPercentage(item.netChangePercent),
        color: item.netChangePercent > 0
            ? AppColors.positiveColor
            : (item.netChangePercent < 0 ? AppColors.negativeColor : null),
      )),
      // Expiry
      DataCell(_buildTextCell(
        item.expiry != null
            ? DateFormatter.formatToShortDate(item.expiry!)
            : AppStrings.dashPlaceholder,
      )),
      // LUT
      DataCell(
          _buildTextCell(DateFormatter.formatToDateTimeWithAmPm(item.lut))),
    ];
  }

  /// Build Exchange cell with trend icon
  Widget _buildExchangeCell(String exchange, double netChange) {
    final isPositive = netChange > 0;
    final isNegative = netChange < 0;
    final iconColor = isPositive
        ? AppColors.positiveColor
        : (isNegative ? AppColors.negativeColor : AppColors.primaryBlue);

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
                color: AppColors.primaryBlue,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Build text cell
  Widget _buildTextCell(
      String text, {
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
          fontWeight: isBold ? FontWeight.w600 : FontWeight.w600,
          color: color ?? AppColors.black,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}