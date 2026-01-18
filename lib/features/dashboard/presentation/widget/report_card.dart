import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widget/app_dropdown.dart';
import 'exchange_chips.dart';

/// Report Card Widget
class ReportCard extends StatelessWidget {
  final String title;
  final Widget chart;
  final List<String> clients;
  final String? selectedClient;
  final ValueChanged<String?> onClientChanged;
  final List<String> periods;
  final String selectedPeriod;
  final ValueChanged<String?> onPeriodChanged;
  final List<String> exchanges;
  final Set<String> selectedExchanges;
  final ValueChanged<String> onExchangeToggle;
  final List<int>? topCounts;
  final int? selectedTopCount;
  final ValueChanged<String?>? onTopCountChanged;

  const ReportCard({
    Key? key,
    required this.title,
    required this.chart,
    required this.clients,
    this.selectedClient,
    required this.onClientChanged,
    required this.periods,
    required this.selectedPeriod,
    required this.onPeriodChanged,
    required this.exchanges,
    required this.selectedExchanges,
    required this.onExchangeToggle,
    this.topCounts,
    this.selectedTopCount,
    this.onTopCountChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: LightThemeColors.primaryColor,
          width: 1.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: _buildHeader(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: ExchangeChips(
              exchanges: exchanges,
              selectedExchanges: selectedExchanges,
              onToggle: onExchangeToggle,
            ),
          ),
          SizedBox(height: 12.h),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
              child: chart,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate if dropdowns can fit in one row
        final dropdownWidth = 140.w;
        final spacing = 12.w;
        final numDropdowns = topCounts != null ? 3 : 2;
        final requiredWidth = (dropdownWidth * numDropdowns) + (spacing * (numDropdowns - 1));
        final canFitInRow = constraints.maxWidth > requiredWidth + 100.w;

        if (canFitInRow) {
          return Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.openSans(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: LightThemeColors.textColor,
                  ),
                ),
              ),
              _buildDropdowns(dropdownWidth),
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.openSans(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: LightThemeColors.textColor,
                ),
              ),
              SizedBox(height: 12.h),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _buildDropdowns(dropdownWidth),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildDropdowns(double dropdownWidth) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppDropdown(
          type: AppDropdownType.search,
          hintText: 'Client',
          value: selectedClient,
          items: clients,
          width: dropdownWidth,
          searchHint: 'Search & Add',
          onChanged: onClientChanged,
        ),
        SizedBox(width: 12.w),
        AppDropdown(
          type: AppDropdownType.simple,
          hintText: 'Period',
          value: selectedPeriod,
          items: periods,
          width: dropdownWidth,
          onChanged: onPeriodChanged,
        ),
        if (topCounts != null && onTopCountChanged != null) ...[
          SizedBox(width: 12.w),
          AppDropdown(
            type: AppDropdownType.simple,
            hintText: 'Top',
            value: selectedTopCount?.toString(),
            items: topCounts!.map((e) => e.toString()).toList(),
            width: dropdownWidth,
            onChanged: onTopCountChanged,
          ),
        ],
      ],
    );
  }
}