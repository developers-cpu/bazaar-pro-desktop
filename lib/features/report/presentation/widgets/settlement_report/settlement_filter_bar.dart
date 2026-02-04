import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/date_range_picker_dialog.dart';
class SettlementFilterBar extends StatefulWidget {
  final String selectedDateRange;
  final ValueChanged<String?> onDateRangeChanged;
  final VoidCallback onReset;
  final VoidCallback onView;
  const SettlementFilterBar({
    super.key,
    required this.selectedDateRange,
    required this.onDateRangeChanged,
    required this.onReset,
    required this.onView,
  });
  @override
  State<SettlementFilterBar> createState() => _SettlementFilterBarState();
}
class _SettlementFilterBarState extends State<SettlementFilterBar> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  late String _thisWeekSubtitle;
  late String _prevWeekSubtitle;
  String _customPeriodSubtitle = 'Select Date Range';
  @override
  void initState() {
    super.initState();
    _calculateDateRanges();
  }
  void _calculateDateRanges() {
    final now = DateTime.now();
    final dateFormat = DateFormat('dd-MM-yy');
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final sunday = monday.add(const Duration(days: 6));
    _thisWeekSubtitle =
        '${dateFormat.format(monday)} to ${dateFormat.format(sunday)}';
    final prevMonday = monday.subtract(const Duration(days: 7));
    final prevSunday = prevMonday.add(const Duration(days: 6));
    _prevWeekSubtitle =
        '${dateFormat.format(prevMonday)} to ${dateFormat.format(prevSunday)}';
  }
  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }
  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }
  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isOpen = true;
    });
  }
  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isOpen = false;
    });
  }
  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
  Future<void> _handleCustomDateSelection() async {
    _closeDropdown(); 
    final result = await CustomDateRangePickerDialog.show(
      context,
      initialStartDate: DateTime.now(), 
    );
    if (result != null) {
      final dateFormat = DateFormat('dd-MM-yy');
      final formattedRange =
          '${dateFormat.format(result.start)} to ${dateFormat.format(result.end)}';
      setState(() {
        _customPeriodSubtitle = formattedRange;
      });
      widget.onDateRangeChanged('Custom Period');
    }
  }
  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _closeDropdown,
              behavior: HitTestBehavior.opaque,
              child: Container(color: Colors.transparent),
            ),
          ),
          CompositedTransformFollower(
            link: _layerLink,
            offset: Offset(0, 45.h), 
            showWhenUnlinked: false,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8.r),
              color: Colors.white,
              child: Container(
                width: 200.w, 
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primaryBlue),
                  borderRadius: BorderRadius.circular(8.r),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDropdownItem(
                      title: 'This Week',
                      subtitle: _thisWeekSubtitle,
                      isSelected: widget.selectedDateRange == 'This Week',
                      onTap: () {
                        widget.onDateRangeChanged('This Week');
                        _closeDropdown();
                      },
                    ),
                    _buildDropdownItem(
                      title: 'Previous Week',
                      subtitle: _prevWeekSubtitle,
                      isSelected: widget.selectedDateRange == 'Previous Week',
                      onTap: () {
                        widget.onDateRangeChanged('Previous Week');
                        _closeDropdown();
                      },
                    ),
                    _buildCustomPeriodItem(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildDropdownItem({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryBlue.withOpacity(0.1)
              : Colors.transparent,
          border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        ),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.openSans(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor, 
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: GoogleFonts.openSans(
                fontSize: 12.sp,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildCustomPeriodItem() {
    final isSelected = widget.selectedDateRange == 'Custom Period';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primaryBlue.withOpacity(0.1)
            : Colors.transparent,
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Custom Period',
            style: GoogleFonts.openSans(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTextColor,
            ),
          ),
          SizedBox(height: 4.h),
          InkWell(
            onTap: _handleCustomDateSelection,
            child: Text(
              _customPeriodSubtitle,
              style: GoogleFonts.openSans(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F4A66),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          CompositedTransformTarget(
            link: _layerLink,
            child: InkWell(
              onTap: _toggleDropdown,
              borderRadius: BorderRadius.circular(8.r),
              child: Container(
                width: 200.w,
                height: 40.h,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primaryBlue, width: 2),
                  borderRadius: BorderRadius.circular(8.r),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.selectedDateRange,
                      style: GoogleFonts.openSans(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.billTableHeaderText,
                      ),
                    ),
                    Icon(
                      _isOpen
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: AppColors.billTableHeaderText,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            height: 40.h,
            width: 100.w,
            child: OutlinedButton(
              onPressed: widget.onReset,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primaryBlue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.zero,
              ),
              child: Text(
                'Reset',
                style: GoogleFonts.openSans(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          SizedBox(
            height: 40.h,
            width: 100.w,
            child: ElevatedButton(
              onPressed: widget.onView,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1F4A66),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.zero,
              ),
              child: Text(
                'View',
                style: GoogleFonts.openSans(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
