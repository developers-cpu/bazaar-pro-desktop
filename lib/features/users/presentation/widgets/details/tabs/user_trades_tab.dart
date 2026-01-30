import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/app_dropdown.dart';
import 'package:bazarpro/features/users/domain/entities/user.dart';
import '../../common/user_reset_buttons.dart';

class UserTradesTab extends StatefulWidget {
  final User user;

  const UserTradesTab({super.key, required this.user});

  @override
  State<UserTradesTab> createState() => _UserTradesTabState();
}

class _UserTradesTabState extends State<UserTradesTab> {
  String? _selectedExchange = 'Exchange';
  String? _selectedSymbol = 'Symbol';
  String? _selectedStatus = 'Status';

  // Mock data for trades
  final List<Map<String, dynamic>> _trades = [
    {
      'uName': 'PATIL',
      'pUser': 'DEMO',
      'exch': 'MCX',
      'symbol': 'GOLD05DEC',
      'bs': 'SELL',
      'type': 'Market',
      'qty': -500.0,
      'lot': 1.0,
      'pl': 36200.0,
      'validity': 'Market',
      'price': 124191.0,
      'brk': 0.0,
      'net': 124191.0,
    },
    {
      'uName': 'DEMO4',
      'pUser': 'DEMO49',
      'exch': 'MCX',
      'symbol': 'GOLD05DEC',
      'bs': 'BUY',
      'type': 'Market',
      'qty': 1000000.0,
      'lot': 1.0,
      'pl': 36200.0,
      'validity': 'Market',
      'price': 124191.0,
      'brk': 0.0,
      'net': 124191.0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilterBar(),
        _buildRecordCount(),
        Expanded(child: _buildTable()),
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryBlue),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Select Date Range',
                    style: GoogleFonts.openSans(
                      fontSize: 12.sp,
                      color: AppColors.textColor(context),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    Icons.calendar_today,
                    size: 16.sp,
                    color: AppColors.primaryBlue,
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            AppDropdown(
              hintText: 'Exchange',
              items: const ['NSE', 'MCX'],
              value: _selectedExchange == 'Exchange' ? null : _selectedExchange,
              onChanged: (val) => setState(() => _selectedExchange = val),
              width: 140.w,
              height: 35.h,
            ),
            SizedBox(width: 12.w),
            AppDropdown(
              hintText: 'Symbol',
              items: const ['GOLD', 'SILVER'],
              value: _selectedSymbol == 'Symbol' ? null : _selectedSymbol,
              onChanged: (val) => setState(() => _selectedSymbol = val),
              width: 140.w,
              height: 35.h,
            ),
            SizedBox(width: 12.w),
            AppDropdown(
              hintText: 'Status',
              items: const ['Executed', 'Pending', 'Rejected'],
              value: _selectedStatus == 'Status' ? null : _selectedStatus,
              onChanged: (val) => setState(() => _selectedStatus = val),
              width: 140.w,
              height: 35.h,
            ),
            SizedBox(width: 12.w),
            UserResetButtons(
              onReset: () {
                setState(() {
                  _selectedExchange = 'Exchange';
                  _selectedSymbol = 'Symbol';
                  _selectedStatus = 'Status';
                });
              },
              onView: () {},
            ),
          ],
        ),
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
        columnSpacing: 10,
        horizontalMargin: 12,
        minWidth: 1200,
        headingRowColor: MaterialStateProperty.all(
          AppColors.primaryBlue.withOpacity(0.1),
        ),
        headingRowHeight: 40.h,
        dataRowHeight: 40.h,
        columns: [
          _buildColumn('U. NAME'),
          _buildColumn('P USER'),
          _buildColumn('EXCH'),
          _buildColumn('SYMBOL'),
          _buildColumn('B/S'),
          _buildColumn('Trade Type'),
          _buildColumn('QTY', numeric: true),
          _buildColumn('Lot', numeric: true),
          _buildColumn('P/L', numeric: true),
          _buildColumn('Validity'),
          _buildColumn('T. PRICE', numeric: true),
          _buildColumn('Brk', numeric: true),
          _buildColumn('NET', numeric: true),
        ],
        rows: _trades.map((trade) => _buildRow(trade)).toList(),
      ),
    );
  }

  DataColumn2 _buildColumn(String label, {bool numeric = false}) {
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
      size: ColumnSize.M,
    );
  }

  DataRow _buildRow(Map<String, dynamic> trade) {
    final isBuy = trade['bs'] == 'BUY';
    return DataRow(
      cells: [
        DataCell(Text(trade['uName'], style: _cellStyle())),
        DataCell(Text(trade['pUser'], style: _cellStyle())),
        DataCell(Text(trade['exch'], style: _cellStyle())),
        DataCell(
          Text(
            trade['symbol'],
            style: _cellStyle(
              isSymbol: true,
              color: isBuy ? AppColors.primaryBlue : AppColors.errorColor,
            ),
          ),
        ),
        DataCell(
          Text(
            trade['bs'],
            style: _cellStyle(
              color: isBuy ? AppColors.primaryBlue : AppColors.errorColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(Text(trade['type'], style: _cellStyle())),
        DataCell(
          Text(
            trade['qty'].toStringAsFixed(2),
            style: _cellStyle(
              color: isBuy ? AppColors.primaryBlue : AppColors.errorColor,
            ),
          ),
        ),
        DataCell(Text(trade['lot'].toStringAsFixed(2), style: _cellStyle())),
        DataCell(Text(trade['pl'].toStringAsFixed(2), style: _cellStyle())),
        DataCell(Text(trade['validity'], style: _cellStyle())),
        DataCell(
          Text(
            trade['price'].toStringAsFixed(2),
            style: _cellStyle(color: AppColors.errorColor),
          ),
        ),
        DataCell(
          Text(
            trade['brk'].toStringAsFixed(2),
            style: _cellStyle(color: AppColors.errorColor),
          ),
        ),
        DataCell(Text(trade['net'].toStringAsFixed(2), style: _cellStyle())),
      ],
    );
  }

  TextStyle _cellStyle({
    Color? color,
    bool isSymbol = false,
    FontWeight? fontWeight,
  }) {
    return GoogleFonts.openSans(
      fontSize: 11.sp,
      fontWeight: fontWeight ?? (isSymbol ? FontWeight.bold : FontWeight.w500),
      color: color ?? AppColors.textColor(context),
    );
  }
}
