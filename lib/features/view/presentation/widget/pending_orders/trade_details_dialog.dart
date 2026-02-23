import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../domain/entities/pending_orders/pending_order.dart';
import '../../../../../core/widget/table/animated_price_box.dart';
import 'delete_order_dialog.dart';
import 'modify_order_dialog.dart';
class TradeDetailsDialog extends StatelessWidget {
  final PendingOrder order;
  final bool isDarkMode;
  const TradeDetailsDialog({
    Key? key,
    required this.order,
    this.isDarkMode = false,
  }) : super(key: key);
  static void show({
    required BuildContext context,
    required PendingOrder order,
    bool isDarkMode = false,
  }) {
    showDialog(
      context: context,
      barrierColor: AppColors.black.withOpacity(0.54),
      builder: (_) => TradeDetailsDialog(order: order, isDarkMode: isDarkMode),
    );
  }
  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: 'Trade Details',
      isDarkMode: isDarkMode,
      width: 500.w,
      headerColor: AppColors.primaryBlue,
      showButtons: false,
      scrollable: false,
      contentPadding: EdgeInsets.zero,
      content: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.symbol,
                          style: GoogleFonts.openSans(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2C5F7A),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Q.${order.qty.toStringAsFixed(6)}',
                          style: GoogleFonts.openSans(
                            fontSize: 14.sp,
                            color: const Color(0xFF2C5F7A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedPriceBox(
                        price: order.triggerPrice.toStringAsFixed(0),
                        isDarkMode: isDarkMode,
                      ),
                      SizedBox(width: 8.w),
                      AnimatedPriceBox(
                        price: order.triggerPrice.toStringAsFixed(0),
                        isDarkMode: isDarkMode,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.greyBorder),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                order.userId,
                style: GoogleFonts.openSans(
                  fontSize: 16.sp,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 45.h,
                    child: ElevatedButton(
                      onPressed: () {
                        ModifyOrderDialog.show(
                          context: context,
                          order: order,
                          isDarkMode: isDarkMode,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'Modify Order',
                        style: GoogleFonts.openSans(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: SizedBox(
                    height: 45.h,
                    child: ElevatedButton(
                      onPressed: () {
                        DeleteOrderDialog.show(
                          context: context,
                          order: order,
                          isDarkMode: isDarkMode,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'Cancel Order',
                        style: GoogleFonts.openSans(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
