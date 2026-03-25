import 'package:bazarpro/core/widget/app_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../bloc/expiry_report/expiry_report_bloc.dart';
import '../../bloc/expiry_report/expiry_report_event.dart';
import '../../bloc/expiry_report/expiry_report_state.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_state.dart';

class ExpiryReportFilterBar extends StatefulWidget {
  const ExpiryReportFilterBar({super.key});

  @override
  State<ExpiryReportFilterBar> createState() => _ExpiryReportFilterBarState();
}

class _ExpiryReportFilterBarState extends State<ExpiryReportFilterBar> {
  String? _tempExchange;
  String? _tempMonth;
  bool _isInitialized = false;

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final isClient = authState is AuthAuthenticated &&
        authState.user.role.toLowerCase() == 'client';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: BlocBuilder<ExpiryReportBloc, ExpiryReportState>(
        builder: (context, state) {
          if (!_isInitialized && state is ExpiryReportLoaded) {
            _tempExchange = state.currentExchange;
            _tempMonth = state.currentMonth;
            _isInitialized = true;
          }

          final List<String> months = [
            'January', 'February', 'March', 'April', 'May', 'June',
            'July', 'August', 'September', 'October', 'November', 'December'
          ];

          final viewButton = SizedBox(
            height: 35.h,
            width: 100.w,
            child: ElevatedButton(
              onPressed: () {
                context.read<ExpiryReportBloc>().add(
                  LoadExpiryReport(
                    exchange: _tempExchange,
                    month: _tempMonth,
                  ),
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
                'View',
                style: GoogleFonts.openSans(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ),
          );

          final resetButton = SizedBox(
            height: 35.h,
            width: 100.w,
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  _tempExchange = null;
                  _tempMonth = null;
                });
                context.read<ExpiryReportBloc>().add(
                  const LoadExpiryReport(),
                );
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
          );

          final exchangeDropdown = AppDropdown(
            hintText: 'Exchange',
            items: const ['NSE', 'MCX'],
            value: _tempExchange,
            onChanged: (value) {
              setState(() {
                _tempExchange = value;
              });
            },
            width: 200.w,
            height: 35.h,
          );

          final monthDropdown = AppDropdown(
            hintText: 'Month',
            items: months,
            value: _tempMonth,
            onChanged: (value) {
              setState(() {
                _tempMonth = value;
              });
            },
            width: 200.w,
            height: 35.h,
          );

          if (isClient) {
            return Row(
              children: [
                exchangeDropdown,
                SizedBox(width: 16.w),
                monthDropdown,
                SizedBox(width: 16.w),
                viewButton,
              ],
            );
          }
          return Row(
            children: [
              exchangeDropdown,
              SizedBox(width: 16.w),
              monthDropdown,
              const Spacer(),
              resetButton,
              SizedBox(width: 16.w),
              viewButton,
            ],
          );
        },
      ),
    );
  }
}
