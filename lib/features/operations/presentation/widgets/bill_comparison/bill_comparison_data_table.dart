import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';
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
      comparatorBuilder: (item, columnId) {
        switch (columnId) {
          case 'index':
            return item.index;
          case 'username':
            return item.username;
          case 'billTotal':
            return item.billTotal;
          case 'billBrokerage':
            return item.billBrokerage;
          case 'billNetTotal':
            return item.billNetTotal;
          case 'settlementTotal':
            return item.settlementTotal;
          case 'settlementBrokerage':
            return item.settlementBrokerage;
          case 'settlementNetTotal':
            return item.settlementNetTotal;
          case 'type':
            return item.type;
          default:
            return '';
        }
      },
      cellBuilder: (item, column) {
        switch (column.id) {
          case 'index':
            return _buildText(
              item.index.toString().padLeft(2, '0'),
              isNumeric: true,
            );
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

  Widget _buildText(String text, {bool isNumeric = false}) {
    return ViewTextCell(text: text, isDark: false, isNumeric: isNumeric);
  }

  Widget _buildHighlightedText(String text, bool isMismatch) {
    return ViewTextCell(
      text: text,
      isDark: false,
      isNumeric: true,
      color: isMismatch ? LightThemeColors.negativeTextColor : null,
    );
  }

  Widget _buildTypeCell(String type) {
    bool isMismatch =
        type.toLowerCase().contains('mistmatch') ||
        type.toLowerCase().contains('mismatch');
    return ViewTextCell(
      text: type,
      isDark: false,
      color: isMismatch
          ? LightThemeColors.negativeTextColor
          : LightThemeColors.positiveTextColor,
      fontWeight: FontWeight.w600,
    );
  }
}
