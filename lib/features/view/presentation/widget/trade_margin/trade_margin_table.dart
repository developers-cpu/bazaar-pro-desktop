import 'package:bazarpro/features/view/domain/entities/trade_margin/trade_margin.dart';
import 'package:flutter/material.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_record_count.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';

class TradeMarginTable extends StatelessWidget {
  final List<TradeMargin> tradeMargins;
  final bool isDarkMode;
  const TradeMarginTable({
    super.key,
    required this.tradeMargins,
    this.isDarkMode = false,
  });
  List<ViewTableColumn> _getColumns() {
    return const [
      ViewTableColumn(id: 'exchange', label: 'EXCH', width: 100),
      ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 150),
      ViewTableColumn(id: 'expiryDate', label: 'EXPIRY DATE', width: 200),
      ViewTableColumn(
        id: 'marginPct',
        label: 'MARGIN (%)',
        width: 150,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'marginAmt',
        label: 'MARGIN (A.)',
        width: 150,
        isNumeric: true,
      ),
    ];
  }

  Widget _buildCell(TradeMargin item, ViewTableColumn column, bool isDark) {
    switch (column.id) {
      case 'exchange':
        return ViewTextCell(text: item.exchange, isDark: isDark);
      case 'symbol':
        return ViewTextCell(text: item.symbol, isDark: isDark);
      case 'expiryDate':
        return ViewDateTimeCell(dateTime: item.expiryDate, isDark: isDark);
      case 'marginPct':
        return ViewNumberCell(
          value: item.marginPercentage,
          isDark: isDark,
          colorByValue: false,
        );
      case 'marginAmt':
        return ViewNumberCell(
          value: item.marginAmount,
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
            sortColumn: null,
            sortAscending: true,
            isDarkMode: isDarkMode,
            autoFit: true,
            emptyMessage: 'No trade margins found',
            cellBuilder: (item, column) => _buildCell(item, column, isDarkMode),
            onSort: (columnId, ascending) {},
          ),
        ),
      ],
    );
  }
}
