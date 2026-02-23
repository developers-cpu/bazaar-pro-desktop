import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';

class TradeSettingsTabBar extends StatelessWidget {
  final List<String> tabs;
  final int activeTab;
  final ValueChanged<int> onTabChanged;

  const TradeSettingsTabBar({
    super.key,
    required this.tabs,
    required this.activeTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(tabs.length, (i) {
          final selected = activeTab == i;
          return GestureDetector(
            onTap: () => onTabChanged(i),
            child: Padding(
              padding: EdgeInsets.only(right: 30.w),
              child: Container(
                padding: EdgeInsets.only(bottom: 6.h),
                decoration: BoxDecoration(
                  border: selected
                      ? Border(
                          bottom: BorderSide(
                            color: AppColors.primaryBlue,
                            width: 1.5,
                          ),
                        )
                      : null,
                ),
                child: Text(
                  tabs[i],
                  style: GoogleFonts.openSans(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: selected
                        ? AppColors.primaryBlue
                        : AppColors.primaryBlue.withOpacity(0.6),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
