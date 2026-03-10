import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_data_table_footer.dart';
import '../../../../../core/widget/table/view_record_count.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_state.dart';
import '../../../domain/entities/credit_history.dart';
import '../../bloc/credit_history/credit_history_bloc.dart';
import '../../bloc/credit_history/credit_history_state.dart';

class CreditHistoryTable extends StatelessWidget {
  final bool isDarkMode;
  const CreditHistoryTable({super.key, this.isDarkMode = false});
  List<ViewTableColumn> _getColumns(bool isClient) {
    if (isClient) {
      return const [
        ViewTableColumn(id: 'dateTime', label: 'DATE TIME', width: 200),
        ViewTableColumn(id: 'type', label: 'TYPE', width: 160),
        ViewTableColumn(
          id: 'amount',
          label: 'AMOUNT',
          width: 200,
          isNumeric: true,
        ),
        ViewTableColumn(
          id: 'balance',
          label: 'BALANCE',
          width: 200,
          isNumeric: true,
        ),
        ViewTableColumn(id: 'comment', label: 'COMMENT', width: 250),
      ];
    }
    return const [
      ViewTableColumn(id: 'userName', label: 'U.NAME', width: 160),
      ViewTableColumn(id: 'dateTime', label: 'DATE TIME', width: 200),
      ViewTableColumn(id: 'type', label: 'TYPE', width: 160),
      ViewTableColumn(
        id: 'amount',
        label: 'AMOUNT',
        width: 200,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'balance',
        label: 'BALANCE',
        width: 200,
        isNumeric: true,
      ),
      ViewTableColumn(id: 'comment', label: 'COMMENT', width: 250),
    ];
  }

  Widget _buildCell(CreditHistory item, ViewTableColumn column, bool isDark) {
    switch (column.id) {
      case 'userName':
        return ViewTextCell(text: item.userName, isDark: isDark);
      case 'dateTime':
        return ViewDateTimeCell(dateTime: item.dateTime, isDark: isDark);
      case 'type':
        Color typeColor = AppColors.primaryTextColor;
        if (item.type.toLowerCase() == 'credit') {
          typeColor = AppColors.blue;
        } else if (item.type.toLowerCase() == 'debit') {
          typeColor = AppColors.red;
        }
        return ViewTextCell(
          text: item.type,
          color: typeColor,
          isDark: isDark,
          isStart: true,
        );
      case 'amount':
        return ViewNumberCell(
          value: item.amount,
          isDark: isDark,
          colorByValue: true,
        );
      case 'balance':
        return ViewNumberCell(value: item.balance, isDark: isDark);
      case 'comment':
        return ViewTextCell(text: item.comment, isDark: isDark);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final isClient =
        authState is AuthAuthenticated &&
        authState.user.role.toLowerCase() == 'client';

    return BlocBuilder<CreditHistoryBloc, CreditHistoryState>(
      builder: (context, state) {
        if (state is CreditHistoryLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is CreditHistoryError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        if (state is! CreditHistoryLoaded) {
          return const SizedBox.shrink();
        }
        double totalAmount = state.creditHistory.fold(
          0,
          (sum, item) => sum + item.amount,
        );
        return Column(
          children: [
            ViewRecordCount(count: state.creditHistory.length),
            Flexible(
              fit: FlexFit.loose,
              child: ViewDataTable<CreditHistory>(
                columns: _getColumns(isClient),
                data: state.creditHistory,
                idExtractor: (item) => item.id,
                autoFit: true,
                isDarkMode: isDarkMode,
                emptyMessage: 'No credit history found',
                cellBuilder: (item, column) =>
                    _buildCell(item, column, isDarkMode),
                comparatorBuilder: (item, columnId) {
                  switch (columnId) {
                    case 'userName':
                      return item.userName;
                    case 'dateTime':
                      return item.dateTime;
                    case 'type':
                      return item.type;
                    case 'amount':
                      return item.amount;
                    case 'balance':
                      return item.balance;
                    case 'comment':
                      return item.comment;
                    default:
                      return '';
                  }
                },
                footerBuilder: (columns) {
                  return ViewDataTableFooter(
                    columns: columns,
                    values: {
                      if (isClient)
                        'dateTime': 'Total'
                      else
                        'userName': 'Total',
                      'amount': totalAmount.toStringAsFixed(2),
                    },
                    isDarkMode: isDarkMode,
                    columnColors: {
                      'amount': ViewTableCellStyles.getValueColor(
                        totalAmount,
                        isDark: isDarkMode,
                      ),
                    },
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
