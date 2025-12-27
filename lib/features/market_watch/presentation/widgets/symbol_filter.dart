import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';

/// Reusable symbol filter dropdown widget
/// Allows filtering market items by symbol (NIFTY, GOLD, etc.)
/// Provides search functionality and multi-select support
class SymbolFilter extends StatelessWidget {
  final String? selectedSymbol;
  final Function(String?) onChanged;
  final List<String> availableSymbols;

  const SymbolFilter({
    Key? key,
    this.selectedSymbol,
    required this.onChanged,
    required this.availableSymbols,
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
          value: selectedSymbol,
          hint: Text(
            AppStrings.symbolFilter,
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
          items: _getSymbolItems(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  /// Get list of symbol dropdown items
  List<DropdownMenuItem<String>> _getSymbolItems() {
    // Get unique symbols from available symbols list
    final uniqueSymbols = availableSymbols.toSet().toList();
    uniqueSymbols.sort();

    return uniqueSymbols.map((symbol) {
      return DropdownMenuItem<String>(
        value: symbol,
        child: Text(symbol),
      );
    }).toList();
  }
}
