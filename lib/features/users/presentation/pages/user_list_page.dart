import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/user.dart';
import '../bloc/user_list/user_list_bloc.dart';
import '../bloc/user_list/user_list_event.dart';
import '../bloc/user_list/user_list_state.dart';
import '../widgets/common/user_data_table.dart';
import '../widgets/common/user_filter_bar.dart';
import '../widgets/dialogs/user_form_dialog.dart';
import '../widgets/dialogs/leverage_update_dialog.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  String? _selectedUserType;
  String? _selectedUserStatus;

  @override
  void initState() {
    super.initState();
    context.read<UserListBloc>().add(const LoadUsersEvent());
  }

  /// Show edit user dialog
  void _showEditUserDialog(User user) {
    UserFormDialog.showEdit(
      context: context,
      userType: user.type,
      userName: user.userName,
      name: user.name,
      credit: user.credit.toStringAsFixed(0),
      leverage: user.leverage,
      plSharing: user.plPercent.toStringAsFixed(0),
      brokerageSharing: user.brkPercent.toStringAsFixed(0),
      onUserUpdated: () {
        // Refresh user list after update
        context.read<UserListBloc>().add(const LoadUsersEvent());
      },
    );
  }

  /// Show leverage update dialog
  void _showLeverageDialog(User user) {
    LeverageUpdateDialog.show(
      context: context,
      userId: user.id,
      userName: user.userName,
      currentLeverage: user.leverage,
      onUpdate: (newLeverage) {
        // TODO: Call API to update leverage
        // Refresh user list after update
        context.read<UserListBloc>().add(const LoadUsersEvent());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundColor(context),
      child: Column(
        children: [
          _buildFilterBar(),
          Expanded(child: _buildDataTable()),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return BlocBuilder<UserListBloc, UserListState>(
      builder: (context, state) {
        List<String> userTypes = [];
        List<String> userStatuses = [];
        int totalRecords = 0;

        if (state is UserListLoaded) {
          userTypes = state.userTypes;
          userStatuses = state.userStatuses;
          totalRecords = state.totalRecords;
        }

        return UserFilterBar(
          filters: [
            UserFilterDropdown(
              hint: 'User Type',
              value: _selectedUserType,
              items: userTypes,
              onChanged: (value) {
                setState(() => _selectedUserType = value);
              },
            ),
            UserFilterDropdown(
              hint: 'User Status',
              value: _selectedUserStatus,
              items: userStatuses,
              onChanged: (value) {
                setState(() => _selectedUserStatus = value);
              },
            ),
          ],
          recordCount: totalRecords,
          onReset: () {
            setState(() {
              _selectedUserType = null;
              _selectedUserStatus = null;
            });
            context.read<UserListBloc>().add(const ResetFiltersEvent());
          },
          onView: () {
            context.read<UserListBloc>().add(
              ApplyFiltersEvent(
                userType: _selectedUserType,
                userStatus: _selectedUserStatus,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDataTable() {
    return BlocBuilder<UserListBloc, UserListState>(
      builder: (context, state) {
        if (state is UserListLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is UserListError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
                SizedBox(height: 16.h),
                Text(
                  state.message,
                  style: TextStyle(fontSize: 14.sp, color: Colors.red),
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () {
                    context.read<UserListBloc>().add(const LoadUsersEvent());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is UserListLoaded) {
          return _buildTable(state);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildTable(UserListLoaded state) {
    final columns = _getColumns();
    final isDarkMode = AppColors.isDarkMode(context);

    return UserDataTable<User>(
      columns: columns,
      data: state.filteredUsers,
      isDarkMode: isDarkMode,
      idExtractor: (user) => user.id,
      selectedId: state.selectedUserId,
      sortColumn: state.sortColumn,
      sortAscending: state.sortAscending,
      onSort: (columnId, ascending) {
        context.read<UserListBloc>().add(
          SortByColumnEvent(columnId: columnId, ascending: ascending),
        );
      },
      onRowTap: (user) {
        context.read<UserListBloc>().add(SelectUserEvent(user.id));
      },
      cellBuilder: (user, column) => _buildCellContent(user, column.id),
      emptyMessage: 'No users found',
    );
  }

  List<UserTableColumn> _getColumns() {
    return [
      const UserTableColumn(
        id: 'edit',
        label: 'EDIT',
        width: 60,
        sortable: false,
      ),
      const UserTableColumn(
        id: 'action',
        label: 'ACTION',
        width: 70,
        sortable: false,
      ),
      const UserTableColumn(id: 'userName', label: 'USER NAME', width: 150),
      const UserTableColumn(id: 'parentUser', label: 'PAR.USER', width: 100),
      const UserTableColumn(id: 'type', label: 'TYPE', width: 80),
      const UserTableColumn(id: 'name', label: 'NAME', width: 100),
      const UserTableColumn(
        id: 'plPercent',
        label: 'P/L %',
        width: 80,
        isNumeric: true,
      ),
      const UserTableColumn(
        id: 'brkPercent',
        label: 'BRK %',
        width: 80,
        isNumeric: true,
      ),
      const UserTableColumn(id: 'leverage', label: 'LVRJ', width: 60),
      const UserTableColumn(
        id: 'credit',
        label: 'CREDIT',
        width: 100,
        isNumeric: true,
      ),
      const UserTableColumn(id: 'pl', label: 'P/L', width: 80, isNumeric: true),
      const UserTableColumn(
        id: 'equity',
        label: 'EQUITY',
        width: 100,
        isNumeric: true,
      ),
      const UserTableColumn(
        id: 'totalMargin',
        label: 'TOT. MARGIN %',
        width: 120,
        isNumeric: true,
      ),
      const UserTableColumn(
        id: 'usedMargin',
        label: 'USED MARGIN %',
        width: 120,
        isNumeric: true,
      ),
      const UserTableColumn(
        id: 'freeMargin',
        label: 'FREE MARGIN %',
        width: 120,
        isNumeric: true,
      ),
      const UserTableColumn(
        id: 'createdDate',
        label: 'CREATED DATE',
        width: 150,
      ),
      const UserTableColumn(
        id: 'lastLoginDateTime',
        label: 'LAST LOGIN D/T',
        width: 150,
      ),
      const UserTableColumn(
        id: 'deviceType',
        label: 'TY. OFF DEVICE',
        width: 200,
      ),
      const UserTableColumn(id: 'ipAddress', label: 'IP ADDRESS', width: 130),
    ];
  }

  Widget _buildCellContent(User user, String columnId) {
    switch (columnId) {
      case 'edit':
        return Center(
          child: GestureDetector(
            onTap: () => _showEditUserDialog(user),
            child: Icon(
              Icons.edit_outlined,
              size: 16.sp,
              color: AppColors.primaryBlue,
            ),
          ),
        );
      case 'action':
        return Center(
          child: CircleAvatar(
            radius: 12.r,
            backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.1),
            child: Icon(
              Icons.person,
              size: 14.sp,
              color: AppColors.primaryBlue,
            ),
          ),
        );
      case 'userName':
        return GestureDetector(
          onTap: () {
            // Navigate to user details
          },
          child: Text(
            user.userName,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.primaryBlue,
              decoration: TextDecoration.underline,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        );
      case 'parentUser':
        return Text(
          user.parentUser,
          style: TextStyle(
            fontSize: 11.sp,
            color: AppColors.textColor(context),
          ),
          overflow: TextOverflow.ellipsis,
        );
      case 'type':
        return Text(
          user.type,
          style: TextStyle(
            fontSize: 11.sp,
            color: AppColors.textColor(context),
          ),
          overflow: TextOverflow.ellipsis,
        );
      case 'name':
        return Text(
          user.name,
          style: TextStyle(
            fontSize: 11.sp,
            color: AppColors.textColor(context),
          ),
          overflow: TextOverflow.ellipsis,
        );
      case 'plPercent':
        return Text(
          user.plPercent.toStringAsFixed(0),
          style: TextStyle(
            fontSize: 11.sp,
            color: AppColors.textColor(context),
          ),
        );
      case 'brkPercent':
        return Text(
          user.brkPercent.toStringAsFixed(0),
          style: TextStyle(
            fontSize: 11.sp,
            color: AppColors.textColor(context),
          ),
        );
      case 'leverage':
        return GestureDetector(
          onTap: () => _showLeverageDialog(user),
          child: Text(
            user.leverage,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.primaryBlue,
              decoration: TextDecoration.underline,
            ),
          ),
        );
      case 'credit':
        return Text(
          _formatNumber(user.credit),
          style: TextStyle(
            fontSize: 11.sp,
            color: AppColors.primaryBlue,
            decoration: TextDecoration.underline,
          ),
        );
      case 'pl':
        return Text(
          _formatNumber(user.pl),
          style: TextStyle(
            fontSize: 11.sp,
            color: user.pl >= 0 ? AppColors.textColor(context) : Colors.red,
          ),
        );
      case 'equity':
        return Text(
          _formatNumber(user.equity),
          style: TextStyle(
            fontSize: 11.sp,
            color: AppColors.textColor(context),
          ),
        );
      case 'totalMargin':
        return Text(
          _formatNumber(user.totalMargin),
          style: TextStyle(
            fontSize: 11.sp,
            color: AppColors.textColor(context),
          ),
        );
      case 'usedMargin':
        return Text(
          user.usedMargin.toStringAsFixed(2),
          style: TextStyle(
            fontSize: 11.sp,
            color: user.usedMargin >= 0
                ? AppColors.textColor(context)
                : Colors.red,
          ),
        );
      case 'freeMargin':
        return Text(
          _formatNumber(user.freeMargin),
          style: TextStyle(
            fontSize: 11.sp,
            color: AppColors.textColor(context),
          ),
        );
      case 'createdDate':
        return Text(
          DateFormat('dd/MM/yy hh:mm:ss a').format(user.createdDate),
          style: TextStyle(
            fontSize: 11.sp,
            color: AppColors.textColor(context),
          ),
        );
      case 'lastLoginDateTime':
        return Text(
          user.lastLoginDateTime != null
              ? DateFormat(
                  'dd/MM/yy hh:mm:ss a',
                ).format(user.lastLoginDateTime!)
              : '',
          style: TextStyle(
            fontSize: 11.sp,
            color: AppColors.textColor(context),
          ),
        );
      case 'deviceType':
        return Text(
          user.deviceType ?? '',
          style: TextStyle(
            fontSize: 11.sp,
            color: AppColors.textColor(context),
          ),
          overflow: TextOverflow.ellipsis,
        );
      case 'ipAddress':
        return Text(
          user.ipAddress ?? '',
          style: TextStyle(
            fontSize: 11.sp,
            color: AppColors.textColor(context),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  String _formatNumber(double value) {
    if (value == 0) return '0';
    return NumberFormat('#,##0').format(value.toInt());
  }
}
