import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';

/// Reusable table header widget
/// Displays column headers for the market watch table
/// Styled consistently across the application
class MarketTableHeader extends StatelessWidget {
  const MarketTableHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.tableHeaderHeight,
      color: AppColors.tableHeaderBackground,
      child: Row(
        children: [
          _buildHeaderCell(AppStrings.exchange, flex: 1),
          _buildHeaderCell(AppStrings.symbol, flex: 1),
          _buildHeaderCell(AppStrings.buyQty, flex: 1),
          _buildHeaderCell(AppStrings.buyPrice, flex: 1),
          _buildHeaderCell(AppStrings.sellPrice, flex: 1),
          _buildHeaderCell(AppStrings.sellQty, flex: 1),
          _buildHeaderCell(AppStrings.netChange, flex: 1),
          _buildHeaderCell(AppStrings.high, flex: 1),
          _buildHeaderCell(AppStrings.low, flex: 1),
          _buildHeaderCell(AppStrings.open, flex: 1),
          _buildHeaderCell(AppStrings.close, flex: 1),
          _buildHeaderCell(AppStrings.ltp, flex: 1),
          _buildHeaderCell(AppStrings.netChangePercent, flex: 1),
          _buildHeaderCell(AppStrings.expiry, flex: 1),
          _buildHeaderCell(AppStrings.lut, flex: 2),
        ],
      ),
    );
  }

  /// Build individual header cell with consistent styling
  Widget _buildHeaderCell(String title, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingS,
          vertical: AppDimensions.paddingM,
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
          title,
          style: const TextStyle(
            fontSize: AppDimensions.fontSizeS,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryTextColor,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
