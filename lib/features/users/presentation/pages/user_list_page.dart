import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/widget/app_dropdown.dart';
import '../../domain/entities/user.dart';
import '../bloc/user_list/user_list_bloc.dart';
import '../bloc/user_list/user_list_event.dart';
import '../bloc/user_list/user_list_state.dart';
import '../../../../core/widget/table/view_data_table.dart';
import '../../../../core/widget/table/view_record_count.dart';
import '../../../../core/widget/table/view_table_cell_styles.dart';
import '../../../../core/widget/table/view_reset_buttons.dart';
import '../widgets/create_user/master_form_dialog.dart';
import '../widgets/create_user/client_form_dialog.dart';
import '../widgets/create_user/leverage_update_dialog.dart';
import '../widgets/create_user/change_password_dialog.dart';
import '../widgets/create_user/update_access_dialog.dart';
import '../widgets/user_details/user_details_dialog.dart';
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
  void _showEditUserDialog(User user) {
    final userData = {
      'name': user.name,
      'username': user.userName,
      'mobile': '',
      'credit': user.credit.toStringAsFixed(0),
      'leverage': user.leverage,
      'plSharing': user.plPercent.toStringAsFixed(0),
      'brokerageSharing': user.brkPercent.toStringAsFixed(0),
    };
    if (user.type == 'Master') {
      MasterFormDialog.showEdit(
        context: context,
        userData: userData,
        onComplete: () {
          context.read<UserListBloc>().add(const LoadUsersEvent());
        },
      );
    } else {
      ClientFormDialog.showEdit(
        context: context,
        userData: userData,
        onComplete: () {
          context.read<UserListBloc>().add(const LoadUsersEvent());
        },
      );
    }
  }
  void _showLeverageDialog(User user) {
    LeverageUpdateDialog.show(
      context: context,
      userId: user.id,
      userName: user.userName,
      currentLeverage: user.leverage,
      onUpdate: (newLeverage) {
        context.read<UserListBloc>().add(const LoadUsersEvent());
      },
    );
  }
  void _showChangePasswordDialog(User user) {
    ChangePasswordDialog.show(
      context: context,
      userId: user.id,
      userName: user.userName,
      onChangePassword: (oldPassword, newPassword) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password updated successfully')),
        );
      },
    );
  }
  void _showActionDialog(User user) {
    final currentSettings = {
      'bet': true,
      'closeOnly': false,
      'viewOnly': false,
      'status': user.isActive,
      'allowChat': true,
      'positionCut15Days': false,
      'freshLimitSL': true,
      'lockUser': false,
    };
    UpdateAccessDialog.show(
      context: context,
      userId: user.id,
      userName: user.userName,
      currentSettings: currentSettings,
      onUpdate: (updatedSettings) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Access settings updated successfully')),
        );
      },
    );
  }
  void _showUserDetailsDialog(User user, {String? initialTab}) {
    UserDetailsDialog.show(
      context,
      user,
      initialTab: initialTab,
      onEdit: (_) => _showEditUserDialog(user),
      onAction: (_) => _showActionDialog(user),
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
    return Container(
      padding: EdgeInsets.all(12.w),
      color: AppColors.white,
      child: BlocBuilder<UserListBloc, UserListState>(
        builder: (context, state) {
          List<String> userTypes = [];
          List<String> userStatuses = [];
          int totalRecords = 0;
          if (state is UserListLoaded) {
            userTypes = state.userTypes;
            userStatuses = state.userStatuses;
            totalRecords = state.totalRecords;
          }
          return Column(
            children: [
              Row(
                children: [
                  AppDropdown(
                    hintText: 'User Type',
                    items: userTypes,
                    value: _selectedUserType,
                    onChanged: (val) {
                      setState(() => _selectedUserType = val);
                    },
                    width: 160.w,
                    height: 35.h,
                    type: AppDropdownType.simple,
                  ),
                  SizedBox(width: 8.w),
                  AppDropdown(
                    hintText: 'User Status',
                    items: userStatuses,
                    value: _selectedUserStatus,
                    onChanged: (val) {
                      setState(() => _selectedUserStatus = val);
                    },
                    width: 160.w,
                    height: 35.h,
                    type: AppDropdownType.simple,
                  ),
                  const Spacer(),
                  ViewResetButtons(
                    onReset: () {
                      setState(() {
                        _selectedUserType = null;
                        _selectedUserStatus = null;
                      });
                      context.read<UserListBloc>().add(
                        const ResetFiltersEvent(),
                      );
                    },
                    onView: () {
                      context.read<UserListBloc>().add(
                        ApplyFiltersEvent(
                          userType: _selectedUserType,
                          userStatus: _selectedUserStatus,
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Align(
                alignment: Alignment.centerLeft,
                child: ViewRecordCount(count: totalRecords),
              ),
            ],
          );
        },
      ),
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
    return ViewDataTable<User>(
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
      cellBuilder: (user, column) => _buildCellContent(user, column.id, isDarkMode),
      emptyMessage: 'No users found',
    );
  }
  List<ViewTableColumn> _getColumns() {
    return [
      const ViewTableColumn(
        id: 'edit',
        label: 'EDIT',
        width: 60,
        sortable: false,
      ),
      const ViewTableColumn(
        id: 'action',
        label: 'ACTION',
        width: 70,
        sortable: false,
      ),
      const ViewTableColumn(id: 'userName', label: 'USER NAME', width: 150),
      const ViewTableColumn(id: 'parentUser', label: 'PAR.USER', width: 100),
      const ViewTableColumn(id: 'type', label: 'TYPE', width: 80),
      const ViewTableColumn(id: 'name', label: 'NAME', width: 100),
      const ViewTableColumn(
        id: 'plPercent',
        label: 'P/L %',
        width: 80,
        isNumeric: true,
      ),
      const ViewTableColumn(
        id: 'brkPercent',
        label: 'BRK %',
        width: 80,
        isNumeric: true,
      ),
      const ViewTableColumn(id: 'leverage', label: 'LVRJ', width: 60),
      const ViewTableColumn(
        id: 'credit',
        label: 'CREDIT',
        width: 100,
        isNumeric: true,
      ),
      const ViewTableColumn(id: 'pl', label: 'P/L', width: 80, isNumeric: true),
      const ViewTableColumn(
        id: 'equity',
        label: 'EQUITY',
        width: 100,
        isNumeric: true,
      ),
      const ViewTableColumn(
        id: 'totalMargin',
        label: 'TOT. MARGIN %',
        width: 120,
        isNumeric: true,
      ),
      const ViewTableColumn(
        id: 'usedMargin',
        label: 'USED MARGIN %',
        width: 120,
        isNumeric: true,
      ),
      const ViewTableColumn(
        id: 'freeMargin',
        label: 'FREE MARGIN %',
        width: 120,
        isNumeric: true,
      ),
      const ViewTableColumn(
        id: 'createdDate',
        label: 'CREATED DATE',
        width: 150,
      ),
      const ViewTableColumn(
        id: 'lastLoginDateTime',
        label: 'LAST LOGIN D/T',
        width: 150,
      ),
      const ViewTableColumn(
        id: 'deviceType',
        label: 'TY. OFF DEVICE',
        width: 200,
      ),
      const ViewTableColumn(id: 'ipAddress', label: 'IP ADDRESS', width: 130),
    ];
  }
  Widget _buildCellContent(User user, String columnId, bool isDark) {
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
          child: Theme(
            data: Theme.of(context).copyWith(
              cardColor: AppColors.white,
              popupMenuTheme: PopupMenuThemeData(
                color: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                elevation: 4,
              ),
            ),
            child: PopupMenuButton<String>(
              tooltip: 'Actions',
              offset: const Offset(0, 30),
              padding: EdgeInsets.zero,
              icon: CircleAvatar(
                radius: 12.r,
                backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.1),
                child: Icon(
                  Icons.person,
                  size: 14.sp,
                  color: AppColors.primaryBlue,
                ),
              ),
              onSelected: (value) {
                switch (value) {
                  case 'change_password':
                    _showChangePasswordDialog(user);
                    break;
                  case 'update_leverage':
                    _showLeverageDialog(user);
                    break;
                  case 'action':
                    _showActionDialog(user);
                    break;
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'change_password',
                  height: 40.h,
                  child: Text(
                    'Change Password',
                    style: GoogleFonts.openSans(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'update_leverage',
                  height: 40.h,
                  child: Text(
                    'Update Leverage',
                    style: GoogleFonts.openSans(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'action',
                  height: 40.h,
                  child: Text(
                    'Action',
                    style: GoogleFonts.openSans(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      case 'userName':
        return ViewLinkCell(
          text: user.userName,
          isDark: isDark,
          onTap: () => _showUserDetailsDialog(user),
        );
      case 'parentUser':
        return ViewTextCell(text: user.parentUser, isDark: isDark);
      case 'type':
        return ViewTextCell(text: user.type, isDark: isDark);
      case 'name':
        return ViewTextCell(text: user.name, isDark: isDark);
      case 'plPercent':
        return ViewNumberCell(
          value: user.plPercent,
          displayText: '${user.plPercent}%',
          isDark: isDark,
        );
      case 'brkPercent':
        return ViewNumberCell(
          value: user.brkPercent,
          displayText: '${user.brkPercent}%',
          isDark: isDark,
        );
      case 'leverage':
        return ViewLinkCell(
          text: '1:${user.leverage}',
          isDark: isDark,
          onTap: () => _showLeverageDialog(user),
        );
      case 'credit':
        return ViewLinkCell(
          text: user.credit.toStringAsFixed(0),
          isDark: isDark,
          onTap: () => _showUserDetailsDialog(user, initialTab: 'Credit'),
        );
      case 'pl':
        return ViewNumberCell(value: user.pl, isDark: isDark);
      case 'equity':
        return ViewNumberCell(value: user.equity, isDark: isDark);
      case 'totalMargin':
        return ViewNumberCell(value: user.totalMargin, isDark: isDark);
      case 'usedMargin':
        return ViewNumberCell(value: user.usedMargin, isDark: isDark);
      case 'freeMargin':
        return ViewNumberCell(value: user.freeMargin, isDark: isDark);
      case 'createdDate':
        return ViewDateTimeCell(dateTime: user.createdDate, isDark: isDark);
      case 'lastLoginDateTime':
        return user.lastLoginDateTime != null
            ? ViewDateTimeCell(dateTime: user.lastLoginDateTime!, isDark: isDark)
            : ViewTextCell(
                text: '',
                isDark: isDark,
                alignment: Alignment.centerRight,
              );
      case 'deviceType':
        return ViewTextCell(text: user.deviceType ?? '', isDark: isDark);
      case 'ipAddress':
        return ViewTextCell(text: user.ipAddress ?? '', isDark: isDark);
      default:
        return const SizedBox.shrink();
    }
  }
}
