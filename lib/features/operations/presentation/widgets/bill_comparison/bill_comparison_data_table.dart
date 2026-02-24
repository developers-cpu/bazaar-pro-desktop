import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../domain/entities/bill_comparison/bill_comparison_entity.dart';

class BillComparisonDataTable extends StatelessWidget {
  final List<BillComparisonEntity> data;
  const BillComparisonDataTable({super.key, required this.data});
  @override
  Widget build(BuildContext context) {
    final columns = [
      ViewTableColumn(id: 'index', label: 'INDEX', width: 60.w),
      ViewTableColumn(id: 'username', label: 'USERNAME', width: 120.w),
      ViewTableColumn(id: 'bill_total', label: 'BILL TOTAL', width: 120.w),
      ViewTableColumn(
        id: 'bill_brokerage',
        label: 'BILL BROKERAGE',
        width: 140.w,
      ),
      ViewTableColumn(
        id: 'bill_net_total',
        label: 'BILL NET TOTAL',
        width: 140.w,
      ),
      ViewTableColumn(
        id: 'settlement_total',
        label: 'SETTLEMENT TOTAL',
        width: 140.w,
      ),
      ViewTableColumn(
        id: 'settlement_brokerage',
        label: 'SETTLEMENT BROKERAGE',
        width: 160.w,
      ),
      ViewTableColumn(
        id: 'settlement_net_total',
        label: 'SETTLEMENT NET TOTAL',
        width: 160.w,
      ),
      ViewTableColumn(id: 'type', label: 'TYPE', width: 100.w),
    ];
    return ViewDataTable<BillComparisonEntity>(
      autoFit: true,
      columns: columns,
      data: data,
      idExtractor: (item) => item.index.toString(),
      cellBuilder: (item, column) {
        switch (column.id) {
          case 'index':
            return _buildText(item.index.toString().padLeft(2, '0'));
          case 'username':
            return _buildText(item.username);
          case 'bill_total':
            return _buildHighlightedText(item.billTotal, item.isTotalMismatch);
          case 'bill_brokerage':
            return _buildHighlightedText(
              item.billBrokerage,
              item.isBrokerageMismatch,
            );
          case 'bill_net_total':
            return _buildHighlightedText(
              item.billNetTotal,
              item.isNetTotalMismatch,
            );
          case 'settlement_total':
            return _buildHighlightedText(
              item.settlementTotal,
              item.isTotalMismatch,
            );
          case 'settlement_brokerage':
            return _buildHighlightedText(
              item.settlementBrokerage,
              item.isBrokerageMismatch,
            );
          case 'settlement_net_total':
            return _buildHighlightedText(
              item.settlementNetTotal,
              item.isNetTotalMismatch,
            );
          case 'type':
            return _buildTypeCell(item.type);
          default:
            return const SizedBox();
        }
      },
    );
  }

  Widget _buildText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textDark,
      ),
    );
  }

  Widget _buildHighlightedText(String text, bool isMismatch) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
        color: isMismatch ? AppColors.errorColor : AppColors.textDark,
      ),
    );
  }

  Widget _buildTypeCell(String type) {
    bool isMismatch =
        type.toLowerCase().contains('mistmatch') ||
        type.toLowerCase().contains('mismatch');
    return Text(
      type,
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: isMismatch ? AppColors.errorColor : AppColors.primaryBlue,
      ),
    );
  }
}
