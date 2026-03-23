import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../domain/entities/net_postion/net_position.dart';
import '../../bloc/net_position/net_position_bloc.dart';
import '../../bloc/net_position/net_position_state.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../../../../core/widget/table/view_record_count.dart';

class OpenPositionDialog {
  static void show({
    required BuildContext context,
    bool isDarkMode = false,
    String? userName,
  }) {
    final netPositionBloc = context.read<NetPositionBloc>();
    CommonDialog.show(
      context: context,
      title: userName != null ? 'Open Position - $userName' : 'Open Position',
      isDarkMode: isDarkMode,
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.8,
      headerColor: AppColors.primaryBlue,
      showButtons: false,
      scrollable: false,
      contentPadding: EdgeInsets.zero,
      content: BlocProvider.value(
        value: netPositionBloc,
        child: _OpenPositionContent(isDarkMode: isDarkMode, userName: userName),
      ),
    );
  }
}

class _OpenPositionContent extends StatelessWidget {
  final bool isDarkMode;
  final String? userName;
  const _OpenPositionContent({Key? key, this.isDarkMode = false, this.userName})
    : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<NetPositionBloc, NetPositionState>(
            builder: (context, state) {
              if (state is NetPositionLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is NetPositionError) {
                return Center(
                  child: Text(
                    state.message,
                    style: GoogleFonts.openSans(
                      fontSize: 16.sp,
                      color: AppColors.red,
                    ),
                  ),
                );
              }
              if (state is NetPositionLoaded) {
                final positions = userName != null
                    ? state.filteredPositions
                          .where((p) => p.userName == userName)
                          .toList()
                    : state.filteredPositions;
                return _buildTable(context, positions);
              }
              return const Center(child: Text('No positions available'));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTable(BuildContext context, List<NetPosition> positions) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        children: [
          ViewRecordCount(count: positions.length),
          Expanded(
            child: ViewDataTable<NetPosition>(
              columns: _getColumns(),
              data: positions,
              idExtractor: (item) =>
                  '${item.userName}_${item.symbol}_${item.exchange}',
              isDarkMode: isDarkMode,
              autoFit: true,
              comparatorBuilder: (item, columnId) {
                switch (columnId) {
                  case 'userName':
                    return item.userName;
                  case 'pUser':
                    return item.pUser;
                  case 'exchange':
                    return item.exchange;
                  case 'symbol':
                    return item.symbol;
                  case 'buyQty':
                    return item.buyQty;
                  case 'sellQty':
                    return item.sellQty;
                  case 'netQty':
                    return item.netQty;
                  case 'netAvgPrice':
                    return item.netAvgPrice;
                  case 'cmp':
                    return item.cmp;
                  case 'm2mAmount':
                    return item.m2mAmount;
                  case 'ourPercentage':
                    return item.ourPercentage;
                  default:
                    return '';
                }
              },
              headerBgColor: const Color(0xFFD3E3EC),
              emptyMessage: 'No positions found',
              cellBuilder: (item, column) => _buildCell(context, item, column),
            ),
          ),
        ],
      ),
    );
  }

  List<ViewTableColumn> _getColumns() {
    return const [
      ViewTableColumn(id: 'userName', label: 'U.NAME', width: 100),
      ViewTableColumn(id: 'exchange', label: 'EXCH', width: 80),
      ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 130),
      ViewTableColumn(
        id: 'buyQty',
        label: 'BUY QTY',
        width: 100,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'sellQty',
        label: 'SELL QTY',
        width: 100,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'netQty',
        label: 'NET QTY',
        width: 100,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'netAvgPrice',
        label: 'NET AVG PRICE',
        width: 130,
        isNumeric: true,
      ),
      ViewTableColumn(id: 'cmp', label: 'CMP', width: 100, isNumeric: true),
      ViewTableColumn(
        id: 'mToMAmt',
        label: 'M2M AMT',
        width: 100,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'ourPercent',
        label: 'OUR %',
        width: 80,
        isNumeric: true,
      ),
      ViewTableColumn(id: 'user', label: 'USER', width: 60, isNumeric: true),
      ViewTableColumn(id: 'days', label: 'DAYS', width: 80, isNumeric: true),
    ];
  }

  Widget _buildCell(
    BuildContext context,
    NetPosition item,
    ViewTableColumn column,
  ) {
    switch (column.id) {
      case 'userName':
        return ViewTextCell(text: item.userName, isDark: isDarkMode);
      case 'exchange':
        return ViewTextCell(text: item.exchange, isDark: isDarkMode);
      case 'symbol':
        return ViewTextCell(
          text: item.symbol,
          isDark: isDarkMode,
          color: AppColors.primaryBlue,
        );
      case 'buyQty':
        return ViewNumberCell(
          value: item.buyQty,
          fixedColor: item.buyQty > 0 ? AppColors.blue : null,
          isDark: isDarkMode,
        );
      case 'sellQty':
        return ViewNumberCell(
          value: item.sellQty,
          fixedColor: item.sellQty > 0 ? AppColors.red : null,
          isDark: isDarkMode,
        );
      case 'netQty':
        if (userName == null && item.userCount > 0) {
          final color = item.netQty > 0 ? AppColors.blue : AppColors.red;
          return GestureDetector(
            onTap: () => OpenPositionDialog.show(
              context: context,
              isDarkMode: isDarkMode,
              userName: item.userName,
            ),
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
                    isDark: isDarkMode,
                    color: color,
                  ),
                  maxLines: 1,
                  softWrap: false,
                ),
              ),
            ),
          );
        }
        return ViewNumberCell(
          value: item.netQty,
          fixedColor: item.netQty > 0 ? AppColors.blue : AppColors.red,
          isDark: isDarkMode,
        );
      case 'netAvgPrice':
        return ViewNumberCell(value: item.netAvgPrice, isDark: isDarkMode);
      case 'cmp':
        return ViewNumberCell(
          value: item.cmp,
          fixedColor: AppColors.primaryBlue,
          isDark: isDarkMode,
        );
      case 'mToMAmt':
        return ViewNumberCell(
          value: item.m2mAmount,
          fixedColor: item.m2mAmount >= 0 ? AppColors.blue : AppColors.red,
          isDark: isDarkMode,
        );
      case 'ourPercent':
        return ViewNumberCell(
          value: item.ourPercentage,
          displayText: item.ourPercentage.toStringAsFixed(2),
          isDark: isDarkMode,
          colorByValue: false,
        );
      case 'user':
        return ViewNumberCell(
          value: double.tryParse(item.userCount.toString()) ?? 0,
          displayText: item.userCount > 0 ? item.userCount.toString() : '-',
          isDark: isDarkMode,
          colorByValue: false,
        );
      case 'days':
        return ViewNumberCell(
          value: item.days.toDouble(),
          displayText: item.days.toString(),
          colorByValue: false,
          isDark: isDarkMode,
          padding: EdgeInsets.only(right: 15.w),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
