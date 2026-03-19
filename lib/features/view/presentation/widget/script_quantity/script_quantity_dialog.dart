import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_record_count.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../domain/entities/script_quantity/script_quantity.dart';

class ScriptQuantityDialog {
  static void show({
    required BuildContext context,
    required List<ScriptQuantity> quantities,
    required String exchange,
    required String group,
    required int totalRecords,
    bool isClient = false,
  }) {
    CommonDialog.show(
      context: context,
      title: 'Script Quantity',
      width: 700.w,
      height: 750.h,
      showButtons: false,
      scrollable: false,
      contentPadding: EdgeInsets.zero,
      content: _ScriptQuantityContent(
        quantities: quantities,
        exchange: exchange,
        group: group,
        totalRecords: totalRecords,
        isClient: isClient,
      ),
    );
  }
}

class _ScriptQuantityContent extends StatefulWidget {
  final List<ScriptQuantity> quantities;
  final String exchange;
  final String group;
  final int totalRecords;
  final bool isClient;
  const _ScriptQuantityContent({
    Key? key,
    required this.quantities,
    required this.exchange,
    required this.group,
    required this.totalRecords,
    this.isClient = false,
  }) : super(key: key);
  @override
  State<_ScriptQuantityContent> createState() => _ScriptQuantityContentState();
}

class _ScriptQuantityContentState extends State<_ScriptQuantityContent> {
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16.h),
        _buildFilterInfo(context),
        SizedBox(height: 8.h),
        if (!widget.isClient) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: ViewRecordCount(count: widget.totalRecords),
          ),
          SizedBox(height: 8.h),
        ],
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: ViewDataTable<ScriptQuantity>(
              columns: _columns,
              data: widget.quantities,
              comparatorBuilder: (item, columnId) {
                switch (columnId) {
                  case 'symbol':
                    return item.symbol;
                  case 'breakupQty':
                    return item.breakupQty;
                  case 'maxQty':
                    return item.maxQty;
                  default:
                    return '';
                }
              },
              cellBuilder: _buildCell,
              idExtractor: (item) => item.symbol,
              emptyMessage: 'No script quantities found',
              autoFit: true,
            ),
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildCell(ScriptQuantity item, ViewTableColumn column) {
    switch (column.id) {
      case 'symbol':
        return Padding(
          padding: EdgeInsets.only(left: 12.w),
          child: ViewTextCell(text: item.symbol, isStart: true),
        );
      case 'breakupQty':
        return ViewNumberCell(value: item.breakupQty, colorByValue: false);
      case 'maxQty':
        return ViewNumberCell(value: item.maxQty, colorByValue: false);
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