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
      color: AppColors.tableColumnHeadColor(context),
      child: Row(
        children: [
          _buildHeaderCell(context, AppStrings.exchange, flex: 1),
          _buildHeaderCell(context, AppStrings.symbol, flex: 1),
          _buildHeaderCell(context, AppStrings.buyQty, flex: 1),
          _buildHeaderCell(context, AppStrings.buyPrice, flex: 1),
          _buildHeaderCell(context, AppStrings.sellPrice, flex: 1),
          _buildHeaderCell(context, AppStrings.sellQty, flex: 1),
          _buildHeaderCell(context, AppStrings.netChange, flex: 1),
          _buildHeaderCell(context, AppStrings.high, flex: 1),
          _buildHeaderCell(context, AppStrings.low, flex: 1),
          _buildHeaderCell(context, AppStrings.open, flex: 1),
          _buildHeaderCell(context, AppStrings.close, flex: 1),
          _buildHeaderCell(context, AppStrings.ltp, flex: 1),
          _buildHeaderCell(context, AppStrings.netChangePercent, flex: 1),
          _buildHeaderCell(context, AppStrings.expiry, flex: 1),
          _buildHeaderCell(context, AppStrings.lut, flex: 2),
        ],
      ),
    );
  }

  /// Build individual header cell with consistent styling
  Widget _buildHeaderCell(BuildContext context, String title, {int flex = 1}) {
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
              color: AppColors.dividerColor(context),
              width: AppDimensions.borderWidthThin,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: AppDimensions.fontSizeS,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor(context),
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
