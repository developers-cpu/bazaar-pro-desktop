import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../../../core/widget/custom_action_button.dart';
import '../../../../../core/widget/custom_outlined_button.dart';
import '../../../domain/entities/pending_orders/pending_order.dart';
import '../../../../../core/widget/table/success_dialog.dart';

class PendingToSuccessDialog {
  static void show({
    required BuildContext context,
    required PendingOrder order,
    bool isDarkMode = false,
  }) {
    CommonDialog.show(
      context: context,
      title: 'Pending to Success',
      isDarkMode: isDarkMode,
      width: 500.w,
      headerColor: const Color(0xFF1F4A66),
      showButtons: false,
      scrollable: false,
      contentPadding: EdgeInsets.zero,
      contentBuilder: (context, onClose) => _PendingToSuccessContent(
        order: order,
        isDarkMode: isDarkMode,
        onClose: onClose,
      ),
    );
  }
}

class _PendingToSuccessContent extends StatelessWidget {
  final PendingOrder order;
  final bool isDarkMode;
  final VoidCallback onClose;

  const _PendingToSuccessContent({
    Key? key,
    required this.order,
    this.isDarkMode = false,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isBuy = order.isBuy;
    final Color actionColor = isBuy ? const Color(0xFF0052FF) : AppColors.red;
    String formattedQty = order.qty
        .toStringAsFixed(6)
        .replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Are You Sure you want to Pending to Success  Order ?',
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
              fontSize: 16.sp,
              color: const Color(0xFF1F4A66),
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.symbol,
                          style: GoogleFonts.openSans(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1F4A66),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          '${order.buySell} - ${order.orderType}',
                          style: GoogleFonts.openSans(
                            fontSize: 12.sp,
                            color: actionColor,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Q.$formattedQty',
                      style: GoogleFonts.openSans(
                        fontSize: 14.sp,
                        color: const Color(0xFF1F4A66),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 32.w),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade100),
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  order.triggerPrice.toStringAsFixed(0),
                  style: GoogleFonts.openSans(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 32.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: CustomOutlinedActionButton(
                  text: 'No',
                  height: 40.h,
                  borderRadius: 8.r,
                  fontSize: 14.sp,
                  borderColor:
                      isDarkMode ? Colors.white : const Color(0xFF1F4A66),
                  textColor:
                      isDarkMode ? Colors.white : const Color(0xFF1F4A66),
                  onPressed: onClose,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: CustomActionButton(
                  text: 'Yes',
                  height: 40.h,
                  borderRadius: 8.r,
                  fontSize: 14.sp,
                  backgroundColor: const Color(0xFF1F4A66),
                  textColor: Colors.white,
                  onPressed: () {
                    onClose();
                    Future.delayed(Duration.zero, () {
                      SuccessDialog.show(
                        context: context,
                        title: 'Successful !',
                        subtitle: 'Pending to Success Order Successfully Done',
                      );
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
