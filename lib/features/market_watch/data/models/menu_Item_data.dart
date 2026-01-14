import 'dart:ui';

/// Menu item model for dropdown options
class MenuItemData {
  final String title;
  final VoidCallback? onTap;
  final bool hasDivider;

  const MenuItemData({
    required this.title,
    this.onTap,
    this.hasDivider = false,
  });
}

/// Tab configuration for AppBar
class AppBarTab {
  final String title;
  final List<MenuItemData>? dropdownItems;
  final VoidCallback? onTap;

  const AppBarTab({
    required this.title,
    this.dropdownItems,
    this.onTap,
  });

  bool get hasDropdown => dropdownItems != null && dropdownItems!.isNotEmpty;
}
