import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/common_dilog_box.dart';
import 'package:bazarpro/features/users/domain/entities/user.dart';
import 'tabs/user_placeholder_tab.dart';
import 'tabs/user_position_tab.dart';
import 'tabs/user_trades_tab.dart';
import 'tabs/user_group_settings_tab.dart';
import 'tabs/user_brokerage_tab.dart';
import 'tabs/user_credit_tab.dart';
import 'tabs/user_list_tab.dart';
import 'tabs/user_rejection_log_tab.dart';
import 'tabs/user_sharing_details_tab.dart';
import 'tabs/user_intraday_square_off_tab.dart';
import 'tabs/user_trade_margin_tab.dart';
import 'tabs/user_pending_orders_tab.dart';
import '../dialogs/change_password_dialog.dart';

class UserDetailsDialog extends StatefulWidget {
  final User user;
  final String? initialTab;
  final VoidCallback? onEdit;
  final VoidCallback? onAction;

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
    VoidCallback? onEdit,
    VoidCallback? onAction,
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

class _UserDetailsDialogState extends State<UserDetailsDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = [
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
    'Intraday Square off',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.user.type != 'Master') {
      _tabs.remove('User List');
    }

    // Tab Controller
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: widget.initialTab != null
          ? _tabs.indexOf(widget.initialTab!) == -1
                ? 0
                : _tabs.indexOf(widget.initialTab!)
          : 0,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: 'User Details',
      width: 1000.w,
      height: 700.h,
      showButtons: false,
      scrollable: false,
      contentPadding: EdgeInsets.zero,
      content: Column(
        children: [
          _buildHeader(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _tabs.map((tab) {
                switch (tab) {
                  case 'Position':
                    return UserPositionTab(user: widget.user);
                  case 'Trades':
                    return UserTradesTab(user: widget.user);
                  case 'Group Settings':
                    return UserGroupSettingsTab(user: widget.user);
                  case 'Brk':
                    return UserBrokerageTab(user: widget.user);
                  case 'Credit':
                    return UserCreditTab(user: widget.user);
                  case 'User List':
                    return UserListTab(user: widget.user);
                  case 'Rejection Log':
                    return UserRejectionLogTab(user: widget.user);
                  case 'Sharing Details':
                    return UserSharingDetailsTab(user: widget.user);
                  case 'Trade Margin':
                    return UserTradeMarginTab(user: widget.user);
                  case 'Pending Orders':
                    return UserPendingOrdersTab(user: widget.user);
                  case 'Change Password':
                    return const SizedBox(); // Placeholder, dialog opens on tap
                  case 'Intraday Square off':
                    return UserIntradaySquareOffTab(user: widget.user);
                  default:
                    return UserPlaceholderTab(title: tab);
                }
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.greyBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.errorColor),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              widget.user.type.substring(0, 1).toUpperCase(),
              style: GoogleFonts.openSans(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.errorColor,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            widget.user.userName,
            style: GoogleFonts.openSans(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor(context),
            ),
          ),
          const Spacer(),
          _buildActionButton(Icons.edit, 'Edit', () {
            if (widget.onEdit != null) widget.onEdit!();
          }),
          SizedBox(width: 8.w),
          _buildActionButton(Icons.person, 'Action', () {
            if (widget.onAction != null) widget.onAction!();
          }, isPrimary: true),
        ],
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
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isPrimary
              ? AppColors.primaryBlue.withOpacity(0.1)
              : AppColors.white,
          border: Border.all(
            color: isPrimary ? AppColors.primaryBlue : AppColors.borderColor,
          ),
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 14.sp,
              color: isPrimary ? AppColors.primaryBlue : AppColors.warningColor,
            ),
            SizedBox(width: 4.w),
            Text(
              label,
              style: GoogleFonts.openSans(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: isPrimary
                    ? AppColors.primaryBlue
                    : AppColors.textColor(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppColors.white,
      width: double.infinity,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: AppColors.primaryBlue,
        unselectedLabelColor: AppColors.textColor(context),
        indicatorColor: AppColors.primaryBlue,
        indicatorWeight: 3.h,
        labelStyle: GoogleFonts.openSans(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
        tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        tabAlignment: TabAlignment.start,
        onTap: (index) {
          if (_tabs[index] == 'Change Password') {
            _tabController.index = _tabController.previousIndex;
            ChangePasswordDialog.show(
              context: context,
              userId: widget.user.id,
              userName: widget.user.userName,
              onChangePassword: (oldPass, newPass) {
                // TODO: Implement API call
                print('Change password: $oldPass -> $newPass');
              },
            );
          }
        },
      ),
    );
  }
}
