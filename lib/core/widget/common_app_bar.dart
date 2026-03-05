import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../features/market_watch/data/models/menu_Item_data.dart';
import '../constants/app_colors.dart';
import '../constants/app_images.dart';
import '../constants/app_strings.dart';
import 'svg_icon.dart';
import '../routes/app_routes.dart';

class CommonAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String username;
  final String version;
  final int selectedIndex;
  final Function(int)? onTabSelected;
  final List<AppBarTab> tabs;
  final bool showReloadIcon;
  final bool showExportIcon;
  final VoidCallback? onReload;
  final VoidCallback? onExportPdf;
  final VoidCallback? onExportExcel;
  final Map<int, String>? selectedDropdownItems;
  final String? userRole;
  const CommonAppBar({
    Key? key,
    this.username = AppStrings.defaultUsername,
    this.version = AppStrings.defaultVersion,
    this.selectedIndex = 0,
    this.onTabSelected,
    required this.tabs,
    this.showReloadIcon = false,
    this.showExportIcon = false,
    this.onReload,
    this.onExportPdf,
    this.onExportExcel,
    this.selectedDropdownItems,
    this.userRole,
  }) : super(key: key);
  @override
  Size get preferredSize => Size.fromHeight(64.h);
  @override
  State<CommonAppBar> createState() => _CommonAppBarState();
}

