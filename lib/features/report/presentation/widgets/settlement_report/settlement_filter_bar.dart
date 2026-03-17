import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/app_dropdown.dart';
import '../../../../../../core/widget/date_range_picker_dialog.dart';

class SettlementFilterBar extends StatefulWidget {
  final ValueChanged<String?> onDateRangeChanged;
  final VoidCallback onReset;
  final VoidCallback onView;
  const SettlementFilterBar({
    super.key,
    required this.onDateRangeChanged,
    required this.onReset,
    required this.onView,
  });
  @override
  State<SettlementFilterBar> createState() => _SettlementFilterBarState();
}

class _SettlementFilterBarState extends State<SettlementFilterBar> {
  String _selectedDateRange = 'This Week';
  String _customPeriodLabel = 'Select Date Range';

  String _weekLabel(DateTime monday) {
    final sunday = monday.add(const Duration(days: 6));
    final fmt = DateFormat('dd-MM-yy');
    return '${fmt.format(monday)} to ${fmt.format(sunday)}';
  }

  String get _thisWeekLabel {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return _weekLabel(monday);
  }

  String get _previousWeekLabel {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1 + 7));
    return _weekLabel(monday);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          AppDropdown(
            width: 200.w,
            height: 35.h,
            hintText: 'This Week',
            value: _selectedDateRange,
            items: const ['This Week', 'Previous Week', 'Custom Period'],
            subtitles: [_thisWeekLabel, _previousWeekLabel, _customPeriodLabel],
            onChanged: (value) async {
              if (value == 'Custom Period') {
                final DateTimeRange? picked =
                    await CustomDateRangePickerDialog.show(
                      context,
                      showSimpleUI: true,
                    );
                if (picked != null) {
                  setState(() {
                    _selectedDateRange = 'Custom Period';
                    _customPeriodLabel =
                        '${DateFormat('dd-MM-yy').format(picked.start)} to ${DateFormat('dd-MM-yy').format(picked.end)}';
                  });
                  widget.onDateRangeChanged('Custom Period');
                }
              } else if (value != null) {
                setState(() {
                  _selectedDateRange = value;
                });
                widget.onDateRangeChanged(value);
              }
            },
          ),
          const Spacer(),
          SizedBox(
            height: 35.h,
            width: 100.w,
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  _selectedDateRange = 'This Week';
                  _customPeriodLabel = 'Select Date Range';
                });
                widget.onReset();
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primaryBlue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.zero,
              ),
              child: Text(
                'Reset',
                style: GoogleFonts.openSans(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          SizedBox(
            height: 35.h,
            width: 100.w,
            child: ElevatedButton(
              onPressed: widget.onView,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1F4A66),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.zero,
              ),
              child: Text(
                'View',
                style: GoogleFonts.openSans(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
