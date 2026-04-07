import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/widget/table/view_data_table.dart';
import '../../../../core/widget/table/view_record_count.dart'
    show ViewRecordCount;
import '../../../../core/widget/table/view_table_cell_styles.dart';
import '../../domain/entities/user.dart';
import '../bloc/inactive_user_list/inactive_user_list_bloc.dart';
import '../bloc/inactive_user_list/inactive_user_list_event.dart';
import '../bloc/inactive_user_list/inactive_user_list_state.dart';
import '../widgets/create_user/master_form_dialog.dart';
import '../widgets/create_user/client_form_dialog.dart';
import '../widgets/create_user/leverage_update_dialog.dart';
import '../widgets/create_user/change_password_dialog.dart';
import '../widgets/create_user/update_access_dialog.dart';
import '../widgets/user_details/user_details_dialog.dart';

class InactiveUserListPage extends StatefulWidget {
  const InactiveUserListPage({super.key});
  @override
  State<InactiveUserListPage> createState() => _InactiveUserListPageState();
}

class _InactiveUserListPageState extends State<InactiveUserListPage> {
  String? _selectedUserType;
  String? _selectedUserStatus;
  @override
  void initState() {
    super.initState();
    context.read<InactiveUserListBloc>().add(const LoadInactiveUsersEvent());
  }

