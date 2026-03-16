import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../../../../core/widget/app_date_picker.dart';
import '../../../../../core/widget/custom_action_button.dart';
import 'import_date_settings_dialog.dart';
class DateSettingsHeaders extends StatefulWidget {
  final String selectedMonth;
  final ValueChanged<String> onMonthChanged;
  const DateSettingsHeaders({
    super.key,
    required this.selectedMonth,
    required this.onMonthChanged,
  });
  @override
  State<DateSettingsHeaders> createState() => _DateSettingsHeadersState();
}
class _DateSettingsHeadersState extends State<DateSettingsHeaders> {
  DateTime? _expiryDate;
  DateTime? _launchDate;
  DateTime? _closeDate;
  final _months = const [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: 200.w,
              child: AppDropdown(
                hintText: 'Select Month',
                items: _months,
                value: widget.selectedMonth,
                onChanged: (val) {
                  if (val != null && val.isNotEmpty) {
                    widget.onMonthChanged(val);
                  }
                },
                type: AppDropdownType.simple,
                width: 200.w,
                height: 35.h,
              ),
            ),
            const Spacer(),
            CustomActionButton(
              text: 'Import',
              onPressed: () => _showImportDialog(context),
              width: 100.w,
              height: 35.h,
              borderRadius: 8.r,
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AppDatePicker(
              label: 'Expiry Date',
              value: _expiryDate,
              onChanged: (d) => setState(() => _expiryDate = d),
              width: 200.w,
              height: 35.h,
            ),
            SizedBox(width: 15.w),
            AppDatePicker(
              label: 'Launch Date',
              value: _launchDate,
              onChanged: (d) => setState(() => _launchDate = d),
              width: 200.w,
              height: 35.h,
            ),
            SizedBox(width: 15.w),
            AppDatePicker(
              label: 'Close date',
              value: _closeDate,
              onChanged: (d) => setState(() => _closeDate = d),
              width: 200.w,
              height: 35.h,
            ),
            const Spacer(),
            CustomActionButton(
              text: 'Update',
              onPressed: () {},
              width: 100.w,
              height: 35.h,
              borderRadius: 8.r,
            ),
          ],
        ),
      ],
    );
  }
  void _showImportDialog(BuildContext context) {
    ImportDateSettingsDialog.show(context);
  }
}
