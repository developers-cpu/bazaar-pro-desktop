import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../../../core/widget/app_dropdown.dart';
class UsedMarginDialog extends StatefulWidget {
  const UsedMarginDialog({Key? key}) : super(key: key);
  static void show({required BuildContext context}) {
    showDialog(
      context: context,
      barrierColor: AppColors.black.withOpacity(0.54),
      builder: (_) => const UsedMarginDialog(),
    );
  }
  @override
  State<UsedMarginDialog> createState() => _UsedMarginDialogState();
}
class _UsedMarginDialogState extends State<UsedMarginDialog> {
  String _selectedUserType = 'User Type';
  String _selectedUser = 'User';
  String _selectedExchange = 'Exchange';
  String _selectedSymbol = 'Symbol';
  final Color headerColor = const Color(0xFF2C5F7A);
  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: 'Used Margin',
      width: 700.w,
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
                Expanded(
                  child: AppDropdown(
                    value: _selectedUserType,
                    hintText: 'User Type',
                    items: const ['User Type', 'Client', 'Master'],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedUserType = val);
                    },
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: AppDropdown(
                    value: _selectedUser,
                    hintText: 'User',
                    items: const ['User', 'John Doe', 'Jane Doe'],
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
                    items: const ['Exchange', 'MCX', 'NSE'],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedExchange = val);
                    },
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
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
          SizedBox(height: 8.h),
          Expanded(child: _buildTable()),
        ],
      ),
    );
  }
  Widget _buildTable() {
    return Column(
      children: [
        _buildTableHeader(),
        Expanded(
          child: ListView.builder(
            itemCount: 15,
            itemBuilder: (context, index) {
              return _buildTableRow(index);
            },
          ),
        ),
        _buildTableFooter(),
      ],
    );
  }
  Widget _buildTableHeader() {
    return Container(
      height: 40.h,
      color: const Color(0xFFC6DBE8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(child: _headerCell('EXCH ⇅')),
          Expanded(flex: 2, child: _headerCell('SYMBOL ⇅')),
          Expanded(child: _headerCell('NET. QTY ⇅')),
          Expanded(child: _headerCell('USED MARGIN ⇅')),
        ],
      ),
    );
  }
  Widget _headerCell(String title) {
    return Center(
      child: Text(
        title,
        style: GoogleFonts.openSans(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          color: headerColor,
        ),
      ),
    );
  }
  Widget _buildTableRow(int index) {
    bool isEven = index % 2 == 0;
    String qty = index % 3 == 0 ? '1000' : (index % 2 == 0 ? '1.00' : '-1.00');
    Color qtyColor = qty.startsWith('-') ? AppColors.red : AppColors.blue;
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: isEven ? AppColors.white : Colors.grey.shade100,
        border: Border(bottom: BorderSide(color: AppColors.greyBorder)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(child: _cell('MCX', headerColor)),
          Expanded(flex: 2, child: _cell('GOLD05DEC', headerColor)),
          Expanded(child: _cell(qty, qtyColor, bold: true)),
          Expanded(child: _cell('50000', AppColors.blue, bold: true)),
        ],
      ),
    );
  }
  Widget _cell(String title, Color color, {bool bold = false}) {
    return Center(
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
  Widget _buildTableFooter() {
    return Container(
      height: 40.h,
      color: const Color(0xFFC6DBE8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 32.w),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'TOTAL',
                  style: GoogleFonts.openSans(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: headerColor,
                  ),
                ),
              ),
            ),
          ),
          Expanded(flex: 2, child: const SizedBox()),
          Expanded(child: const SizedBox()),
          Expanded(child: _cell('7856023', AppColors.blue, bold: true)),
        ],
      ),
    );
  }
}
