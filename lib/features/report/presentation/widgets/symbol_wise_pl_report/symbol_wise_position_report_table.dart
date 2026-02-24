import 'package:bazarpro/features/report/domain/entities/symbol_wise_position_report.dart';
import 'package:bazarpro/features/report/presentation/widgets/symbol_wise_pl_report/symbol_open_position_dialog.dart';
import 'package:bazarpro/features/report/presentation/widgets/symbol_wise_pl_report/symbol_trade_list_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_record_count.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../../../../core/widget/table/view_data_table_footer.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../bloc/symbol_wise_position_report/symbol_wise_position_report_bloc.dart';
import '../../bloc/symbol_wise_position_report/symbol_wise_position_report_state.dart';

class SymbolWisePositionReportTable extends StatelessWidget {
  final bool isDarkMode;
  const SymbolWisePositionReportTable({super.key, this.isDarkMode = false});
  List<ViewTableColumn> _getColumns() {
    return const [
      ViewTableColumn(id: 'exchange', label: 'EXCH', width: 80),
      ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 180),
      ViewTableColumn(
        id: 'netQty',
        label: 'N.QTY',
        width: 100,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'netMs',
        label: 'N.QTY%',
        width: 100,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'netAvgPrice',
        label: 'A PRICE',
        width: 120,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'brokerage',
        label: 'BRK',
        width: 100,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'wbaPrice',
        label: 'W.B.A.PRICE',
        width: 120,
        isNumeric: true,
      ),
      ViewTableColumn(id: 'cmp', label: 'CMP', width: 120, isNumeric: true),
      ViewTableColumn(id: 'netPL', label: 'P/L', width: 120, isNumeric: true),
      ViewTableColumn(
        id: 'releasePL',
        label: 'P/L(%)',
        width: 120,
        isNumeric: true,
      ),
      ViewTableColumn(id: 'm2m', label: 'BRK%', width: 120, isNumeric: true),
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
          style: ViewTableCellStyles.getTextStyle(
            isDark: isDark,
            color: ViewTableCellStyles.getValueColor(value, isDark: isDark),
          ).copyWith(decoration: TextDecoration.underline),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildCell(
    BuildContext context,
    SymbolWisePositionReport item,
    ViewTableColumn column,
    bool isDark,
  ) {
    final absQty = item.netQty.abs();
    final wbaPrice = absQty > 0
        ? (item.netQty < 0
              ? item.netAvgPrice - (item.brokerage / absQty)
              : item.netAvgPrice + (item.brokerage / absQty))
        : item.netAvgPrice;
    switch (column.id) {
      case 'exchange':
        return ViewTextCell(text: item.exchange, isDark: isDark);
      case 'symbol':
        return ViewLinkCell(
          text: item.symbol,
          isDark: isDark,
          onTap: () =>
              SymbolOpenPositionDialog.show(context, symbol: item.symbol),
        );
      case 'netQty':
        return _buildClickableNumberCell(context, item.netQty, () {
          SymbolTradeListDialog.show(context, symbol: item.symbol);
        }, isDark);
      case 'netMs':
        return ViewNumberCell(value: item.netMs, isDark: isDark);
      case 'netAvgPrice':
        return ViewNumberCell(
          value: item.netAvgPrice,
          isDark: isDark,
          colorByValue: false,
        );
      case 'brokerage':
        return ViewNumberCell(
          value: item.brokerage,
          isDark: isDark,
          colorByValue: false,
        );
      case 'wbaPrice':
        return ViewNumberCell(
          value: wbaPrice,
          isDark: isDark,
          colorByValue: false,
        );
      case 'cmp':
        Color cmpColor = isDark ? Colors.white : Colors.black;
        if (item.netQty != 0) {
          bool isProfit = item.netQty > 0
              ? item.cmp > item.netAvgPrice
              : item.cmp < item.netAvgPrice;
          cmpColor = isProfit ? AppColors.buyColor : AppColors.sellColor;
        }
        return ViewNumberCell(
          value: item.cmp,
          isDark: isDark,
          fixedColor: cmpColor,
        );
      case 'netPL':
        return ViewNumberCell(value: item.netPL, isDark: isDark);
      case 'releasePL':
        return ViewNumberCell(value: item.releasePL, isDark: isDark);
      case 'm2m':
        return ViewNumberCell(value: item.m2m, isDark: isDark);
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
        double totalNetPL = 0;
        double totalReleasePL = 0;
        double totalM2m = 0;
        for (var item in state.reports) {
          totalBrokerage += item.brokerage;
          totalNetPL += item.netPL;
          totalReleasePL += item.releasePL;
          totalM2m += item.m2m;
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
                autoFit: true,
                isDarkMode: isDarkMode,
                emptyMessage: 'No reports found',
                cellBuilder: (item, column) =>
                    _buildCell(context, item, column, isDarkMode),
                footerBuilder: (columns) {
                  return ViewDataTableFooter(
                    columns: columns,
                    values: {
                      'symbol': 'Total',
                      'brokerage': totalBrokerage.toStringAsFixed(2),
                      'netPL': totalNetPL.toStringAsFixed(2),
                      'releasePL': totalReleasePL.toStringAsFixed(2),
                      'm2m': totalM2m.toStringAsFixed(2),
                    },
                    columnColors: {
                      'netPL': totalNetPL >= 0
                          ? AppColors.buyColor
                          : AppColors.sellColor,
                      'releasePL': totalReleasePL >= 0
                          ? AppColors.buyColor
                          : AppColors.sellColor,
                      'm2m': totalM2m >= 0
                          ? AppColors.buyColor
                          : AppColors.sellColor,
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
