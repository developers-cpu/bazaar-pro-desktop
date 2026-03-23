import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/app_tab_bar.dart';
import '../../../../../../core/widget/common_dilog_box.dart';
import 'package:bazarpro/features/users/domain/entities/user.dart';
import 'tabs/user_placeholder_tab.dart';
import 'tabs/user_position_tab.dart';
import 'tabs/user_quantity_settings_tab.dart';
import 'tabs/user_trades_tab.dart';
import 'tabs/user_group_settings_tab.dart';
import 'tabs/user_brokerage_tab.dart';
import 'tabs/user_credit_tab.dart';
import 'user_hierarchy_dialog.dart';
import 'tabs/user_rejection_log_tab.dart';
import 'tabs/user_sharing_details_tab.dart';
import 'user_intraday_square_off_dialog.dart';
import 'user_exchange_wise_position_limit_dialog.dart';
import 'tabs/user_trade_margin_tab.dart';
import 'tabs/user_pending_orders_tab.dart';
import '../create_user/change_password_dialog.dart';

class UserDetailsDialog extends StatefulWidget {
  final User user;
  final String? initialTab;
  final void Function(BuildContext)? onEdit;
  final void Function(BuildContext)? onAction;
  const UserDetailsDialog({
    super.key,
    required this.user,
    this.initialTab,
    this.onEdit,
    this.onAction,
  });
  static void show(
    BuildContext context,
    User user, {
    String? initialTab,
    void Function(BuildContext)? onEdit,
    void Function(BuildContext)? onAction,
  }) {
    showDialog(
      context: context,
      barrierColor: AppColors.black.withValues(alpha: 0.54),
      builder: (_) => UserDetailsDialog(
        user: user,
        initialTab: initialTab,
        onEdit: onEdit,
        onAction: onAction,
      ),
    );
  }

  @override
  State<UserDetailsDialog> createState() => _UserDetailsDialogState();
}

class _UserDetailsDialogState extends State<UserDetailsDialog> {
  int _activeTab = 0;
  final List<String> _baseTabs = [
    'Position',
    'Trades',
    'Group Settings',
    'Brk',
    'Credit',
    'User List',
    'Rejection Log',
    'Sharing Details',
    'Trade Margin',
    'Pending Orders',
    'Change Password',
    'INT. Square off',
    'Ex. Wise Position Lmt',
  ];
  late List<String> _currentTabs;
  String? _selectedQuantityGroup;
  @override
  void initState() {
    super.initState();
    _currentTabs = List.from(_baseTabs);
    if (widget.user.type != 'Master') {
      _currentTabs.remove('User List');
    }
    if (widget.user.type.toLowerCase() == 'client') {
      _currentTabs.remove('Sharing Details');
    }
    if (widget.initialTab != null) {
      _activeTab = _currentTabs.indexOf(widget.initialTab!);
      if (_activeTab == -1) _activeTab = 0;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onViewSettings(String groupName) {
    setState(() {
      _selectedQuantityGroup = groupName;
      if (!_currentTabs.contains('Quantity Settings')) {
        int groupIndex = _currentTabs.indexOf('Group Settings');
        if (groupIndex != -1) {
          _currentTabs.insert(groupIndex + 1, 'Quantity Settings');
        } else {
          _currentTabs.add('Quantity Settings');
        }
      }
      _activeTab = _currentTabs.indexOf('Quantity Settings');
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: 'User Details',
      width: 1350.w,
      height: 700.h,
      showButtons: false,
      scrollable: false,
      contentPadding: EdgeInsets.zero,
      content: Column(
        children: [
          _buildHeader(),
          Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: _buildTabBar(),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: _buildTabContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    final tab = _currentTabs[_activeTab];
    switch (tab) {
      case 'Position':
        return UserPositionTab(user: widget.user);
      case 'Trades':
        return UserTradesTab(user: widget.user);
      case 'Group Settings':
        return UserGroupSettingsTab(
          user: widget.user,
          onViewSettings: _onViewSettings,
        );
      case 'Quantity Settings':
        return UserQuantitySettingsTab(
          user: widget.user,
          groupName: _selectedQuantityGroup,
        );
      case 'Brk':
        return UserBrokerageTab(user: widget.user);
      case 'Credit':
        return UserCreditTab(user: widget.user);
      case 'User List':
        return const SizedBox();
      case 'Rejection Log':
        return UserRejectionLogTab(user: widget.user);
      case 'Sharing Details':
        return UserSharingDetailsTab(user: widget.user);
      case 'Trade Margin':
        return UserTradeMarginTab(user: widget.user);
      case 'Pending Orders':
        return UserPendingOrdersTab(user: widget.user);
      case 'Change Password':
        return const SizedBox();
      case 'INT. Square off':
        return const SizedBox();
      case 'Ex. Wise Position Lmt':
        return const SizedBox();
      default:
        return UserPlaceholderTab(title: tab);
    }
  }

  void _handleTabChange(int index) {
    final tabName = _currentTabs[index];
    if (tabName == 'Change Password') {
      ChangePasswordDialog.show(
        context: context,
        userId: widget.user.id,
        userName: widget.user.userName,
        requireCurrentPassword: false,
        onChangePassword: (oldPass, newPass) {
          print('Change password: $oldPass -> $newPass');
        },
      );
      return;
    } else if (tabName == 'INT. Square off') {
      UserIntradaySquareOffDialog.show(context, widget.user);
      return;
    } else if (tabName == 'Ex. Wise Position Lmt') {
      UserExchangeWisePositionLimitDialog.show(context, widget.user);
      return;
    } else if (tabName == 'User List') {
      UserHierarchyDialog.show(context, widget.user);
      return;
    }
    setState(() {
      if (tabName != 'Quantity Settings' &&
          _currentTabs.contains('Quantity Settings')) {
        _currentTabs.remove('Quantity Settings');
        _selectedQuantityGroup = null;
        index = _currentTabs.indexOf(tabName);
        if (index == -1) index = 0;
      }
      _activeTab = index;
    });
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      color: AppColors.white,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: const Color(0xFF1F4A66), width: 1.5),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.errorColor),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                widget.user.type.substring(0, 1).toUpperCase(),
                style: GoogleFonts.openSans(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.errorColor,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              widget.user.userName,
              style: GoogleFonts.openSans(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F4A66),
              ),
            ),
            const Spacer(),
            _buildActionButton(Icons.edit, 'Edit', () {
              if (widget.onEdit != null) widget.onEdit!(context);
            }),
            SizedBox(width: 8.w),
            _buildActionButton(Icons.person, 'Action', () {
              if (widget.onAction != null) widget.onAction!(context);
            }, isPrimary: true),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool isPrimary = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFFDFECFE) : const Color(0xFFFFF4E5),
          border: Border.all(
            color: isPrimary
                ? const Color(0xFF0066FF)
                : const Color(0xFFFFCC80),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 14.sp,
              color: isPrimary
                  ? const Color(0xFF0066FF)
                  : const Color(0xFFFF9800),
            ),
            SizedBox(width: 4.w),
            Text(
              label,
              style: GoogleFonts.openSans(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F4A66),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return AppTabBar(
      tabs: _currentTabs,
      activeTab: _activeTab,
      onTabChanged: _handleTabChange,
    );
  }
}
