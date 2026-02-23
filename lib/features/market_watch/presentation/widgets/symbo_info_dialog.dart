import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widget/common_dilog_box.dart';
import '../../domain/entities/market_item.dart';
import '../bloc/theme/theme_bloc.dart';
import '../bloc/theme/theme_state.dart' show ThemeState;
class SymbolInfoDialog extends StatelessWidget {
  final MarketItem item;
  const SymbolInfoDialog({Key? key, required this.item}) : super(key: key);
  static void show(BuildContext context, MarketItem item) {
    final themeBloc = context.read<ThemeBloc>();
    final isDark = themeBloc.state.isDarkMode;
    CommonDialog.show(
      context: context,
      title: 'Symbol Info',
      width: 400.w,
      content: _SymbolInfoContent(item: item, isDark: isDark),
      showButtons: false,
      isDarkMode: isDark,
      headerColor: AppColors.primaryBlue,
      backgroundColor: isDark
          ? DarkThemeColors.cardBackground
          : LightThemeColors.cardBackground,
      contentPadding: EdgeInsets.zero,
    );
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        final isDark = themeState.isDarkMode;
        return CommonDialog(
          title: 'Symbol Info',
          content: _SymbolInfoContent(item: item, isDark: isDark),
          width: 400.w,
          showButtons: false,
          isDarkMode: isDark,
          headerColor: AppColors.primaryBlue,
          backgroundColor: isDark
              ? DarkThemeColors.cardBackground
              : LightThemeColors.cardBackground,
          contentPadding: EdgeInsets.zero,
        );
      },
    );
  }
}
class _SymbolInfoContent extends StatelessWidget {
  final MarketItem item;
  final bool isDark;
  const _SymbolInfoContent({Key? key, required this.item, required this.isDark})
    : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [_buildDivider(), _buildInfoList()],
    );
  }
  Widget _buildDivider() {
    return Container(
      height: 1.h,
      color: isDark
          ? DarkThemeColors.dividerColor
          : LightThemeColors.dividerColor,
    );
  }
  Widget _buildInfoList() {
    final infoItems = [
      {'label': 'Exchange Name', 'value': item.exchange},
      {'label': 'Symbol Name', 'value': item.symbol},
      {
        'label': 'Expiry Date',
        'value': item.expiry != null
            ? DateFormat('dd/MM/yy').format(item.expiry!)
            : 'N/A',
      },
      {'label': 'Lotsize', 'value': '10'},
      {'label': 'Trade Margin', 'value': '6'},
      {'label': 'Trade Attribute', 'value': 'Full'},
      {'label': 'Odd Lot Trade', 'value': 'Yes'},
      {
        'label': 'Max Qty.',
        'value': _formatQuantity(item.buyQty + item.sellQty),
      },
      {'label': 'Breakup Qty.', 'value': '500'},
      {'label': 'Max Lot', 'value': '0'},
      {'label': 'Breakup Lot', 'value': '0'},
    ];
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        children: infoItems.map((info) {
          return _buildInfoRow(info['label']!, info['value']!);
        }).toList(),
      ),
    );
  }
  Widget _buildInfoRow(String label, String value) {
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
