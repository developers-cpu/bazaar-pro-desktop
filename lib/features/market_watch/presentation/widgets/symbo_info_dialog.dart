import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/market_item.dart';

class SymbolInfoDialog extends StatelessWidget {
  final MarketItem item;

  const SymbolInfoDialog({Key? key, required this.item}) : super(key: key);

  static void show(BuildContext context, MarketItem item) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => SymbolInfoDialog(item: item),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Container(
        width: 400.w,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            SizedBox(height: 16.h),
            _buildDivider(),
            SizedBox(height: 16.h),
            _buildInfoGrid(),
            SizedBox(height: 16.h),
            _buildDivider(),
            SizedBox(height: 16.h),
            _buildPriceSection(),
            SizedBox(height: 20.h),
            _buildCloseButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.symbol,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryBlue,
              ),
            ),
            SizedBox(height: 4.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                item.exchange,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close, size: 24.sp, color: AppColors.textDark),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 1.h, color: AppColors.greyBorder);
  }

  Widget _buildInfoGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildInfoItem('LTP', _formatNumber(item.ltp))),
            Expanded(child: _buildInfoItem('Net Change', _formatChange(item.netChange))),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(child: _buildInfoItem('Open', _formatNumber(item.open))),
            Expanded(child: _buildInfoItem('Close', _formatNumber(item.close))),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(child: _buildInfoItem('High', _formatNumber(item.high))),
            Expanded(child: _buildInfoItem('Low', _formatNumber(item.low))),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(child: _buildInfoItem('Buy Qty', item.buyQty.toString())),
            Expanded(child: _buildInfoItem('Sell Qty', item.sellQty.toString())),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(child: _buildInfoItem('Buy Price', _formatNumber(item.buyPrice))),
            Expanded(child: _buildInfoItem('Sell Price', _formatNumber(item.sellPrice))),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value) {
    final isNegative = value.startsWith('-');
    final isChange = label.contains('Change');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textDark.withOpacity(0.6),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: isChange
                ? (isNegative ? AppColors.red : AppColors.successColor)
                : AppColors.textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.primaryBgColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Expiry Date',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textDark.withOpacity(0.6),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                item.expiry != null
                    ? DateFormat('dd MMM yyyy').format(item.expiry!)
                    : 'N/A',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Last Updated',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textDark.withOpacity(0.6),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                DateFormat('dd MMM yyyy, HH:mm').format(item.lut),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        child: Text(
          'Close',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  String _formatNumber(double value) {
    if (value >= 100000) {
      return NumberFormat('#,##,###.##').format(value);
    }
    return value.toStringAsFixed(2);
  }

  String _formatChange(double value) {
    final sign = value >= 0 ? '+' : '';
    return '$sign${value.toStringAsFixed(2)}';
  }
}