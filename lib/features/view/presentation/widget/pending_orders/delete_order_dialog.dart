import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../../../core/widget/custom_action_button.dart';
import '../../../../../core/widget/custom_outlined_button.dart';
import '../../../domain/entities/pending_orders/pending_order.dart';
import '../../../../../core/widget/table/success_dialog.dart';

class DeleteOrderDialog extends StatelessWidget {
  final PendingOrder order;
  final bool isDarkMode;
  const DeleteOrderDialog({
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
      builder: (_) => DeleteOrderDialog(order: order, isDarkMode: isDarkMode),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: 'Delete Order',
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
            Text(
              'Are You Sure you want to Delete this  Order ?',
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 18.sp,
                color: const Color(0xFF1F4A66),
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
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.symbol,
                        style: GoogleFonts.openSans(
                          fontSize: 16.sp,
                          color: const Color(0xFF2C5F7A),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        order.buySell,
                        style: GoogleFonts.openSans(
                          fontSize: 14.sp,
                          color: order.buySell.toUpperCase().startsWith('BUY')
                              ? AppColors.blue
                              : AppColors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Q.${order.qty.toStringAsFixed(6)}',
                  style: GoogleFonts.openSans(
                    fontSize: 14.sp,
                    color: const Color(0xFF2C5F7A),
                  ),
                ),
                SizedBox(width: 16.w),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(color: AppColors.greyBorder),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    order.triggerPrice.toStringAsFixed(0),
                    style: GoogleFonts.openSans(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomOutlinedActionButton(
                  text: 'No',
                  width: 200.w,
                  height: 40.h,
                  borderRadius: 8.r,
                  fontSize: 14.sp,
                  borderColor: isDarkMode
                      ? Colors.white
                      : const Color(0xFF1F4A66),
                  textColor: isDarkMode
                      ? Colors.white
                      : const Color(0xFF1F4A66),
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(width: 16.w),
                CustomActionButton(
                  text: 'Yes',
                  width: 200.w,
                  height: 40.h,
                  borderRadius: 8.r,
                  fontSize: 14.sp,
                  backgroundColor: const Color(0xFF1F4A66),
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                    Future.delayed(Duration.zero, () {
                      SuccessDialog.show(
                        context: context,
                        title: 'Successful Deleted !',
                        subtitle: 'Your Order is Successfully Deleted',
                      );
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
