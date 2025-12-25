import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../domain/entities/market_item.dart';

/// Reusable table row widget for displaying market data
/// Handles selection state and provides consistent styling
/// Shows data with proper formatting for numbers and dates
class MarketTableRow extends StatelessWidget {
  final MarketItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final Function(Offset) onRightClick;
  final int index;

  const MarketTableRow({
    Key? key,
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.onRightClick,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine background color based on selection and row index
    Color backgroundColor = isSelected
        ? AppColors.selectedRowBackground
        : (index % 2 == 0 ? AppColors.tableRowBackground : AppColors.tableAlternateRowBackground);

    return GestureDetector(
      onTap: onTap,
      onSecondaryTapDown: (details) {
        onRightClick(details.globalPosition);
      },
      child: Container(
        height: AppDimensions.tableRowHeight,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border(
            bottom: BorderSide(
              color: AppColors.borderColor,
              width: AppDimensions.borderWidthThin,
            ),
            left: isSelected
                ? BorderSide(
                    color: AppColors.selectedRowBorder,
                    width: AppDimensions.borderWidthThick,
                  )
                : BorderSide.none,
          ),
        ),
        child: Row(
          children: [
            _buildCell(item.exchange, flex: 1),
            _buildCell(item.symbol, flex: 1, isBold: true),
            _buildCell(NumberFormatter.formatQuantity(item.buyQty), flex: 1),
            _buildCell(NumberFormatter.formatPrice(item.buyPrice), flex: 1),
            _buildCell(NumberFormatter.formatPrice(item.sellPrice), flex: 1),
            _buildCell(NumberFormatter.formatQuantity(item.sellQty), flex: 1),
            _buildCell(
              NumberFormatter.formatChange(item.netChange),
              flex: 1,
              color: item.netChange > 0
                  ? AppColors.positiveTextColor
                  : (item.netChange < 0 ? AppColors.negativeTextColor : null),
            ),
            _buildCell(NumberFormatter.formatPrice(item.high), flex: 1),
            _buildCell(NumberFormatter.formatPrice(item.low), flex: 1),
            _buildCell(NumberFormatter.formatPrice(item.open), flex: 1),
            _buildCell(NumberFormatter.formatPrice(item.close), flex: 1),
            _buildCell(NumberFormatter.formatPrice(item.ltp), flex: 1),
            _buildCell(
              NumberFormatter.formatPercentage(item.netChangePercent),
              flex: 1,
              color: item.netChangePercent > 0
                  ? AppColors.positiveTextColor
                  : (item.netChangePercent < 0 ? AppColors.negativeTextColor : null),
            ),
            _buildCell(
              item.expiry != null ? DateFormatter.formatToShortDate(item.expiry!) : '-',
              flex: 1,
            ),
            _buildCell(DateFormatter.formatToDateTimeWithAmPm(item.lut), flex: 2),
          ],
        ),
      ),
    );
  }

  /// Build individual cell with consistent styling
  Widget _buildCell(
    String text, {
    int flex = 1,
    bool isBold = false,
    Color? color,
  }) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingS,
          vertical: AppDimensions.paddingS,
        ),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: AppColors.borderColor,
              width: AppDimensions.borderWidthThin,
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: AppDimensions.fontSizeS,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: color ?? AppColors.primaryTextColor,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
