import 'package:bazarpro/features/report/domain/entities/trade_margin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../view/presentation/widget/common/view_data_table.dart';
import '../../../../view/presentation/widget/common/view_record_count.dart';
import '../../../../view/presentation/widget/common/view_table_cell_styles.dart';
import '../../bloc/trade_margin/trade_margin_bloc.dart';
import '../../bloc/trade_margin/trade_margin_state.dart';

class TradeMarginTable extends StatelessWidget {
  final bool isDarkMode;

  const TradeMarginTable({super.key, this.isDarkMode = false});

  List<ViewTableColumn> _getColumns() {
    return const [
      ViewTableColumn(id: 'exchange', label: 'EXCH', width: 150),
      ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 200),
      ViewTableColumn(id: 'expiryDate', label: 'EXPIRY DATE', width: 250),
      ViewTableColumn(
        id: 'marginPct',
        label: 'MARGIN (%)',
        width: 250,
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
        return ViewLinkCell(text: item.symbol, isDark: isDark);
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
    return BlocBuilder<TradeMarginBloc, TradeMarginState>(
      builder: (context, state) {
        if (state is TradeMarginLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TradeMarginError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        if (state is! TradeMarginLoaded) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            ViewRecordCount(count: state.tradeMargins.length),
            Expanded(
              child: ViewDataTable<TradeMargin>(
                columns: _getColumns(),
                data: state.tradeMargins,
                idExtractor: (item) => item.exchange + item.symbol,
                sortColumn: null,
                sortAscending: true,
                isDarkMode: isDarkMode,
                emptyMessage: 'No trade margins found',
                cellBuilder: (item, column) =>
                    _buildCell(item, column, isDarkMode),
                onSort: (columnId, ascending) {},
              ),
            ),
          ],
        );
      },
    );
  }
}
