import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../../../../core/widget/table/success_dialog.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_record_count.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_state.dart';
import 'package:google_fonts/google_fonts.dart';

class SquareOffDialog extends StatefulWidget {
  const SquareOffDialog({Key? key}) : super(key: key);
  static void show({required BuildContext context}) {
    showDialog(
      context: context,
      barrierColor: AppColors.black.withOpacity(0.54),
      builder: (_) => const SquareOffDialog(),
    );
  }

  @override
  State<SquareOffDialog> createState() => _SquareOffDialogState();
}

class _SquareOffDialogState extends State<SquareOffDialog> {
  String _selectedExchange = 'Exchange';
  String _selectedSymbol = 'Symbol';
  final Color headerColor = const Color(0xFF2C5F7A);
  Set<int> _selectedIndices = {
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
  };
  bool _selectAll = true;
  void _toggleSelectAll() {
    setState(() {
      _selectAll = !_selectAll;
      if (_selectAll) {
        _selectedIndices = Set.from(List.generate(15, (index) => index));
      } else {
        _selectedIndices.clear();
      }
    });
  }

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
        _selectAll = false;
      } else {
        _selectedIndices.add(index);
        if (_selectedIndices.length == 15) {
          _selectAll = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final isClient =
        authState is AuthAuthenticated &&
        authState.user.role.toLowerCase() == 'client';

    return CommonDialog(
      title: 'Square Off',
      width: 800.w,
      height: 600.h,
      showButtons: false,
      contentPadding: EdgeInsets.zero,
      scrollable: false,
      content: Column(
        children: [
          if (!isClient)
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  SizedBox(
                    width: 200.w,
                    child: AppDropdown(
                      type: AppDropdownType.simple,
                      value: _selectedExchange,
                      hintText: 'Exchange',
                      items: const [
                        'NSE',
                        'MCX',
                        'CE/PE',
                        'OTHERS',
                        'COMEX',
                        'CRYPTO',
                        'GIFT',
                        'FOREX',
                      ],
                      onChanged: (val) {
                        if (val != null)
                          setState(() => _selectedExchange = val);
                      },
                    ),
                  ),
                  SizedBox(width: 16.w),
                  SizedBox(
                    width: 200.w,
                    child: AppDropdown(
                      type: AppDropdownType.search,
                      value: _selectedSymbol,
                      hintText: 'Symbol',
                      items: const [
                        'GIFTNIFTY Oct 28',
                        'NIFTY Oct 28',
                        'BANKNIFTY Oct 28',
                        'MINI GOLDMINI Dec 05',
                        'MINI SILVERMINI Dec 05',
                        'DOW Dec 19',
                        'NASDAQ Dec 19',
                        'S & P Dec 19',
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedSymbol = val);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ViewRecordCount(count: 15),
          Expanded(child: _buildTable()),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildTable() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
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
            ),
          ),
        ),
      ],
    );
  }

  List<ViewTableColumn> _getColumns() {
    return [
      ViewTableColumn(
        id: 'select',
        label: '',
        width: 40.w,
        sortable: false,
        customHeaderWidget: GestureDetector(
          onTap: _toggleSelectAll,
          child: _buildCheckbox(_selectAll),
        ),
      ),
      ViewTableColumn(id: 'exchange', label: 'EXCH', width: 80.w),
      ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 120.w),
      ViewTableColumn(
        id: 'buyQty',
        label: 'BUY QTY',
        width: 100.w,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'sellQty',
        label: 'SELL QTY',
        width: 100.w,
        isNumeric: true,
      ),
      ViewTableColumn(id: 'qty', label: 'QTY', width: 80.w, isNumeric: true),
      ViewTableColumn(id: 'pl', label: 'P/L', width: 100.w, isNumeric: true),
      ViewTableColumn(
        id: 'tPrice',
        label: 'T. PRICE',
        width: 100.w,
        isNumeric: true,
      ),
    ];
  }

  Widget _buildCell(int index, ViewTableColumn column) {
    switch (column.id) {
      case 'select':
        return Center(
          child: GestureDetector(
            onTap: () => _toggleSelection(index),
            child: _buildCheckbox(_selectedIndices.contains(index)),
          ),
        );
      case 'exchange':
        return ViewTextCell(text: 'MCX');
      case 'symbol':
        return ViewTextCell(text: 'GOLD05DEC');
      case 'buyQty':
        return ViewNumberCell(value: 0.0, displayText: '0.00');
      case 'sellQty':
        return ViewNumberCell(
          value: 1.0,
          displayText: '1.00',
          fixedColor: AppColors.red,
        );
      case 'qty':
        return ViewNumberCell(
          value: -1.0,
          displayText: '-1.00',
          fixedColor: AppColors.blue,
        );
      case 'pl':
        return ViewNumberCell(value: 36200.0, displayText: '36200.00');
      case 'tPrice':
        return ViewNumberCell(
          value: 124191.0,
          displayText: '124191.00',
          fixedColor: AppColors.red,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildCheckbox(bool value) {
    return Container(
      width: 18.w,
      height: 18.w,
      decoration: BoxDecoration(
        color: value ? headerColor : Colors.transparent,
        border: Border.all(
          color: value ? headerColor : AppColors.greyBorder,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: value ? Icon(Icons.check, size: 14.sp, color: Colors.white) : null,
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSquareOffButton('Square Off', 'All', AppColors.primaryBlue),
          ],
        ),
      ),
    );
  }

  Widget _buildSquareOffButton(String text, String type, Color color) {
    return SizedBox(
      height: 40.h,
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: SizedBox(width: 500.w, child: _buildConfirmationContent()),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
        ),
        child: Text(
          text,
          style: GoogleFonts.openSans(fontSize: 14.sp, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildConfirmationContent() {
    String title = 'Square off All Positions';
    String message = 'Are You Sure you want to Square off all Positions?';

    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: GoogleFonts.openSans(
              fontSize: 22.sp,
              color: AppColors.primaryBlue,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            message,
            style: GoogleFonts.openSans(
              fontSize: 16.sp,
              color: Colors.grey.shade500,
            ),
          ),
          SizedBox(height: 24.h),
          _buildConfirmationActions(),
        ],
      ),
    );
  }

  Widget _buildConfirmationActions() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 40.h,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.primaryBlue, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'No',
                style: GoogleFonts.openSans(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: SizedBox(
            height: 40.h,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Future.delayed(Duration.zero, () {
                  SuccessDialog.show(
                    context: context,
                    title: 'Successful !',
                    subtitle: 'Selected Position are Successfully Squared off',
                  );
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'Yes',
                style: GoogleFonts.openSans(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
