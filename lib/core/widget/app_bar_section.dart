import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widget/common_app_bar.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/market_watch/data/models/menu_Item_data.dart';
import '../../features/users/presentation/widgets/create_user/user_search_dialog.dart';
import '../../features/tools/presentation/widgets/about_dialog.dart';
import '../../features/users/presentation/widgets/create_user/change_password_dialog.dart';
import '../../features/tools/presentation/widgets/messages/messages_dialog.dart';
import '../../features/tools/presentation/widgets/announcement/announcement_dialog.dart';
import '../../features/tools/presentation/widgets/shortcuts/shortcuts_dialog.dart';
import '../../features/tools/presentation/widgets/total_volume/total_volume_dialog.dart';
import '../../features/operations/presentation/widgets/inactivity_management/inactivity_management_dialog.dart';
import '../../features/operations/presentation/widgets/surveillance/vpn_restriction_dialog.dart';
import '../../features/report/presentation/widgets/users_bill_summary/users_bill_summary_dialog.dart';
import '../../features/view/presentation/widget/login_history/login_history_dialog.dart';
import '../../features/view/presentation/widget/manual_trade/manual_trade_dialog.dart';
import '../../features/view/presentation/widget/trade_margin/trade_margin_dialog.dart';
import '../../features/report/presentation/widgets/credit_history/credit_history_dialog.dart';
import '../../features/view/presentation/widget/script_master/script_master_dialog.dart';

class AppBarSection extends StatefulWidget implements PreferredSizeWidget {
  final int selectedTabIndex;
  final String? userRole;
  final String? currentPageTitle;
  final Function(int) onTabSelected;
  final VoidCallback? onReload;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onExportPdf;
  final VoidCallback? onExportExcel;
  final Function(String)? onViewAction;
  final Function(String)? onUserAction;
  final Function(String)? onReportAction;
  final bool showExportByDefault;
  const AppBarSection({
    Key? key,
    required this.selectedTabIndex,
    required this.onTabSelected,
    this.userRole,
    this.currentPageTitle,
    this.onReload,
    this.onNotificationTap,
    this.onExportPdf,
    this.onExportExcel,
    this.onViewAction,
    this.onUserAction,
    this.onReportAction,
    this.showExportByDefault = false,
  }) : super(key: key);
  @override
  Size get preferredSize =>
      Size.fromHeight(selectedTabIndex == 0 ? 98.h : 64.h);
  @override
  State<AppBarSection> createState() => AppBarSectionState();
}

class AppBarSectionState extends State<AppBarSection> {
  late List<AppBarTab> _tabs;
  final Map<int, String> _selectedDropdownItems = {};
  @override
  void initState() {
    super.initState();
    _initializeTabs();
    if (widget.currentPageTitle != null) {
      _selectedDropdownItems[widget.selectedTabIndex] =
          widget.currentPageTitle!;
    }
  }

