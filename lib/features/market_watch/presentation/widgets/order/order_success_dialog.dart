import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../data/models/order_dialog_type.dart';
class OrderSuccessDialog extends StatefulWidget {
  final OrderType orderType;
  final String? symbol;
  final String? exchange;
  final int? quantity;
  final double? price;
  final bool isDarkMode;
  const OrderSuccessDialog({
    Key? key,
    required this.orderType,
    this.symbol,
    this.exchange,
    this.quantity,
    this.price,
    this.isDarkMode = false,
  }) : super(key: key);
  static Future<void> show(
    BuildContext context, {
    required OrderType orderType,
    String? symbol,
    String? exchange,
    int? quantity,
    double? price,
    bool isDarkMode = false,
  }) {
    return showDialog(
      context: context,
      barrierColor: AppColors.black.withOpacity(0.54),
      useRootNavigator: true,
      builder: (context) => OrderSuccessDialog(
        orderType: orderType,
        symbol: symbol,
        exchange: exchange,
        quantity: quantity,
        price: price,
        isDarkMode: isDarkMode,
      ),
    );
  }
  @override
  State<OrderSuccessDialog> createState() => _OrderSuccessDialogState();
}
class _OrderSuccessDialogState extends State<OrderSuccessDialog> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final statusColor = widget.orderType == OrderType.buy
        ? const Color(0xFF0052FF)
        : AppColors.red;
    final titleText = 'Order Placed Successfully!';
    final actionName = widget.orderType == OrderType.buy ? 'Buy' : 'Sell';
    final dateFormat = DateFormat('dd/MM/yy');
    final timeFormat = DateFormat('hh:mm:ss a');
    final now = DateTime.now();
    return Dialog(
      alignment: Alignment.bottomRight,
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.only(right: 16.w, bottom: 12.h),
      child: Container(
        width: 260.w,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: widget.isDarkMode
              ? DarkThemeColors.cardBackground
              : AppColors.white,
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
                    widget.symbol ?? '-',
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
                    color: statusColor.withOpacity(0.08),
                    border: Border.all(
                      color: statusColor.withOpacity(0.6),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                  child: Text(
                    actionName,
                    style: GoogleFonts.openSans(
                      fontSize: 10.sp,
                      color: statusColor,
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
                  widget.quantity != null ? 'Q.${widget.quantity}' : '-',
                  style: GoogleFonts.openSans(
                    fontSize: 12.sp,
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  widget.price != null ? widget.price!.toStringAsFixed(2) : '-',
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
