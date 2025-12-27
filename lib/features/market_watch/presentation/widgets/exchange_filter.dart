import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';

/// Reusable exchange filter dropdown widget
/// Allows filtering market items by exchange (NSE, MCX, etc.)
/// Provides clear UI with proper styling
class ExchangeFilter extends StatelessWidget {
  final String? selectedExchange;
  final Function(String?) onChanged;

  const ExchangeFilter({
    Key? key,
    this.selectedExchange,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimensions.filterDropdownWidth,
      height: AppDimensions.filterDropdownHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor(context),
        border: Border.all(
          color: AppColors.borderColor,
          width: AppDimensions.borderWidthThin,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusS),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedExchange,
          hint: Text(
            AppStrings.exchangeFilter,
            style: TextStyle(
              fontSize: AppDimensions.fontSizeM,
              color: AppColors.secondaryTextColor,
            ),
          ),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          style: TextStyle(
            fontSize: AppDimensions.fontSizeM,
            color: AppColors.primaryTextColor,
          ),
          dropdownColor: AppColors.backgroundColor(context),
          items: _getExchangeItems(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  /// Get list of exchange dropdown items
  List<DropdownMenuItem<String>> _getExchangeItems() {
    final exchanges = [
      AppStrings.nse,
      AppStrings.mcx,
      AppStrings.cePe,
      AppStrings.others,
      AppStrings.comex,
      AppStrings.crypto,
      AppStrings.gift,
      AppStrings.forex,
    ];

    return exchanges.map((exchange) {
      return DropdownMenuItem<String>(
        value: exchange,
        child: Text(exchange),
      );
    }).toList();
  }
}
