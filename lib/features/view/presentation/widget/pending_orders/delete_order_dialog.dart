import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../domain/entities/pending_orders/pending_order.dart';
import '../common/animated_price_box.dart';
import '../common/success_dialog.dart';

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
      height: 350.h,
      headerColor: const Color(0xFF2C5F7A),
      showButtons: true,
      cancelText: 'No',
      saveText: 'Yes',
      autoPop: false,
      onCancel: () {
        Navigator.pop(context);
      },
      onSave: () {

        Navigator.pop(context);

        Future.delayed(Duration.zero, () {
          SuccessDialog.show(
            context: context,
            title: 'Successful Deleted !',
            subtitle: 'Your Order is Successfully Deleted',
          );
        });
      },
      scrollable: false,
      contentPadding: EdgeInsets.zero,
      content: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          children: [
            Text(
              'Are You Sure you want to Delete this Order ?',
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 18.sp,
                color: AppColors.primaryBlue,
              ),
            ),
            SizedBox(height: 32.h),
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
          ],
        ),
      ),
    );
  }
}
