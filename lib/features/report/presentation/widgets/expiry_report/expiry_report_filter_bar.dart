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

class ExpiryReportFilterBar extends StatelessWidget {
  const ExpiryReportFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final isClient =
        authState is AuthAuthenticated &&
        authState.user.role.toLowerCase() == 'client';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: BlocBuilder<ExpiryReportBloc, ExpiryReportState>(
        builder: (context, state) {
          final selectedExchange =
              state is ExpiryReportLoaded ? state.currentExchange : null;

          final viewButton = SizedBox(
            height: 35.h,
            width: 100.w,
            child: ElevatedButton(
              onPressed: () {
                final currentState = context.read<ExpiryReportBloc>().state;
                final exchange = currentState is ExpiryReportLoaded
                    ? currentState.currentExchange
                    : null;
                context.read<ExpiryReportBloc>().add(
                  LoadExpiryReport(exchange: exchange),
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
            value: selectedExchange,
            onChanged: (value) {
              context.read<ExpiryReportBloc>().add(
                LoadExpiryReport(exchange: value),
              );
            },
            width: 200.w,
            height: 35.h,
          );

          if (isClient) {
            return Row(
              children: [
                exchangeDropdown,
                SizedBox(width: 16.w),
                viewButton,
              ],
            );
          }
          return Row(
            children: [
              exchangeDropdown,
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
