import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../domain/entities/pending_orders/pending_order.dart';
import 'package:intl/intl.dart';

class OrderStatusDialog extends StatefulWidget {
  final bool isSuccess;
  final PendingOrder order;
  final String actionName;
  final VoidCallback? onClose;
  const OrderStatusDialog({
    Key? key,
    required this.isSuccess,
    required this.order,
    required this.actionName,
    this.onClose,
  }) : super(key: key);
  static void show({
    required BuildContext context,
    required bool isSuccess,
    required PendingOrder order,
    required String actionName,
  }) {
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 12.h,
        right: 16.w,
        child: OrderStatusDialog(
          isSuccess: isSuccess,
          order: order,
          actionName: actionName,
          onClose: () {
            overlayEntry.remove();
          },
        ),
      ),
    );
    Overlay.of(context).insert(overlayEntry);
  }

  @override
  State<OrderStatusDialog> createState() => _OrderStatusDialogState();
}

class _OrderStatusDialogState extends State<OrderStatusDialog> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && widget.onClose != null) {
        widget.onClose!();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = widget.isSuccess
        ? const Color(0xFF0052FF)
        : AppColors.red;
    final titleText = widget.isSuccess
        ? 'Order Successful !'
        : 'Order Rejected !';
    final isBuy = widget.actionName.toLowerCase().contains('buy');
    final actionColor = isBuy ? const Color(0xFF0052FF) : AppColors.red;
    final dateFormat = DateFormat('dd/MM/yy');
    final timeFormat = DateFormat('hh:mm:ss a');
    final now = DateTime.now();
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 260.w,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: statusColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: statusColor,
              offset: Offset(3.w, 3.h),
              blurRadius: 0,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              titleText,
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
            SizedBox(height: 6.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.order.symbol,
                    style: GoogleFonts.openSans(
                      fontSize: 11.sp,
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 4.w),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      color: statusColor,
                      size: 12.sp,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      dateFormat.format(now),
                      style: GoogleFonts.openSans(
                        fontSize: 10.sp,
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: actionColor.withOpacity(0.08),
                    border: Border.all(
                      color: actionColor.withOpacity(0.6),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                  child: Text(
                    widget.actionName,
                    style: GoogleFonts.openSans(
                      fontSize: 10.sp,
                      color: actionColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.access_time, color: statusColor, size: 12.sp),
                    SizedBox(width: 3.w),
                    Text(
                      timeFormat.format(now),
                      style: GoogleFonts.openSans(
                        fontSize: 10.sp,
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Q.${widget.order.qty.toStringAsFixed(widget.order.qty.truncateToDouble() == widget.order.qty ? 0 : 2)}',
                  style: GoogleFonts.openSans(
                    fontSize: 12.sp,
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  widget.order.triggerPrice.toStringAsFixed(0),
                  style: GoogleFonts.openSans(
                    fontSize: 12.sp,
                    color: statusColor,
                    fontWeight: FontWeight.w700,
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