import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../domain/entities/script_quantity.dart';

/// Script Quantity Dialog
/// Shows script quantity data in a dialog matching the screenshot design
class ScriptQuantityDialog extends StatefulWidget {
  final List<ScriptQuantity> quantities;
  final String exchange;
  final String group;
  final int totalRecords;

  const ScriptQuantityDialog({
    Key? key,
    required this.quantities,
    required this.exchange,
    required this.group,
    required this.totalRecords,
  }) : super(key: key);

  static void show({
    required BuildContext context,
    required List<ScriptQuantity> quantities,
    required String exchange,
    required String group,
    required int totalRecords,
  }) {
    showDialog(
      context: context,
      barrierColor: AppColors.black.withOpacity(0.54),
      builder: (_) => ScriptQuantityDialog(
        quantities: quantities,
        exchange: exchange,
        group: group,
        totalRecords: totalRecords,
      ),
    );
  }

  @override
  State<ScriptQuantityDialog> createState() => _ScriptQuantityDialogState();
}

class _ScriptQuantityDialogState extends State<ScriptQuantityDialog> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = AppColors.cardBackground(context);
    final headerBgColor = AppColors.primaryColor(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 24.h),
      child: Container(
        width: 900.w,
        height: 600.h,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            _buildHeader(context, headerBgColor),
            SizedBox(height: 12.h),
            _buildFilterInfo(context),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'RECORD : ${widget.totalRecords}',
                  style: GoogleFonts.openSans(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor(context),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Expanded(child: _buildTable(context)),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color headerBgColor) {
    return Container(
      width: double.infinity,
      height: 50.h,
      decoration: BoxDecoration(
        color: headerBgColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Script Quantity',
              style: GoogleFonts.openSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.close,
              size: 20.sp,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterInfo(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: _buildInfoBox(context, 'Exchange', widget.exchange),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildInfoBox(context, 'Group', widget.group),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(BuildContext context, String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.tableColumnHeadColor(context),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.openSans(
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.supportiveTextColor(context),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: GoogleFonts.openSans(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.cardBorderColor(context),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          _buildTableHeader(context),
          Expanded(
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.zero,
                itemCount: widget.quantities.length,
                itemBuilder: (context, index) {
                  return _buildTableRow(context, widget.quantities[index], index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    return Container(
      height: 44.h,
      decoration: BoxDecoration(
        color: AppColors.tableColumnHeadColor(context),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(7.r),
          topRight: Radius.circular(7.r),
        ),
      ),
      child: Row(
        children: [
          _buildHeaderCell(context, 'SYMBOL', flex: 2, showSort: true),
          _buildHeaderCell(context, 'BREAKUP QTY', flex: 1, isNumeric: true, showSort: true),
          _buildHeaderCell(context, 'MAX QTY', flex: 1, isNumeric: true, showSort: true),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(
      BuildContext context,
      String label, {
        required int flex,
        bool isNumeric = false,
        bool showSort = false,
      }) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        alignment: isNumeric ? Alignment.center : Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: isNumeric ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                label,
                style: GoogleFonts.openSans(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor(context),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (showSort) ...[
              SizedBox(width: 4.w),
              Icon(
                Icons.swap_vert,
                size: 14.sp,
                color: AppColors.textColor(context),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTableRow(BuildContext context, ScriptQuantity quantity, int index) {
    final rowColor = index % 2 == 0
        ? AppColors.getTableRowBackground(context)
        : AppColors.getTableAlternateRowBackground(context);

    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: rowColor,
        border: Border(
          bottom: BorderSide(
            color: AppColors.dividerColor(context),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildDataCell(context, quantity.symbol, flex: 2),
          _buildDataCell(
            context,
            quantity.breakupQty.toStringAsFixed(0),
            flex: 1,
            isNumeric: true,
          ),
          _buildDataCell(
            context,
            quantity.maxQty.toStringAsFixed(0),
            flex: 1,
            isNumeric: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDataCell(
      BuildContext context,
      String text, {
        required int flex,
        bool isNumeric = false,
        Color? color,
      }) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        alignment: isNumeric ? Alignment.center : Alignment.centerLeft,
        child: Text(
          text,
          style: GoogleFonts.openSans(
            fontSize: 13.sp,
            fontWeight: isNumeric ? FontWeight.w500 : FontWeight.w400,
            color: color ?? AppColors.textColor(context),
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}