  @override
  void didUpdateWidget(AppBarSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentPageTitle != widget.currentPageTitle &&
        widget.currentPageTitle != null) {
      _selectedDropdownItems[widget.selectedTabIndex] =
          widget.currentPageTitle!;
    }
  }

  void _initializeTabs() {
    final allTabs = [
      const AppBarTab(title: AppStrings.marketWatch),
      const AppBarTab(title: AppStrings.dashboard),
      AppBarTab(
        title: AppStrings.view,
        dropdownItems: _getViewDropdownItems(widget.userRole),
      ),
      AppBarTab(
        title: 'User',
        dropdownItems: [
          MenuItemData(
            title: 'Create User',
            onTap: () => _navigateToPage(
              _getTabIndex('User'),
              'Create User',
              '/create-user',
            ),
          ),
          MenuItemData(
            title: 'In-Active User',
            onTap: () => _navigateToPage(
              _getTabIndex('User'),
              'In-Active User',
              '/inactive-user',
            ),
          ),
          MenuItemData(
            title: 'Search User',
            onTap: () {
              UserSearchDialog.show(context);
            },
          ),
        ],
      ),
      AppBarTab(
        title: AppStrings.report,
        dropdownItems: _getReportDropdownItems(widget.userRole),
      ),
      AppBarTab(
        title: AppStrings.tools,
        dropdownItems: _getToolsDropdownItems(),
      ),
      AppBarTab(
        title: 'Operations',
        dropdownItems: _getOperationsDropdownItems(),
      ),
    ];
    if (widget.userRole == 'Admin' || widget.userRole == 'Super Admin') {
      _tabs = allTabs;
    } else if (widget.userRole == 'Master') {
      _tabs = allTabs.sublist(0, allTabs.length - 1);
    } else if (widget.userRole == 'Client') {
      _tabs = [allTabs[0], allTabs[1], allTabs[2], allTabs[4], allTabs[5]];
    } else {
      _tabs = [allTabs[0], allTabs[1]];
    }
  }

  int _getTabIndex(String title) {
    for (int i = 0; i < _tabs.length; i++) {
      if (_tabs[i].title == title) return i;
    }
    return -1;
  }

  void _navigateToPage(int tabIndex, String itemTitle, String routeName) {
    if (tabIndex == -1) return;
    setState(() {
      _selectedDropdownItems[tabIndex] = itemTitle;
    });
    widget.onViewAction?.call(routeName);
    Navigator.of(context).pushReplacementNamed(routeName);
  }

  List<MenuItemData> _getOperationsDropdownItems() {
    return [
      MenuItemData(
        title: 'Exchange Settings',
        onTap: () => _navigateToPage(
          _getTabIndex('Operations'),
          'Exchange Settings',
          '/exchange-settings',
        ),
      ),
      MenuItemData(
        title: 'Group',
        onTap: () =>
            _navigateToPage(_getTabIndex('Operations'), 'Group', '/group'),
      ),
      MenuItemData(
        title: 'Trade Settings',
        onTap: () => _navigateToPage(
          _getTabIndex('Operations'),
          'Trade Settings',
          '/trade-settings',
        ),
      ),
      MenuItemData(
        title: 'Date Settings',
        onTap: () => _navigateToPage(
          _getTabIndex('Operations'),
          'Date Settings',
          '/date-settings',
        ),
      ),
      MenuItemData(
        title: 'Script Settings',
        onTap: () => _navigateToPage(
          _getTabIndex('Operations'),
          'Script Settings',
          '/script-settings',
        ),
      ),
      MenuItemData(
        title: 'Symbol Settings',
        onTap: () => _navigateToPage(
          _getTabIndex('Operations'),
          'Symbol Settings',
          '/symbol-settings',
        ),
      ),
      MenuItemData(
        title: 'VPN Restriction',
        onTap: () {
          VpnRestrictionDialog.show(context);
        },
      ),
      MenuItemData(
        title: 'Message',
        onTap: () => _navigateToPage(
          _getTabIndex('Operations'),
          'Message',
          '/operations-message',
        ),
      ),
      MenuItemData(
        title: 'Settlement Progress',
        onTap: () => _navigateToPage(
          _getTabIndex('Operations'),
          'Settlement Progress',
          '/settlement-progress',
        ),
      ),
      MenuItemData(
        title: 'Settlement Master % Sharing',
        onTap: () => _navigateToPage(
          _getTabIndex('Operations'),
          'Settlement Master % Sharing',
          '/settlement-master-sharing',
        ),
      ),
      MenuItemData(
        title: 'Server',
        onTap: () =>
            _navigateToPage(_getTabIndex('Operations'), 'Server', '/server'),
      ),
      MenuItemData(
        title: 'Bill Comparision',
        onTap: () => _navigateToPage(
          _getTabIndex('Operations'),
          'Bill Comparision',
          '/bill-comparison',
        ),
      ),
      MenuItemData(
        title: 'Inactivity Management',
        onTap: () {
          InactivityManagementDialog.show(context);
        },
      ),
    ];
  }

  List<MenuItemData> _getViewDropdownItems(String? role) {
    if (role == 'Client') {
      return [
        MenuItemData(
          title: 'Trades',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.view),
            'Trades',
            '/trades',
          ),
        ),
        MenuItemData(
          title: 'Deals',
          onTap: () =>
              _navigateToPage(_getTabIndex(AppStrings.view), 'Deals', '/deals'),
        ),
        MenuItemData(
          title: 'Pending Orders',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.view),
            'Pending Orders',
            '/pending_order-orders',
          ),
        ),
        MenuItemData(
          title: 'Net Position',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.view),
            'Net Position',
            '/net-position',
          ),
        ),
        MenuItemData(
          title: 'Rejection Log',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.view),
            'Rejection Log',
            '/rejection-log',
          ),
        ),
        MenuItemData(
          title: 'Login History',
          onTap: () {
            LoginHistoryDialog.show(context);
            final viewIndex = _getTabIndex(AppStrings.view);
            if (viewIndex != -1) {
              setState(() {
                _selectedDropdownItems[viewIndex] = 'Login History';
              });
            }
          },
        ),
        MenuItemData(
          title: 'Intraday History',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.view),
            'Intraday History',
            '/intraday-history',
          ),
        ),
        MenuItemData(
          title: 'Script Quantity',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.view),
            'Script Quantity',
            '/script-quantity',
          ),
        ),
        MenuItemData(
          title: 'Trade Margin',
          onTap: () {
            TradeMarginDialog.show(context);
            final viewIndex = _getTabIndex(AppStrings.view);
            if (viewIndex != -1) {
              setState(() {
                _selectedDropdownItems[viewIndex] = 'Trade Margin';
              });
            }
          },
        ),
        MenuItemData(
          title: 'Brokerage',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.view),
            'Brokerage',
            '/brokerage',
          ),
        ),
      ];
    } else if (role == 'Master') {
      return [
        MenuItemData(
          title: 'Trades',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.view),
            'Trades',
            '/trades',
          ),
        ),
        MenuItemData(
          title: 'Deals',
          onTap: () =>
              _navigateToPage(_getTabIndex(AppStrings.view), 'Deals', '/deals'),
        ),
        MenuItemData(
          title: 'Pending Orders',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.view),
            'Pending Orders',
            '/pending_order-orders',
          ),
        ),
        MenuItemData(
          title: 'Net Position',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.view),
            'Net Position',
            '/net-position',
          ),
        ),
        MenuItemData(
          title: 'Rejection Log',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.view),
            'Rejection Log',
            '/rejection-log',
          ),
        ),
        MenuItemData(
          title: 'Login History',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.view),
            'Login History',
            '/login-history',
          ),
        ),
        MenuItemData(
          title: 'Intraday History',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.view),
            'Intraday History',
            '/intraday-history',
          ),
        ),
        MenuItemData(
          title: 'Script Quantity',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.view),
            'Script Quantity',
            '/script-quantity',
          ),
        ),
        MenuItemData(
          title: 'Trade Margin',
          onTap: () {
            TradeMarginDialog.show(context);
            final viewIndex = _getTabIndex(AppStrings.view);
            if (viewIndex != -1) {
              setState(() {
                _selectedDropdownItems[viewIndex] = 'Trade Margin';
              });
            }
          },
        ),
        MenuItemData(
          title: 'Script Master',
          onTap: () {
            ScriptMasterDialog.show(context);
            final viewIndex = _getTabIndex(AppStrings.view);
            if (viewIndex != -1) {
              setState(() {
                _selectedDropdownItems[viewIndex] = 'Script Master';
              });
            }
          },
        ),
        MenuItemData(
          title: 'Broker List',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.view),
            'Broker List',
            '/broker-list',
          ),
        ),
      ];
    } else {
      return [
        MenuItemData(
          title: 'Trades',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.view),
            'Trades',
            '/trades',
          ),
        ),
        MenuItemData(
          title: 'Deals',
          onTap: () =>
              _navigateToPage(_getTabIndex(AppStrings.view), 'Deals', '/deals'),
        ),
        MenuItemData(
          title: 'Pending Orders',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.view),
            'Pending Orders',
            '/pending_order-orders',
          ),
        ),
        MenuItemData(
          title: 'Net Position',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.view),
            'Net Position',
            '/net-position',
          ),
        ),
        MenuItemData(
          title: 'Rejection Log',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.view),
            'Rejection Log',
            '/rejection-log',
          ),
        ),
        MenuItemData(
          title: 'Login History',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.view),
            'Login History',
            '/login-history',
          ),
        ),
        MenuItemData(
          title: 'Intraday History',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.view),
            'Intraday History',
            '/intraday-history',
          ),
        ),
        MenuItemData(
          title: 'Script Master',
          onTap: () {
            ScriptMasterDialog.show(context);
            final viewIndex = _getTabIndex(AppStrings.view);
            if (viewIndex != -1) {
              setState(() {
                _selectedDropdownItems[viewIndex] = 'Script Master';
              });
            }
          },
        ),
        MenuItemData(
          title: 'Script Quantity',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.view),
            'Script Quantity',
            '/script-quantity',
          ),
        ),
        MenuItemData(
          title: 'Deleted Trade',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.view),
            'Deleted Trade',
            '/deleted-trade',
          ),
        ),
        MenuItemData(
          title: 'Rejected Trade',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.view),
            'Rejected Trade',
            '/rejected-trade',
          ),
        ),
        MenuItemData(
          title: 'Trade Margin',
          onTap: () {
            TradeMarginDialog.show(context);
            final viewIndex = _getTabIndex(AppStrings.view);
            if (viewIndex != -1) {
              setState(() {
                _selectedDropdownItems[viewIndex] = 'Trade Margin';
              });
            }
          },
        ),
        MenuItemData(
          title: 'Manual Trade',
          onTap: () {
            ManualTradeDialog.show(context);
            final viewIndex = _getTabIndex(AppStrings.view);
            if (viewIndex != -1) {
              setState(() {
                _selectedDropdownItems[viewIndex] = 'Manual Trade';
              });
            }
          },
        ),
      ];
    }
  }

  List<MenuItemData> _getReportDropdownItems(String? role) {
    if (role == 'Client') {
      return [
        MenuItemData(
          title: 'Credit History',
          onTap: () {
            CreditHistoryDialog.show(context);
            final reportIndex = _getTabIndex(AppStrings.report);
            if (reportIndex != -1) {
              setState(() {
                _selectedDropdownItems[reportIndex] = 'Credit History';
              });
            }
          },
        ),
        MenuItemData(
          title: 'Bill Generate',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.report),
            'Bill Generate',
            '/bill-generate',
          ),
        ),
        MenuItemData(
          title: 'Symbol Wise Report',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.report),
            'Symbol Wise Report',
            '/symbol-wise-pl',
          ),
        ),
        MenuItemData(
          title: 'Exchange Wise Report',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.report),
            'Exchange Wise Report',
            '/exchange-wise-report',
          ),
        ),
        MenuItemData(
          title: 'Expiry Report',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.report),
            'Expiry Report',
            '/expiry-report',
          ),
        ),
      ];
    } else if (role == 'Master') {
      return [
        MenuItemData(
          title: 'Trade Logs',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.report),
            'Trade Logs',
            '/trade-logs',
          ),
        ),
        MenuItemData(
          title: 'Credit History',
          onTap: () {
            CreditHistoryDialog.show(context);
            final reportIndex = _getTabIndex(AppStrings.report);
            if (reportIndex != -1) {
              setState(() {
                _selectedDropdownItems[reportIndex] = 'Credit History';
              });
            }
          },
        ),
        MenuItemData(
          title: 'Bill Generate',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.report),
            'Bill Generate',
            '/bill-generate',
          ),
        ),
        MenuItemData(
          title: 'Settlement',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.report),
            'Settlement',
            '/settlement',
          ),
        ),
        MenuItemData(
          title: 'Profit & Loss',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.report),
            'Profit & Loss',
            '/profit-loss',
          ),
        ),
        MenuItemData(
          title: 'User Wise Profit & Loss',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.report),
            'User Wise Profit & Loss',
            '/user-wise-pl',
          ),
        ),
        MenuItemData(
          title: 'Symbol Wise Position Report',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.report),
            'Symbol Wise Position Report',
            '/symbol-wise-position',
          ),
        ),
        MenuItemData(
          title: 'Symbol Wise PL',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.report),
            'Symbol Wise PL',
            '/symbol-wise-pl',
          ),
        ),
        MenuItemData(
          title: 'Exchange Wise Report',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.report),
            'Exchange Wise Report',
            '/exchange-wise-report',
          ),
        ),
        MenuItemData(
          title: 'User Script Position Tracking',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.report),
            'User Script Position Tracking',
            '/user-script-position',
          ),
        ),
        MenuItemData(
          title: 'Activity Report',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.report),
            'Activity Report',
            '/activity-report',
          ),
        ),
        MenuItemData(
          title: 'Expiry Report',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.report),
            'Expiry Report',
            '/expiry-report',
          ),
        ),
      ];
    } else {
      return [
        MenuItemData(
          title: 'Trade Logs',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.report),
            'Trade Logs',
            '/trade-logs',
          ),
        ),
        MenuItemData(
          title: 'Credit History',
          onTap: () {
            CreditHistoryDialog.show(context);
            final reportIndex = _getTabIndex(AppStrings.report);
            if (reportIndex != -1) {
              setState(() {
                _selectedDropdownItems[reportIndex] = 'Credit History';
              });
            }
          },
        ),
        MenuItemData(
          title: 'Bill Generate',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.report),
            'Bill Generate',
            '/bill-generate',
          ),
        ),
        MenuItemData(
          title: 'Settlement',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.report),
            'Settlement',
            '/settlement',
          ),
        ),
        MenuItemData(
          title: 'Settlement With % Sharing',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.report),
            'Settlement With % Sharing',
            '/settlement-with-sharing',
          ),
        ),
        MenuItemData(
          title: 'Profit & Loss',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.report),
            'Profit & Loss',
            '/profit-loss',
          ),
        ),
        MenuItemData(
          title: 'User Wise Profit & Loss',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.report),
            'User Wise Profit & Loss',
            '/user-wise-pl',
          ),
        ),
        MenuItemData(
          title: 'Symbol Wise Position Report',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.report),
            'Symbol Wise Position Report',
            '/symbol-wise-position',
          ),
        ),
        MenuItemData(
          title: 'Symbol Wise PL',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.report),
            'Symbol Wise PL',
            '/symbol-wise-pl',
          ),
        ),
        MenuItemData(
          title: 'Exchange Wise Report',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.report),
            'Exchange Wise Report',
            '/exchange-wise-report',
          ),
        ),
        MenuItemData(
          title: 'User Script Position Tracking',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.report),
            'User Script Position Tracking',
            '/user-script-position',
          ),
        ),
        MenuItemData(
          title: 'Activity Report',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.report),
            'Activity Report',
            '/activity-report',
          ),
        ),
        MenuItemData(
          title: "User's Bill Summary",
          onTap: () {
            UsersBillSummaryDialog.show(context);
          },
        ),
        MenuItemData(
          title: 'Back Office Activity Report',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.report),
            'Back Office Activity Report',
            '/back-office-activity-report',
          ),
        ),
        MenuItemData(
          title: 'Expiry Report',
          onTap: () => _navigateToPage(
            _getTabIndex(AppStrings.report),
            'Expiry Report',
            '/expiry-report',
          ),
        ),
      ];
    }
  }

  void _onTabSelected(int index) {
    if (index == 0) {
      Navigator.of(context).pushReplacementNamed('/market-watch');
    } else if (index == 1) {
      Navigator.of(context).pushReplacementNamed('/dashboard');
    } else if (index == _getTabIndex(AppStrings.tools)) {
      Navigator.of(context).pushReplacementNamed('/tools');
    }
    widget.onTabSelected(index);
  }

  bool hasDropdown(int index) {
    if (index < 0 || index >= _tabs.length) return false;
    return _tabs[index].hasDropdown;
  }

  bool get _shouldShowReloadIcon {
    return widget.selectedTabIndex == 0;
  }

  @override
  Widget build(BuildContext context) {
    final shouldShowExport = widget.showExportByDefault;
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        String username = AppStrings.defaultUsername;
        String? userRole = widget.userRole;
        if (authState is AuthAuthenticated) {
          username = authState.user.username;
          userRole = authState.user.role;
        }
        return CommonAppBar(
          tabs: _tabs,
          selectedIndex: widget.selectedTabIndex,
          onTabSelected: _onTabSelected,
          showMarketTicker: widget.selectedTabIndex == 0,
          showReloadIcon: _shouldShowReloadIcon,
          showExportIcon: shouldShowExport,
          onReload: widget.onReload,
          onNotificationTap: widget.onNotificationTap,
          onExportPdf: widget.onExportPdf,
          onExportExcel: widget.onExportExcel,
          selectedDropdownItems: _selectedDropdownItems,
          username: username,
          userRole: userRole,
        );
      },
    );
  }

  List<MenuItemData> _getToolsDropdownItems() {
    final isClient = widget.userRole?.toLowerCase() == 'client';
    return [
      MenuItemData(
        title: 'About',
        onTap: () {
          AboutDialogBox.show(context);
          final toolsIndex = _getTabIndex(AppStrings.tools);
          if (toolsIndex != -1) {
            setState(() {
              _selectedDropdownItems[toolsIndex] = 'About';
            });
          }
        },
      ),
      MenuItemData(
        title: 'Change Password',
        onTap: () {
          ChangePasswordDialog.show(
            context: context,
            userId: 'current_user_id',
            userName: 'Current User',
            requireCurrentPassword: true,
            onChangePassword: (oldNum, newNum) {
              print('Change password: $oldNum -> $newNum');
            },
          );
          final toolsIndex = _getTabIndex(AppStrings.tools);
          if (toolsIndex != -1) {
            setState(() {
              _selectedDropdownItems[toolsIndex] = 'Change Password';
            });
          }
        },
      ),
      MenuItemData(
        title: 'Market Timing',
        onTap: () => _navigateToPage(
          _getTabIndex(AppStrings.tools),
          'Market Timing',
          '/tools/market-timing',
        ),
      ),
      MenuItemData(
        title: 'Message',
        onTap: () {
          MessagesDialog.show(context);
          final toolsIndex = _getTabIndex(AppStrings.tools);
          if (toolsIndex != -1) {
            setState(() {
              _selectedDropdownItems[toolsIndex] = 'Message';
            });
          }
        },
      ),
      MenuItemData(
        title: 'Announcement',
        onTap: () {
          AnnouncementDialog.show(context);
          final toolsIndex = _getTabIndex(AppStrings.tools);
          if (toolsIndex != -1) {
            setState(() {
              _selectedDropdownItems[toolsIndex] = 'Announcement';
            });
          }
        },
      ),
      MenuItemData(
        title: 'Rules & Regulations',
        onTap: () => _navigateToPage(
          _getTabIndex(AppStrings.tools),
          'Rules & Regulations',
          '/tools/rules-regulations',
        ),
      ),
      MenuItemData(
        title: 'ShortCuts',
        onTap: () {
          ShortcutsDialog.show(context);
          final toolsIndex = _getTabIndex(AppStrings.tools);
          if (toolsIndex != -1) {
            setState(() {
              _selectedDropdownItems[toolsIndex] = 'ShortCuts';
            });
          }
        },
      ),
      if (!isClient)
        MenuItemData(
          title: 'Total Volume',
          onTap: () {
            TotalVolumeDialog.show(context);
            final toolsIndex = _getTabIndex(AppStrings.tools);
            if (toolsIndex != -1) {
              setState(() {
                _selectedDropdownItems[toolsIndex] = 'Total Volume';
              });
            }
          },
        ),
    ];
  }
}
