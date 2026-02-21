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
import '../common/view_data_table.dart';
import '../common/view_record_count.dart';
import '../common/view_table_cell_styles.dart';

class ScriptMasterTable extends StatelessWidget {
  final bool isDarkMode;
  const ScriptMasterTable({Key? key, this.isDarkMode = false})
    : super(key: key);
  List<ViewTableColumn> _getColumns() {
    return const [
      ViewTableColumn(id: 'exchange', label: 'EXCH', width: 200),
      ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 400),
      ViewTableColumn(id: 'expiryDate', label: 'EXPIRY DATE', width: 300),
      ViewTableColumn(id: 'tradeAttribute', label: 'TRADE ATTR.', width: 220),
      ViewTableColumn(id: 'allowTrade', label: 'ALLOW TRADE', width: 220),
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
        return ViewTextCell(text: item.exchange, isDark: isDark);
      case 'symbol':
        return ViewTextCell(text: item.symbol, isDark: isDark);
      case 'expiryDate':
        return _buildExpiryDateCell(item, isDark);
      case 'tradeAttribute':
        return _buildTradeAttributeCell(item, isDark);
      case 'allowTrade':
        return ViewTextCell(
          text: item.allowTrade ? 'Yes' : 'No',
          isDark: isDark,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildExpiryDateCell(ScriptMaster item, bool isDark) {
    final dateFormat = DateFormat('dd/MM/yy');
    final timeFormat = DateFormat('h:mm:ss a');
    final formattedDate = dateFormat.format(item.expiryDate);
    final formattedTime = timeFormat.format(item.expiryDate);
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        '$formattedDate | $formattedTime',
        style: GoogleFonts.openSans(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: isDark ? Colors.white : AppColors.primaryTextColor,
        ),
      ),
    );
  }

  Widget _buildTradeAttributeCell(ScriptMaster item, bool isDark) {
    final color = item.tradeAttribute.toLowerCase() == 'close'
        ? AppColors.red
        : AppColors.primaryTextColor;
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        item.tradeAttribute,
        style: GoogleFonts.openSans(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: isDark ? Colors.white : color,
        ),
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
