import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../domain/entities/script_quantity/script_quantity.dart';

class ScriptQuantityDialog extends StatefulWidget {
  final List<ScriptQuantity> quantities;
  final String exchange;
  final String group;
  final int totalRecords;
  final bool isClient;
  const ScriptQuantityDialog({
    Key? key,
    required this.quantities,
    required this.exchange,
    required this.group,
    required this.totalRecords,
    this.isClient = false,
  }) : super(key: key);
  static void show({
    required BuildContext context,
    required List<ScriptQuantity> quantities,
    required String exchange,
    required String group,
    required int totalRecords,
    bool isClient = false,
  }) {
    showDialog(
      context: context,
      barrierColor: AppColors.black.withOpacity(0.54),
      builder: (_) => ScriptQuantityDialog(
        quantities: quantities,
        exchange: exchange,
        group: group,
        totalRecords: totalRecords,
        isClient: isClient,
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
    return CommonDialog(
      title: 'Script Quantity',
      width: 700.w,
      height: 750.h,
      showButtons: false,
      scrollable: false,
      contentPadding: EdgeInsets.zero,
      content: Column(
        children: [
          SizedBox(height: 16.h),
          _buildFilterInfo(context),
          SizedBox(height: 8.h),
          if (!widget.isClient) ...[
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
          ],
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

  Widget _buildFilterInfo(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(child: _buildInfoBox(context, 'Exchange', widget.exchange)),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildInfoBox(
              context,
              'Group',
              widget.group.isEmpty ? '${widget.exchange}_X' : widget.group,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(BuildContext context, String label, String value) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFD3E3EC),
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
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              color: Colors.grey[700],
              height: 1.2,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: GoogleFonts.openSans(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryColor(context),
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
