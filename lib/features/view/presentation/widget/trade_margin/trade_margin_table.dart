import 'package:bazarpro/features/view/domain/entities/trade_margin/trade_margin.dart';
import 'package:flutter/material.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_record_count.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';

class TradeMarginTable extends StatelessWidget {
  final List<TradeMargin> tradeMargins;
  final bool isDarkMode;
  final bool isClient;
  const TradeMarginTable({
    super.key,
    required this.tradeMargins,
    this.isDarkMode = false,
    this.isClient = false,
  });
  List<ViewTableColumn> _getColumns() {
    if (isClient) {
      return const [
        ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 250),
        ViewTableColumn(
          id: 'intMarginPct',
          label: 'INT MARGIN (%)',
          width: 150,
          isNumeric: true,
        ),
        ViewTableColumn(
          id: 'cfMarginPct',
          label: 'CF MARGIN (%)',
          width: 150,
          isNumeric: true,
        ),
        ViewTableColumn(
          id: 'intMarginAmt',
          label: 'INT MARGIN(Amt.)',
          width: 150,
          isNumeric: true,
        ),
        ViewTableColumn(
          id: 'cfMarginAmt',
          label: 'CF MARGIN(Amt.)',
          width: 170,
          isNumeric: true,
        ),
      ];
    }
    return const [
      ViewTableColumn(id: 'exchange', label: 'EXCH', width: 100),
      ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 150),
      ViewTableColumn(id: 'expiryDate', label: 'EXPIRY DATE', width: 200),
      ViewTableColumn(
        id: 'intMarginPct',
        label: 'INT MARGIN (%)',
        width: 150,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'cfMarginPct',
        label: 'CF MARGIN (%)',
        width: 150,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'intMarginAmt',
        label: 'INT MARGIN(Amt.)',
        width: 150,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'cfMarginAmt',
        label: 'CF MARGIN(Amt.)',
        width: 170,
        isNumeric: true,
      ),
    ];
  }

  Widget _buildCell(TradeMargin item, ViewTableColumn column, bool isDark) {
    switch (column.id) {
      case 'exchange':
        return ViewTextCell(text: item.exchange, isDark: isDark);
      case 'symbol':
        return Padding(
          padding: const EdgeInsets.only(left: 12),
          child: ViewTextCell(text: item.symbol, isDark: isDark, isStart: true),
        );
      case 'expiryDate':
        return ViewDateTimeCell(dateTime: item.expiryDate, isDark: isDark);
      case 'intMarginPct':
        return ViewNumberCell(
          value: item.intMarginPct,
          isDark: isDark,
          colorByValue: false,
        );
      case 'cfMarginPct':
        return ViewNumberCell(
          value: item.cfMarginPct,
          isDark: isDark,
          colorByValue: false,
        );
      case 'intMarginAmt':
        return ViewNumberCell(
          value: item.intMarginAmt,
          isDark: isDark,
          colorByValue: false,
        );
      case 'cfMarginAmt':
        return ViewNumberCell(
          value: item.cfMarginAmt,
          isDark: isDark,
          colorByValue: false,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ViewRecordCount(count: tradeMargins.length),
        Expanded(
          child: ViewDataTable<TradeMargin>(
            columns: _getColumns(),
            data: tradeMargins,
            idExtractor: (item) => item.exchange + item.symbol,
            isDarkMode: isDarkMode,
            autoFit: true,
            emptyMessage: 'No trade margins found',
            cellBuilder: (item, column) => _buildCell(item, column, isDarkMode),
            comparatorBuilder: (item, columnId) {
              switch (columnId) {
                case 'exchange':
                  return item.exchange;
                case 'symbol':
                  return item.symbol;
                case 'expiryDate':
                  return item.expiryDate;
                case 'intMarginPct':
                  return item.intMarginPct;
                case 'cfMarginPct':
                  return item.cfMarginPct;
                case 'intMarginAmt':
                  return item.intMarginAmt;
                case 'cfMarginAmt':
                  return item.cfMarginAmt;
                default:
                  return '';
              }
            },
          ),
        ),
      ],
    );
  }
}
