import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../common/success_dialog.dart';
import '../common/view_data_table.dart';

class RollOverDialog extends StatefulWidget {
  const RollOverDialog({Key? key}) : super(key: key);

  static void show({required BuildContext context}) {
    showDialog(
      context: context,
      barrierColor: AppColors.black.withOpacity(0.54),
      builder: (_) => const RollOverDialog(),
    );
  }

  @override
  State<RollOverDialog> createState() => _RollOverDialogState();
}

class _RollOverDialogState extends State<RollOverDialog> {
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
      title: 'Roll Over',
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
                    value: _selectedExchange,
                    hintText: 'Exchange',
                    items: const ['Exchange', 'MCX', 'NSE'],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedExchange = val);
                    },
                  ),
                ),
                SizedBox(width: 16.w),
                SizedBox(
                  width: 200.w,
                  child: AppDropdown(
                    value: _selectedSymbol,
                    hintText: 'Symbol',
                    items: const ['Symbol', 'GOLD05DEC', 'SILVER'],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedSymbol = val);
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'RECORD : 12550',
                  style: GoogleFonts.openSans(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: headerColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
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
      ViewTableColumn(id: 'exchange', label: 'EXCH ⇅', width: 100.w),
      ViewTableColumn(id: 'symbol', label: 'SYMBOL ⇅', width: 160.w),
      ViewTableColumn(id: 'qty', label: 'QTY ⇅', width: 120.w),
      ViewTableColumn(id: 'cmp', label: 'CMP ⇅', width: 150.w),
      ViewTableColumn(
        id: 'rollOverPrice',
        label: 'ROLL OVER PRICE ⇅',
        width: 150.w,
      ),
    ];
  }

  Widget _buildCell(int index, ViewTableColumn column) {
    bool isEven = index % 2 == 0;
    bool isPositive = isEven;
    String qty = index == 0 ? '1000' : (isPositive ? '1.00' : '-1.00');
    Color qtyColor = index == 0
        ? AppColors.blue
        : (isPositive ? AppColors.blue : AppColors.red);
    String cmp = isPositive ? '124536.00' : '-124191.00';
    Color cmpColor = isPositive ? AppColors.blue : AppColors.red;

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
      case 'qty':
        return _tableCell(qty, qtyColor);
      case 'cmp':
        return _tableCell(cmp, cmpColor);
      case 'rollOverPrice':
        return _tableCell(cmp, cmpColor);
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

  Widget _cell(String title, double width, Color color, {bool bold = false}) {
    return SizedBox(
      width: width,
      child: Center(
        child: Text(
          title,
          style: GoogleFonts.openSans(
            fontSize: 13.sp,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            color: color,
          ),
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
                    width: 700.w,
                    height: 550.h,
                    padding: EdgeInsets.symmetric(vertical: 24.h),
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
              'Roll Over',
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
    return Column(
      children: [
        Text(
          'Roll over All Positions',
          style: GoogleFonts.openSans(fontSize: 22.sp, color: headerColor),
        ),
        SizedBox(height: 8.h),
        Text(
          'Are You Sure you want to Roll over all Positions ?',
          style: GoogleFonts.openSans(
            fontSize: 16.sp,
            color: Colors.grey.shade500,
          ),
        ),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'RECORD : ${_selectedIndices.length}',
                style: GoogleFonts.openSans(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: headerColor,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Expanded(
          child: Column(
            children: [
              _buildConfirmationTableHeader(),
              Expanded(
                child: ListView.builder(
                  itemCount: _selectedIndices.length,
                  itemBuilder: (context, index) {
                    return _buildConfirmationTableRow(
                      _selectedIndices.toList()[index],
                      index,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        _buildConfirmationActions(),
      ],
    );
  }

  Widget _buildConfirmationTableHeader() {
    return Container(
      height: 40.h,
      color: const Color(0xFFC6DBE8),
      child: Row(
        children: [
          _dialogHeaderCell('EXCH ⇅', 100.w),
          _dialogHeaderCell('SYMBOL ⇅', 180.w),
          _dialogHeaderCell('QTY ⇅', 140.w),
          _dialogHeaderCell('CMP ⇅', 140.w),
          _dialogHeaderCell('ROLL OVER PRICE ⇅', 140.w, isLast: true),
        ],
      ),
    );
  }

  Widget _dialogHeaderCell(String title, double width, {bool isLast = false}) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(right: BorderSide(color: Colors.white, width: 1.5)),
      ),
      child: Center(
        child: Text(
          title,
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: headerColor,
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmationTableRow(int sourceIndex, int tableIndex) {
    bool isPositive = sourceIndex % 2 == 0;
    String qty = sourceIndex == 0 ? '1000' : (isPositive ? '1.00' : '-1.00');
    Color qtyColor = sourceIndex == 0
        ? AppColors.blue
        : (isPositive ? AppColors.blue : AppColors.red);
    String cmp = isPositive ? '124536.00' : '-124191.00';
    Color cmpColor = isPositive ? AppColors.blue : AppColors.red;
    bool isLast = tableIndex == _selectedIndices.length - 1;

    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: AppColors.greyBorder.withOpacity(0.5),
                ),
              ),
      ),
      child: Row(
        children: [
          _cell('MCX', 100.w, Colors.black87),
          _cell('GOLD05DEC', 180.w, Colors.black87),
          _cell(qty, 140.w, qtyColor),
          _cell(cmp, 140.w, cmpColor),
          _cell(cmp, 140.w, cmpColor),
        ],
      ),
    );
  }

  Widget _buildConfirmationActions() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
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
                  Navigator.pop(context); // close confirmation
                  Future.delayed(Duration.zero, () {
                    SuccessDialog.show(
                      context: context,
                      title: 'Successful !',
                      subtitle:
                          'Selected Position are Successfully Rolled over',
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
      ),
    );
  }
}
