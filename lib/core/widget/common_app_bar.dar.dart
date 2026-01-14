import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../features/market_watch/data/models/menu_Item_data.dart';
import '../constants/app_colors.dart';
import '../constants/app_images.dart';
import '../constants/app_strings.dart';
import 'svg_icon.dart';


/// Common AppBar Widget - Reusable across all pages
class CommonAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String username;
  final String version;
  final int selectedIndex;
  final Function(int)? onTabSelected;
  final List<AppBarTab> tabs;
  final bool showReloadIcon;
  final bool showExportButtons;
  final VoidCallback? onReload;
  final VoidCallback? onExportPdf;
  final VoidCallback? onExportExcel;
  final VoidCallback? onCloseExport;

  const CommonAppBar({
    Key? key,
    this.username = AppStrings.defaultUsername,
    this.version = AppStrings.defaultVersion,
    this.selectedIndex = 0,
    this.onTabSelected,
    required this.tabs,
    this.showReloadIcon = false,
    this.showExportButtons = false,
    this.onReload,
    this.onExportPdf,
    this.onExportExcel,
    this.onCloseExport,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(76.h);

  @override
  State<CommonAppBar> createState() => _CommonAppBarState();
}

class _CommonAppBarState extends State<CommonAppBar>
    with SingleTickerProviderStateMixin {
  int? _hoveredDropdownIndex;
  OverlayEntry? _dropdownOverlay;
  final Map<int, GlobalKey> _tabKeys = {};

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
        top: position.dy + size.height + 8.h,
        child: _DropdownMenu(
          items: widget.tabs[index].dropdownItems!,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 76.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: const BoxDecoration(
        color: AppColors.white,
      ),
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
      borderRadius: BorderRadius.circular(12.r),
      child: Image.asset(
        AppImages.appLogo,
        width: 49.w,
        height: 50.h,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 49.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Text(
                AppStrings.logoFallback,
                style: GoogleFonts.openSans(
                  fontSize: 24.sp,
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
      height: 50.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: AppColors.primaryBgColor,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(widget.tabs.length, (index) {
            final isLast = index == widget.tabs.length - 1;
            return Padding(
              padding: EdgeInsets.only(right: isLast ? 0 : 20.w),
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

    return GestureDetector(
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
          setState(() => _hoveredDropdownIndex = null);
          widget.onTabSelected?.call(index);
          tab.onTap?.call();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: isSelected || isDropdownOpen ? 125.w : 100.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: isSelected || isDropdownOpen
              ? AppColors.primaryBlue
              : AppColors.transparent,
          borderRadius: BorderRadius.circular(15.r),
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  tab.title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: GoogleFonts.openSans(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.0,
                    letterSpacing: 0.15,
                    color: isSelected || isDropdownOpen
                        ? AppColors.white
                        : AppColors.textDark,
                  ),
                ),
              ),
            ),
            if (hasDropdown) ...[
              SizedBox(width: 4.w),
              AnimatedRotation(
                turns: isDropdownOpen ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 16.sp,
                  color: isSelected || isDropdownOpen
                      ? AppColors.white
                      : AppColors.textDark,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRightSection(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Export buttons with animation
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: widget.showExportButtons
              ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildExportButtons(),
              SizedBox(width: 15.w),
            ],
          )
              : const SizedBox.shrink(),
        ),
        // Reload button (conditional)
        if (widget.showReloadIcon) ...[
          _buildReloadButton(context),
          SizedBox(width: 15.w),
        ],
        _buildUserInfoSection(context),
      ],
    );
  }

  Widget _buildExportButtons() {
    return Container(
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.primaryBgColor,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // PDF Export Button
          _ExportButton(
            icon: AppImages.pdfIcon,
            label: 'PDF',
            onTap: widget.onExportPdf,
          ),
          Container(
            width: 1,
            height: 30.h,
            margin: EdgeInsets.symmetric(horizontal: 8.w),
            color: AppColors.greyBorder,
          ),
          // Excel Export Button
          _ExportButton(
            icon: AppImages.excelIcon,
            label: 'XLS',
            onTap: widget.onExportExcel,
          ),
          SizedBox(width: 8.w),
          // Close button
          GestureDetector(
            onTap: widget.onCloseExport,
            child: Icon(
              Icons.close,
              size: 20.sp,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReloadButton(BuildContext context) {
    return GestureDetector(
      onTap: widget.onReload,
      child: SvgIcon(
        assetPath: AppImages.reloadIcon,
        isActive: true,
        size: 40.sp,
      ),
    );
  }

  Widget _buildUserInfoSection(BuildContext context) {
    return Container(
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.primaryBgColor,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildUserInitial(),
          SizedBox(width: 8.w),
          _buildUserDetails(),
          SizedBox(width: 4.w),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget _buildUserInitial() {
    return Container(
      width: 30.w,
      height: 30.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.red, width: 1.w),
      ),
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          widget.username.isNotEmpty
              ? widget.username[0].toUpperCase()
              : AppStrings.userInitialFallback,
          style: GoogleFonts.openSans(
            fontSize: 14.sp,
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
          widget.username,
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            height: 1.0,
            letterSpacing: 0.1,
            color: AppColors.primaryBlue,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          widget.version,
          style: GoogleFonts.openSans(
            fontSize: 10.sp,
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
      onTap: () => Navigator.of(context).pushReplacementNamed('/'),
      child: SizedBox(
        width: 36.w,
        height: 36.h,
        child: Center(
          child: SvgIcon(
            assetPath: AppImages.logoutIcon,
            isActive: true,
            size: 24.sp,
          ),
        ),
      ),
    );
  }
}

/// Export button widget
class _ExportButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback? onTap;

  const _ExportButton({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        child: Image.asset(
          icon,
          width: 32.w,
          height: 32.h,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: label == 'PDF'
                    ? const Color(0xFFFF6B6B)
                    : const Color(0xFF4CAF50),
                borderRadius: BorderRadius.circular(4.r),
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

/// Dropdown menu widget
class _DropdownMenu extends StatelessWidget {
  final List<MenuItemData> items;
  final VoidCallback onDismiss;

  const _DropdownMenu({
    required this.items,
    required this.onDismiss,
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
          constraints: BoxConstraints(
            minWidth: 180.w,
            maxWidth: 250.w,
          ),
          padding: EdgeInsets.symmetric(vertical: 8.h),
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
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _DropdownMenuItem(
                    title: item.title,
                    onTap: () {
                      onDismiss();
                      item.onTap?.call();
                    },
                  ),
                  if (item.hasDivider)
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.greyBorder,
                      indent: 16.w,
                      endIndent: 16.w,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

/// Dropdown menu item widget
class _DropdownMenuItem extends StatefulWidget {
  final String title;
  final VoidCallback? onTap;

  const _DropdownMenuItem({
    required this.title,
    this.onTap,
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
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          color: _isHovered ? AppColors.primaryBgColor : AppColors.transparent,
          child: Text(
            widget.title,
            style: GoogleFonts.openSans(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textDark,
            ),
          ),
        ),
      ),
    );
  }
}