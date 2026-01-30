import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widget/common_app_bar.dart';
import '../../features/market_watch/data/models/menu_Item_data.dart';
import '../../features/users/presentation/widgets/dialogs/user_search_dialog.dart';


class AppBarSection extends StatefulWidget implements PreferredSizeWidget {
  final int selectedTabIndex;
  final String? currentPageTitle;
  final Function(int) onTabSelected;
  final VoidCallback? onReload;
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
    this.currentPageTitle,
    this.onReload,
    this.onExportPdf,
    this.onExportExcel,
    this.onViewAction,
    this.onUserAction,
    this.onReportAction,
    this.showExportByDefault = false,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(64.h);

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
    _tabs = [
      
      const AppBarTab(title: AppStrings.marketWatch),

      
      const AppBarTab(title: AppStrings.dashboard),

      
      AppBarTab(
        title: AppStrings.view,
        dropdownItems: [
          MenuItemData(
            title: 'Pending Orders',
            onTap: () =>
                _navigateToPage(2, 'Pending Orders', '/pending_order-orders'),
          ),
          MenuItemData(
            title: 'Trades',
            onTap: () => _navigateToPage(2, 'Trades', '/trades'),
          ),
          MenuItemData(
            title: 'Deals',
            onTap: () => _navigateToPage(2, 'Deals', '/deals'),
          ),
          MenuItemData(
            title: 'Net Position',
            onTap: () => _navigateToPage(2, 'Net Position', '/net-position'),
          ),
          MenuItemData(
            title: 'Rejection Log',
            onTap: () => _navigateToPage(2, 'Rejection Log', '/rejection-log'),
          ),
          MenuItemData(
            title: 'Login History',
            onTap: () => _navigateToPage(2, 'Login History', '/login-history'),
          ),
          MenuItemData(
            title: 'Intraday History',
            onTap: () =>
                _navigateToPage(2, 'Intraday History', '/intraday-history'),
          ),
          MenuItemData(
            title: 'Script Master',
            onTap: () => _navigateToPage(2, 'Script Master', '/script-master'),
          ),
          MenuItemData(
            title: 'Script Quantity',
            onTap: () =>
                _navigateToPage(2, 'Script Quantity', '/script-quantity'),
          ),
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
        ],
      ),

      
      AppBarTab(
        title: 'User',
        dropdownItems: [
          MenuItemData(
            title: 'Create User',
            onTap: () => _navigateToPage(3, 'Create User', '/create-user'),
          ),
          MenuItemData(
            title: 'In-Active User',
            onTap: () => _navigateToPage(3, 'In-Active User', '/inactive-user'),
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
        dropdownItems: [
          MenuItemData(
            title: 'Daily Report',
            onTap: () => _navigateToPage(4, 'Daily Report', '/daily-report'),
          ),
          MenuItemData(
            title: 'Weekly Report',
            onTap: () => _navigateToPage(4, 'Weekly Report', '/weekly-report'),
          ),
          MenuItemData(
            title: 'Monthly Report',
            onTap: () =>
                _navigateToPage(4, 'Monthly Report', '/monthly-report'),
          ),
          MenuItemData(
            title: 'Custom Report',
            onTap: () => _navigateToPage(4, 'Custom Report', '/custom-report'),
          ),
          MenuItemData(
            title: 'Export Report',
            onTap: () {
              _selectDropdownItem(4, 'Export Report');
              
            },
          ),
        ],
      ),

      
      const AppBarTab(title: AppStrings.tools),
    ];
  }

  
  void _navigateToPage(int tabIndex, String itemTitle, String routeName) {
    setState(() {
      _selectedDropdownItems[tabIndex] = itemTitle;
    });

    widget.onViewAction?.call(routeName);

    
    Navigator.of(context).pushReplacementNamed(routeName);
  }

  
  void _selectDropdownItem(int tabIndex, String itemTitle) {
    setState(() {
      _selectedDropdownItems[tabIndex] = itemTitle;
    });

    
    if (widget.selectedTabIndex != tabIndex) {
      widget.onTabSelected(tabIndex);
    }
  }

  void _onTabSelected(int index) {
    
    if (index == 0) {
      Navigator.of(context).pushReplacementNamed('/market-watch');
    } else if (index == 1) {
      Navigator.of(context).pushReplacementNamed('/dashboard');
    } else if (index == 5) {
      
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
    return CommonAppBar(
      tabs: _tabs,
      selectedIndex: widget.selectedTabIndex,
      onTabSelected: _onTabSelected,
      showReloadIcon: _shouldShowReloadIcon,
      showExportIcon: widget.showExportByDefault,
      onReload: widget.onReload,
      onExportPdf: widget.onExportPdf,
      onExportExcel: widget.onExportExcel,
      selectedDropdownItems: _selectedDropdownItems,
    );
  }
}