  void _showEditUserDialog(BuildContext context, User user) {
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
          context.read<InactiveUserListBloc>().add(
            const LoadInactiveUsersEvent(),
          );
        },
      );
    } else {
      ClientFormDialog.showEdit(
        context: context,
        userData: userData,
        onComplete: () {
          context.read<InactiveUserListBloc>().add(
            const LoadInactiveUsersEvent(),
          );
        },
      );
    }
  }

  void _showLeverageDialog(BuildContext context, User user) {
    LeverageUpdateDialog.show(
      context: context,
      userId: user.id,
      userName: user.userName,
      currentLeverage: user.leverage,
      onUpdate: (newLeverage) {
        context.read<InactiveUserListBloc>().add(
          const LoadInactiveUsersEvent(),
        );
      },
    );
  }

  void _showChangePasswordDialog(BuildContext context, User user) {
    debugPrint('Opening Change Password dialog for ${user.userName}');
    ChangePasswordDialog.show(
      context: context,
      userId: user.id,
      userName: user.userName,
      onChangePassword: (oldPassword, newPassword) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password updated successfully')),
          );
        }
      },
    );
  }

  void _showActionDialog(BuildContext context, User user) {
    debugPrint('Opening Action dialog for ${user.userName}');
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
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Access settings updated successfully'),
            ),
          );
        }
      },
    );
  }

  void _showUserDetailsDialog(
    BuildContext context,
    User user, {
    String? initialTab,
  }) {
    UserDetailsDialog.show(
      context,
      user,
      initialTab: initialTab,
      onEdit: (ctx) => _showEditUserDialog(ctx, user),
      onAction: (ctx) => _showActionDialog(ctx, user),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundColor,
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
      child: BlocBuilder<InactiveUserListBloc, InactiveUserListState>(
        builder: (context, state) {
          List<String> userTypes = [];
          List<String> userStatuses = [];
          int totalRecords = 0;
          if (state is InactiveUserListLoaded) {
            userTypes = state.userTypes;
            userStatuses = state.userStatuses;
            totalRecords = state.totalRecords;
          }
          return Column(
            children: [
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
    return BlocBuilder<InactiveUserListBloc, InactiveUserListState>(
      builder: (context, state) {
        if (state is InactiveUserListLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is InactiveUserListError) {
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
                    context.read<InactiveUserListBloc>().add(
                      const LoadInactiveUsersEvent(),
                    );
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        if (state is InactiveUserListLoaded) {
          return _buildTable(state);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildTable(InactiveUserListLoaded state) {
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
        context.read<InactiveUserListBloc>().add(
          SortInactiveByColumnEvent(columnId: columnId, ascending: ascending),
        );
      },
      onRowTap: (user) {
        context.read<InactiveUserListBloc>().add(
          SelectInactiveUserEvent(user.id),
        );
      },
      cellBuilder: (user, column) =>
          _buildCellContent(user, column.id, isDarkMode),
      emptyMessage: 'No inactive users found',
    );
  }

  List<ViewTableColumn> _getColumns() {
    return [
      const ViewTableColumn(
        id: 'action',
        label: 'ACTION',
        width: 70,
        sortable: false,
      ),
      const ViewTableColumn(id: 'userName', label: 'USER NAME', width: 170),
      const ViewTableColumn(id: 'parentUser', label: 'PAR.USER', width: 90),
      const ViewTableColumn(id: 'type', label: 'TYPE', width: 80),
      const ViewTableColumn(id: 'name', label: 'NAME', width: 100),
      const ViewTableColumn(
        id: 'plPercent',
        label: '%',
        width: 70,
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
      const ViewTableColumn(id: 'pl', label: 'P/L', width: 70, isNumeric: true),
      const ViewTableColumn(
        id: 'equity',
        label: 'EQUITY',
        width: 90,
        isNumeric: true,
      ),
      const ViewTableColumn(
        id: 'totalMargin',
        label: 'TOT. MARGIN %',
        width: 140,
        isNumeric: true,
      ),
      const ViewTableColumn(
        id: 'usedMargin',
        label: 'USED MARGIN %',
        width: 150,
        isNumeric: true,
      ),
      const ViewTableColumn(
        id: 'freeMargin',
        label: 'FREE MARGIN %',
        width: 140,
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
        width: 250,
      ),
      const ViewTableColumn(
        id: 'ipAddress',
        label: 'IP ADDRESS',
        width: 130,
        isNumeric: true,
      ),
    ];
  }

  Widget _buildCellContent(User user, String columnId, bool isDark) {
    switch (columnId) {
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
                debugPrint('Action selected: $value');
                Future.delayed(const Duration(milliseconds: 100), () {
                  if (!mounted) {
                    debugPrint('Widget NOT mounted after delay');
                    return;
                  }
                  final hasOverlay =
                      Overlay.maybeOf(context, rootOverlay: true) != null;
                  debugPrint('Target context has overlay: $hasOverlay');

                  switch (value) {
                    case 'change_password':
                      _showChangePasswordDialog(context, user);
                      break;
                    case 'update_leverage':
                      _showLeverageDialog(context, user);
                      break;
                    case 'action':
                      _showActionDialog(context, user);
                      break;
                  }
                });
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
          onTap: () => _showUserDetailsDialog(context, user),
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
          displayText: '${user.plPercent}',
          isDark: isDark,
        );
      case 'brkPercent':
        return ViewNumberCell(
          value: user.brkPercent,
          displayText: '${user.brkPercent}',
          isDark: isDark,
        );
      case 'leverage':
        return ViewLinkCell(
          text: '${user.leverage}',
          isDark: isDark,
          isNumeric: true,
          onTap: () => _showLeverageDialog(context, user),
        );
      case 'credit':
        return ViewLinkCell(
          text: user.credit.toStringAsFixed(0),
          isDark: isDark,
          isNumeric: true,
          onTap: () =>
              _showUserDetailsDialog(context, user, initialTab: 'Credit'),
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
            ? ViewDateTimeCell(
                dateTime: user.lastLoginDateTime!,
                isDark: isDark,
              )
            : ViewTextCell(
                text: '',
                isDark: isDark,
                alignment: Alignment.centerRight,
              );
      case 'deviceType':
        return ViewTextCell(text: user.deviceType ?? '', isDark: isDark);
      case 'ipAddress':
        return ViewTextCell(
          text: user.ipAddress ?? '',
          isDark: isDark,
          isNumeric: true,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
