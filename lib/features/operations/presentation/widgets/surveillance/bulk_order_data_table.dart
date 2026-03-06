import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../domain/entities/surveillance/surveillance_bulk_order.dart';

class BulkOrderDataTable extends StatelessWidget {
  final List<SurveillanceBulkOrder> data;
  final Set<String> selectedIds;
  final ValueChanged<Set<String>> onSelectionChanged;
  const BulkOrderDataTable({
    super.key,
    required this.data,
    required this.selectedIds,
    required this.onSelectionChanged,
  });
  @override
  Widget build(BuildContext context) {
    return ViewDataTable(
      data: data,
      columns: _buildColumns(),
      comparatorBuilder: (item, columnId) {
        switch (columnId) {
          case 'exchange': return item.exchange;
          case 'symbol': return item.symbol;
          case 'intervalTime': return item.intervalTime;
          case 'totalQuantity': return item.totalQuantity;
          case 'tradeSlLimit': return item.tradeSlLimit;
          case 'updatedOn': return item.updatedOn;
          case 'updatedBy': return item.updatedBy;
          default: return '';
        }
      },
      cellBuilder: (item, column) {
        if (column.id == 'checkbox') {
          return Checkbox(
            value: selectedIds.contains(item.id),
            onChanged: (_) {
              final newSelection = Set<String>.from(selectedIds);
              if (newSelection.contains(item.id)) {
                newSelection.remove(item.id);
              } else {
                newSelection.add(item.id);
              }
              onSelectionChanged(newSelection);
            },
            activeColor: AppColors.primaryBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.r),
            ),
          );
        }
        return _buildCell(item, column.id);
      },
      idExtractor: (item) => item.id,
      selectedId: selectedIds.isNotEmpty ? selectedIds.first : null,
      onRowTap: (item) {
        final newSelection = Set<String>.from(selectedIds);
        if (newSelection.contains(item.id)) {
          newSelection.remove(item.id);
        } else {
          newSelection.add(item.id);
        }
        onSelectionChanged(newSelection);
      },
      autoFit: true,
    );
  }

  List<ViewTableColumn> _buildColumns() {
    return [
      ViewTableColumn(
        id: 'checkbox',
        label: '',
        width: 50.w,
        sortable: false,
        customHeaderWidget: Checkbox(
          value: selectedIds.length == data.length && data.isNotEmpty,
          onChanged: (val) {
            if (val == true) {
              onSelectionChanged(data.map((e) => e.id).toSet());
            } else {
              onSelectionChanged({});
            }
          },
          activeColor: AppColors.primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      ),
      ViewTableColumn(id: 'exchange', label: 'EXCHANGE', width: 120.w),
      ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 200.w),
      ViewTableColumn(id: 'intervalTime', label: 'INTERVAL TIME', width: 150.w),
      ViewTableColumn(
        id: 'totalQuantity',
        label: 'TOTAL QUANTITY',
        width: 180.w,
      ),
      ViewTableColumn(
        id: 'tradeSlLimit',
        label: 'TRADE SL/LIMIT (%)',
        width: 180.w,
      ),
      ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 220.w),
      ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 150.w),
    ];
  }

  Widget _buildCell(SurveillanceBulkOrder item, String colId) {
    String text = '';
    switch (colId) {
      case 'exchange':
        text = item.exchange;
        break;
      case 'symbol':
        text = item.symbol;
        break;
      case 'intervalTime':
        text = item.intervalTime.toString();
        break;
      case 'totalQuantity':
        text = item.totalQuantity.toString();
        break;
      case 'tradeSlLimit':
        text = item.tradeSlLimit.toString();
        break;
      case 'updatedOn':
        text = item.updatedOn;
        break;
      case 'updatedBy':
        text = item.updatedBy;
        break;
    }
    return Text(
      text,
      style: GoogleFonts.openSans(
        fontSize: 12.sp,
        color: AppColors.primaryBlue,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
