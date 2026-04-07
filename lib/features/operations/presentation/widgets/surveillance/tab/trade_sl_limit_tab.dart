import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_images.dart';
import '../../../../../../core/widget/app_dropdown.dart';
import '../../../../../../core/widget/custom_action_button.dart';
import '../../../../../../core/widget/custom_input_field.dart';
import '../bulk_order_data_table.dart';
import '../../../../domain/entities/surveillance/surveillance_bulk_order.dart';

class TradeSlLimitTab extends StatelessWidget {
  final List<String> exchanges;
  final String? selectedExchange;
  final ValueChanged<String?> onExchangeChanged;
  final TextEditingController tradeLimitController;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final List<SurveillanceBulkOrder> filteredOrders;
  final Set<String> selectedIds;
  final ValueChanged<Set<String>> onSelectionChanged;
  final VoidCallback onImportPressed;
  final VoidCallback onUpdatePressed;
  final bool isBusy;

  const TradeSlLimitTab({
    super.key,
    required this.exchanges,
    required this.selectedExchange,
    required this.onExchangeChanged,
    required this.tradeLimitController,
    required this.searchController,
    required this.onSearchChanged,
    required this.filteredOrders,
    required this.selectedIds,
    required this.onSelectionChanged,
    required this.onImportPressed,
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
                      hintText: 'Exchange',
                      items: exchanges,
                      value: selectedExchange,
                      onChanged: onExchangeChanged,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text('Trade SL/Limit (%)', style: _labelStyle()),
                  SizedBox(height: 6.h),
                  CustomInputField(
                    hintText: '0.05',
                    controller: tradeLimitController,
                    width: 280.w,
                    height: 35.h,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  CustomInputField(
                    hintText: 'Search',
                    controller: searchController,
                    prefixSvgPath: AppImages.searchIcon,
                    width: 200.w,
                    height: 35.h,
                    onChanged: onSearchChanged,
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            Column(
              children: [
                CustomActionButton(
                  text: 'Import',
                  onPressed: onImportPressed,
                  width: 100.w,
                  height: 35.h,
                  borderRadius: 8.r,
                ),
                SizedBox(height: 10.h),
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
        ),
        SizedBox(height: 10.h),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'RECORD : ${filteredOrders.length}',
            style: GoogleFonts.openSans(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlue,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Expanded(
          child: BulkOrderDataTable(
            data: filteredOrders,
            selectedIds: selectedIds,
            onSelectionChanged: onSelectionChanged,
          ),
        ),
      ],
    );
  }

  TextStyle _labelStyle() => GoogleFonts.openSans(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryBlue,
  );
}
