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

  // Track selected dropdown items for each tab with dropdown
  final Map<int, String> _selectedDropdownItems = {};

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
            onTap: () => _navigateToPage(context, 3, 'Pending Orders', '/pending-orders'),
          ),
          MenuItemData(
            title: 'Trades',
            onTap: () => _navigateToPage(context, 3, 'Trades', '/trades'),
          ),
          MenuItemData(
            title: 'Deals',
            onTap: () => _navigateToPage(context, 3, 'Deals', '/deals'),
          ),
          MenuItemData(
            title: 'Net Position',
            onTap: () => _navigateToPage(context, 3, 'Net Position', '/net-position'),
          ),
          MenuItemData(
            title: 'Rejection Log',
            onTap: () => _navigateToPage(context, 3, 'Rejection Log', '/rejection-log'),
          ),
          MenuItemData(
            title: 'Login History',
            onTap: () => _navigateToPage(context, 3, 'Login History', '/login-history'),
          ),
          MenuItemData(
            title: 'Intraday History',
            onTap: () => _navigateToPage(context, 3, 'Intraday History', '/intraday-history'),
          ),
          MenuItemData(
            title: 'Script Master',
            onTap: () => _navigateToPage(context, 3, 'Script Master', '/script-master'),
          ),
          MenuItemData(
            title: 'Script Quantity',
            onTap: () => _navigateToPage(context, 3, 'Script Quantity', '/script-quantity'),
          ),
          MenuItemData(
            title: 'Bulk Trade',
            onTap: () => _navigateToPage(context, 3, 'Bulk Trade', '/bulk-trade'),
          ),
          MenuItemData(
            title: 'Total Volume',
            onTap: () => _navigateToPage(context, 3, 'Total Volume', '/total-volume'),
          ),
          MenuItemData(
            title: 'Deleted Trade',
            onTap: () => _navigateToPage(context, 3, 'Deleted Trade', '/deleted-trade'),
          ),
          MenuItemData(
            title: 'Manual Trade',
            onTap: () => _navigateToPage(context, 3, 'Manual Trade', '/manual-trade'),
          ),
        ],
      ),

      // User - Has dropdown (index 4)
      AppBarTab(
        title: 'User',
        dropdownItems: [
          MenuItemData(
            title: 'Create User',
            onTap: () => _navigateToPage(context, 4, 'Create User', '/create-user'),
          ),
          MenuItemData(
            title: 'In-Active User',
            onTap: () => _navigateToPage(context, 4, 'In-Active User', '/inactive-user'),
          ),
          MenuItemData(
            title: 'Search User',
            onTap: () => _navigateToPage(context, 4, 'Search User', '/search-user'),
          ),
        ],
      ),

      // Report - Has dropdown (index 5)
      AppBarTab(
        title: AppStrings.report,
        dropdownItems: [
          MenuItemData(
            title: 'Daily Report',
            onTap: () => _navigateToPage(context, 5, 'Daily Report', '/daily-report'),
          ),
          MenuItemData(
            title: 'Weekly Report',
            onTap: () => _navigateToPage(context, 5, 'Weekly Report', '/weekly-report'),
          ),
          MenuItemData(
            title: 'Monthly Report',
            onTap: () => _navigateToPage(context, 5, 'Monthly Report', '/monthly-report'),
          ),
          MenuItemData(
            title: 'Custom Report',
            onTap: () => _navigateToPage(context, 5, 'Custom Report', '/custom-report'),
          ),
          MenuItemData(
            title: 'Export Report',
            onTap: () {
              _selectDropdownItem(5, 'Export Report');
              _toggleExportButtons();
            },
          ),
        ],
      ),

      // Tools - No dropdown (index 6)
      const AppBarTab(title: AppStrings.tools),
    ];
  }

  /// Navigate to specific page and update selection
  void _navigateToPage(BuildContext context, int tabIndex, String itemTitle, String routeName) {
    _selectDropdownItem(tabIndex, itemTitle);
    widget.onViewAction?.call(routeName);

    // Navigate using named route
    Navigator.of(context).pushNamed(routeName);
  }

  /// Select dropdown item and navigate to that tab
  void _selectDropdownItem(int tabIndex, String itemTitle) {
    setState(() {
      _selectedDropdownItems[tabIndex] = itemTitle;
    });

    // Navigate to the tab if not already selected
    if (widget.selectedTabIndex != tabIndex) {
      widget.onTabSelected(tabIndex);
    }
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
      selectedDropdownItems: _selectedDropdownItems,
    );
  }
}