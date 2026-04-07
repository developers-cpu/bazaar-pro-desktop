import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_images.dart';
import '../../../../../../core/widget/custom_action_button.dart';
import '../../../../../../core/widget/custom_input_field.dart';
import '../../../../../../core/widget/table/view_data_table.dart';
import '../../../../domain/entities/exchange_settings/exchange_setting.dart';
import '../exchange_settings_data_table.dart';

class OrderTypeTab extends StatelessWidget {
  final bool orderMarket;
  final bool orderSL;
  final bool orderLimit;
  final ValueChanged<bool> onOrderMarketChanged;
  final ValueChanged<bool> onOrderSLChanged;
  final ValueChanged<bool> onOrderLimitChanged;
  final TextEditingController searchCtrl;
  final ValueChanged<String> onSearchChanged;
  final List<ExchangeSetting> settings;
  final Set<String> selectedIds;
  final ValueChanged<Set<String>> onSelectionChanged;
  final VoidCallback onUpdatePressed;

  const OrderTypeTab({
    super.key,
    required this.orderMarket,
    required this.orderSL,
    required this.orderLimit,
    required this.onOrderMarketChanged,
    required this.onOrderSLChanged,
    required this.onOrderLimitChanged,
    required this.searchCtrl,
    required this.onSearchChanged,
    required this.settings,
    required this.selectedIds,
    required this.onSelectionChanged,
    required this.onUpdatePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Order Type', style: _labelStyle()),
            const Spacer(),
            _updateButton(),
          ],
        ),
        SizedBox(height: 5.h),
        Row(
          children: [
            _checkOption('Market', orderMarket, onOrderMarketChanged),
            SizedBox(width: 10.w),
            _checkOption('SL', orderSL, onOrderSLChanged),
            SizedBox(width: 10.w),
            _checkOption('Limit', orderLimit, onOrderLimitChanged),
          ],
        ),
        SizedBox(height: 10.h),
        _searchAndRecord(),
        SizedBox(height: 10.h),
        Expanded(
          child: ExchangeSettingsDataTable(
            data: settings,
            selectedIds: selectedIds,
            onSelectionChanged: onSelectionChanged,
            columns: [
              ViewTableColumn(id: 'exchange', label: 'EXCHANGE', width: 120.w),
              ViewTableColumn(
                id: 'orderType',
                label: 'ORDER TYPE',
                width: 250.w,
              ),
              ViewTableColumn(
                id: 'updatedOn',
                label: 'UPDATED ON',
                width: 220.w,
              ),
              ViewTableColumn(
                id: 'updatedBy',
                label: 'UPDATED BY',
                width: 150.w,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _searchAndRecord() => Row(
    children: [
      CustomInputField(
        hintText: 'Search',
        controller: searchCtrl,
        prefixSvgPath: AppImages.searchIcon,
        width: 200.w,
        height: 35.h,
        onChanged: onSearchChanged,
      ),
      const Spacer(),
      Text(
        'RECORD : ${settings.length}',
        style: GoogleFonts.openSans(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryBlue,
        ),
      ),
    ],
  );

  Widget _updateButton() => CustomActionButton(
    text: 'Update',
    onPressed: onUpdatePressed,
    width: 100.w,
    height: 35.h,
    borderRadius: 8.r,
  );

  Widget _checkOption(String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: value,
          onChanged: (v) => onChanged(v ?? false),
          activeColor: AppColors.primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.r),
          ),
        ),
        Text(
          label,
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            color: AppColors.primaryBlue,
          ),
        ),
      ],
    );
  }

  TextStyle _labelStyle() => GoogleFonts.openSans(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryBlue,
  );
}
