import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_strings.dart';
import '../bloc/market_watch_bloc.dart';
import '../bloc/market_watch_event.dart';

class MarketWatchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String username;
  final String version;
  final int selectedIndex;
  final Function(int)? onTabSelected;

  const MarketWatchAppBar({
    Key? key,
    this.username = AppStrings.defaultUsername,
    this.version = AppStrings.defaultVersion,
    this.selectedIndex = 0,
    this.onTabSelected,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(76.h);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 76.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: const BoxDecoration(
        color: AppColors.white,
        // No shadow - seamless with filter section
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

  // ─────────────────────────────────────────────────────────────────
  // MENU BAR - 741x55, border-radius: 15px, background: #1F4A660D
  // ─────────────────────────────────────────────────────────────────
  Widget _buildMenuBar() {
    final menuItems = [
      AppStrings.marketWatch,
      AppStrings.dashboard,
      AppStrings.file,
      AppStrings.view,
      AppStrings.report,
      AppStrings.tools,
    ];

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

  Widget _buildNavTab(String title,
      {required bool isSelected, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: isSelected ? 125.w : 100.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : AppColors.transparent,
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
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              height: 1.0,
              letterSpacing: 0.15,
              color: isSelected ? AppColors.white : AppColors.textDark,
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
          color: AppColors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primaryBlue,
            width: 2.w,
          ),
        ),
        child: Center(
          child: _buildSvgIcon(
            AppImages.reloadIcon,
            fallbackIcon: Icons.refresh,
            size: 22.sp,
            color: AppColors.primaryBlue,
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
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.primaryBgColor,
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
  // ─────────────────────────────────────────────────────────────────
  Widget _buildUserInitial() {
    return Container(
      width: 30.w,
      height: 30.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: AppColors.red,
          width: 1.w,
        ),
      ),
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          username.isNotEmpty
              ? username[0].toUpperCase()
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

  // ─────────────────────────────────────────────────────────────────
  // USER DETAILS - Username and Version
  // ─────────────────────────────────────────────────────────────────
  Widget _buildUserDetails() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          username,
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
          version,
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

  // ─────────────────────────────────────────────────────────────────
  // LOGOUT BUTTON with SVG icon
  // ─────────────────────────────────────────────────────────────────
  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacementNamed('/');
      },
      child: SizedBox(
        width: 36.w,
        height: 36.h,
        child: Center(
          child: _buildSvgIcon(
            AppImages.logoutIcon,
            fallbackIcon: Icons.logout,
            size: 24.sp,
            color: AppColors.red,
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