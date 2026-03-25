import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../../domain/entities/symbol_settings/symbol_setting.dart';

class SymbolSettingsDataTable extends StatelessWidget {
  final List<SymbolSetting> data;
  final void Function(SymbolSetting item) onEditPressed;
  final void Function(SymbolSetting item) onTradeMarginPressed;

  const SymbolSettingsDataTable({
    super.key,
    required this.data,
    required this.onEditPressed,
    required this.onTradeMarginPressed,
  });

  @override
  Widget build(BuildContext context) {
    final columns = [
      ViewTableColumn(id: 'exchange', label: 'EXCHANGE', width: 100.w),
      ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 160.w),
      ViewTableColumn(id: 'expiryDate', label: 'EXPIRY DATE', width: 120.w),
      ViewTableColumn(id: 'closeDate', label: 'CLOSE DATE', width: 120.w),
      ViewTableColumn(id: 'cutDate', label: 'CUT DATE', width: 110.w),
      ViewTableColumn(id: 'launchDate', label: 'LAUNCH DATE', width: 120.w),
      ViewTableColumn(id: 'description', label: 'DESCRIPTION', width: 200.w),
      ViewTableColumn(
        id: 'lotSize',
        label: 'LOT SIZE',
        width: 90.w,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'tradeMarginPercent',
        label: 'TRADE\nMARGIN (%)',
        width: 110.w,
        isNumeric: true,
        headerLines: 2,
      ),
      ViewTableColumn(
        id: 'tradeMarginAmount',
        label: 'TRADE\nMARGIN (AMT)',
        width: 120.w,
        isNumeric: true,
        headerLines: 2,
      ),
      ViewTableColumn(
        id: 'tradeAttribute',
        label: 'TRADE\nATTRIBUTE',
        width: 110.w,
        headerLines: 2,
      ),
      ViewTableColumn(
        id: 'allowTrade',
        label: 'ALLOW\nTRADE',
        width: 90.w,
        headerLines: 2,
      ),
      ViewTableColumn(
        id: 'autoTickSize',
        label: 'AUTO\nTICK SIZE',
        width: 100.w,
        headerLines: 2,
      ),
      ViewTableColumn(id: 'size', label: 'SIZE', width: 80.w, isNumeric: true),
      ViewTableColumn(id: 'open', label: 'OPEN', width: 100.w, isNumeric: true),
      ViewTableColumn(id: 'high', label: 'HIGH', width: 100.w, isNumeric: true),
      ViewTableColumn(id: 'low', label: 'LOW', width: 100.w, isNumeric: true),
      ViewTableColumn(
        id: 'edit',
        label: 'ACTION',
        width: 70.w,
        sortable: false,
      ),
      ViewTableColumn(
        id: 'tradeMarginAction',
        label: 'TRADE\nMARGIN',
        width: 100.w,
        sortable: false,
        headerLines: 2,
      ),
    ];

    return ViewDataTable<SymbolSetting>(
      autoFit: false,
      columns: columns,
      data: data,
      idExtractor: (item) => item.id,
      comparatorBuilder: (item, columnId) {
        switch (columnId) {
          case 'exchange':
            return item.exchange;
          case 'symbol':
            return item.symbol;
          case 'expiryDate':
            return item.expiryDate;
          case 'lotSize':
            return item.lotSize;
          case 'tradeMarginPercent':
            return item.tradeMarginPercent;
          case 'tradeMarginAmount':
            return item.tradeMarginAmount;
          case 'open':
            return item.open;
          case 'high':
            return item.high;
          case 'low':
            return item.low;
          default:
            return '';
        }
      },
      cellBuilder: (item, column) => _buildCell(context, item, column),
    );
  }

  Widget _buildCell(
    BuildContext context,
    SymbolSetting item,
    ViewTableColumn column,
  ) {
    if (column.id == 'edit') {
      return ViewIconLinkCell(
        icon: Icons.edit,
        size: 20.sp,
        onTap: () => onEditPressed(item),
      );
    }
    if (column.id == 'tradeMarginAction') {
      return ViewIconLinkCell(
        icon: Icons.edit,
        size: 20.sp,
        onTap: () => onTradeMarginPressed(item),
      );
    }

    String value;
    switch (column.id) {
      case 'exchange':
        value = item.exchange;
        break;
      case 'symbol':
        value = item.symbol;
        break;
      case 'expiryDate':
        value = item.expiryDate;
        break;
      case 'closeDate':
        value = item.closeDate;
        break;
      case 'cutDate':
        value = item.cutDate;
        break;
      case 'launchDate':
        value = item.launchDate;
        break;
      case 'description':
        value = item.description;
        break;
      case 'lotSize':
        value = item.lotSize;
        break;
      case 'tradeMarginPercent':
        value = item.tradeMarginPercent;
        break;
      case 'tradeMarginAmount':
        value = item.tradeMarginAmount;
        break;
      case 'tradeAttribute':
        value = item.tradeAttribute;
        break;
      case 'allowTrade':
        value = item.allowTrade ? 'Yes' : 'No';
        break;
      case 'autoTickSize':
        value = item.autoTickSize ? 'Yes' : 'No';
        break;
      case 'size':
        value = item.size;
        break;
      case 'open':
        value = item.open;
        break;
      case 'high':
        value = item.high;
        break;
      case 'low':
        value = item.low;
        break;
      default:
        value = '';
    }

    return ViewTextCell(
      text: value,
      isDark: false,
      isNumeric: column.isNumeric,
    );
  }
}
