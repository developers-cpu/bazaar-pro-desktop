import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';

class AppTimePicker extends StatefulWidget {
  final String label;
  final String? value; 
  final ValueChanged<String> onChanged;
  final double? width;
  final double? height;

  const AppTimePicker({
    super.key,
    required this.label,
    this.value,
    required this.onChanged,
    this.width,
    this.height,
  });

  @override
  State<AppTimePicker> createState() => _AppTimePickerState();
}

class _AppTimePickerState extends State<AppTimePicker> with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  final LayerLink _layerLink = LayerLink();
  late AnimationController _controller;
  late Animation<double> _animation;

  int _selectedHour = 9;
  int _selectedMinute = 0;
  String _selectedPeriod = 'AM';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _parseInitialValue();
  }

  void _parseInitialValue() {
    if (widget.value != null && widget.value!.isNotEmpty) {
      try {
        final dt = DateFormat('hh:mm a').parse(widget.value!);
        _selectedHour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
        _selectedMinute = dt.minute;
        _selectedPeriod = dt.hour >= 12 ? 'PM' : 'AM';
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    _controller.dispose();
    super.dispose();
  }

  void _toggle() => _isOpen ? _close() : _open();

  void _open() {
    _parseInitialValue();
    _overlayEntry = _createOverlay();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
    _controller.forward();
  }

  void _close() {
    _controller.reverse().then((_) {
      _removeOverlay();
      if (mounted) setState(() => _isOpen = false);
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
  }

  void _onTimeChanged() {
    final hour = _selectedPeriod == 'PM' 
        ? (_selectedHour == 12 ? 12 : _selectedHour + 12) 
        : (_selectedHour == 12 ? 0 : _selectedHour);
    
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, hour, _selectedMinute);
    final formatted = DateFormat('hh:mm a').format(dt);
    widget.onChanged(formatted);
  }

  OverlayEntry _createOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: _close,
                behavior: HitTestBehavior.opaque,
                child: Container(color: Colors.transparent),
              ),
            ),
            Positioned(
              left: offset.dx,
              top: offset.dy + size.height + 3.h,
              child: FadeTransition(
                opacity: _animation,
                child: Material(
                  color: Colors.transparent,
                  child: StatefulBuilder(
                    builder: (ctx, setOverlayState) {
                      return _buildPicker(setOverlayState);
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPicker(StateSetter setOverlayState) {
    return Container(
      width: 220.w,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.12),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildColumn('Hour', List.generate(12, (i) => i + 1), _selectedHour, (val) {
                setOverlayState(() => _selectedHour = val);
                _onTimeChanged();
                _overlayEntry?.markNeedsBuild();
              }),
              _buildColumn('Min', List.generate(12, (i) => i * 5), _selectedMinute, (val) {
                setOverlayState(() => _selectedMinute = val);
                _onTimeChanged();
                _overlayEntry?.markNeedsBuild();
              }),
              _buildColumn('Period', ['AM', 'PM'], _selectedPeriod, (val) {
                setOverlayState(() => _selectedPeriod = val);
                _onTimeChanged();
                _overlayEntry?.markNeedsBuild();
              }),
            ],
          ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: _close,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: Text(
                  'Done',
                  style: GoogleFonts.openSans(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumn(String label, List items, dynamic selectedValue, ValueChanged onChanged) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.openSans(
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryBlue.withOpacity(0.5),
          ),
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: 150.h,
          width: 55.w,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final isSelected = item == selectedValue;
              final display = item is int ? item.toString().padLeft(2, '0') : item.toString();

              return GestureDetector(
                onTap: () => onChanged(item),
                child: Container(
                  height: 30.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryBlue : Colors.transparent,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    display,
                    style: GoogleFonts.openSans(
                      fontSize: 12.sp,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? AppColors.white : AppColors.primaryBlue,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label.isNotEmpty) ...[
          Text(
            widget.label,
            style: GoogleFonts.openSans(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlue,
            ),
          ),
          SizedBox(height: 5.h),
        ],
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: _toggle,
            child: Container(
              width: widget.width ?? 180.w,
              height: widget.height ?? 35.h,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: AppColors.primaryBlue, width: 1.4),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.value ?? 'Select Time',
                      style: GoogleFonts.openSans(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.access_time,
                    size: 16.sp,
                    color: AppColors.primaryBlue,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
