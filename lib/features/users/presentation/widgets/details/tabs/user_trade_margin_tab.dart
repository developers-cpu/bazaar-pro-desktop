import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../users/domain/entities/user.dart';
import '../../common/user_record_count.dart';

class UserTradeMarginTab extends StatefulWidget {
  final User user;

  const UserTradeMarginTab({super.key, required this.user});

  @override
  State<UserTradeMarginTab> createState() => _UserTradeMarginTabState();
}

class _UserTradeMarginTabState extends State<UserTradeMarginTab> {
  // Mock Data
  final List<Map<String, dynamic>> _margins = [
    {
      'exch': 'MCX',
      'symbol': '360NE',
      'expiry': '26/12/25 | 12:00:00 AM',
      'margin_pct': 10000,
      'margin_a': 10000,
    },
    {
      'exch': 'MCX',
      'symbol': 'AARTIND',
      'expiry': '26/12/25 | 12:00:00 AM',
      'margin_pct': 1500,
      'margin_a': 1500,
    },
    {
      'exch': 'MCX',
      'symbol': 'ABB',
      'expiry': '26/12/25 | 12:00:00 AM',
      'margin_pct': 00,
      'margin_a': 00,
    },
    {
      'exch': 'MCX',
      'symbol': 'ABBOTINDIA',
      'expiry': '26/12/25 | 12:00:00 AM',
      'margin_pct': 00,
      'margin_a': 00,
    },
    {
      'exch': 'MCX',
      'symbol': 'ABCAPITAL',
      'expiry': '26/12/25 | 12:00:00 AM',
      'margin_pct': 1000,
      'margin_a': 1000,
    },
    {
      'exch': 'MCX',
      'symbol': 'ACC',
      'expiry': '26/12/25 | 12:00:00 AM',
      'margin_pct': 2000,
      'margin_a': 2000,
    },
    {
      'exch': 'MCX',
      'symbol': 'AMBER',
      'expiry': '26/12/25 | 12:00:00 AM',
      'margin_pct': 1000,
      'margin_a': 1000,
    },
    {
      'exch': 'MCX',
      'symbol': 'ALKEM',
      'expiry': '26/12/25 | 12:00:00 AM',
      'margin_pct': 2000,
      'margin_a': 2000,
    },
    {
      'exch': 'MCX',
      'symbol': 'AMBUJACEM',
      'expiry': '26/12/25 | 12:00:00 AM',
      'margin_pct': 1000,
      'margin_a': 1000,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilterSection(),
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

  Widget _buildFilterSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildDropdown('Exchange')),
              SizedBox(width: 12.w),
              Expanded(child: _buildDropdown('Symbol')),
              SizedBox(width: 12.w),
              Expanded(child: _buildSearchField()),
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
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(child: _buildDropdown('Margin Type')),
              SizedBox(width: 12.w),
              Expanded(child: _buildDropdown('Margin%')),
              SizedBox(width: 12.w),
              Expanded(child: SizedBox()), // Search spacer
              SizedBox(width: 12.w),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
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
                      minimumSize: Size(double.infinity, 40.h),
                    ),
                    child: Text(
                      'Update',
                      style: GoogleFonts.openSans(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
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

  Widget _buildSearchField() {
    return Container(
      height: 40.h,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: Icon(Icons.search, color: AppColors.primaryBlue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.r),
            borderSide: BorderSide(color: AppColors.primaryBlue),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.r),
            borderSide: BorderSide(color: AppColors.primaryBlue),
          ),
          contentPadding: EdgeInsets.zero,
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
              itemCount: _margins.length,
              itemBuilder: (context, index) {
                final margin = _margins[index];
                return _buildTableRow(margin, index);
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
          SizedBox(width: 40.w), // Checkbox placeholder
          _buildHeaderCell('EXCH', flex: 1),
          _buildHeaderCell('SYMBOL', flex: 2),
          _buildHeaderCell('EXPIRY DATE', flex: 3),
          _buildHeaderCell('MARGIN (%)', flex: 3),
          _buildHeaderCell('MARGIN (A.)', flex: 3),
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

  Widget _buildTableRow(Map<String, dynamic> margin, int index) {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.borderColor)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 40.w,
            child: Center(
              child: Container(
                width: 16.w,
                height: 16.w,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderColor),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
          ),
          _buildCell(margin['exch'], flex: 1),
          _buildCell(margin['symbol'], flex: 2),
          _buildCell(margin['expiry'], flex: 3),
          _buildCell(margin['margin_pct'].toString(), flex: 3),
          _buildCell(margin['margin_a'].toString(), flex: 3),
        ],
      ),
    );
  }

  Widget _buildCell(String text, {int flex = 1}) {
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
          text,
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
