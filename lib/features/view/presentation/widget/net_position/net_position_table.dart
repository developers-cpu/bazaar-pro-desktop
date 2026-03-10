import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../domain/entities/net_postion/net_position.dart';
import '../../bloc/net_position/net_position_bloc.dart';
import '../../bloc/net_position/net_position_event.dart';
import '../../bloc/net_position/net_position_state.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_data_table_footer.dart';
import '../../../../../core/widget/table/view_record_count.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';
import 'open_postion_dilog.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_state.dart';

class NetPositionTable extends StatelessWidget {
  final bool showDeviceInfo;
  final bool isDarkMode;
  const NetPositionTable({
    Key? key,
    this.showDeviceInfo = true,
    this.isDarkMode = false,
  }) : super(key: key);

  List<ViewTableColumn> _getColumns(bool isClient) {
    if (isClient) {
      return const [
        ViewTableColumn(id: 'exchange', label: 'EXCH', width: 70),
        ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 140),
        ViewTableColumn(
          id: 'buyQty',
          label: 'BUY QTY',
          width: 90,
          isNumeric: true,
        ),
        ViewTableColumn(
          id: 'sellQty',
          label: 'SELL QTY',
          width: 90,
          isNumeric: true,
        ),
        ViewTableColumn(
          id: 'netQty',
          label: 'NET QTY',
          width: 90,
          isNumeric: true,
        ),
        ViewTableColumn(
          id: 'netAvgPrice',
          label: 'NET AVG.PRICE',
          width: 130,
          isNumeric: true,
        ),
        ViewTableColumn(id: 'cmp', label: 'CMP', width: 100, isNumeric: true),
        ViewTableColumn(
          id: 'm2mAmount',
          label: 'M2M',
          width: 110,
          isNumeric: true,
        ),
        ViewTableColumn(id: 'days', label: 'DAY', width: 50, isNumeric: true),
      ];
    }
    return const [
      ViewTableColumn(id: 'exchange', label: 'EXCH', width: 110),
      ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 160),
      ViewTableColumn(
        id: 'buyQty',
        label: 'BUY QTY',
        width: 130,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'sellQty',
        label: 'SELL QTY',
        width: 130,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'netQty',
        label: 'NET QTY',
        width: 130,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'netAvgPrice',
        label: 'NET AVG PRICE',
        width: 220,
        isNumeric: true,
      ),
      ViewTableColumn(id: 'cmp', label: 'CMP', width: 120, isNumeric: true),
      ViewTableColumn(
        id: 'm2mAmount',
        label: 'M2M AMT',
        width: 150,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'ourPercentage',
        label: 'OUR %',
        width: 150,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'userCount',
        label: 'USER',
        width: 90,
        isNumeric: true,
      ),
    ];
  }

  Widget _buildCell(
    BuildContext context,
    NetPosition item,
    ViewTableColumn column,
    bool isDark,
    bool isClient,
  ) {
    switch (column.id) {
      case 'exchange':
        return ViewTextCell(text: item.exchange, isDark: isDark);
      case 'symbol':
        return isClient
            ? ViewTextCell(
                text: item.symbol,
                isDark: isDark,
                color: AppColors.primaryBlue,
              )
            : ViewTextCell(
                text: item.symbol,
                isDark: isDark,
                color: AppColors.primaryBlue,
              );
      case 'buyQty':
        return ViewNumberCell(
          value: item.buyQty,
          fixedColor: item.buyQty > 0
              ? AppColors.blue
              : AppColors.primaryTextColor,
          isDark: isDark,
        );
      case 'sellQty':
        return ViewNumberCell(
          value: item.sellQty,
          fixedColor: item.sellQty > 0
              ? AppColors.red
              : AppColors.primaryTextColor,
          isDark: isDark,
        );
      case 'netQty':
        return _buildNetQtyCell(context, item, isDark, isClient);
      case 'netAvgPrice':
        return ViewNumberCell(
          value: item.netAvgPrice,
          fixedColor: item.netAvgPrice >= 0
              ? AppColors.primaryBlue
              : AppColors.red,
          isDark: isDark,
        );
      case 'cmp':
        return ViewNumberCell(
          value: item.cmp,
          fixedColor: AppColors.primaryBlue,
          isDark: isDark,
        );
      case 'm2mAmount':
        return ViewNumberCell(
          value: item.m2mAmount,
          fixedColor: item.m2mAmount >= 0 ? AppColors.blue : AppColors.red,
          isDark: isDark,
        );
      case 'ourPercentage':
        return ViewNumberCell(
          value: item.ourPercentage,
          fixedColor: item.ourPercentage >= 0 ? AppColors.blue : AppColors.red,
          isDark: isDark,
        );
      case 'userCount':
        return ViewTextCell(text: item.userCount.toString(), isDark: isDark);
      case 'days':
        return ViewTextCell(text: item.days.toString(), isDark: isDark);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildNetQtyCell(
    BuildContext context,
    NetPosition item,
    bool isDark,
    bool isClient,
  ) {
    final color = item.netQty > 0 ? AppColors.blue : AppColors.red;

    if (isClient) {
      return ViewNumberCell(
        value: item.netQty,
        fixedColor: color,
        isDark: isDark,
      );
    }

    return GestureDetector(
      onTap: () {
        context.read<NetPositionBloc>().add(SelectPositionEvent(item.id));
        OpenPositionDialog.show(context: context, isDarkMode: isDark);
      },
      child: Container(
        width: double.infinity,
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.only(bottom: 2),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: color, width: 2.0)),
          ),
          child: Text(
            item.netQty == item.netQty.toInt()
                ? item.netQty.toInt().toString()
                : item.netQty.toStringAsFixed(2),
            textAlign: TextAlign.end,
            style: ViewTableCellStyles.getTextStyle(
              isDark: isDark,
              color: color,
            ),
            maxLines: 1,
            softWrap: false,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final isClient =
        authState is AuthAuthenticated &&
        authState.user.role.toLowerCase() == 'client';

    return BlocBuilder<NetPositionBloc, NetPositionState>(
      builder: (context, state) {
        if (state is NetPositionLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is NetPositionError) {
          return _buildErrorState(context, state.message);
        }
        if (state is! NetPositionLoaded) {
          return const SizedBox.shrink();
        }
        return Column(
          children: [
            if (!isClient) ViewRecordCount(count: state.totalRecords),
            Expanded(
              child: ViewDataTable<NetPosition>(
                columns: _getColumns(isClient),
                data: state.filteredPositions,
                idExtractor: (item) => item.id,
                selectedId: state.selectedPositionId,
                sortColumn: state.sortColumn,
                sortAscending: state.sortAscending,
                isDarkMode: isDarkMode,
                autoFit: true,
                emptyMessage: 'No net positions found',
                cellBuilder: (item, column) =>
                    _buildCell(context, item, column, isDarkMode, isClient),
                onRowTap: (item) {
                  context.read<NetPositionBloc>().add(
                    SelectPositionEvent(item.id),
                  );
                  if (isClient) {
                    OpenPositionDialog.show(
                      context: context,
                      isDarkMode: isDarkMode,
                    );
                  }
                },
                onSort: (columnId, ascending) {
                  context.read<NetPositionBloc>().add(
                    SortPositionsByColumnEvent(
                      columnId: columnId,
                      ascending: ascending,
                    ),
                  );
                },
                footerBuilder: isClient
                    ? null
                    : (columns) =>
                          _buildTotalsRow(columns, state.filteredPositions),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTotalsRow(
    List<ViewTableColumn> columns,
    List<NetPosition> positions,
  ) {
    double totalM2M = positions.fold(0.0, (sum, item) => sum + item.m2mAmount);
    double totalOurPercentage = positions.fold(
      0.0,
      (sum, item) => sum + item.ourPercentage,
    );
    final Map<String, String> values = {
      'exchange': 'TOTAL',
      'm2mAmount': totalM2M.toStringAsFixed(2),
      'ourPercentage': totalOurPercentage.toStringAsFixed(2),
    };
    final Map<String, Color> columnColors = {
      'm2mAmount': totalM2M >= 0 ? AppColors.blue : AppColors.red,
      'ourPercentage': totalOurPercentage >= 0 ? AppColors.blue : AppColors.red,
      'exchange': isDarkMode ? Colors.white : AppColors.primaryTextColor,
    };
    return ViewDataTableFooter(
      columns: columns,
      values: values,
      columnColors: columnColors,
      isDarkMode: isDarkMode,
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
              context.read<NetPositionBloc>().add(
                const LoadNetPositionsEvent(),
              );
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
