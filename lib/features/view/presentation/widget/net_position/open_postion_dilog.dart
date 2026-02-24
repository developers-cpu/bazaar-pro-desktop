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

class OpenPositionDialog extends StatefulWidget {
  final bool isDarkMode;
  const OpenPositionDialog({Key? key, this.isDarkMode = false})
    : super(key: key);
  static void show({required BuildContext context, bool isDarkMode = false}) {
    showDialog(
      context: context,
      barrierColor: AppColors.black.withOpacity(0.54),
      builder: (_) => BlocProvider.value(
        value: context.read<NetPositionBloc>(),
        child: OpenPositionDialog(isDarkMode: isDarkMode),
      ),
    );
  }

  @override
  State<OpenPositionDialog> createState() => _OpenPositionDialogState();
}

class _OpenPositionDialogState extends State<OpenPositionDialog> {
  String? _selectedUser;
  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: 'Open Position',
      isDarkMode: widget.isDarkMode,
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.8,
      headerColor: AppColors.primaryBlue,
      showButtons: false,
      scrollable: false,
      contentPadding: EdgeInsets.zero,
      content: Column(
        children: [
          if (_selectedUser != null) _buildBackRow(),
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
                  final positions = _selectedUser != null
                      ? state.filteredPositions
                            .where((p) => p.userName == _selectedUser)
                            .toList()
                      : state.filteredPositions;
                  return _buildTable(positions);
                }
                return const Center(child: Text('No positions available'));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackRow() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => setState(() => _selectedUser = null),
            child: Icon(
              Icons.arrow_back,
              size: 20.sp,
              color: AppColors.primaryBlue,
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            _selectedUser ?? '',
            style: GoogleFonts.openSans(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(List<NetPosition> positions) {
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
              isDarkMode: widget.isDarkMode,
              autoFit: true,
              headerBgColor: const Color(0xFFD3E3EC),
              emptyMessage: 'No positions found',
              cellBuilder: (item, column) => _buildCell(item, column),
            ),
          ),
        ],
      ),
    );
  }

  List<ViewTableColumn> _getColumns() {
    return const [
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
        width: 120,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'ourPercent',
        label: 'OUR %',
        width: 80,
        isNumeric: true,
      ),
      ViewTableColumn(id: 'user', label: 'USER', width: 60, isNumeric: true),
      ViewTableColumn(id: 'days', label: 'DAYS', width: 60, isNumeric: true),
    ];
  }

  Widget _buildCell(NetPosition item, ViewTableColumn column) {
    switch (column.id) {
      case 'exchange':
        return ViewTextCell(text: item.exchange, isDark: widget.isDarkMode);
      case 'symbol':
        return ViewTextCell(
          text: item.symbol,
          isDark: widget.isDarkMode,
          color: AppColors.primaryBlue,
        );
      case 'buyQty':
        return ViewNumberCell(
          value: item.buyQty,
          fixedColor: item.buyQty > 0 ? AppColors.blue : null,
          isDark: widget.isDarkMode,
        );
      case 'sellQty':
        return ViewNumberCell(
          value: item.sellQty,
          fixedColor: item.sellQty > 0 ? AppColors.red : null,
          isDark: widget.isDarkMode,
        );
      case 'netQty':
        if (_selectedUser == null && item.userCount > 0) {
          return GestureDetector(
            onTap: () => setState(() => _selectedUser = item.userName),
            child: Center(
              child: Text(
                item.netQty.toStringAsFixed(0),
                style: GoogleFonts.openSans(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: item.netQty > 0 ? AppColors.blue : AppColors.red,
                  decoration: TextDecoration.underline,
                  decorationColor: item.netQty > 0
                      ? AppColors.blue
                      : AppColors.red,
                ),
              ),
            ),
          );
        }
        return ViewNumberCell(
          value: item.netQty,
          fixedColor: item.netQty > 0 ? AppColors.blue : AppColors.red,
          isDark: widget.isDarkMode,
        );
      case 'netAvgPrice':
        return ViewNumberCell(
          value: item.netAvgPrice,
          isDark: widget.isDarkMode,
        );
      case 'cmp':
        return ViewNumberCell(
          value: item.cmp,
          fixedColor: AppColors.primaryBlue,
          isDark: widget.isDarkMode,
        );
      case 'mToMAmt':
        return ViewNumberCell(
          value: item.m2mAmount,
          fixedColor: item.m2mAmount >= 0 ? AppColors.blue : AppColors.red,
          isDark: widget.isDarkMode,
        );
      case 'ourPercent':
        return ViewTextCell(
          text: item.ourPercentage.toStringAsFixed(2),
          isDark: widget.isDarkMode,
        );
      case 'user':
        return ViewTextCell(
          text: item.userCount > 0 ? item.userCount.toString() : '-',
          isDark: widget.isDarkMode,
        );
      case 'days':
        return ViewTextCell(
          text: item.days.toString(),
          isDark: widget.isDarkMode,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
