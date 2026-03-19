import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../domain/entities/script_master/script_master.dart';
import '../../bloc/script_master/script_master_bloc.dart';
import '../../bloc/script_master/script_master_event.dart';
import '../../bloc/script_master/script_master_state.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_record_count.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';

class ScriptMasterTable extends StatelessWidget {
  final bool isDarkMode;
  const ScriptMasterTable({Key? key, this.isDarkMode = false})
    : super(key: key);
  List<ViewTableColumn> _getColumns() {
    return const [
      ViewTableColumn(id: 'exchange', label: 'EXCH', width: 80),
      ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 80),
      ViewTableColumn(
        id: 'expiryDate',
        label: 'EXPIRY DATE',
        width: 80,
        isNumeric: true,
      ),
      ViewTableColumn(id: 'tradeAttribute', label: 'TRADE ATTR.', width: 80),
      ViewTableColumn(id: 'allowTrade', label: 'ALLOW TRADE', width: 80),
    ];
  }

  Widget _buildCell(
    BuildContext context,
    ScriptMaster item,
    ViewTableColumn column,
    bool isDark,
  ) {
    switch (column.id) {
      case 'exchange':
        return Padding(
          padding: const EdgeInsets.only(left: 12),
          child: ViewTextCell(
            text: item.exchange,
            isDark: isDark,
            isStart: true,
          ),
        );
      case 'symbol':
        return Padding(
          padding: const EdgeInsets.only(left: 12),
          child: ViewTextCell(text: item.symbol, isDark: isDark, isStart: true),
        );
      case 'expiryDate':
        return _buildExpiryDateCell(item, isDark);
      case 'tradeAttribute':
        return _buildTradeAttributeCell(item, isDark);
      case 'allowTrade':
        final text = item.allowTrade ? 'Yes' : 'No';
        final textColor = item.allowTrade
            ? (isDark
                  ? DarkThemeColors.positiveTextColor
                  : LightThemeColors.positiveTextColor)
            : (isDark
                  ? DarkThemeColors.negativeTextColor
                  : LightThemeColors.negativeTextColor);
        return Padding(
          padding: const EdgeInsets.only(left: 12),
          child: ViewTextCell(
            text: text,
            color: textColor,
            isDark: isDark,
            isStart: true,
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildExpiryDateCell(ScriptMaster item, bool isDark) {
    final dateFormat = DateFormat('dd/MM/yy');
    final formattedDate = dateFormat.format(item.expiryDate);
    return ViewTextCell(text: formattedDate, isDark: isDark, isNumeric: true);
  }

  Widget _buildTradeAttributeCell(ScriptMaster item, bool isDark) {
    Color textColor = isDark
        ? DarkThemeColors.textColor
        : LightThemeColors.textColor;
    if (item.tradeAttribute.toLowerCase() == 'full') {
      textColor = isDark
          ? DarkThemeColors.positiveTextColor
          : LightThemeColors.positiveTextColor;
    } else if (item.tradeAttribute.toLowerCase() == 'close') {
      textColor = isDark
          ? DarkThemeColors.negativeTextColor
          : LightThemeColors.negativeTextColor;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: ViewTextCell(
        text: item.tradeAttribute,
        color: textColor,
        isDark: isDark,
        isStart: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScriptMasterBloc, ScriptMasterState>(
      builder: (context, state) {
        if (state is ScriptMasterLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ScriptMasterError) {
          return _buildErrorState(context, state.message);
        }
        if (state is! ScriptMasterLoaded) {
          return const SizedBox.shrink();
        }
        return Column(
          children: [
            ViewRecordCount(count: state.totalRecords),
            Expanded(
              child: ViewDataTable<ScriptMaster>(
                columns: _getColumns(),
                data: state.filteredScripts,
                idExtractor: (item) => item.id,
                selectedId: state.selectedScriptId,
                sortColumn: state.sortColumn,
                sortAscending: state.sortAscending,
                isDarkMode: isDarkMode,
                autoFit: true,
                emptyMessage: 'No script masters found',
                cellBuilder: (item, column) =>
                    _buildCell(context, item, column, isDarkMode),
                onRowTap: (item) {
                  context.read<ScriptMasterBloc>().add(
                    SelectScriptEvent(item.id),
                  );
                },
                onSort: (columnId, ascending) {
                  context.read<ScriptMasterBloc>().add(
                    SortScriptsByColumnEvent(
                      columnId: columnId,
                      ascending: ascending,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: GoogleFonts.openSans(fontSize: 14.sp, color: AppColors.red),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () {
              context.read<ScriptMasterBloc>().add(
                const LoadScriptMastersEvent(),
              );
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}