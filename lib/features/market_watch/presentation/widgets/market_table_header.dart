import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_images.dart';

/// Reusable table header widget
/// - Fits all columns on screen when space is available
/// - Becomes horizontally scrollable when screen is too small
/// - Uses flutter_screenutil for responsive sizing
class MarketTableHeader extends StatelessWidget {
  final ScrollController? scrollController;

  const MarketTableHeader({
    Key? key,
    this.scrollController,
  }) : super(key: key);

  // ─────────────────────────────────────────────────────────────────
  // FIGMA DESIGN CONSTANTS
  // ─────────────────────────────────────────────────────────────────
  static const Color _headerBgColor = Color(0xFF1F4A66);
  static const Color _borderColor = Color(0xFFFFFFFF);
  static const Color _textColor = Color(0xFF1F4A66);

  // Column titles
  static const List<String> columnTitles = [
    'EXCHANGE',
    'SYMBOL',
    'BUY QTY',
    'BUY PRICE',
    'SELL PRICE',
    'SELL QTY',
    'NET CHANGE',
    'HIGH',
    'LOW',
    'OPEN',
    'CLOSE',
    'LTP',
    'NET CHANGE%',
    'EXPIRY',
    'LUT',
  ];

  // Minimum column widths to ensure readability
  static const List<double> minColumnWidths = [
    100, // EXCHANGE (with icon)
    100, // SYMBOL
    80,  // BUY QTY
    90, // BUY PRICE
    90, // SELL PRICE
    70,  // SELL QTY
    80, // NET CHANGE
    90,  // HIGH
    90,  // LOW
    90,  // OPEN
    90,  // CLOSE
    100, // LTP
    120, // NET CHANGE%
    100, // EXPIRY
    160, // LUT
  ];

  // Calculate total minimum width
  static double get totalMinWidth =>
      minColumnWidths.fold(0.0, (sum, w) => sum + w);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.h,
      decoration: BoxDecoration(
        color: _headerBgColor.withOpacity(0.3),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.r),
          topRight: Radius.circular(10.r),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth;
          final needsScroll = availableWidth < totalMinWidth;

          if (needsScroll) {
            // Screen too small - use fixed widths with scrolling
            return SingleChildScrollView(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: SizedBox(
                width: totalMinWidth,
                child: Row(
                  children: _buildFixedWidthCells(),
                ),
              ),
            );
          } else {
            // Screen large enough - use Expanded to fill space
            return Row(
              children: _buildExpandedCells(),
            );
          }
        },
      ),
    );
  }

  /// Build cells with fixed minimum widths (for scrollable mode)
  List<Widget> _buildFixedWidthCells() {
    return List.generate(columnTitles.length, (index) {
      return _buildHeaderCell(
        columnTitles[index],
        width: minColumnWidths[index],
        isLast: index == columnTitles.length - 1,
      );
    });
  }

  /// Build cells with Expanded (for fit-to-screen mode)
  List<Widget> _buildExpandedCells() {
    return List.generate(columnTitles.length, (index) {
      return Expanded(
        child: _buildHeaderCell(
          columnTitles[index],
          isLast: index == columnTitles.length - 1,
        ),
      );
    });
  }

  /// Build individual header cell
  Widget _buildHeaderCell(
      String title, {
        double? width,
        bool isLast = false,
      }) {
    return Container(
      width: width,
      height: 55.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
      decoration: BoxDecoration(
        border: Border(
          right: isLast
              ? BorderSide.none
              : const BorderSide(color: _borderColor, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.openSans(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                height: 1.0,
                letterSpacing: 0.15,
                color: _textColor,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          SizedBox(width: 4.w),
          _buildSortIcon(),
        ],
      ),
    );
  }

  /// Build sort icon
  Widget _buildSortIcon() {
    return SizedBox(
      width: 14.w,
      height: 14.h,
      child: SvgPicture.asset(
        AppImages.sortIcon,
        width: 14.w,
        height: 14.h,
        colorFilter: const ColorFilter.mode(
          _textColor,
          BlendMode.srcIn,
        ),
        placeholderBuilder: (context) => Icon(
          Icons.unfold_more,
          size: 14.sp,
          color: _textColor,
        ),
      ),
    );
  }
}