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

class AutoTickSizeTab extends StatelessWidget {
  final bool autoTickYes;
  final ValueChanged<bool> onAutoTickChanged;
  final TextEditingController tickSizeCtrl;
  final TextEditingController searchCtrl;
  final ValueChanged<String> onSearchChanged;
  final List<ExchangeSetting> settings;
  final List<AutoTickSymbolDetail> detailSettings;
  final Set<String> selectedIds;
  final ValueChanged<Set<String>> onSelectionChanged;
  final VoidCallback onUpdatePressed;
  final String? selectedExchange;
  final ValueChanged<String> onExchangeTap;
  final VoidCallback onBack;

  const AutoTickSizeTab({
    super.key,
    required this.autoTickYes,
    required this.onAutoTickChanged,
    required this.tickSizeCtrl,
    required this.searchCtrl,
    required this.onSearchChanged,
    required this.settings,
    required this.detailSettings,
    required this.selectedIds,
    required this.onSelectionChanged,
    required this.onUpdatePressed,
    required this.selectedExchange,
    required this.onExchangeTap,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final isDetailView = selectedExchange != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isDetailView) ...[
          Row(
            children: [
              InkWell(
                onTap: onBack,
                child: Icon(
                  Icons.arrow_back,
                  size: 24.sp,
                  color: AppColors.primaryBlue,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'Exchange Settings  (${selectedExchange!})',
               style: GoogleFonts.openSans(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
        ],
        Row(
          children: [
            Text('Auto Tick Size', style: _labelStyle()),
            SizedBox(width: 80.w),
            Text('Tick Size (If No)', style: _labelStyle()),
            const Spacer(),
            _updateButton(),
          ],
        ),
        SizedBox(height: 5.h),
        Row(
          children: [
            _radioOption('Yes', autoTickYes, () => onAutoTickChanged(true)),
            SizedBox(width: 10.w),
            _radioOption('No', !autoTickYes, () => onAutoTickChanged(false)),
            SizedBox(width: 40.w),
            CustomInputField(
              hintText: '0.05',
              controller: tickSizeCtrl,
              width: 200.w,
              height: 35.h,
            ),
          ],
        ),
        SizedBox(height: 10.h),
        _searchAndRecord(
          isDetailView ? detailSettings.length : settings.length,
        ),
        SizedBox(height: 10.h),
        Expanded(
          child: ExchangeSettingsDataTable(
            data: isDetailView ? detailSettings : settings,
            selectedIds: selectedIds,
            onSelectionChanged: onSelectionChanged,
            columns: isDetailView ? _detailColumns() : _summaryColumns(),
            tappableColumns: isDetailView ? const {} : const {'exchange'},
            onCellTap: isDetailView
                ? null
                : (item) {
                    if (item is ExchangeSetting) {
                      onExchangeTap(item.exchange);
                    }
                  },
          ),
        ),
      ],
    );
  }

  List<ViewTableColumn> _summaryColumns() {
    return [
      ViewTableColumn(id: 'exchange', label: 'EXCHANGE', width: 120.w),
      ViewTableColumn(
        id: 'autoTickSize',
        label: 'AUTO TICK SIZE',
        width: 200.w,
      ),
      ViewTableColumn(id: 'tickSize', label: 'TICK SIZE', width: 150.w),
      ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 220.w),
      ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 150.w),
    ];
  }

  List<ViewTableColumn> _detailColumns() {
    return [
      ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 180.w),
      ViewTableColumn(
        id: 'autoTickSize',
        label: 'AUTO TICK SIZE',
        width: 200.w,
      ),
      ViewTableColumn(id: 'tickSize', label: 'TICK SIZE', width: 150.w),
      ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 220.w),
      ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 150.w),
    ];
  }

  Widget _searchAndRecord(int recordCount) {
    return Row(
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
          'RECORD : $recordCount',
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryBlue,
          ),
        ),
      ],
    );
  }

  Widget _updateButton() => CustomActionButton(
    text: 'Update',
    onPressed: onUpdatePressed,
    width: 100.w,
    height: 35.h,
    borderRadius: 8.r,
  );

  Widget _radioOption(String label, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<bool>(
            value: true,
            groupValue: selected,
            onChanged: (_) => onTap(),
            activeColor: AppColors.primaryBlue,
          ),
          Text(
            label,
            style: GoogleFonts.openSans(
              fontSize: 12.sp,
              color: AppColors.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _labelStyle() => GoogleFonts.openSans(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryBlue,
  );
}
