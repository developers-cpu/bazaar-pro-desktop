import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../users/domain/entities/user.dart';
import '../../common/user_record_count.dart';

class UserRejectionLogTab extends StatefulWidget {
  final User user;

  const UserRejectionLogTab({super.key, required this.user});

  @override
  State<UserRejectionLogTab> createState() => _UserRejectionLogTabState();
}

class _UserRejectionLogTabState extends State<UserRejectionLogTab> {
  // Mock Data
  final List<Map<String, dynamic>> _logs = [
    {
      'date': '04/11/25 01:25:35 PM',
      'status': 'rejected',
      'uName': 'DEMO03',
      'symbol': 'NIFTY25N0425550CE',
      'type': 'BUY',
      'qty': 95,
      'price': 15000,
      'comment': 'SCRIPT BLOCKED IF YOU HAVE POSITION ONLY CLOSED BY MARKET',
    },
    {
      'date': '04/11/25 01:25:35 PM',
      'status': 'rejected',
      'uName': 'DEMO03',
      'symbol': 'NIFTY25N0425550CE',
      'type': 'BUY',
      'qty': 178,
      'price': 5000,
      'comment': 'SCRIPT BLOCKED IF YOU HAVE POSITION ONLY CLOSED BY MARKET',
    },
    {
      'date': '04/11/25 01:25:35 PM',
      'status': 'rejected',
      'uName': 'DEMO03',
      'symbol': 'GOLD',
      'type': 'SELL',
      'qty': 125,
      'price': 50000,
      'comment': 'SCRIPT BLOCKED IF YOU HAVE POSITION ONLY CLOSED BY MARKET',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilterBar(),
        Container(
          color: AppColors.white,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          alignment: Alignment.centerRight,
          child: UserRecordCount(count: 12550),
        ),
        Expanded(child: _buildTable()),
      ],
    );
  }

  Widget _buildFilterBar() {
    // Reusing UserFilterBar or building custom one if specific fields needed
    // The screenshot has "Select Date Range", "Exchange", "Symbol"
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40.h,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryBlue),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Date Range',
                    style: GoogleFonts.openSans(
                      fontSize: 14.sp,
                      color: AppColors.textColor(context),
                    ),
                  ),
                  Icon(
                    Icons.calendar_today,
                    size: 16.sp,
                    color: AppColors.primaryBlue,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(child: _buildDropdown('Exchange')),
          SizedBox(width: 12.w),
          Expanded(child: _buildDropdown('Symbol')),
          SizedBox(width: 12.w),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textColor(context),
                    side: BorderSide(color: AppColors.greyBorder),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
                  ),
                  child: Text(
                    'Reset',
                    style: GoogleFonts.openSans(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
                  ),
                  child: Text(
                    'View',
                    style: GoogleFonts.openSans(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String hint) {
    return Container(
      height: 40.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryBlue),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(
            hint,
            style: GoogleFonts.openSans(
              fontSize: 14.sp,
              color: AppColors.textColor(context),
            ),
          ),
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, color: AppColors.primaryBlue),
          items: [],
          onChanged: (value) {},
        ),
      ),
    );
  }

  Widget _buildTable() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.r),
          topRight: Radius.circular(8.r),
        ),
      ),
      child: Column(
        children: [
          _buildTableHeader(),
          Expanded(
            child: ListView.builder(
              itemCount: _logs.length,
              itemBuilder: (context, index) {
                final log = _logs[index];
                return _buildTableRow(log, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.2),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.r),
          topRight: Radius.circular(8.r),
        ),
      ),
      child: Row(
        children: [
          _buildHeaderCell('Order D/T', flex: 2),
          _buildHeaderCell('STATUS', flex: 1),
          _buildHeaderCell('U.Name', flex: 1),
          _buildHeaderCell('SYMBOL', flex: 2),
          _buildHeaderCell('TYPE', flex: 1),
          _buildHeaderCell('QTY', flex: 1),
          _buildHeaderCell('PRICE', flex: 1),
          _buildHeaderCell('COMMENT', flex: 4),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String label, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: AppColors.borderColor, width: 0.5),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.openSans(
            fontSize: 11.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlue,
          ),
        ),
      ),
    );
  }

  Widget _buildTableRow(Map<String, dynamic> log, int index) {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.borderColor)),
      ),
      child: Row(
        children: [
          _buildCell(log['date'], flex: 2),
          _buildCell(log['status'], flex: 1),
          _buildCell(log['uName'], flex: 1),
          _buildCell(log['symbol'], flex: 2),
          _buildCell(log['type'], flex: 1),
          _buildCell(log['qty'].toString(), flex: 1),
          _buildCell(log['price'].toString(), flex: 1),
          _buildCell(log['comment'], flex: 4, alignLeft: true),
        ],
      ),
    );
  }

  Widget _buildCell(String text, {int flex = 1, bool alignLeft = false}) {
    return Expanded(
      flex: flex,
      child: Container(
        alignment: alignLeft ? Alignment.centerLeft : Alignment.center,
        padding: alignLeft ? EdgeInsets.only(left: 8.w) : null,
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: AppColors.borderColor, width: 0.5),
          ),
        ),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.openSans(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textColor(context),
          ),
        ),
      ),
    );
  }
}
