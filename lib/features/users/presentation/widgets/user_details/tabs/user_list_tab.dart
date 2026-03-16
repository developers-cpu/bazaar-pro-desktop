import '../../../../../../core/widget/table/view_data_table.dart';
import '../../../../../../core/widget/table/view_record_count.dart';
import '../../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../../../../../injection_container.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../domain/entities/user.dart';
import '../user_details_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bazarpro/features/users/presentation/bloc/nested_users/nested_users_bloc.dart';
import 'package:bazarpro/features/users/presentation/bloc/nested_users/nested_users_event.dart';
import 'package:bazarpro/features/users/presentation/bloc/nested_users/nested_users_state.dart';

class UserListTab extends StatelessWidget {
  final User user;
  const UserListTab({super.key, required this.user});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NestedUsersBloc>()..add(LoadNestedUsers(user.id)),
      child: const UserListTabView(),
    );
  }
}

class UserListTabView extends StatelessWidget {
  const UserListTabView({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<NestedUsersBloc, NestedUsersState>(
          builder: (context, state) {
            int count = 0;
            if (state is NestedUsersLoaded) {
              count = state.users.length;
            }
            return Container(
              color: AppColors.white,
              child: ViewRecordCount(count: count),
            );
          },
        ),
        Expanded(
          child: BlocBuilder<NestedUsersBloc, NestedUsersState>(
            builder: (context, state) {
              if (state is NestedUsersLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is NestedUsersError) {
                return Center(child: Text('Error: ${state.message}'));
              }
              List<User> users = [];
              if (state is NestedUsersLoaded) {
                users = state.users;
              }
              return ViewDataTable<User>(
                columns: _getColumns(),
                data: users,
                cellBuilder: (user, column) =>
                    _buildCellContent(context, user, column.id),
                idExtractor: (user) => user.id,
                emptyMessage: 'No users found',
                comparatorBuilder: (item, columnId) {
                  switch (columnId) {
                    case 'userName':
                      return item.userName;
                    case 'name':
                      return item.name;
                    case 'parentUser':
                      return item.parentUser;
                    case 'type':
                      return item.type;
                    case 'plPercent':
                      return item.plPercent;
                    case 'brkPercent':
                      return item.brkPercent;
                    case 'credit':
                      return item.credit;
                    case 'pl':
                      return item.pl;
                    case 'equity':
                      return item.equity;
                    case 'status':
                      return item.status;
                    default:
                      return '';
                  }
                },
                rowHeight: 40.h,
                headerHeight: 40.h,
              );
            },
          ),
        ),
      ],
    );
  }

  List<ViewTableColumn> _getColumns() {
    return [
      ViewTableColumn(id: 'userName', label: 'USER NAME', width: 120.w),
      ViewTableColumn(id: 'name', label: 'NAME', width: 100.w),
      ViewTableColumn(id: 'type', label: 'TYPE', width: 80.w),
      ViewTableColumn(id: 'parentUser', label: 'PAR.USER', width: 100.w),
      ViewTableColumn(
        id: 'credit',
        label: 'CREDIT',
        width: 100.w,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'balance',
        label: 'BALANCE',
        width: 100.w,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'brkPercent',
        label: 'BRK %',
        width: 80.w,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'plPercent',
        label: 'P/L %',
        width: 80.w,
        isNumeric: true,
      ),
      ViewTableColumn(id: 'deviceId', label: 'DEVICE ID', width: 150.w),
      ViewTableColumn(id: 'createdDate', label: 'CREATED DATE', width: 150.w),
      ViewTableColumn(id: 'ipAddress', label: 'IP ADDRESS', width: 130.w),
    ];
  }

  Widget _buildCellContent(BuildContext context, User user, String columnId) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (columnId) {
      case 'userName':
        return ViewLinkCell(
          text: user.userName,
          onTap: () => _showUserDetailsDialog(context, user),
          isDark: isDark,
        );
      case 'name':
        return ViewTextCell(text: user.name, isDark: isDark);
      case 'type':
        return ViewTextCell(text: user.type, isDark: isDark);
      case 'parentUser':
        return ViewTextCell(text: user.parentUser, isDark: isDark);
      case 'credit':
        return ViewLinkCell(
          text: user.credit.toStringAsFixed(0),
          onTap: () =>
              _showUserDetailsDialog(context, user, initialTab: 'Credit'),
          isDark: isDark,
          isNumeric: true,
        );
      case 'balance':
        return ViewNumberCell(
          value: user.equity,
          colorByValue: false,
          isDark: isDark,
        );
      case 'brkPercent':
        return ViewNumberCell(
          value: user.brkPercent,
          colorByValue: false,
          isDark: isDark,
        );
      case 'plPercent':
        return ViewNumberCell(
          value: user.plPercent,
          colorByValue: false,
          isDark: isDark,
        );
      case 'deviceId':
        return ViewTextCell(text: user.deviceType ?? 'N/A', isDark: isDark);
      case 'createdDate':
        return ViewDateTimeCell(dateTime: user.createdDate, isDark: isDark);
      case 'ipAddress':
        return ViewTextCell(text: user.ipAddress ?? '', isDark: isDark);
      default:
        return const SizedBox.shrink();
    }
  }

  void _showUserDetailsDialog(
    BuildContext context,
    User user, {
    String? initialTab,
  }) {
    UserDetailsDialog.show(context, user, initialTab: initialTab);
  }
}
