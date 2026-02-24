import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../../../../core/widget/table/success_dialog.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_record_count.dart';

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
    return CommonDialog(
      title: 'Square Off',
      width: 800.w,
      height: 600.h,
      showButtons: false,
      headerColor: headerColor,
      contentPadding: EdgeInsets.zero,
      scrollable: false,
      content: Column(
        children: [
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
                      if (val != null) setState(() => _selectedExchange = val);
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
          ViewRecordCount(count: 12550),
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
          child: ViewDataTable<int>(
            columns: _getColumns(),
            data: List.generate(15, (index) => index),
            idExtractor: (item) => item.toString(),
            cellBuilder: (item, column) => _buildCell(item, column),
            isDarkMode: false,
            autoFit: true,
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
      ViewTableColumn(id: 'buyQty', label: 'BUY QTY', width: 100.w),
      ViewTableColumn(id: 'sellQty', label: 'SELL QTY', width: 100.w),
      ViewTableColumn(id: 'qty', label: 'QTY', width: 80.w),
      ViewTableColumn(id: 'pl', label: 'P/L', width: 100.w),
      ViewTableColumn(id: 'tPrice', label: 'T. PRICE', width: 100.w),
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
        return _tableCell('MCX', headerColor);
      case 'symbol':
        return _tableCell('GOLD05DEC', headerColor);
      case 'buyQty':
        return _tableCell('0.00', headerColor);
      case 'sellQty':
        return _tableCell('1.00', AppColors.red);
      case 'qty':
        return _tableCell('-1.00', AppColors.blue);
      case 'pl':
        return _tableCell('36200.00', headerColor);
      case 'tPrice':
        return _tableCell('124191.00', AppColors.red);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _tableCell(String title, Color color, {bool bold = false}) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        title,
        style: GoogleFonts.openSans(
          fontSize: 13.sp,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          color: color,
        ),
      ),
    );
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
        child: SizedBox(
          width: 400.w,
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
                  child: Container(
                    width: 500.w,
                    child: _buildConfirmationContent(),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: headerColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Square Off',
              style: GoogleFonts.openSans(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmationContent() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Square off All Positions',
            style: GoogleFonts.openSans(fontSize: 22.sp, color: headerColor),
          ),
          SizedBox(height: 8.h),
          Text(
            'Are You Sure you want to Square off all Positions?',
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
                side: BorderSide(color: headerColor, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'No',
                style: GoogleFonts.openSans(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: headerColor,
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
                backgroundColor: headerColor,
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
