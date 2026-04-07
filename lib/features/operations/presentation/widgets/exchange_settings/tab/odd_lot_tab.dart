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

class OddLotTab extends StatelessWidget {
  final bool selectTypeYes;
  final ValueChanged<bool> onSelectTypeChanged;
  final TextEditingController searchCtrl;
  final ValueChanged<String> onSearchChanged;
  final List<ExchangeSetting> settings;
  final Set<String> selectedIds;
  final ValueChanged<Set<String>> onSelectionChanged;
  final VoidCallback onUpdatePressed;

  const OddLotTab({
    super.key,
    required this.selectTypeYes,
    required this.onSelectTypeChanged,
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
            Text('Select  Type', style: _labelStyle()),
            const Spacer(),
            _updateButton(),
          ],
        ),
        SizedBox(height: 5.h),
        Row(
          children: [
            _radioOption('Yes', selectTypeYes, () => onSelectTypeChanged(true)),
            SizedBox(width: 10.w),
            _radioOption(
              'No',
              !selectTypeYes,
              () => onSelectTypeChanged(false),
            ),
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
              ViewTableColumn(id: 'oddLot', label: 'ODD LOT', width: 200.w),
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
  Widget _radioOption(String label, bool selected, VoidCallback onTap) =>
      InkWell(
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
  TextStyle _labelStyle() => GoogleFonts.openSans(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryBlue,
  );
}
