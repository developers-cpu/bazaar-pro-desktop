import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/market_item.dart';
import '../bloc/theme/theme_bloc.dart';
import '../bloc/theme/theme_state.dart' show ThemeState;

class SymbolInfoDialog extends StatelessWidget {
  final MarketItem item;

  const SymbolInfoDialog({Key? key, required this.item}) : super(key: key);

  static void show(BuildContext context, MarketItem item) {
    showDialog(
      context: context,
      barrierColor: AppColors.black.withOpacity(0.54),
      builder: (_) => BlocProvider.value(
        value: context.read<ThemeBloc>(),
        child: SymbolInfoDialog(item: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        final isDark = themeState.isDarkMode;

        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w), // or EdgeInsets.zero
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Container(
              width: 400.w,
              decoration: BoxDecoration(
                color: isDark
                    ? DarkThemeColors.cardBackground
                    : LightThemeColors.cardBackground,
                borderRadius: BorderRadius.circular(16.r),

              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(context, isDark),
                  _buildDivider(isDark),
                  _buildInfoList(isDark),
                ],
              ),
            ),
          ),
        );

      },
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.r),
        topRight: Radius.circular(16.r),
      ),
      child: Container(
        height: 60.h,
        color: AppColors.primaryBlue,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          children: [
            // Title
            Expanded(
              child: Text(
                'Symbol Info',
                style: GoogleFonts.openSans(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ),

            // Close button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.close,
                size: 22.sp,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildDivider(bool isDark) {
    return Container(
      height: 1.h,
      color: isDark
          ? DarkThemeColors.dividerColor
          : LightThemeColors.dividerColor,
    );
  }

  Widget _buildInfoList(bool isDark) {
    final infoItems = [
      {'label': 'Exchange Name', 'value': item.exchange},
      {'label': 'Symbol Name', 'value': item.symbol},
      {
        'label': 'Expiry Date',
        'value': item.expiry != null
            ? DateFormat('dd/MM/yy').format(item.expiry!)
            : 'N/A'
      },
      {'label': 'Lotsize', 'value': '10'},
      {'label': 'Trade Margin', 'value': '6'},
      {'label': 'Trade Attribute', 'value': 'Full'},
      {'label': 'Odd Lot Trade', 'value': 'Yes'},
      {'label': 'Max Qty.', 'value': _formatQuantity(item.buyQty + item.sellQty)},
      {'label': 'Breakup Qty.', 'value': '500'},
      {'label': 'Max Lot', 'value': '0'},
      {'label': 'Breakup Lot', 'value': '0'},
    ];

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        children: infoItems.map((info) {
          return _buildInfoRow(
            info['label']!,
            info['value']!,
            isDark,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? DarkThemeColors.dividerColor.withOpacity(0.3)
                : LightThemeColors.dividerColor.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.openSans(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? DarkThemeColors.textColor
                  : LightThemeColors.textColor,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.openSans(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? DarkThemeColors.positiveTextColor
                  : LightThemeColors.textColor,
            ),
          ),
        ],
      ),
    );
  }

  String _formatQuantity(int value) {
    return NumberFormat('#,###').format(value);
  }
}