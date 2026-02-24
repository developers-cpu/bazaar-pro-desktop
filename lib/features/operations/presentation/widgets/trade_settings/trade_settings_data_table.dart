import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../domain/entities/trade_settings/trade_setting.dart';

class TradeSettingsDataTable extends StatelessWidget {
  final List<dynamic> data;
  final Set<String> selectedIds;
  final ValueChanged<Set<String>> onSelectionChanged;
  final int activeTab;
  final ValueChanged<String>? onExchangeTap;
  const TradeSettingsDataTable({
    super.key,
    required this.data,
    required this.selectedIds,
    required this.onSelectionChanged,
    required this.activeTab,
    this.onExchangeTap,
  });
  @override
  Widget build(BuildContext context) {
    return ViewDataTable(
      data: data,
      columns: _buildColumns(),
      cellBuilder: (item, column) {
        if (item is! TradeSetting) return const SizedBox.shrink();
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
        if (column.id == 'exchange') {
          return _buildExchangeCell(item);
        }
        return _buildCell(item, column.id);
      },
      idExtractor: (item) {
        if (item is! TradeSetting) return '';
        return item.id;
      },
      selectedId: selectedIds.isNotEmpty ? selectedIds.first : null,
      onRowTap: (item) {
        if (item is TradeSetting) {
          final newSelection = Set<String>.from(selectedIds);
          if (newSelection.contains(item.id)) {
            newSelection.remove(item.id);
          } else {
            newSelection.add(item.id);
          }
          onSelectionChanged(newSelection);
        }
      },
      autoFit: true,
    );
  }

  List<ViewTableColumn> _buildColumns() {
    final List<ViewTableColumn> columns = [_checkboxColumn()];
    columns.addAll(_columnsForTab());
    return columns;
  }

  ViewTableColumn _checkboxColumn() {
    return ViewTableColumn(
      id: 'checkbox',
      label: '',
      width: 50.w,
      sortable: false,
      customHeaderWidget: Checkbox(
        value: selectedIds.length == data.length && data.isNotEmpty,
        onChanged: (val) {
          if (val == true) {
            onSelectionChanged(
              data.whereType<TradeSetting>().map((e) => e.id).toSet(),
            );
          } else {
            onSelectionChanged({});
          }
        },
        activeColor: AppColors.primaryBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
      ),
    );
  }

  Widget _buildExchangeCell(TradeSetting item) {
    if (onExchangeTap != null) {
      return InkWell(
        onTap: () => onExchangeTap!(item.exchange),
        child: Text(
          item.exchange,
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            color: AppColors.primaryBlue,
            decoration: TextDecoration.underline,
            decorationColor: AppColors.primaryBlue,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
    return Text(
      item.exchange,
      style: GoogleFonts.openSans(
        fontSize: 12.sp,
        color: AppColors.primaryBlue,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  List<ViewTableColumn> _columnsForTab() {
    switch (activeTab) {
      case 0:
        return [
          ViewTableColumn(id: 'exchange', label: 'EXCHANGE', width: 120.w),
          ViewTableColumn(id: 'marginType', label: 'MARGIN TYPE', width: 150.w),
          ViewTableColumn(
            id: 'intMarginPercentage',
            label: 'INT MARGIN (%)',
            width: 150.w,
          ),
          ViewTableColumn(
            id: 'cfMarginPercentage',
            label: 'CF MARGIN (%)',
            width: 150.w,
          ),
          ViewTableColumn(
            id: 'intMarginAmt',
            label: 'INT MARGIN(Amt.)',
            width: 150.w,
          ),
          ViewTableColumn(
            id: 'cfMarginAmt',
            label: 'CF MARGIN(Amt.)',
            width: 150.w,
          ),
          ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 200.w),
          ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 100.w),
        ];
      case 1:
        return [
          ViewTableColumn(id: 'exchange', label: 'EXCHANGE', width: 120.w),
          ViewTableColumn(
            id: 'brokerageType',
            label: 'BROKERAGE TYPE',
            width: 150.w,
          ),
          ViewTableColumn(
            id: 'turnoverWiseBrokerageRs',
            label: 'TURNOVER WISE BROKERAGE(Rs)',
            width: 220.w,
          ),
          ViewTableColumn(
            id: 'lotWiseBrokerageAmt',
            label: 'LOT WISE BROKERAGE(Amt.)',
            width: 200.w,
          ),
          ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 200.w),
          ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 100.w),
        ];
      case 2:
        return [
          ViewTableColumn(id: 'exchange', label: 'EXCHANGE', width: 120.w),
          ViewTableColumn(
            id: 'leverageMultiplier',
            label: 'LEVERAGE',
            width: 200.w,
          ),
          ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 200.w),
          ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 100.w),
        ];
      case 3:
        return [
          ViewTableColumn(id: 'exchange', label: 'EXCHANGE', width: 120.w),
          ViewTableColumn(
            id: 'tradeSecondsLimit',
            label: 'TRADE SECONDS',
            width: 200.w,
          ),
          ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 200.w),
          ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 100.w),
        ];
      default:
        return [
          ViewTableColumn(id: 'exchange', label: 'EXCHANGE', width: 120.w),
          ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 200.w),
          ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 100.w),
        ];
    }
  }

  Widget _buildCell(TradeSetting item, String colId) {
    String text = '';
    switch (colId) {
      case 'exchange':
        text = item.exchange;
        break;
      case 'marginType':
        text = item.marginType ?? '-';
        break;
      case 'intMarginPercentage':
        text = item.intMarginPercentage ?? '-';
        break;
      case 'cfMarginPercentage':
        text = item.cfMarginPercentage ?? '-';
        break;
      case 'intMarginAmt':
        text = item.intMarginAmt ?? '-';
        break;
      case 'cfMarginAmt':
        text = item.cfMarginAmt ?? '-';
        break;
      case 'brokerageType':
        text = item.brokerageType ?? '-';
        break;
      case 'turnoverWiseBrokerageRs':
        text = item.turnoverWiseBrokerageRs ?? '-';
        break;
      case 'lotWiseBrokerageAmt':
        text = item.lotWiseBrokerageAmt ?? '-';
        break;
      case 'leverageMultiplier':
        text = item.leverageMultiplier ?? '-';
        break;
      case 'tradeSecondsLimit':
        text = item.tradeSecondsLimit ?? '-';
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
