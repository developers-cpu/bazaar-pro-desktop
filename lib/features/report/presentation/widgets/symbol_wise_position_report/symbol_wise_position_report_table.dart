import 'package:bazarpro/features/report/domain/entities/symbol_wise_position_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../view/presentation/widget/common/view_data_table.dart';
import '../../../../view/presentation/widget/common/view_record_count.dart';
import '../../../../view/presentation/widget/common/view_table_cell_styles.dart';
import '../../../../view/presentation/widget/common/view_data_table_footer.dart';
import '../../bloc/symbol_wise_position_report/symbol_wise_position_report_bloc.dart';
import '../../bloc/symbol_wise_position_report/symbol_wise_position_report_state.dart';

class SymbolWisePositionReportTable extends StatelessWidget {
  final bool isDarkMode;

  const SymbolWisePositionReportTable({super.key, this.isDarkMode = false});

  List<ViewTableColumn> _getColumns() {
    return const [
      ViewTableColumn(id: 'exchange', label: 'EXCH', width: 100),
      ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 180),
      ViewTableColumn(id: 'netQty', label: 'N.QTY', width: 120),
      ViewTableColumn(id: 'netQtyPercent', label: 'N.QTY%', width: 120),
      ViewTableColumn(id: 'avgPrice', label: 'A PRICE', width: 120),
      ViewTableColumn(id: 'brokerage', label: 'BRK', width: 120),
      ViewTableColumn(id: 'wbaPrice', label: 'W.B.A.PRICE', width: 120),
      ViewTableColumn(id: 'cmp', label: 'CMP', width: 120),
      ViewTableColumn(id: 'pl', label: 'P/L', width: 120),
      ViewTableColumn(id: 'plPercent', label: 'P/L(%)', width: 120),
      ViewTableColumn(id: 'brokeragePercent', label: 'BRK%', width: 120),
    ];
  }

  Widget _buildCell(
    SymbolWisePositionReport item,
    ViewTableColumn column,
    bool isDark,
  ) {
    switch (column.id) {
      case 'exchange':
        return ViewTextCell(text: item.exchange, isDark: isDark);
      case 'symbol':
        return ViewTextCell(
          text: item.symbol,
          isDark: isDark,
          fontWeight: FontWeight.bold,
        );
      case 'netQty':
        return ViewTextCell(
          text: item.netQty.toStringAsFixed(2),
          isDark: isDark,
        );
      case 'netQtyPercent':
        return ViewTextCell(
          text: item.netQtyPercent.toStringAsFixed(2),
          isDark: isDark,
        );
      case 'avgPrice':
        return ViewTextCell(
          text: item.avgPrice.toStringAsFixed(2),
          isDark: isDark,
        );
      case 'brokerage':
        return ViewTextCell(
          text: item.brokerage.toStringAsFixed(2),
          isDark: isDark,
        );
      case 'wbaPrice':
        return ViewTextCell(
          text: item.wbaPrice.toStringAsFixed(2),
          isDark: isDark,
        );
      case 'cmp':
        return ViewTextCell(
          text: item.cmp.toStringAsFixed(2),
          isDark: isDark,
          color: Colors.blue,
        );
      case 'pl':
        return ViewTextCell(
          text: item.pl.toStringAsFixed(2),
          isDark: isDark,
          color: item.pl >= 0 ? Colors.blue : Colors.red,
        );
      case 'plPercent':
        return ViewTextCell(
          text: item.plPercent.toStringAsFixed(2),
          isDark: isDark,
          color: item.plPercent >= 0 ? Colors.blue : Colors.red,
        );
      case 'brokeragePercent':
        return ViewTextCell(
          text: item.brokeragePercent.toStringAsFixed(2),
          isDark: isDark,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      SymbolWisePositionReportBloc,
      SymbolWisePositionReportState
    >(
      builder: (context, state) {
        if (state is SymbolWisePositionReportLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is SymbolWisePositionReportError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        if (state is! SymbolWisePositionReportLoaded) {
          return const SizedBox.shrink();
        }

        double totalBrokerage = 0;
        double totalPL = 0;
        double totalPLPercent = 0;
        double totalBrokeragePercent = 0;

        for (var item in state.reports) {
          totalBrokerage += item.brokerage;
          totalPL += item.pl;
          totalPLPercent += item.plPercent;
          totalBrokeragePercent += item.brokeragePercent;
        }

        return Column(
          children: [
            ViewRecordCount(count: state.reports.length),
            Expanded(
              child: ViewDataTable<SymbolWisePositionReport>(
                columns: _getColumns(),
                data: state.reports,
                idExtractor: (item) => item.id,
                sortColumn: null,
                sortAscending: true,
                isDarkMode: isDarkMode,
                emptyMessage: 'No reports found',
                cellBuilder: (item, column) =>
                    _buildCell(item, column, isDarkMode),
                footerBuilder: (columns) {
                  return ViewDataTableFooter(
                    columns: columns,
                    values: {
                      'brokerage': totalBrokerage.toStringAsFixed(2),
                      'pl': totalPL.toStringAsFixed(2),
                      'plPercent': totalPLPercent.toStringAsFixed(2),
                      'brokeragePercent': totalBrokeragePercent.toStringAsFixed(
                        2,
                      ),
                      'exchange': 'Total',
                    },
                    isDarkMode: isDarkMode,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
