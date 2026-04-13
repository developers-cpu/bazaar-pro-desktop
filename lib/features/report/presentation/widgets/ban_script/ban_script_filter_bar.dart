import 'package:bazarpro/core/widget/app_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../bloc/ban_script/ban_script_bloc.dart';
import '../../bloc/ban_script/ban_script_event.dart';
import '../../bloc/ban_script/ban_script_state.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_state.dart';

class BanScriptFilterBar extends StatefulWidget {
  final String banType;
  const BanScriptFilterBar({super.key, required this.banType});

  @override
  State<BanScriptFilterBar> createState() => _BanScriptFilterBarState();
}

class _BanScriptFilterBarState extends State<BanScriptFilterBar> {
  String? _tempExchange;
  bool _isInitialized = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: BlocBuilder<BanScriptBloc, BanScriptState>(
        builder: (context, state) {
          if (!_isInitialized && state is BanScriptLoaded) {
            _tempExchange = state.currentExchange;
            _isInitialized = true;
          }

          final viewButton = SizedBox(
            height: 35.h,
            width: 100.w,
            child: ElevatedButton(
              onPressed: () {
                context.read<BanScriptBloc>().add(
                  FetchBanScriptEvent(
                    exchange: _tempExchange,
                    banType: widget.banType,
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
                });
                context.read<BanScriptBloc>().add(
                  FetchBanScriptEvent(banType: widget.banType),
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
            items: const ['NSE', 'MCX', 'CE/PE', 'GIFT', 'CRYPTO', 'OTHERS'],
            value: _tempExchange,
            onChanged: (value) {
              setState(() {
                _tempExchange = value;
              });
            },
            width: 200.w,
            height: 35.h,
          );

          final authState = context.read<AuthBloc>().state;
          final isClient = authState is AuthAuthenticated &&
              authState.user.role.toLowerCase() == 'client';

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