class _CommonAppBarState extends State<CommonAppBar>
    with SingleTickerProviderStateMixin {
  int? _hoveredDropdownIndex;
  int? _hoveredTabIndex;
  OverlayEntry? _dropdownOverlay;
  final Map<int, GlobalKey> _tabKeys = {};
  bool _isExportExpanded = false;
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.tabs.length; i++) {
      _tabKeys[i] = GlobalKey();
    }
  }

  @override
  void didUpdateWidget(CommonAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tabs.length != oldWidget.tabs.length) {
      _tabKeys.clear();
      for (int i = 0; i < widget.tabs.length; i++) {
        _tabKeys[i] = GlobalKey();
      }
    }
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _isExportExpanded = false;
    }
  }

  @override
  void dispose() {
    _removeDropdown();
    super.dispose();
  }

  void _removeDropdown() {
    _dropdownOverlay?.remove();
    _dropdownOverlay = null;
  }

  void _showDropdown(int index) {
    if (!widget.tabs[index].hasDropdown) return;
    _removeDropdown();
    final RenderBox? renderBox =
        _tabKeys[index]?.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    _dropdownOverlay = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx,
        top: position.dy + size.height + 6.h,
        child: _DropdownMenu(
          items: widget.tabs[index].dropdownItems!,
          selectedItem: widget.selectedDropdownItems?[index],
          onDismiss: () {
            _removeDropdown();
            setState(() => _hoveredDropdownIndex = null);
          },
        ),
      ),
    );
    Overlay.of(context).insert(_dropdownOverlay!);
    setState(() => _hoveredDropdownIndex = index);
  }

  void _toggleExportButtons() {
    setState(() {
      _isExportExpanded = !_isExportExpanded;
    });
  }

  void _closeExportButtons() {
    setState(() {
      _isExportExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 64.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: const BoxDecoration(color: AppColors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildLogo(),
          Flexible(child: _buildMenuBar()),
          _buildRightSection(context),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: Image.asset(
        AppImages.appLogo,
        width: 42.w,
        height: 42.h,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 42.w,
            height: 42.h,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: Text(
                AppStrings.logoFallback,
                style: GoogleFonts.openSans(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuBar() {
    return Container(
      height: 44.h,
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.primaryBgColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(widget.tabs.length, (index) {
            final isLast = index == widget.tabs.length - 1;
            return Padding(
              padding: EdgeInsets.only(right: isLast ? 0 : 6.w),
              child: _buildNavTab(
                index,
                widget.tabs[index],
                isSelected: index == widget.selectedIndex,
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildNavTab(int index, AppBarTab tab, {required bool isSelected}) {
    final hasDropdown = tab.hasDropdown;
    final isDropdownOpen = _hoveredDropdownIndex == index;
    String displayTitle = tab.title;
    if (widget.selectedDropdownItems != null &&
        widget.selectedDropdownItems!.containsKey(index)) {
      displayTitle = widget.selectedDropdownItems![index]!;
    }
    final isActive =
        isSelected ||
        (hasDropdown &&
            widget.selectedDropdownItems?.containsKey(index) == true);
    final isHoveredOrOpen = isDropdownOpen || _hoveredTabIndex == index;
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredTabIndex = index),
      onExit: (_) => setState(() => _hoveredTabIndex = null),
      child: GestureDetector(
        key: _tabKeys[index],
        onTap: () {
          if (hasDropdown) {
            if (isDropdownOpen) {
              _removeDropdown();
              setState(() => _hoveredDropdownIndex = null);
            } else {
              _showDropdown(index);
            }
          } else {
            _removeDropdown();
            setState(() {
              _hoveredDropdownIndex = null;
              _hoveredTabIndex = null;
            });
            widget.onTabSelected?.call(index);
            tab.onTap?.call();
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          constraints: BoxConstraints(minWidth: 100.w),
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: isActive
              ? BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(12.r),
                )
              : isHoveredOrOpen
              ? BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryBlue.withOpacity(0.0),
                      AppColors.primaryBlue.withOpacity(0.5),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(4.r),
                )
              : BoxDecoration(
                  color: AppColors.transparent,
                  borderRadius: BorderRadius.circular(12.r),
                ),
          alignment: Alignment.center,
          child: Text(
            displayTitle,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.openSans(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              height: 1.0,
              letterSpacing: 0.15,
              color: isActive ? AppColors.white : AppColors.textDark,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRightSection(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showExportIcon) ...[
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _isExportExpanded
                ? _buildExpandedExportButtons()
                : _buildCollapsedExportButton(),
          ),
          SizedBox(width: 10.w),
        ],
        if (widget.showReloadIcon) ...[
          _buildReloadButton(context),
          SizedBox(width: 10.w),
        ],
        _buildUserInfoSection(context),
      ],
    );
  }

  Widget _buildCollapsedExportButton() {
    return GestureDetector(
      onTap: _toggleExportButtons,
      child: Container(
        width: 45.w,
        height: 45.h,
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1F4A66),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Center(
          child: SvgIcon(
            assetPath: AppImages.fileExportIcon,
            isActive: true,
            size: 35.sp,
            activeColor: AppColors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedExportButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 45.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F4FA),
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ExportButton(
                icon: AppImages.pdfIcon,
                label: 'PDF',
                onTap: () {
                  widget.onExportPdf?.call();
                  _closeExportButtons();
                },
              ),
              Container(
                width: 2.w,
                height: 35.h,
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                color: Color(0xFF1F4A66),
              ),
              _ExportButton(
                icon: AppImages.excelIcon,
                label: 'XLS',
                onTap: () {
                  widget.onExportExcel?.call();
                  _closeExportButtons();
                },
              ),
            ],
          ),
        ),
        SizedBox(width: 10.w),
        GestureDetector(
          onTap: _closeExportButtons,
          child: Container(
            width: 45.w,
            height: 45.h,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F4FA),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Center(
              child: Icon(
                Icons.close,
                size: 24.sp,
                color: const Color(0xFF1F4A66),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReloadButton(BuildContext context) {
    return GestureDetector(
      onTap: widget.onReload,
      child: SvgIcon(
        assetPath: AppImages.reloadIcon,
        isActive: true,
        size: 36.sp,
      ),
    );
  }

  Widget _buildUserInfoSection(BuildContext context) {
    return Container(
      height: 44.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.primaryBgColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildUserInitial(),
          SizedBox(width: 6.w),
          _buildUserDetails(),
          SizedBox(width: 3.w),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget _buildUserInitial() {
    String badgeInitial = AppStrings.userInitialFallback;
    if (widget.userRole != null && widget.userRole!.isNotEmpty) {
      if (widget.userRole == 'Super Admin') {
        badgeInitial = 'SA';
      } else {
        badgeInitial = widget.userRole![0].toUpperCase();
      }
    }

    return Container(
      width: 26.w,
      height: 26.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.red, width: 1.w),
      ),
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          badgeInitial,
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            height: 1.0,
            letterSpacing: 0.46,
            color: AppColors.red,
          ),
        ),
      ),
    );
  }

  Widget _buildUserDetails() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.username.toUpperCase(),
          style: GoogleFonts.openSans(
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            height: 1.0,
            letterSpacing: 0.1,
            color: AppColors.primaryBlue,
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          widget.version,
          style: GoogleFonts.openSans(
            fontSize: 9.sp,
            fontWeight: FontWeight.w600,
            height: 1.0,
            letterSpacing: 0.5,
            color: AppColors.primaryBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false),
      child: SizedBox(
        width: 32.w,
        height: 32.h,
        child: Center(
          child: SvgIcon(
            assetPath: AppImages.logoutIcon,
            isActive: true,
            size: 22.sp,
          ),
        ),
      ),
    );
  }
}

class _ExportButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback? onTap;
  const _ExportButton({required this.icon, required this.label, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Image.asset(
          icon,
          width: 35.w,
          height: 35.h,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 35.w,
              height: 35.h,
              decoration: BoxDecoration(
                color: label == 'PDF'
                    ? const Color(0xFFFF6B6B)
                    : const Color(0xFF4CAF50),
                borderRadius: BorderRadius.circular(8.r),
              ),
              alignment: Alignment.center,
              child: Text(
                label,
                style: GoogleFonts.openSans(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DropdownMenu extends StatelessWidget {
  final List<MenuItemData> items;
  final VoidCallback onDismiss;
  final String? selectedItem;
  const _DropdownMenu({
    required this.items,
    required this.onDismiss,
    this.selectedItem,
  });
  @override
  Widget build(BuildContext context) {
    return TapRegion(
      onTapOutside: (_) => onDismiss(),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12.r),
        color: AppColors.white,
        child: Container(
          constraints: BoxConstraints(minWidth: 130.w, maxWidth: 200.w),
          padding: EdgeInsets.symmetric(vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: items.map((item) {
              final isSelected = selectedItem == item.title;
              return _DropdownMenuItem(
                title: item.title,
                isSelected: isSelected,
                onTap: () {
                  onDismiss();
                  item.onTap?.call();
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _DropdownMenuItem extends StatefulWidget {
  final String title;
  final VoidCallback? onTap;
  final bool isSelected;
  const _DropdownMenuItem({
    required this.title,
    this.onTap,
    this.isSelected = false,
  });
  @override
  State<_DropdownMenuItem> createState() => _DropdownMenuItemState();
}

class _DropdownMenuItemState extends State<_DropdownMenuItem> {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: EdgeInsets.only(left: 10.w, top: 5.h, bottom: 5.h),
          decoration: BoxDecoration(
            color: AppColors.transparent,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: GoogleFonts.openSans(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
