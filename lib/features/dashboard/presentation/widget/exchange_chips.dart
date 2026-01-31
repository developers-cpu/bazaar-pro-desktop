import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';

class ExchangeChips extends StatelessWidget {
  final List<String> exchanges;
  final Set<String> selectedExchanges;
  final ValueChanged<String> onToggle;

  const ExchangeChips({
    Key? key,
    required this.exchanges,
    required this.selectedExchanges,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: exchanges.map((exchange) {
          final isSelected = selectedExchanges.contains(exchange);
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: _ExchangeChip(
              label: exchange,
              isSelected: isSelected,
              onTap: () => onToggle(exchange),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ExchangeChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ExchangeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: isSelected ? LightThemeColors.primaryColor : AppColors.transparent,
          borderRadius: BorderRadius.circular(8.r),

        ),
        child: Text(
          label,
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            color: isSelected ? AppColors.white : LightThemeColors.primaryColor,
          ),
        ),
      ),
    );
  }
}