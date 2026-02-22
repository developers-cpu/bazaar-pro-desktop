import 'package:bazarpro/features/report/domain/entities/exchange_wise_pl/exchange_wise_pl_report.dart';
import 'package:flutter/material.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_data_table_footer.dart';
import '../../../../../core/widget/table/view_record_count.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';
import 'deals_dialog.dart';
import 'exchange_trade_list_dialog.dart';
import 'exchange_open_position_dialog.dart';
class ExchangeWisePLTable extends StatelessWidget {
  final List<ExchangeWisePLReport> reports;
  final bool isDarkMode;
  const ExchangeWisePLTable({
    super.key,
    required this.reports,
    this.isDarkMode = false,
  });
  List<ViewTableColumn> _getColumns() {
    return const [
      ViewTableColumn(id: 'exchange', label: 'EXCH', width: 120),
      ViewTableColumn(id: 'm2m', label: 'M2M', width: 140),
      ViewTableColumn(id: 'realisedPL', label: 'REALISED P/L', width: 140),
      ViewTableColumn(id: 'brokerage', label: 'BRK', width: 120),
      ViewTableColumn(id: 'total', label: 'TOTAL', width: 140),
    ];
  }
  Widget _buildClickableNumberCell(
    BuildContext context,
    double value,
    VoidCallback onTap,
    bool isDark,
  ) {
    return InkWell(
      onTap: onTap,
      child: Center(
        child: Text(
          value.toStringAsFixed(2),
          style:
              ViewTableCellStyles.getTextStyle(
                isDark: isDark,
                color: ViewTableCellStyles.getValueColor(value, isDark: isDark),
              ).copyWith(
                decoration: TextDecoration.underline,
                decorationColor: ViewTableCellStyles.getValueColor(
                  value,
                  isDark: isDark,
                ),
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
  Widget _buildClickableTextCell(
    BuildContext context,
    String text,
    VoidCallback onTap,
    bool isDark,
  ) {
    return InkWell(
      onTap: onTap,
      child: Center(
        child: Text(
          text,
          style: ViewTableCellStyles.getTextStyle(isDark: isDark).copyWith(
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
  Widget _buildCell(
    BuildContext context,
    ExchangeWisePLReport item,
    ViewTableColumn column,
    bool isDark,
  ) {
    switch (column.id) {
      case 'exchange':
        return _buildClickableTextCell(context, item.exchange, () {
          ExchangeTradeListDialog.show(context, exchange: item.exchange);
        }, isDark);
      case 'm2m':
        return _buildClickableNumberCell(context, item.m2m, () {
          ExchangeOpenPositionDialog.show(context, exchange: item.exchange);
        }, isDark);
      case 'realisedPL':
        return _buildClickableNumberCell(context, item.realisedPL, () {
          DealsDialog.show(context, exchange: item.exchange);
        }, isDark);
      case 'brokerage':
        return ViewNumberCell(
          value: item.brokerage,
          isDark: isDark,
          colorByValue: false,
        );
      case 'total':
        return ViewNumberCell(value: item.totalPL, isDark: isDark);
      default:
        return const SizedBox.shrink();
    }
  }
  @override
  Widget build(BuildContext context) {
    double totalM2M = 0;
    double totalRealisedPL = 0;
    double totalBrokerage = 0;
    double totalPL = 0;
    for (var report in reports) {
      totalM2M += report.m2m;
      totalRealisedPL += report.realisedPL;
      totalBrokerage += report.brokerage;
      totalPL += report.totalPL;
    }
    return Column(
      children: [
        ViewRecordCount(count: reports.length),
        Expanded(
          child: ViewDataTable<ExchangeWisePLReport>(
            columns: _getColumns(),
            data: reports,
            idExtractor: (item) => item.exchange,
            sortColumn: null,
            sortAscending: true,
            autoFit: true,
            isDarkMode: isDarkMode,
            emptyMessage: 'No reports found',
            cellBuilder: (item, column) =>
                _buildCell(context, item, column, isDarkMode),
            footerBuilder: (columns) {
              return ViewDataTableFooter(
                columns: columns,
                values: {
                  'exchange': 'TOTAL',
                  'm2m': totalM2M.toStringAsFixed(2),
                  'realisedPL': totalRealisedPL.toStringAsFixed(2),
                  'brokerage': totalBrokerage.toStringAsFixed(2),
                  'total': totalPL.toStringAsFixed(2),
                },
                isDarkMode: isDarkMode,
              );
            },
          ),
        ),
      ],
    );
  }
}
