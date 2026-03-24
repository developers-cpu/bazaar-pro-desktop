import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_record_count.dart'
    show ViewRecordCount;
import '../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../bloc/expiry_report/expiry_report_bloc.dart';
import '../../bloc/expiry_report/expiry_report_state.dart';
import '../../../data/models/expiry_report_model.dart';

class ExpiryReportTable extends StatelessWidget {
  final bool isDarkMode;
  const ExpiryReportTable({super.key, this.isDarkMode = false});

  List<ViewTableColumn> _getColumns() {
    return const [
      ViewTableColumn(id: 'exchange', label: 'EXCHANGE', width: 120),
      ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 180),
      ViewTableColumn(
        id: 'expiry',
        label: 'EXPIRY',
        width: 200,
        alignment: Alignment.centerRight,
      ),
      ViewTableColumn(
        id: 'closeDate',
        label: 'CLOSE DATE',
        width: 200,
        alignment: Alignment.centerRight,
      ),
      ViewTableColumn(
        id: 'cutDate',
        label: 'CUT DATE',
        width: 200,
        alignment: Alignment.centerRight,
      ),
    ];
  }

  Widget _buildCell(ExpiryReportModel item, ViewTableColumn column, bool isDark) {
    switch (column.id) {
      case 'exchange':
        return ViewTextCell(
          text: item.exchange,
          isDark: isDark,
          fontWeight: FontWeight.normal,
        );
      case 'symbol':
        return ViewTextCell(
          text: item.symbol,
          isDark: isDark,
          fontWeight: FontWeight.normal,
        );
      case 'expiry':
        return ViewDateTimeCell(dateTime: item.expiry, isDark: isDark);
      case 'closeDate':
        return ViewDateTimeCell(dateTime: item.closeDate, isDark: isDark);
      case 'cutDate':
        return ViewDateTimeCell(dateTime: item.cutDate, isDark: isDark);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpiryReportBloc, ExpiryReportState>(
      builder: (context, state) {
        if (state is ExpiryReportLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ExpiryReportError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        if (state is! ExpiryReportLoaded) {
          return const SizedBox.shrink();
        }
        return Column(
          children: [
            ViewRecordCount(count: state.data.length),
            Flexible(
              fit: FlexFit.loose,
              child: ViewDataTable<ExpiryReportModel>(
                columns: _getColumns(),
                data: state.data,
                idExtractor: (item) =>
                    '${item.exchange}_${item.symbol}_${item.expiry}',
                autoFit: true,
                isDarkMode: isDarkMode,
                emptyMessage: 'No expiry data found',
                cellBuilder: (item, column) =>
                    _buildCell(item, column, isDarkMode),
                comparatorBuilder: (item, columnId) {
                  switch (columnId) {
                    case 'exchange':
                      return item.exchange;
                    case 'symbol':
                      return item.symbol;
                    case 'expiry':
                      return item.expiry;
                    case 'closeDate':
                      return item.closeDate;
                    case 'cutDate':
                      return item.cutDate;
                    default:
                      return '';
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
