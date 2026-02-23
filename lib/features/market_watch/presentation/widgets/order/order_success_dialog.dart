import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../data/models/order_dialog_type.dart';
class OrderSuccessDialog extends StatelessWidget {
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
      barrierDismissible: true,
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
  Color get _primaryColor => orderType == OrderType.buy
      ? const Color(0xFF0066FF)
      : const Color(0xFFFF0000);
  String get _orderTypeText => orderType == OrderType.buy ? 'Buy' : 'Sell';
  Color get _bgColor => isDarkMode
      ? DarkThemeColors.cardBackground
      : LightThemeColors.cardBackground;
  Color get _textColor =>
      isDarkMode ? DarkThemeColors.textColor : LightThemeColors.textColor;
  Color get _supportiveTextColor => isDarkMode
      ? DarkThemeColors.supportiveTextColor
      : LightThemeColors.supportiveTextColor;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Container(
        width: 400.w,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.15),
              blurRadius: 20.r,
              offset: Offset(0, 10.h),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline,
                size: 48.sp,
                color: _primaryColor,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Order Placed Successfully!',
              style: GoogleFonts.openSans(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: _textColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              'Your $_orderTypeText order has been placed.',
              style: GoogleFonts.openSans(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: _supportiveTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            if (symbol != null ||
                exchange != null ||
                quantity != null ||
                price != null)
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: _primaryColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    if (exchange != null && symbol != null)
                      _buildDetailRow('Symbol', '$exchange - $symbol'),
                    if (quantity != null)
                      _buildDetailRow('Quantity', quantity.toString()),
                    if (price != null)
                      _buildDetailRow('Price', '₹${price!.toStringAsFixed(2)}'),
                  ],
                ),
              ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              height: 45.h,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Text(
                  'OK',
                  style: GoogleFonts.openSans(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.openSans(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: _supportiveTextColor,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.openSans(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: _textColor,
            ),
          ),
        ],
      ),
    );
  }
}
