import 'package:bazarpro/core/widget/app_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../bloc/bill_generate/bill_generate_bloc.dart';
import '../../bloc/bill_generate/bill_generate_event.dart';
class BillGenerateFilterBar extends StatelessWidget {
  const BillGenerateFilterBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: AppDropdown(
              hintText: 'This Week',
              items: const ['This Week', 'Previous Week', 'Custom Period'],
              onChanged: (value) async {
                if (value == 'Custom Period') {
                  final DateTimeRange? picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) {}
                }
              },
              height: 40.h,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: AppDropdown(
              hintText: 'User Type',
              items: const ['Master', 'Client'],
              onChanged: (value) {},
              height: 40.h,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: AppDropdown(
              hintText: 'User',
              items: const ['User 1', 'User 2', 'User 3'],
              type: AppDropdownType.search,
              searchHint: 'Search & Add',
              onChanged: (value) {
                context.read<BillGenerateBloc>().add(
                  FilterBillGenerateReport(userId: value),
                );
              },
              height: 40.h,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: AppDropdown(
              hintText: 'Bill Format',
              items: const ['Advance', 'Regular'],
              onChanged: (value) {
                context.read<BillGenerateBloc>().add(
                  FilterBillGenerateReport(billFormat: value),
                );
              },
              height: 40.h,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: AppDropdown(
              hintText: 'Bill Type',
              items: const ['PDF', 'Excel'],
              onChanged: (value) {
                context.read<BillGenerateBloc>().add(
                  FilterBillGenerateReport(billType: value),
                );
              },
              height: 40.h,
            ),
          ),
          SizedBox(width: 16.w),
          SizedBox(
            height: 40.h,
            width: 100.w,
            child: OutlinedButton(
              onPressed: () {
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
            height: 40.h,
            width: 120.w,
            child: ElevatedButton(
              onPressed: () {
                context.read<BillGenerateBloc>().add(
                  const LoadBillGenerateReport(),
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
        ],
      ),
    );
  }
}
