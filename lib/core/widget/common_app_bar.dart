import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_event.dart';
import '../../features/market_watch/data/models/menu_Item_data.dart';
import '../constants/app_colors.dart';
import '../constants/app_images.dart';
import '../constants/app_strings.dart';
import '../../features/market_watch/presentation/widgets/market_status_clock.dart';
import '../../features/market_watch/presentation/widgets/market_watch_ticker_strip.dart';
import 'svg_icon.dart';

class CommonAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String username;
  final String version;
  final int selectedIndex;
  final Function(int)? onTabSelected;
  final List<AppBarTab> tabs;
  final bool showMarketTicker;
  final bool showReloadIcon;
  final bool showExportIcon;
  final VoidCallback? onReload;
  final VoidCallback? onNotificationTap;
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
    this.showMarketTicker = false,
    this.showReloadIcon = false,
    this.showExportIcon = false,
    this.onReload,
    this.onNotificationTap,
    this.onExportPdf,
    this.onExportExcel,
    this.selectedDropdownItems,
    this.userRole,
  }) : super(key: key);
  @override
  Size get preferredSize => Size.fromHeight(showMarketTicker ? 98.h : 64.h);
  @override
  State<CommonAppBar> createState() => _CommonAppBarState();
}

class _CommonAppBarState extends State<CommonAppBar> {
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
      height: widget.showMarketTicker ? 98.h : 64.h,
      decoration: const BoxDecoration(color: AppColors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.showMarketTicker) const MarketWatchTickerStrip(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                children: [
                  _buildLeftSection(),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: _buildMenuBar(),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  _buildRightSection(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeftSection() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildLogo(),
        SizedBox(width: 10.w),
        const MarketStatusClock(),
      ],
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
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 760.w),
      child: Container(
        height: 44.h,
        padding: EdgeInsets.all(3.w),
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
                padding: EdgeInsets.only(right: isLast ? 0 : 4.w),
                child: _buildNavTab(
                  index,
                  widget.tabs[index],
                  isSelected: index == widget.selectedIndex,
                ),
              );
            }),
          ),
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
          constraints: BoxConstraints(minWidth: 82.w),
          padding: EdgeInsets.symmetric(horizontal: 8.w),
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
              fontSize: 10.5.sp,
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
      mainAxisAlignment: MainAxisAlignment.end,
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
          _buildNotificationButton(),
          SizedBox(width: 10.w),
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

  Widget _buildNotificationButton() {
    return GestureDetector(
      onTap: widget.onNotificationTap,
      child: Icon(
        Icons.notifications_none_rounded,
        size: 24.sp,
        color: AppColors.primaryBlue,
      ),
    );
  }

  Widget _buildUserInfoSection(BuildContext context) {
    return Container(
      height: 44.h,
      constraints: BoxConstraints(minWidth: 150.w, maxWidth: 190.w),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.primaryBgColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildUserInitial(),
          SizedBox(width: 6.w),
          Expanded(child: _buildUserDetails()),
          SizedBox(width: 4.w),
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
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
      onTap: () {
        context.read<AuthBloc>().add(const LogoutEvent());
      },
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

class _DropdownMenu extends StatefulWidget {
  final List<MenuItemData> items;
  final VoidCallback onDismiss;
  final String? selectedItem;
  const _DropdownMenu({
    required this.items,
    required this.onDismiss,
    this.selectedItem,
  });
  @override
  State<_DropdownMenu> createState() => _DropdownMenuState();
}

class _DropdownMenuState extends State<_DropdownMenu> {
  int _highlightedIndex = -1;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      setState(() {
        _highlightedIndex = (_highlightedIndex + 1) % widget.items.length;
      });
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      setState(() {
        _highlightedIndex =
            (_highlightedIndex - 1 + widget.items.length) % widget.items.length;
      });
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter) {
      if (_highlightedIndex >= 0 && _highlightedIndex < widget.items.length) {
        widget.onDismiss();
        widget.items[_highlightedIndex].onTap?.call();
      }
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      widget.onDismiss();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: TapRegion(
        onTapOutside: (_) => widget.onDismiss(),
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 220.w,
            constraints: BoxConstraints(maxHeight: 650.h),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.borderColor),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: widget.items
                    .asMap()
                    .entries
                    .map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      return _DropdownMenuItem(
                        title: item.title,
                        isSelected: widget.selectedItem == item.title,
                        isHighlighted: _highlightedIndex == index,
                        onTap: () {
                          widget.onDismiss();
                          item.onTap?.call();
                        },
                        onHover: (hovered) {
                          if (hovered) {
                            setState(() => _highlightedIndex = index);
                          }
                        },
                      );
                    })
                    .toList(growable: false),
              ),
            ),
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
  final bool isHighlighted;
  final ValueChanged<bool>? onHover;
  const _DropdownMenuItem({
    required this.title,
    this.onTap,
    this.isSelected = false,
    this.isHighlighted = false,
    this.onHover,
  });
  @override
  State<_DropdownMenuItem> createState() => _DropdownMenuItemState();
}

class _DropdownMenuItemState extends State<_DropdownMenuItem> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => widget.onHover?.call(true),
      onExit: (_) => widget.onHover?.call(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: EdgeInsets.only(left: 10.w, top: 5.h, bottom: 5.h),
          decoration: widget.isHighlighted
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
