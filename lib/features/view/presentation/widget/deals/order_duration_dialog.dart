import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../../domain/entities/deals/deals.dart';
import 'package:bazarpro/core/widget/common_dilog_box.dart';
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
    return CommonDialog(
      title: 'Order Duration',
      isDarkMode: isDarkMode,
      width: 1100.w,
      height: 370.h,
      headerColor: AppColors.primaryBlue,
      showButtons: false,
      scrollable: false,
      contentPadding: EdgeInsets.zero,
      content: _buildTable(),
    );
  }
  List<ViewTableColumn> _getColumns() {
    return const [
      ViewTableColumn(id: 'id', label: 'ID', width: 60),
      ViewTableColumn(id: 'duration', label: 'DURATION', width: 140),
      ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 160),
      ViewTableColumn(id: 'type', label: 'TYPE', width: 110),
      ViewTableColumn(id: 'qty', label: 'QTY', width: 110, isNumeric: true),
      ViewTableColumn(id: 'price', label: 'PRICE', width: 120, isNumeric: true),
      ViewTableColumn(
        id: 'executionDateTime',
        label: 'EXECUTION D/T',
        width: 220,
      ),
      ViewTableColumn(id: 'pl', label: 'P/L', width: 120, isNumeric: true),
    ];
  }
  Widget _buildCell(Deal item, ViewTableColumn column, bool isDark) {
    final index = relatedOrders.indexOf(item) + 1;
    switch (column.id) {
      case 'id':
        return ViewTextCell(text: index.toString(), isDark: isDark);
      case 'duration':
        return ViewTextCell(
          text: item.orderDuration.isNotEmpty ? item.orderDuration : '-',
          color: const Color(0xFF2C5F7A),
          isDark: isDark,
        );
      case 'symbol':
        return ViewTextCell(
          text: item.symbol,
          color: item.buySell.toUpperCase().startsWith('BUY')
              ? AppColors.blue
              : AppColors.red,
          isDark: isDark,
        );
      case 'type':
        return ViewTextCell(text: item.orderType, isDark: isDark);
      case 'qty':
        return ViewNumberCell(value: item.qty, isDark: isDark);
      case 'price':
        return ViewNumberCell(value: item.triggerPrice, isDark: isDark);
      case 'executionDateTime':
        return ViewDateTimeCell(
          dateTime: item.executionDateTime ?? item.orderDateTime,
          isDark: isDark,
        );
      case 'pl':
        return ViewNumberCell(
          value: item.pl,
          colorByValue: true,
          isDark: isDark,
        );
      default:
        return const SizedBox.shrink();
    }
  }
  Widget _buildTable() {
    return ViewDataTable<Deal>(
      columns: _getColumns(),
      data: relatedOrders,
      idExtractor: (item) => item.id,
      isDarkMode: isDarkMode,
      emptyMessage: 'No related orders found',
      cellBuilder: (item, column) => _buildCell(item, column, isDarkMode),
    );
  }
}
