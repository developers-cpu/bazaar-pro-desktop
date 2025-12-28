import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WatchlistWidget extends StatefulWidget {
  final Function(int)? onWatchlistSelected;

  const WatchlistWidget({
    Key? key,
    this.onWatchlistSelected,
  }) : super(key: key);

  @override
  State<WatchlistWidget> createState() => _WatchlistWidgetState();
}

class _WatchlistWidgetState extends State<WatchlistWidget> {
  List<String> _watchlists = ['Watchlist 1', 'Watchlist 2', 'Watchlist 3'];
  int _selectedWatchlistIndex = -1; // -1 means "All" is selected

  /// Add new watchlist
  void _addWatchlist() {
    setState(() {
      int nextNumber = _watchlists.length + 1;
      _watchlists.add('Watchlist $nextNumber');
    });
  }

  /// Remove watchlist
  void _removeWatchlist(int index) {
    if (_watchlists.length > 1) {
      setState(() {
        _watchlists.removeAt(index);
        if (_selectedWatchlistIndex == index) {
          _selectedWatchlistIndex = -1; // Reset to "All"
          widget.onWatchlistSelected?.call(-1);
        } else if (_selectedWatchlistIndex > index) {
          _selectedWatchlistIndex--;
        }
      });
    } else {
      // Show message that at least one watchlist is required
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'At least one watchlist is required',
            style: TextStyle(fontSize: 14.sp),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /// Select watchlist
  void _selectWatchlist(int index) {
    setState(() {
      _selectedWatchlistIndex = index;
    });
    widget.onWatchlistSelected?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: Colors.white,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // Add Button - Always first
          _buildAddButton(),
          SizedBox(width: 10.w),

          // All Button
          _buildWatchlistButton(
            label: 'All',
            index: -1,
            isSelected: _selectedWatchlistIndex == -1,
            showCloseIcon: false,
          ),
          SizedBox(width: 10.w),

          // Watchlist Buttons
          ...List.generate(_watchlists.length, (index) {
            return Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: _buildWatchlistButton(
                label: _watchlists[index],
                index: index,
                isSelected: _selectedWatchlistIndex == index,
                showCloseIcon: true,
              ),
            );
          }),
        ],
      ),
    );
  }

  /// Build Add Button
  Widget _buildAddButton() {
    return InkWell(
      onTap: _addWatchlist,
      borderRadius: BorderRadius.circular(15.r),
      child: Container(
        width: 135.w,
        height: 42.h,
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1F4A66),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // + Icon with Circular Border
            Container(
              width: 18.w,
              height: 18.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 1.2.w,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.add,
                  size: 14.sp,
                  color: Colors.white,
                ),
              ),
            ),

            SizedBox(width: 8.w),

            Text(
              'Add',
              style: TextStyle(
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                color: Colors.white,
                letterSpacing: 0.15,
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build Watchlist Button
  Widget _buildWatchlistButton({
    required String label,
    required int index,
    required bool isSelected,
    required bool showCloseIcon,
  }) {
    return InkWell(
      onTap: () => _selectWatchlist(index),
      borderRadius: BorderRadius.circular(15.r),
      child: Container(
        width: 135.w,
        height: 42.h,
        padding: EdgeInsets.only(
          top: 10.h,
          bottom: 10.h,
          left: 10.w,
          right: showCloseIcon ? 5.w : 10.w,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: const Color(0xFF1F4A66),
            width: isSelected ? 1.5.w : 1.w,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  color: const Color(0xFF1F4A66),
                  letterSpacing: 0.15,
                  height: 1.0,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (showCloseIcon) ...[
              SizedBox(width: 4.w),
              InkWell(
                onTap: () => _removeWatchlist(index),
                borderRadius: BorderRadius.circular(9.r),
                child: Container(
                  width: 18.w,
                  height: 18.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF1F4A66),
                      width: 1.w,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.close,
                      size: 12.sp,
                      color: const Color(0xFF1F4A66),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

