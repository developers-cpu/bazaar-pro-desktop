import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_images.dart';
import '../bloc/market_watch_bloc.dart';
import '../bloc/market_watch_event.dart';

class MarketWatchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String username;
  final String version;
  final int selectedIndex;
  final Function(int)? onTabSelected;

  const MarketWatchAppBar({
    Key? key,
    this.username = 'DEMO02',
    this.version = 'v1.1.0.0',
    this.selectedIndex = 0,
    this.onTabSelected,
  }) : super(key: key);

  // ─────────────────────────────────────────────────────────────────
  // FIGMA DESIGN CONSTANTS
  // ─────────────────────────────────────────────────────────────────
  static const Color _primaryColor = Color(0xFF1F4A66);
  static const Color _primaryBgColor = Color(0x0D1F4A66);
  static const Color _textDark = Color(0xFF131313);
  static const Color _redColor = Color(0xFFFF0000);
  static const Color _white = Colors.white;

  @override
  Size get preferredSize => Size.fromHeight(76.h);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 76.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: _white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          _buildLogo(),

          // Menu Bar - Flexible to prevent overflow
          Flexible(
            child: _buildMenuBar(),
          ),

          // Right Section: Reload + User Info
          _buildRightSection(context),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // LOGO - 49x50, border-radius: 12px
  // ─────────────────────────────────────────────────────────────────
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
              color: _primaryColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Text(
                'B',
                style: GoogleFonts.openSans(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: _white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // MENU BAR - 741x55, border-radius: 15px, background: #1F4A660D
  // ─────────────────────────────────────────────────────────────────
  Widget _buildMenuBar() {
    final menuItems = [
      'Market Watch',
      'Dashboard',
      'File',
      'View',
      'Report',
      'Tools',
    ];

    return Container(
      height: 50.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: _primaryBgColor,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(menuItems.length, (index) {
            final isLast = index == menuItems.length - 1;
            return Padding(
              padding: EdgeInsets.only(right: isLast ? 0 : 20.w),
              child: _buildNavTab(
                menuItems[index],
                isSelected: index == selectedIndex,
                onTap: () => onTabSelected?.call(index),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // MENU TAB ITEM
  // Selected: 131x45, background: #1F4A66, text: #FFFFFF
  // Unselected: 100x45, text: #131313
  // ─────────────────────────────────────────────────────────────────
  Widget _buildNavTab(String title, {required bool isSelected, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: isSelected ? 125.w : 110.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: isSelected ? _primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(15.r),
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: GoogleFonts.openSans(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              height: 1.0,
              letterSpacing: 0.15,
              color: isSelected ? _white : _textDark,
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // RIGHT SECTION: Reload Button + User Info with Logout
  // ─────────────────────────────────────────────────────────────────
  Widget _buildRightSection(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Reload Button - 48x48, border-width: 2px
        _buildReloadButton(context),

        SizedBox(width: 15.w),

        // User Info Section - 162x56
        _buildUserInfoSection(context),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // RELOAD BUTTON - 48x48 with 2px border, circular
  // ─────────────────────────────────────────────────────────────────
  Widget _buildReloadButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<MarketWatchBloc>().add(const LoadMarketItemsEvent());
      },
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: _white,
          shape: BoxShape.circle,
          border: Border.all(
            color: _primaryColor,
            width: 2.w,
          ),
        ),
        child: Center(
          child: _buildSvgIcon(
            AppImages.appLogo,
            fallbackIcon: Icons.refresh,
            size: 22.sp,
            color: _primaryColor,
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // USER INFO SECTION - 162x56, border-radius: 15px, background: #1F4A660D
  // ─────────────────────────────────────────────────────────────────
  Widget _buildUserInfoSection(BuildContext context) {
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: _primaryBgColor,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // User Initial with red border
          _buildUserInitial(),

          SizedBox(width: 8.w),

          // Username and Version
          _buildUserDetails(),

          SizedBox(width: 4.w),

          // Logout Button
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // USER INITIAL - Circle with red border
  // Font: Open Sans, SemiBold 600, 14.77px, letter-spacing: 0.46px
  // Color: #FF0000, Border: 0.92px solid #FF0000
  // ─────────────────────────────────────────────────────────────────
  Widget _buildUserInitial() {
    return Container(
      width: 30.w,
      height: 30.h,
      padding: EdgeInsets.fromLTRB(3.w, 2.h, 3.w, 2.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: _redColor,
          width: 0.92.w,
        ),
      ),
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          username.isNotEmpty ? username[0].toUpperCase() : 'U',
          style: GoogleFonts.openSans(
            fontSize: 14.77.sp,
            fontWeight: FontWeight.w600,
            height: 1.0,
            letterSpacing: 0.46,
            color: _redColor,
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // USER DETAILS - Username and Version
  // Username: Bold 700, 14px, letter-spacing: 0.1px, color: #1F4A66
  // Version: SemiBold 600, 11px, letter-spacing: 0.5px, color: #1F4A66
  // ─────────────────────────────────────────────────────────────────
  Widget _buildUserDetails() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Username - Bold 700, 14px
        Text(
          username,
          style: GoogleFonts.openSans(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            height: 1.0,
            letterSpacing: 0.1,
            color: _primaryColor,
          ),
        ),
        SizedBox(height: 4.h),
        // Version - SemiBold 600, 11px
        Text(
          version,
          style: GoogleFonts.openSans(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            height: 1.0,
            letterSpacing: 0.5,
            color: _primaryColor,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // LOGOUT BUTTON with SVG icon
  // ─────────────────────────────────────────────────────────────────
  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacementNamed('/');
      },
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: _buildSvgIcon(
            AppImages.logoutIcon,
            fallbackIcon: Icons.logout,
            size: 30.sp,
            color: _redColor,
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // HELPER: SVG Icon with Material Icon fallback
  // ─────────────────────────────────────────────────────────────────
  Widget _buildSvgIcon(
      String svgPath, {
        required IconData fallbackIcon,
        required double size,
        required Color color,
      }) {
    return SvgPicture.asset(
      svgPath,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      placeholderBuilder: (context) => Icon(
        fallbackIcon,
        size: size,
        color: color,
      ),
    );
  }
}