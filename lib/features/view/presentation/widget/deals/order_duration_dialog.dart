import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../domain/entities/deals/deals.dart';

class OrderDurationDialog extends StatelessWidget {
  final List<Deal> relatedOrders;
  final bool isDarkMode;

  const OrderDurationDialog({
    Key? key,
    required this.relatedOrders,
    this.isDarkMode = false,
  }) : super(key: key);

  static void show({
    required BuildContext context,
    required List<Deal> relatedOrders,
    bool isDarkMode = false,
  }) {
    showDialog(
      context: context,
      barrierColor: AppColors.black.withOpacity(0.54),
      builder: (_) => OrderDurationDialog(
        relatedOrders: relatedOrders,
        isDarkMode: isDarkMode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = isDarkMode
        ? const Color(0xFF1A1A1A)
        : AppColors.white;

    final headerBgColor = isDarkMode
        ? const Color(0xFF2C5F7A)
        : const Color(0xFF2C5F7A);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        width: 1100.w,
        height: 370.h,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          children: [
            _buildHeader(context, headerBgColor),
            SizedBox(height: 20.h),
            _buildTable(),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color headerBgColor) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.r),
        topRight: Radius.circular(20.r),
      ),
      child: Container(
        width: 1100.w,
        height: 60.h,
        color: headerBgColor,
        padding: EdgeInsets.all(15.w),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Order Duration',
                style: GoogleFonts.openSans(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.close,
                size: 22.sp,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTable() {
    return Container(
      width: 1060.w,
      height: 280.h,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyBorder),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        children: [
          _buildTableHeader(),
          Expanded(
            child: ListView.builder(
              itemCount: relatedOrders.length,
              itemBuilder: (context, index) {
                return _buildTableRow(relatedOrders[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      height: 55.h,
      decoration: BoxDecoration(
        color: const Color(0xFFC6DBE8),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.r),
          topRight: Radius.circular(15.r),
        ),
        border: Border(
          bottom: BorderSide(
            color: AppColors.greyBorder,
            width: 2,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildHeaderCell('ID', 60),
          _buildHeaderCell('DURATION', 140),
          _buildHeaderCell('SYMBOL', 160),
          _buildHeaderCell('TYPE', 110),
          _buildHeaderCell('QTY', 110),
          _buildHeaderCell('PRICE', 120),
          _buildHeaderCell('EXECUTION D/T', 200),
          _buildHeaderCell('P/L', 120),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String label, double width) {
    return SizedBox(
      width: width.w,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Text(
          label,
          style: GoogleFonts.openSans(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2C5F7A),
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildTableRow(Deal deal, int index) {
    final rowColor = index % 2 == 0
        ? AppColors.white
        : const Color(0xFFF8F9FA);

    return Container(
      height: 45.h,
      decoration: BoxDecoration(
        color: rowColor,
        border: Border(
          bottom: BorderSide(
            color: AppColors.greyBorder,
            width: 2,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildDataCell((index + 1).toString(), 60),
          _buildDataCell(
            deal.orderDuration.isNotEmpty ? deal.orderDuration : '-',
            140,
            color: const Color(0xFF2C5F7A),
          ),
          _buildDataCell(
            deal.symbol,
            160,
            color: deal.buySell.toUpperCase().startsWith('BUY')
                ? AppColors.blue
                : AppColors.red,
          ),
          _buildDataCell(deal.orderType, 110),
          _buildDataCell(
            deal.qty.toStringAsFixed(0),
            110,
            isNumeric: true,
          ),
          _buildDataCell(
            deal.triggerPrice.toStringAsFixed(0),
            120,
            isNumeric: true,
          ),
          _buildDataCell(
            _formatDateTime(deal.executionDateTime ?? deal.orderDateTime),
            200,
          ),
          _buildDataCell(
            deal.pl.toStringAsFixed(0),
            120,
            isNumeric: true,
            color: deal.pl >= 0 ? AppColors.blue : AppColors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildDataCell(
      String text,
      double width, {
        bool isNumeric = false,
        Color? color,
      }) {
    return Container(
      width: width.w,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Text(
        text,
        style: GoogleFonts.openSans(
          fontSize: 14.sp,
          fontWeight: isNumeric ? FontWeight.w600 : FontWeight.w400,
          color: color ?? AppColors.primaryTextColor,
        ),
        textAlign: isNumeric ? TextAlign.right : TextAlign.left,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year.toString().substring(2)} ${_formatTime(dateTime)}';
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : (dateTime.hour == 0 ? 12 : dateTime.hour);
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')} $period';
  }
}