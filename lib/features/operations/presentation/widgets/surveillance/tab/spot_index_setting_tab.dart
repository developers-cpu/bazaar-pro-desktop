import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/app_dropdown.dart';
import '../../../../../../core/widget/custom_action_button.dart';

class SpotIndexSettingTab extends StatelessWidget {
  final List<String> options;
  final List<String> pendingSpotSymbols;
  final ValueChanged<List<String>> onPendingSymbolsChanged;
  final List<String> selectedSpotSymbols;
  final ValueChanged<String> onRemoveSymbol;
  final VoidCallback onUpdatePressed;
  final bool isBusy;

  const SpotIndexSettingTab({
    super.key,
    required this.options,
    required this.pendingSpotSymbols,
    required this.onPendingSymbolsChanged,
    required this.selectedSpotSymbols,
    required this.onRemoveSymbol,
    required this.onUpdatePressed,
    required this.isBusy,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 240.w,
                    child: AppDropdown(
                      type: AppDropdownType.multiSelect,
                      hintText: 'Symbol',
                      items: options,
                      selectedValues: pendingSpotSymbols,
                      showSelectedChipsInField: true,
                      showSelectAll: false,
                      searchHint: 'Search & Add',
                      onMultiChanged: onPendingSymbolsChanged,
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    'Selected Symbols',
                    style: GoogleFonts.openSans(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: selectedSpotSymbols
                        .map(
                          (symbol) => Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundColor,
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: AppColors.primaryBlue,
                                width: 1.2,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  symbol,
                                  style: GoogleFonts.openSans(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                GestureDetector(
                                  onTap: () => onRemoveSymbol(symbol),
                                  child: Container(
                                    width: 18.w,
                                    height: 18.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.primaryBlue,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      size: 12.sp,
                                      color: AppColors.primaryBlue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            CustomActionButton(
              text: 'Update',
              onPressed: isBusy ? () {} : onUpdatePressed,
              width: 100.w,
              height: 35.h,
              borderRadius: 8.r,
              isLoading: isBusy,
            ),
          ],
        ),
      ],
    );
  }
}
