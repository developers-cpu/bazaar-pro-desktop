import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../domain/entities/market_item.dart';
import '../bloc/market_watch_bloc.dart';
import '../bloc/market_watch_event.dart';
import '../bloc/market_watch_state.dart';
import 'market_table_header.dart';

class MarketTableBody extends StatelessWidget {
  final MarketWatchLoaded state;
  final Function(Offset) onRightClick;
  final ScrollController? horizontalScrollController;

  const MarketTableBody({
    Key? key,
    required this.state,
    required this.onRightClick,
    this.horizontalScrollController,
  }) : super(key: key);

  // ─────────────────────────────────────────────────────────────────
  // DESIGN CONSTANTS
  // ─────────────────────────────────────────────────────────────────
  static const Color _primaryColor = Color(0xFF1F4A66);
  static const Color _borderColor = Color(0xFFE0E0E0);
  static const Color _rowBgColor = Color(0xFFFFFFFF);
  static const Color _altRowBgColor = Color(0xFFF8F9FA);
  static const Color _selectedRowBgColor = Color(0xFFE3F2FD);
  static const Color _positiveColor = Color(0xFF4CAF50);
  static const Color _negativeColor = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    if (state.filteredItems.isEmpty) {
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final needsScroll = availableWidth < MarketTableHeader.totalMinWidth;

        if (needsScroll) {
          // Screen too small - use fixed widths with horizontal scrolling
          return SingleChildScrollView(
            controller: horizontalScrollController,
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            child: SizedBox(
              width: MarketTableHeader.totalMinWidth,
              child: _buildVerticalList(useFixedWidths: true),
            ),
          );
        } else {
          // Screen large enough - use Expanded to fill space
          return _buildVerticalList(useFixedWidths: false);
        }
      },
    );
  }

  /// Build vertical scrolling list of rows
  Widget _buildVerticalList({required bool useFixedWidths}) {
    return ListView.builder(
      itemCount: state.filteredItems.length,
      itemBuilder: (context, index) {
        final item = state.filteredItems[index];
        final isSelected = state.selectedItemId == item.id;
        return _buildDataRow(context, item, index, isSelected, useFixedWidths);
      },
    );
  }

  /// Build individual data row
  Widget _buildDataRow(
      BuildContext context,
      MarketItem item,
      int index,
      bool isSelected,
      bool useFixedWidths,
      ) {
    final bgColor = isSelected
        ? _selectedRowBgColor
        : (index % 2 == 0 ? _rowBgColor : _altRowBgColor);

    final minWidths = MarketTableHeader.minColumnWidths;

    // Build all cell data
    final cellData = [
      _CellData(
        text: item.exchange,
        showTrendIcon: true,
        netChange: item.netChange,
      ),
      _CellData(text: item.symbol, isBold: true),
      _CellData(text: NumberFormatter.formatQuantity(item.buyQty)),
      _CellData(text: NumberFormatter.formatPrice(item.buyPrice)),
      _CellData(text: NumberFormatter.formatPrice(item.sellPrice)),
      _CellData(text: NumberFormatter.formatQuantity(item.sellQty)),
      _CellData(
        text: NumberFormatter.formatChange(item.netChange),
        color: item.netChange > 0
            ? _positiveColor
            : (item.netChange < 0 ? _negativeColor : null),
      ),
      _CellData(text: NumberFormatter.formatPrice(item.high)),
      _CellData(text: NumberFormatter.formatPrice(item.low)),
      _CellData(text: NumberFormatter.formatPrice(item.open)),
      _CellData(text: NumberFormatter.formatPrice(item.close)),
      _CellData(text: NumberFormatter.formatPrice(item.ltp)),
      _CellData(
        text: NumberFormatter.formatPercentage(item.netChangePercent),
        color: item.netChangePercent > 0
            ? _positiveColor
            : (item.netChangePercent < 0 ? _negativeColor : null),
      ),
      _CellData(
        text: item.expiry != null
            ? DateFormatter.formatToShortDate(item.expiry!)
            : '-',
      ),
      _CellData(text: DateFormatter.formatToDateTimeWithAmPm(item.lut)),
    ];

    return GestureDetector(
      onTap: () {
        context.read<MarketWatchBloc>().add(
          SelectMarketItemEvent(itemId: item.id),
        );
      },
      onSecondaryTapDown: (details) {
        onRightClick(details.globalPosition);
        context.read<MarketWatchBloc>().add(
          SelectMarketItemEvent(itemId: item.id),
        );
      },
      child: Container(
        height: 45.h,
        decoration: BoxDecoration(
          color: bgColor,
          border: Border(
            bottom: const BorderSide(color: _borderColor, width: 1),
            left: isSelected
                ? BorderSide(color: _primaryColor, width: 3.w)
                : BorderSide.none,
          ),
        ),
        child: Row(
          children: List.generate(cellData.length, (i) {
            final cell = cellData[i];
            final isLast = i == cellData.length - 1;

            if (useFixedWidths) {
              return _buildDataCell(
                cell,
                width: minWidths[i],
                isLast: isLast,
              );
            } else {
              return Expanded(
                child: _buildDataCell(cell, isLast: isLast),
              );
            }
          }),
        ),
      ),
    );
  }

  /// Build individual data cell
  Widget _buildDataCell(
      _CellData cell, {
        double? width,
        bool isLast = false,
      }) {
    return Container(
      width: width,
      height: 45.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
      decoration: BoxDecoration(
        border: Border(
          right: isLast
              ? BorderSide.none
              : const BorderSide(color: _borderColor, width: 1),
        ),
      ),
      child: cell.showTrendIcon
          ? _buildExchangeCellContent(cell)
          : _buildTextCellContent(cell),
    );
  }

  /// Build Exchange cell with trend icon
  Widget _buildExchangeCellContent(_CellData cell) {
    final isPositive = cell.netChange > 0;
    final isNegative = cell.netChange < 0;
    final iconColor = isPositive
        ? _positiveColor
        : (isNegative ? _negativeColor : _primaryColor);

    return Row(
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
        Expanded(
          child: Text(
            cell.text,
            style: GoogleFonts.openSans(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: _primaryColor,
              letterSpacing: 0.1,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// Build text cell content
  Widget _buildTextCellContent(_CellData cell) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        cell.text,
        style: GoogleFonts.openSans(
          fontSize: 13.sp,
          fontWeight: cell.isBold ? FontWeight.w600 : FontWeight.w400,
          color: cell.color ?? _primaryColor,
          letterSpacing: 0.1,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

/// Cell data helper class
class _CellData {
  final String text;
  final bool isBold;
  final Color? color;
  final bool showTrendIcon;
  final double netChange;

  const _CellData({
    required this.text,
    this.isBold = false,
    this.color,
    this.showTrendIcon = false,
    this.netChange = 0,
  });
}