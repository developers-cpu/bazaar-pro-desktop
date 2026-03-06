import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_data_table_footer.dart';
import '../../../../../core/widget/table/view_record_count.dart'
    show ViewRecordCount;
import '../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../bloc/symbol_wise_pl/symbol_wise_pl_bloc.dart';
import '../../bloc/symbol_wise_pl/symbol_wise_pl_state.dart';
import '../../../domain/entities/symbol_wise_pl/symbol_wise_pl_report.dart';
import '../../../../view/presentation/widget/net_position/net_position_dialog.dart';
import '../../widgets/exchange_wise_pl/deals_dialog.dart';

class ClientSymbolWisePLTable extends StatelessWidget {
  final bool isDarkMode;
  const ClientSymbolWisePLTable({super.key, this.isDarkMode = false});
  List<ViewTableColumn> _getColumns() {
    return const [
      ViewTableColumn(id: 'exchange', label: 'EXCH', width: 80),
      ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 220),
      ViewTableColumn(id: 'm2m', label: 'M2M', width: 140),
      ViewTableColumn(id: 'releasePL', label: 'REALISED P/L', width: 140),
      ViewTableColumn(id: 'brokerage', label: 'BRK', width: 120),
      ViewTableColumn(id: 'netPL', label: 'TOTAL', width: 140),
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

  Widget _buildCell(
    BuildContext context,
    SymbolWisePLReport item,
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
          fontWeight: FontWeight.normal,
        );
      case 'm2m':
        return _buildClickableNumberCell(context, item.m2m, () {
          NetPositionDialog.show(context, symbol: item.symbol);
        }, isDark);
      case 'releasePL':
        return _buildClickableNumberCell(context, item.releasePL, () {
          DealsDialog.show(context, symbol: item.symbol, title: 'Realised P/L');
        }, isDark);
      case 'brokerage':
        return ViewNumberCell(
          value: item.brokerage,
          isDark: isDark,
          colorByValue: false,
        );
      case 'netPL':
        return ViewNumberCell(value: item.netPL, isDark: isDark);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SymbolWisePLBloc, SymbolWisePLState>(
      builder: (context, state) {
        if (state is SymbolWisePLLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is SymbolWisePLError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        if (state is! SymbolWisePLLoaded) {
          return const SizedBox.shrink();
        }
        double totalReleasePL = 0;
        double totalM2M = 0;
        double totalBrokerage = 0;
        double totalNetPL = 0;
        for (var item in state.reports) {
          totalReleasePL += item.releasePL;
          totalM2M += item.m2m;
          totalBrokerage += item.brokerage;
          totalNetPL += item.netPL;
        }
        return Column(
          children: [
            ViewRecordCount(count: state.reports.length),
            Flexible(
              fit: FlexFit.loose,
              child: ViewDataTable<SymbolWisePLReport>(
                columns: _getColumns(),
                data: state.reports,
                idExtractor: (item) => item.id,
                autoFit: true,
                isDarkMode: isDarkMode,
                emptyMessage: 'No reports found',
                cellBuilder: (item, column) =>
                    _buildCell(context, item, column, isDarkMode),
                comparatorBuilder: (item, columnId) {
                  switch (columnId) {
                    case 'exchange':
                      return item.exchange;
                    case 'symbol':
                      return item.symbol;
                    case 'm2m':
                      return item.m2m;
                    case 'releasePL':
                      return item.releasePL;
                    case 'brokerage':
                      return item.brokerage;
                    case 'netPL':
                      return item.netPL;
                    default:
                      return '';
                  }
                },
                footerBuilder: (columns) {
                  return ViewDataTableFooter(
                    columns: columns,
                    values: {
                      'exchange': 'Total',
                      'm2m': totalM2M.toStringAsFixed(2),
                      'releasePL': totalReleasePL.toStringAsFixed(2),
                      'brokerage': totalBrokerage.toStringAsFixed(2),
                      'netPL': totalNetPL.toStringAsFixed(2),
                    },
                    columnColors: {
                      'm2m': ViewTableCellStyles.getValueColor(
                        totalM2M,
                        isDark: isDarkMode,
                      ),
                      'releasePL': ViewTableCellStyles.getValueColor(
                        totalReleasePL,
                        isDark: isDarkMode,
                      ),
                      'netPL': ViewTableCellStyles.getValueColor(
                        totalNetPL,
                        isDark: isDarkMode,
                      ),
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
