import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_data_table_footer.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_state.dart';

class UsedMarginDialog {
  static void show({required BuildContext context}) {
    CommonDialog.show(
      context: context,
      title: 'Used Margin',
      width: 600.w,
      height: 500.h,
      showButtons: false,
      contentPadding: EdgeInsets.zero,
      scrollable: false,
      content: const _UsedMarginDialogContent(),
    );
  }
}

class _UsedMarginDialogContent extends StatefulWidget {
  const _UsedMarginDialogContent({Key? key}) : super(key: key);
  @override
  State<_UsedMarginDialogContent> createState() =>
      _UsedMarginDialogContentState();
}

class _UsedMarginDialogContentState extends State<_UsedMarginDialogContent> {
  String _selectedUserType = 'User Type';
  String _selectedUser = 'User';
  String _selectedExchange = 'Exchange';
  String _selectedSymbol = 'Symbol';
  final Color headerColor = const Color(0xFF2C5F7A);
  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final isClient =
        authState is AuthAuthenticated &&
        authState.user.role.toLowerCase() == 'client';
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              if (!isClient) ...[
                Expanded(
                  child: AppDropdown(
                    value: _selectedUserType,
                    hintText: 'User Type',
                    items: const ['Client', 'Master'],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedUserType = val);
                    },
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: AppDropdown(
                    value: _selectedUser,
                    hintText: 'Username',
                    items: const ['John Doe', 'Jane Doe'],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedUser = val);
                    },
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: AppDropdown(
                    value: _selectedExchange,
                    hintText: 'Exchange',
                    items: const [
                      'NSE',
                      'MCX',
                      'CE/PE',
                      'OTHERS',
                      'COMEX FUTURE',
                      'COMEX SPOT',
                      'CRYPTO',
                      'GIFT',
                      'FOREX',
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedExchange = val);
                    },
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: AppDropdown(
                    type: AppDropdownType.search,
                    value: _selectedSymbol,
                    hintText: 'Symbol',
                    items: const [
                      'SGX GIFTNIFTY Oct 28',
                      'NSE NIFTY Oct 28',
                      'NSE BANKNIFTY Oct 28',
                      'MINI GOLDMINI Dec 05',
                      'MINI SILVERMINI Dec 05',
                      'OTHER DOW Dec 19',
                      'OTHER NASDAQ Dec 19',
                      'OTHER S & P Dec 19',
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedSymbol = val);
                    },
                  ),
                ),
              ] else ...[
                Expanded(
                  child: AppDropdown(
                    value: _selectedExchange,
                    hintText: 'Exchange',
                    items: const [
                      'NSE',
                      'MCX',
                      'CE/PE',
                      'OTHERS',
                      'COMEX FUTURE',
                      'COMEX SPOT',
                      'CRYPTO',
                      'GIFT',
                      'FOREX',
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedExchange = val);
                    },
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: AppDropdown(
                    type: AppDropdownType.search,
                    value: _selectedSymbol,
                    hintText: 'Symbol',
                    items: const [
                      'SGX GIFTNIFTY Oct 28',
                      'NSE NIFTY Oct 28',
                      'NSE BANKNIFTY Oct 28',
                      'MINI GOLDMINI Dec 05',
                      'MINI SILVERMINI Dec 05',
                      'OTHER DOW Dec 19',
                      'OTHER NASDAQ Dec 19',
                      'OTHER S & P Dec 19',
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedSymbol = val);
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: _buildTable(),
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildTable() {
    return Column(
      children: [
        Expanded(
          child: ViewDataTable<int>(
            columns: _getColumns(),
            data: List.generate(15, (index) => index),
            idExtractor: (item) => item.toString(),
            comparatorBuilder: (item, columnId) {
              return item;
            },
            cellBuilder: (item, column) => _buildCell(item, column),
            isDarkMode: false,
            autoFit: true,
            footerBuilder: (columns) => _buildTotalsRow(columns),
          ),
        ),
      ],
    );
  }

  List<ViewTableColumn> _getColumns() {
    return [
      ViewTableColumn(id: 'exchange', label: 'EXCH', width: 80.w),
      ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 110.w),
      ViewTableColumn(
        id: 'netQty',
        label: 'NET. QTY',
        width: 90.w,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'usedMargin',
        label: 'USED MARGIN',
        width: 110.w,
        isNumeric: true,
      ),
    ];
  }

  Widget _buildCell(int index, ViewTableColumn column) {
    bool isEven = index % 2 == 0;
    String qty = index % 3 == 0 ? '1000' : (isEven ? '1.00' : '-1.00');
    Color qtyColor = qty.startsWith('-') ? AppColors.red : AppColors.blue;
    switch (column.id) {
      case 'exchange':
        return ViewTextCell(text: 'MCX');
      case 'symbol':
        return ViewTextCell(text: 'GOLD05DEC');
      case 'netQty':
        return ViewNumberCell(
          value: double.tryParse(qty) ?? 0.0,
          displayText: qty,
          fixedColor: qtyColor,
        );
      case 'usedMargin':
        return ViewNumberCell(
          value: 50000.0,
          displayText: '50000',
          fixedColor: AppColors.blue,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTotalsRow(List<ViewTableColumn> columns) {
    final Map<String, String> values = {
      'exchange': 'TOTAL',
      'usedMargin': '7856023',
    };
    return ViewDataTableFooter(
      columns: columns,
      values: values,
      isDarkMode: false,
    );
  }
}