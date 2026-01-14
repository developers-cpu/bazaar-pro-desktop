import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widget/common_app_bar.dar.dart';
import '../../data/models/menu_Item_data.dart';


/// Market AppBar Section

class MarketAppBarSection extends StatefulWidget implements PreferredSizeWidget {
  final int selectedTabIndex;
  final Function(int) onTabSelected;
  final VoidCallback onReload;
  final VoidCallback? onExportPdf;
  final VoidCallback? onExportExcel;
  final Function(String)? onViewAction;
  final Function(String)? onUserAction;
  final Function(String)? onReportAction;

  const MarketAppBarSection({
    Key? key,
    required this.selectedTabIndex,
    required this.onTabSelected,
    required this.onReload,
    this.onExportPdf,
    this.onExportExcel,
    this.onViewAction,
    this.onUserAction,
    this.onReportAction,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(76.h);

  @override
  State<MarketAppBarSection> createState() => MarketAppBarSectionState();
}

/// Exposed state class for external access to hasDropdown method
class MarketAppBarSectionState extends State<MarketAppBarSection> {
  bool _showExportButtons = false;
  late List<AppBarTab> _tabs;

  @override
  void initState() {
    super.initState();
    _initializeTabs();
  }

  void _initializeTabs() {
    _tabs = [
      // Market Watch - No dropdown (index 0)
      const AppBarTab(title: AppStrings.marketWatch),

      // Dashboard - No dropdown (index 1)
      const AppBarTab(title: AppStrings.dashboard),

      // File - No dropdown (index 2)
      const AppBarTab(title: AppStrings.file),

      // View - Has dropdown (index 3)
      AppBarTab(
        title: AppStrings.view,
        dropdownItems: [
          MenuItemData(
            title: 'Pending Orders',
            onTap: () => widget.onViewAction?.call('pending_orders'),
          ),
          MenuItemData(
            title: 'Trades',
            onTap: () => widget.onViewAction?.call('trades'),
          ),
          MenuItemData(
            title: 'Deals',
            onTap: () => widget.onViewAction?.call('deals'),
            hasDivider: true,
          ),
          MenuItemData(
            title: 'Net Position',
            onTap: () => widget.onViewAction?.call('net_position'),
          ),
          MenuItemData(
            title: 'Rejection Log',
            onTap: () => widget.onViewAction?.call('rejection_log'),
          ),
          MenuItemData(
            title: 'Login History',
            onTap: () => widget.onViewAction?.call('login_history'),
          ),
          MenuItemData(
            title: 'Intraday History',
            onTap: () => widget.onViewAction?.call('intraday_history'),
            hasDivider: true,
          ),
          MenuItemData(
            title: 'Script Master',
            onTap: () => widget.onViewAction?.call('script_master'),
          ),
          MenuItemData(
            title: 'Script Quantity',
            onTap: () => widget.onViewAction?.call('script_quantity'),
          ),
          MenuItemData(
            title: 'Bulk Trade',
            onTap: () => widget.onViewAction?.call('bulk_trade'),
          ),
          MenuItemData(
            title: 'Total Volume',
            onTap: () => widget.onViewAction?.call('total_volume'),
          ),
          MenuItemData(
            title: 'Deleted Trade',
            onTap: () => widget.onViewAction?.call('deleted_trade'),
          ),
          MenuItemData(
            title: 'Manual Trade',
            onTap: () => widget.onViewAction?.call('manual_trade'),
          ),
        ],
      ),

      // User - Has dropdown (index 4)
      AppBarTab(
        title: 'User',
        dropdownItems: [
          MenuItemData(
            title: 'User Profile',
            onTap: () => widget.onUserAction?.call('profile'),
          ),
          MenuItemData(
            title: 'Settings',
            onTap: () => widget.onUserAction?.call('settings'),
          ),
          MenuItemData(
            title: 'Preferences',
            onTap: () => widget.onUserAction?.call('preferences'),
          ),
        ],
      ),

      // Report - Has dropdown (index 5)
      AppBarTab(
        title: AppStrings.report,
        dropdownItems: [
          MenuItemData(
            title: 'Daily Report',
            onTap: () => widget.onReportAction?.call('daily'),
          ),
          MenuItemData(
            title: 'Weekly Report',
            onTap: () => widget.onReportAction?.call('weekly'),
          ),
          MenuItemData(
            title: 'Monthly Report',
            onTap: () => widget.onReportAction?.call('monthly'),
          ),
          MenuItemData(
            title: 'Custom Report',
            onTap: () => widget.onReportAction?.call('custom'),
            hasDivider: true,
          ),
          MenuItemData(
            title: 'Export Report',
            onTap: _toggleExportButtons,
          ),
        ],
      ),

      // Tools - No dropdown (index 6)
      const AppBarTab(title: AppStrings.tools),
    ];
  }

  void _toggleExportButtons() {
    setState(() => _showExportButtons = !_showExportButtons);
  }

  void _closeExportButtons() {
    setState(() => _showExportButtons = false);
  }

  void _onTabSelected(int index) {
    // Hide export buttons when switching tabs (except for Report tab - index 5)
    if (index != 5) {
      _closeExportButtons();
    }
    widget.onTabSelected(index);
  }

  /// Show reload icon only for Market Watch tab (index 0)
  bool get _shouldShowReloadIcon => widget.selectedTabIndex == 0;

  /// Check if tab has dropdown - exposed for external access
  bool hasDropdown(int index) {
    if (index < 0 || index >= _tabs.length) return false;
    return _tabs[index].hasDropdown;
  }

  @override
  Widget build(BuildContext context) {
    return CommonAppBar(
      tabs: _tabs,
      selectedIndex: widget.selectedTabIndex,
      onTabSelected: _onTabSelected,
      showReloadIcon: _shouldShowReloadIcon,
      showExportButtons: _showExportButtons,
      onReload: widget.onReload,
      onExportPdf: widget.onExportPdf,
      onExportExcel: widget.onExportExcel,
      onCloseExport: _closeExportButtons,
    );
  }
}