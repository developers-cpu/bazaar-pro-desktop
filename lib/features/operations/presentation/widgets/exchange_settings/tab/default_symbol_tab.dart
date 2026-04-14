import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_images.dart';
import '../../../../../../core/widget/app_dropdown.dart';
import '../../../../../../core/widget/custom_action_button.dart';
import '../../../../../../core/widget/custom_input_field.dart';
import '../../../../../../core/widget/table/view_data_table.dart';
import '../../../../domain/entities/exchange_settings/exchange_setting.dart';
import '../exchange_settings_data_table.dart';

class DefaultSymbolTab extends StatelessWidget {
  final String? selectedExchange;
  final List<String> exchanges;
  final ValueChanged<String?> onExchangeChanged;
  final TextEditingController searchCtrl;
  final ValueChanged<String> onSearchChanged;
  final List<DefaultSymbol> symbols;
  final Set<String> selectedIds;
  final ValueChanged<Set<String>> onSelectionChanged;
  final VoidCallback onUpdatePressed;
  final Map<String, bool> watchlistStates;
  final ValueChanged<String> onWatchlistToggle;

  const DefaultSymbolTab({
    super.key,
    required this.selectedExchange,
    required this.exchanges,
    required this.onExchangeChanged,
    required this.searchCtrl,
    required this.onSearchChanged,
    required this.symbols,
    required this.selectedIds,
    required this.onSelectionChanged,
    required this.onUpdatePressed,
    required this.watchlistStates,
    required this.onWatchlistToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 200.w,
              child: AppDropdown(
                items: exchanges,
                value: selectedExchange,
                hintText: 'Exchange',
                onChanged: onExchangeChanged,
              ),
            ),
            SizedBox(width: 15.w),
            CustomInputField(
              hintText: 'Search',
              controller: searchCtrl,
              prefixSvgPath: AppImages.searchIcon,
              width: 200.w,
              height: 35.h,
              onChanged: onSearchChanged,
            ),
            const Spacer(),
            if (selectedExchange != null)
              CustomActionButton(
                text: 'Update',
                onPressed: onUpdatePressed,
                width: 100.w,
                height: 35.h,
                borderRadius: 8.r,
              ),
          ],
        ),
        if (selectedExchange != null) ...[
          SizedBox(height: 10.h),
          Row(
            children: [
              const Spacer(),
              Text(
                'RECORD : ${symbols.length}',
                style: GoogleFonts.openSans(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: ExchangeSettingsDataTable(
              data: symbols,
              selectedIds: selectedIds,
              onSelectionChanged: onSelectionChanged,
              columns: [
                ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 180.w),
                ViewTableColumn(
                  id: 'updatedOn',
                  label: 'UPDATED ON',
                  width: 220.w,
                ),
                ViewTableColumn(
                  id: 'updatedBy',
                  label: 'UPDATED BY',
                  width: 180.w,
                ),
                ViewTableColumn(
                  id: 'showInWatchlist',
                  label: 'SHOW IN WATCHLIST',
                  width: 150.w,
                ),
              ],
              activeTab: 6,
              watchlistStates: watchlistStates,
              onWatchlistToggle: onWatchlistToggle,
            ),
          ),
        ] else
          const Expanded(child: SizedBox.shrink()),
      ],
    );
  }
}
