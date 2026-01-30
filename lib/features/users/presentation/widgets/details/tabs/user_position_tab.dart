import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/app_dropdown.dart';
import 'package:bazarpro/features/users/domain/entities/user.dart';
import '../../common/user_reset_buttons.dart';

class UserPositionTab extends StatefulWidget {
  final User user;

  const UserPositionTab({super.key, required this.user});

  @override
  State<UserPositionTab> createState() => _UserPositionTabState();
}

class _UserPositionTabState extends State<UserPositionTab> {
  String? _selectedExchange = 'Exchange';
  String? _selectedSymbol = 'Symbol';

  // Mock data for position
  final List<Map<String, dynamic>> _positions = [
    {
      'exch': 'MCX',
      'symbol': 'GOLD05DEC',
      'buyQty': 500.0,
      'sellQty': 500.0,
      'netQty': 500.0,
      'netAp': 124191.0,
      'cmp': -124191.0,
      'm2m': -124191.0,
      'lot': 1.0,
    },
    {
      'exch': 'MCX',
      'symbol': 'GOLD05DEC',
      'buyQty': 1000000.0,
      'sellQty': 1000000.0,
      'netQty': 1000000.0,
      'netAp': 124191.0,
      'cmp': 124191.0,
      'm2m': 124191.0,
      'lot': 1.0,
    },
    {
      'exch': 'MCX',
      'symbol': 'GOLD05DEC',
      'buyQty': 500.0,
      'sellQty': 500.0,
      'netQty': 500.0,
      'netAp': -256.0,
      'cmp': -256.0,
      'm2m': -256.0,
      'lot': 1.0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilterBar(),
        _buildRecordCount(),
        Expanded(child: _buildTable()),
        _buildFooter(),
      ],
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.greyBorder)),
      ),
      child: Row(
        children: [
          Row(
            children: [
              AppDropdown(
                hintText: 'Exchange',
                items: const ['NSE', 'MCX'],
                value: _selectedExchange == 'Exchange'
                    ? null
                    : _selectedExchange,
                onChanged: (val) => setState(() => _selectedExchange = val),
                width: 150.w,
                height: 35.h,
              ),
              SizedBox(width: 12.w),
              AppDropdown(
                hintText: 'Symbol',
                items: const ['GOLD', 'SILVER'],
                value: _selectedSymbol == 'Symbol' ? null : _selectedSymbol,
                onChanged: (val) => setState(() => _selectedSymbol = val),
                width: 150.w,
                height: 35.h,
              ),
            ],
          ),
          const Spacer(),
          UserResetButtons(
            onReset: () {
              setState(() {
                _selectedExchange = 'Exchange';
                _selectedSymbol = 'Symbol';
              });
            },
            onView: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildRecordCount() {
    return Container(
      color: AppColors.white,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      alignment: Alignment.centerRight,
      child: UserRecordCountWidget(count: 12550),
    );
  }

  Widget _buildTable() {
    return Theme(
      data: Theme.of(
        context,
      ).copyWith(dividerColor: AppColors.greyBorder.withOpacity(0.5)),
      child: DataTable2(
        columnSpacing: 12,
        horizontalMargin: 12,
        minWidth: 900,
        headingRowColor: MaterialStateProperty.all(
          AppColors.primaryBlue.withOpacity(0.1),
        ),
        headingRowHeight: 40.h,
        dataRowHeight: 40.h,
        columns: [
          _buildColumn('EXCH', numeric: false),
          _buildColumn('SYMBOL', numeric: false),
          _buildColumn('BUY QTY'),
          _buildColumn('SELL QTY'),
          _buildColumn('NET QTY'),
          _buildColumn('NET A. P.'),
          _buildColumn('CMP'),
          _buildColumn('M2M AMT'),
          _buildColumn('Lot'),
        ],
        rows: _positions.map((pos) => _buildRow(pos)).toList(),
      ),
    );
  }

  DataColumn2 _buildColumn(String label, {bool numeric = true}) {
    return DataColumn2(
      label: Text(
        label,
        style: GoogleFonts.openSans(
          fontSize: 11.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryBlue,
        ),
      ),
      numeric: numeric,
      size: ColumnSize.L,
    );
  }

  DataRow _buildRow(Map<String, dynamic> pos) {
    return DataRow(
      cells: [
        DataCell(Text(pos['exch'], style: _cellStyle())),
        DataCell(Text(pos['symbol'], style: _cellStyle(isSymbol: true))),
        DataCell(
          Text(
            pos['buyQty'].toStringAsFixed(2),
            style: _cellStyle(color: AppColors.primaryBlue),
          ),
        ),
        DataCell(
          Text(
            pos['sellQty'].toStringAsFixed(2),
            style: _cellStyle(color: AppColors.errorColor),
          ),
        ),
        DataCell(Text(pos['netQty'].toStringAsFixed(2), style: _cellStyle())),
        DataCell(Text(pos['netAp'].toStringAsFixed(2), style: _cellStyle())),
        DataCell(
          Text(
            pos['cmp'].toStringAsFixed(2),
            style: _cellStyle(color: AppColors.errorColor),
          ),
        ),
        DataCell(
          Text(
            pos['m2m'].toStringAsFixed(2),
            style: _cellStyle(color: AppColors.errorColor),
          ),
        ),
        DataCell(Text(pos['lot'].toStringAsFixed(2), style: _cellStyle())),
      ],
    );
  }

  TextStyle _cellStyle({Color? color, bool isSymbol = false}) {
    return GoogleFonts.openSans(
      fontSize: 11.sp,
      fontWeight: isSymbol ? FontWeight.bold : FontWeight.w500,
      color: color ?? AppColors.textColor(context),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.1),
        border: Border(top: BorderSide(color: AppColors.greyBorder)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildFooterItem('Used Margin', '1000000.00'),
          Container(height: 20.h, width: 1, color: AppColors.greyBorder),
          _buildFooterItem('Free Margin', '1000000.00'),
          Container(height: 20.h, width: 1, color: AppColors.greyBorder),
          _buildFooterItem('Credit', '500000.00'),

          const Spacer(),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSummaryItem('Realised P&L', '0.00'),
                SizedBox(width: 12.w),
                Icon(Icons.add, size: 14.sp),
                SizedBox(width: 12.w),
                _buildSummaryItem('M2M', '124536.00'),
                SizedBox(width: 12.w),
                Text('=', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 12.w),
                Text(
                  '-81400.00',
                  style: GoogleFonts.openSans(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.errorColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterItem(String label, String value) {
    return Row(
      children: [
        Text(
          '$label : ',
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor(context),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Row(
      children: [
        Text(
          '$label : ',
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor(context),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlue,
          ),
        ),
      ],
    );
  }
}
