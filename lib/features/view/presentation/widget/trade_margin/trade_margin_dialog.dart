import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../bloc/trade_margin/trade_margin_bloc.dart';
import '../../bloc/trade_margin/trade_margin_state.dart';
import 'trade_margin_filter_bar.dart';
import 'trade_margin_table.dart';
class TradeMarginDialog extends StatelessWidget {
  const TradeMarginDialog({super.key});
  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierColor: AppColors.black.withOpacity(0.54),
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<TradeMarginBloc>(context),
        child: const TradeMarginDialog(),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final bgColor = AppColors.cardBackground(context);
    final headerBgColor = AppColors.primaryColor(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: Container(
        width: 800.w,
        height: 750.h,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            _buildHeader(context, headerBgColor),
            SizedBox(height: 16.h),
            const TradeMarginFilterBar(),
            SizedBox(height: 8.h),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: BlocBuilder<TradeMarginBloc, TradeMarginState>(
                  builder: (context, state) {
                    if (state is TradeMarginLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is TradeMarginLoaded) {
                      return TradeMarginTable(tradeMargins: state.tradeMargins);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
  Widget _buildHeader(BuildContext context, Color headerBgColor) {
    return Container(
      width: double.infinity,
      height: 50.h,
      decoration: BoxDecoration(
        color: headerBgColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Trade Margin',
              style: GoogleFonts.openSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.close, size: 20.sp, color: AppColors.white),
          ),
        ],
      ),
    );
  }
}
