import 'package:bazarpro/core/widget/app_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../bloc/bill_generate/bill_generate_bloc.dart';
import '../../bloc/bill_generate/bill_generate_event.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_state.dart';
import '../../../../../../core/widget/date_range_picker_dialog.dart';

import 'package:intl/intl.dart';

class BillGenerateFilterBar extends StatefulWidget {
  const BillGenerateFilterBar({super.key});

  @override
  State<BillGenerateFilterBar> createState() => _BillGenerateFilterBarState();
}

class _BillGenerateFilterBarState extends State<BillGenerateFilterBar> {
  String _customPeriodLabel = 'Select Date Range';
  String _selectedDateRange = 'This Week';
  String? _selectedUserType;
  String? _selectedUser;
  String? _selectedBillType;
  String? _selectedBillFormat;

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final isClient =
        authState is AuthAuthenticated &&
        authState.user.role.toLowerCase() == 'client';

    final rowChildren = <Widget>[
      AppDropdown(
        width: 200.w,
        hintText: 'This Week',
        value: _selectedDateRange,
        items: const ['This Week', 'Previous Week', 'Custom Period'],
        subtitles: [
          '27-10-25 to 02-11-25',
          '20-10-25 to 26-10-25',
          _customPeriodLabel,
        ],
        onChanged: (value) async {
          if (value == 'Custom Period') {
            final DateTimeRange? picked =
                await CustomDateRangePickerDialog.show(
                  context,
                  showSimpleUI: true,
                );
            if (picked != null) {
              setState(() {
                _selectedDateRange = value!;
                _customPeriodLabel =
                    '${DateFormat('dd-MM-yy').format(picked.start)} to ${DateFormat('dd-MM-yy').format(picked.end)}';
              });
            }
          } else if (value != null) {
            setState(() {
              _selectedDateRange = value;
            });
          }
        },
        height: 35.h,
      ),
      SizedBox(width: 16.w),
      if (!isClient) ...[
        AppDropdown(
          width: 200.w,
          hintText: 'User Type',
          value: _selectedUserType,
          items: const ['Master', 'Client'],
          onChanged: (value) {
            setState(() {
              _selectedUserType = value;
            });
          },
          height: 35.h,
        ),
        SizedBox(width: 16.w),
      ],
      if (!isClient) ...[
        AppDropdown(
          width: 200.w,
          hintText: 'User',
          value: _selectedUser,
          items: const ['User 1', 'User 2', 'User 3'],
          type: AppDropdownType.search,
          searchHint: 'Search & Add',
          onChanged: (value) {
            setState(() {
              _selectedUser = value;
            });
            context.read<BillGenerateBloc>().add(
              FilterBillGenerateReport(userId: value),
            );
          },
          height: 35.h,
        ),
        SizedBox(width: 16.w),
      ],
      AppDropdown(
        width: 200.w,
        hintText: 'Bill Type',
        value: _selectedBillType,
        items: const ['Advance', 'Regular'],
        onChanged: (value) {
          setState(() {
            _selectedBillType = value;
          });
          context.read<BillGenerateBloc>().add(
            FilterBillGenerateReport(billType: value),
          );
        },
        height: 35.h,
      ),
      SizedBox(width: 16.w),
      AppDropdown(
        width: 200.w,
        hintText: 'Bill Format',
        value: _selectedBillFormat,
        items: const ['PDF', 'Excel'],
        onChanged: (value) {
          setState(() {
            _selectedBillFormat = value;
          });
          context.read<BillGenerateBloc>().add(
            FilterBillGenerateReport(billFormat: value),
          );
        },
        height: 35.h,
      ),
      if (isClient) const Spacer() else const Spacer(),
      SizedBox(
        height: 35.h,
        width: 100.w,
        child: OutlinedButton(
          onPressed: () {
            setState(() {
              _selectedDateRange = 'This Week';
              _selectedUserType = null;
              _selectedUser = null;
              _selectedBillType = null;
              _selectedBillFormat = null;
            });
            context.read<BillGenerateBloc>().add(
              const LoadBillGenerateReport(),
            );
          },
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColors.primaryBlue),
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
        width: 120.w,
        child: ElevatedButton(
          onPressed: () {
            context.read<BillGenerateBloc>().add(
              const LoadBillGenerateReport(shouldExport: true),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1F4A66),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            padding: EdgeInsets.zero,
          ),
          child: Text(
            'Generate',
            style: GoogleFonts.openSans(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      width: double.infinity,
      child: Row(children: rowChildren),
    );
  }
}
