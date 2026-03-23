import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../../domain/entities/script_settings/bonus_dividend_entry.dart';

class DividendEffectDataTable extends StatelessWidget {
  final List<BonusDividendEntry> data;

  const DividendEffectDataTable({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ViewDataTable(
      data: data,
      columns: _buildColumns(),
      comparatorBuilder: (item, columnId) {
        switch (columnId) {
          case 'username':
            return item.username;
          case 'symbol':
            return item.symbol;
          case 'netQty':
            return item.netQty;
          case 'closePrice':
            return item.closePrice;
          case 'dividendRatio':
            return item.ratio;
          case 'afterEffectNetQty':
            return item.afterEffectNetQty;
          case 'dividendEffectPrice':
            return item.effectPrice;
          default:
            return '';
        }
      },
      cellBuilder: (item, column) => _buildCell(item, column.id),
      idExtractor: (item) => item.id,
      autoFit: true,
    );
  }

  List<ViewTableColumn> _buildColumns() {
    return [
      ViewTableColumn(id: 'username', label: 'USERNAME', width: 150.w),
      ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 150.w),
      ViewTableColumn(
        id: 'netQty',
        label: 'NET QTY',
        width: 150.w,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'closePrice',
        label: 'CLOSE PRICE',
        width: 150.w,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'dividendRatio',
        label: 'DIVIDEND RATIO',
        width: 150.w,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'afterEffectNetQty',
        label: 'AFTER EFFECT NET QTY',
        width: 180.w,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'dividendEffectPrice',
        label: 'DIVIDEND EFFECT PRICE',
        width: 180.w,
        isNumeric: true,
      ),
    ];
  }

  Widget _buildCell(BonusDividendEntry item, String colId) {
    String text = '';
    Color? color;
    bool isNumeric = false;

    switch (colId) {
      case 'username':
        text = item.username;
        break;
      case 'symbol':
        text = item.symbol;
        break;
      case 'netQty':
        text = item.netQty.toStringAsFixed(0);
        isNumeric = true;
        color = LightThemeColors.positiveTextColor;
        break;
      case 'closePrice':
        text = item.closePrice.toStringAsFixed(0);
        isNumeric = true;
        break;
      case 'dividendRatio':
        text = item.ratio;
        isNumeric = true;
        break;
      case 'afterEffectNetQty':
        text = item.afterEffectNetQty.toStringAsFixed(0);
        isNumeric = true;
        color = LightThemeColors.positiveTextColor;
        break;
      case 'dividendEffectPrice':
        text = item.effectPrice.toStringAsFixed(0);
        isNumeric = true;
        break;
    }

    return ViewTextCell(
      text: text,
      isDark: false,
      isNumeric: isNumeric,
      color: color,
    );
  }
}
