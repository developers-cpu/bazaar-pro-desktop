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
        ? AppColors.getSelectedRowBackground(context)
        : (index % 2 == 0
              ? AppColors.getTableRowBackground(context)
              : AppColors.getTableAlternateRowBackground(context));

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
              color: AppColors.dividerColor(context),
              width: AppDimensions.borderWidthThin,
            ),
            left: isSelected
                ? BorderSide(
                    color: AppColors.getSelectedRowBorder(context),
                    width: AppDimensions.borderWidthThick,
                  )
                : BorderSide.none,
          ),
        ),
        child: Row(
          children: [
            _buildCell(context, item.exchange, flex: 1),
            _buildCell(context, item.symbol, flex: 1, isBold: true),
            _buildCell(
              context,
              NumberFormatter.formatQuantity(item.buyQty),
              flex: 1,
            ),
            _buildCell(
              context,
              NumberFormatter.formatPrice(item.buyPrice),
              flex: 1,
            ),
            _buildCell(
              context,
              NumberFormatter.formatPrice(item.sellPrice),
              flex: 1,
            ),
            _buildCell(
              context,
              NumberFormatter.formatQuantity(item.sellQty),
              flex: 1,
            ),
            _buildCell(
              context,
              NumberFormatter.formatChange(item.netChange),
              flex: 1,
              color: item.netChange > 0
                  ? AppColors.getPositiveTextColor(context)
                  : (item.netChange < 0
                        ? AppColors.getNegativeTextColor(context)
                        : null),
            ),
            _buildCell(
              context,
              NumberFormatter.formatPrice(item.high),
              flex: 1,
            ),
            _buildCell(context, NumberFormatter.formatPrice(item.low), flex: 1),
            _buildCell(
              context,
              NumberFormatter.formatPrice(item.open),
              flex: 1,
            ),
            _buildCell(
              context,
              NumberFormatter.formatPrice(item.close),
              flex: 1,
            ),
            _buildCell(context, NumberFormatter.formatPrice(item.ltp), flex: 1),
            _buildCell(
              context,
              NumberFormatter.formatPercentage(item.netChangePercent),
              flex: 1,
              color: item.netChangePercent > 0
                  ? AppColors.getPositiveTextColor(context)
                  : (item.netChangePercent < 0
                        ? AppColors.getNegativeTextColor(context)
                        : null),
            ),
            _buildCell(
              context,
              item.expiry != null
                  ? DateFormatter.formatToShortDate(item.expiry!)
                  : '-',
              flex: 1,
            ),
            _buildCell(
              context,
              DateFormatter.formatToDateTimeWithAmPm(item.lut),
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }

  /// Build individual cell with consistent styling
  Widget _buildCell(
    BuildContext context,
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
              color: AppColors.dividerColor(context),
              width: AppDimensions.borderWidthThin,
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: AppDimensions.fontSizeS,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: color ?? AppColors.textColor(context),
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
