import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../domain/entities/market_item.dart';
import '../bloc/market_watch_bloc.dart';
import '../bloc/market_watch_event.dart';
import '../bloc/market_watch_state.dart';


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
  // ─────────────────────────────────────────────────────────────────
  // DESIGN CONSTANTS
  // ─────────────────────────────────────────────────────────────────
  static const Color _headerBgColor = Color(0xFF1F4A66);
  static const Color _headerTextColor = Color(0xFF1F4A66);
  static const Color _primaryColor = Color(0xFF1F4A66);
  static const Color _borderColor = Color(0xFFE0E0E0);
  static const Color _rowBgColor = Color(0xFFFFFFFF);
  static const Color _altRowBgColor = Color(0xFFF8F9FA);
  static const Color _selectedRowBgColor = Color(0xFFE3F2FD);
  static const Color _positiveColor = Color(0xFF4CAF50);
  static const Color _negativeColor = Color(0xFFE53935);

  // Sorting state
  int? _sortColumnIndex;
  bool _sortAscending = true;

  @override
  Widget build(BuildContext context) {
    if (widget.state.filteredItems.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: GoogleFonts.openSans(
            fontSize: 16.sp,
            color: _primaryColor.withOpacity(0.6),
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        border: Border.all(color: _borderColor, width: 1),
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
            _headerBgColor.withOpacity(0.3),
          ),
          headingTextStyle: GoogleFonts.openSans(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: _headerTextColor,
            letterSpacing: 0.15,
          ),

          // Row styling
          dataRowHeight: 45.h,
          dataTextStyle: GoogleFonts.openSans(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: _primaryColor,
            letterSpacing: 0.1,
          ),

          // Border
          border: TableBorder(
            horizontalInside: BorderSide(color: _borderColor, width: 1),
            verticalInside: BorderSide(color: _borderColor.withOpacity(0.5), width: 1),
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
      _buildColumn('EXCHANGE', 120, onSort: _onSort),
      _buildColumn('SYMBOL', 100, onSort: _onSort),
      _buildColumn('BUY QTY', 100, onSort: _onSort, numeric: true),
      _buildColumn('BUY PRICE', 110, onSort: _onSort, numeric: true),
      _buildColumn('SELL PRICE', 110, onSort: _onSort, numeric: true),
      _buildColumn('SELL QTY', 100, onSort: _onSort, numeric: true),
      _buildColumn('NET CHANGE', 110, onSort: _onSort, numeric: true),
      _buildColumn('HIGH', 90, onSort: _onSort, numeric: true),
      _buildColumn('LOW', 90, onSort: _onSort, numeric: true),
      _buildColumn('OPEN', 90, onSort: _onSort, numeric: true),
      _buildColumn('CLOSE', 90, onSort: _onSort, numeric: true),
      _buildColumn('LTP', 100, onSort: _onSort, numeric: true),
      _buildColumn('NET CHANGE%', 120, onSort: _onSort, numeric: true),
      _buildColumn('EXPIRY', 100, onSort: _onSort),
      _buildColumn('LUT', 160, onSort: _onSort),
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
                color: _headerTextColor,
                letterSpacing: 0.15,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 4.w),
          SvgPicture.asset(
            AppImages.sortIcon,
            width: 14.w,
            height: 14.h,
            colorFilter: ColorFilter.mode(
              _headerTextColor.withOpacity(0.7),
              BlendMode.srcIn,
            ),
            placeholderBuilder: (context) => Icon(
              Icons.unfold_more,
              size: 14.sp,
              color: _headerTextColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  /// Handle column sort
  void _onSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
    // You can dispatch a sort event to the bloc here if needed
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
            return _selectedRowBgColor;
          }
          return index % 2 == 0 ? _rowBgColor : _altRowBgColor;
        }),
        onTap: () {
          context.read<MarketWatchBloc>().add(
            SelectMarketItemEvent(itemId: item.id),
          );
        },
        onSecondaryTap: () {
          // Handle right click - get position from gesture
        },
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
            ? _positiveColor
            : (item.netChange < 0 ? _negativeColor : null),
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
            ? _positiveColor
            : (item.netChangePercent < 0 ? _negativeColor : null),
      )),
      // Expiry
      DataCell(_buildTextCell(
        item.expiry != null
            ? DateFormatter.formatToShortDate(item.expiry!)
            : '-',
      )),
      // LUT
      DataCell(_buildTextCell(DateFormatter.formatToDateTimeWithAmPm(item.lut))),
    ];
  }

  /// Build Exchange cell with trend icon
  Widget _buildExchangeCell(String exchange, double netChange) {
    final isPositive = netChange > 0;
    final isNegative = netChange < 0;
    final iconColor = isPositive
        ? _positiveColor
        : (isNegative ? _negativeColor : _primaryColor);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            "",
            width: 16.w,
            height: 16.h,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            placeholderBuilder: (context) => Icon(
              isPositive ? Icons.trending_up : Icons.trending_down,
              size: 16.sp,
              color: iconColor,
            ),
          ),
          SizedBox(width: 6.w),
          Flexible(
            child: Text(
              exchange,
              style: GoogleFonts.openSans(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: _primaryColor,
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
          fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
          color: color ?? _primaryColor,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}