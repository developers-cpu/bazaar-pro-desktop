import 'package:bazarpro/features/users/presentation/widgets/common/user_data_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../users/domain/entities/user.dart';
import '../../common/user_record_count.dart';
import '../user_details_dialog.dart';

class UserListTab extends StatelessWidget {
  final User user;

  const UserListTab({super.key, required this.user});

  // Mock data for nested users
  List<User> get _nestedUsers => [
    User(
      id: '1',
      userName: 'RAJ03',
      name: 'RAJ',
      type: 'Master',
      parentUser: 'DEMO',
      credit: 0,
      plPercent: 40,
      brkPercent: 40,
      leverage: '100',
      status: 'Active',
      totalMargin: 0,
      usedMargin: 0,
      freeMargin: 0,
      pl: 0,
      equity: 40,
      createdDate: DateTime.now(),
      lastLoginDateTime: DateTime.now(),
      deviceType: 'Android',
      ipAddress: '192.168.1.1',
    ),
    User(
      id: '2',
      userName: 'RAJ03',
      name: 'RAJ',
      type: 'Client',
      parentUser: 'DEMO',
      credit: 100000,
      plPercent: 100,
      brkPercent: 60,
      leverage: '100',
      status: 'Active',
      totalMargin: 0,
      usedMargin: 0,
      freeMargin: 0,
      pl: 0,
      equity: 100,
      createdDate: DateTime.now(),
      lastLoginDateTime: DateTime.now(),
      deviceType: 'Android',
      ipAddress: '192.168.1.1',
    ),
    // Add more mock users as needed to match screenshot
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColors.white,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          alignment: Alignment.centerRight,
          child: UserRecordCount(count: 12550, compact: false),
        ),
        Expanded(
          child: UserDataTable<User>(
            columns: _getColumns(),
            data: _nestedUsers,
            cellBuilder: (user, column) =>
                _buildCellContent(context, user, column.id),
            idExtractor: (user) => user.id,
            emptyMessage: 'No users found',
            rowHeight: 40.h,
            headerHeight: 40.h,
          ),
        ),
      ],
    );
  }

  List<UserTableColumn> _getColumns() {
    return [
      const UserTableColumn(id: 'userName', label: 'USER NAME', width: 120),
      const UserTableColumn(id: 'name', label: 'NAME', width: 100),
      const UserTableColumn(id: 'type', label: 'TYPE', width: 80),
      const UserTableColumn(id: 'parentUser', label: 'PAR.USER', width: 100),
      const UserTableColumn(
        id: 'credit',
        label: 'CREDIT',
        width: 100,
        isNumeric: true,
      ),
      const UserTableColumn(
        id: 'balance',
        label: 'BALANCE',
        width: 100,
        isNumeric: true,
      ),
      const UserTableColumn(
        id: 'brkPercent',
        label: 'BRK %',
        width: 80,
        isNumeric: true,
      ),
      const UserTableColumn(
        id: 'plPercent',
        label: 'P/L %',
        width: 80,
        isNumeric: true,
      ),
      const UserTableColumn(id: 'deviceId', label: 'DEVICE ID', width: 150),
      const UserTableColumn(
        id: 'createdDate',
        label: 'CREATED DATE',
        width: 150,
      ),
      const UserTableColumn(id: 'ipAddress', label: 'IP ADDRESS', width: 130),
    ];
  }

  Widget _buildCellContent(BuildContext context, User user, String columnId) {
    switch (columnId) {
      case 'userName':
        return InkWell(
          onTap: () => _showUserDetailsDialog(context, user),
          child: Text(
            user.userName,
            style: GoogleFonts.openSans(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlue,
              decoration: TextDecoration.underline,
            ),
          ),
        );
      case 'name':
        return Text(user.name, style: _textStyle(context));
      case 'type':
        return Text(user.type, style: _textStyle(context));
      case 'parentUser':
        return Text(user.parentUser, style: _textStyle(context));
      case 'credit':
        return InkWell(
          onTap: () =>
              _showUserDetailsDialog(context, user, initialTab: 'Credit'),
          child: Text(
            user.credit.toStringAsFixed(0),
            style: GoogleFonts.openSans(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlue,
              decoration: TextDecoration.underline,
            ),
          ),
        );
      case 'balance': // Using equity as mockup for balance
        return Text(user.equity.toStringAsFixed(0), style: _textStyle(context));
      case 'brkPercent':
        return Text(
          user.brkPercent.toStringAsFixed(0),
          style: _textStyle(context),
        );
      case 'plPercent':
        return Text(
          user.plPercent.toStringAsFixed(0),
          style: _textStyle(context),
        );
      case 'deviceId':
        return Text('AFCAGFREG-2132-1265', style: _textStyle(context)); // Mock
      case 'createdDate':
        return Text('26/11/25 01:33:04 PM', style: _textStyle(context)); // Mock
      case 'ipAddress':
        return Text(user.ipAddress ?? '', style: _textStyle(context));
      default:
        return const SizedBox.shrink();
    }
  }

  TextStyle _textStyle(BuildContext context) {
    return GoogleFonts.openSans(
      fontSize: 11.sp,
      color: AppColors.textColor(context),
    );
  }

  void _showUserDetailsDialog(
    BuildContext context,
    User user, {
    String? initialTab,
  }) {
    // Recursively show User Details for the clicked user
    // Note: This relies on UserDetailsDialog being imported and having a show method that can be called.
    // Since we are inside a tab of UserDetailsDialog, we are opening another one on top.
    // This depth might need management, but for now this fulfills the request.
    UserDetailsDialog.show(context, user, initialTab: initialTab);
  }
}
