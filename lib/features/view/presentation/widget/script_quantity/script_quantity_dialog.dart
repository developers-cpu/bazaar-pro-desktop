import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../domain/entities/script_quantity/script_quantity.dart';


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
  static final List<ViewTableColumn> _columns = [
    const ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 200),
    const ViewTableColumn(
      id: 'breakupQty',
      label: 'BREAKUP QTY',
      width: 200,
      isNumeric: true,
    ),
    const ViewTableColumn(
      id: 'maxQty',
      label: 'MAX QTY',
      width: 200,
      isNumeric: true,
    ),
  ];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = AppColors.cardBackground(context);
    final headerBgColor = AppColors.primaryColor(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: Container(
        width: 700.w,
        height: 750.h,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            _buildHeader(context, headerBgColor),
            SizedBox(height: 16.h),
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
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: ViewDataTable<ScriptQuantity>(
                  columns: _columns,
                  data: widget.quantities,
                  cellBuilder: _buildCell,
                  idExtractor: (item) => item.symbol,
                  emptyMessage: 'No script quantities found',
                  autoFit: true,
                ),
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildCell(ScriptQuantity item, ViewTableColumn column) {
    switch (column.id) {
      case 'symbol':
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          alignment: Alignment.centerLeft,
          child: Text(
            item.symbol,
            style: GoogleFonts.openSans(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTextColor,
            ),
          ),
        );
      case 'breakupQty':
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          alignment: Alignment.centerRight,
          child: Text(
            item.breakupQty.toStringAsFixed(0),
            style: GoogleFonts.openSans(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTextColor,
            ),
          ),
        );
      case 'maxQty':
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          alignment: Alignment.centerRight,
          child: Text(
            item.maxQty.toStringAsFixed(0),
            style: GoogleFonts.openSans(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTextColor,
            ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
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
            child: Icon(Icons.close, size: 20.sp, color: AppColors.white),
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
          Expanded(child: _buildInfoBox(context, 'Exchange', widget.exchange)),
          SizedBox(width: 12.w),
          Expanded(child: _buildInfoBox(context, 'Group', widget.group)),
        ],
      ),
    );
  }

  Widget _buildInfoBox(BuildContext context, String label, String value) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.tableColumnHeadColor(context),
        borderRadius: BorderRadius.circular(6.r),
      ),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: GoogleFonts.openSans(
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.primaryColor(context).withOpacity(0.8),
              height: 1.2,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: GoogleFonts.openSans(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryColor(context),
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
