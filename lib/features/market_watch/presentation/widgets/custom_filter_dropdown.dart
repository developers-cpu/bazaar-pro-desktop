import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';


class CustomFilterDropdown extends StatefulWidget {
  final String hintText;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final double? width;
  final double? dropdownHeight;

  const CustomFilterDropdown({
    Key? key,
    required this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
    this.width,
    this.dropdownHeight,
  }) : super(key: key);

  @override
  State<CustomFilterDropdown> createState() => _CustomFilterDropdownState();
}

class _CustomFilterDropdownState extends State<CustomFilterDropdown>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _removeOverlay();
    _controller.dispose();
    super.dispose();
  }

  void _toggle() => _isOpen ? _close() : _open();

  void _open() {
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

  TextStyle get _textStyle => GoogleFonts.openSans(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    height: 1.0,
    letterSpacing: 0.15,
    color: AppColors.primaryBlue,
  );

  OverlayEntry _createOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    // Calculate dropdown height based on items
    final itemHeight = 40.h;
    final maxVisibleItems = 8;
    final visibleItems = widget.items.length > maxVisibleItems
        ? maxVisibleItems
        : widget.items.length;
    final calculatedHeight = widget.dropdownHeight ??
        (visibleItems * itemHeight + 20.h); // 20 for padding

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Dismiss layer
          Positioned.fill(
            child: GestureDetector(
              onTap: _close,
              behavior: HitTestBehavior.opaque,
              child: Container(color: AppColors.transparent),
            ),
          ),
          // Dropdown menu
          Positioned(
            left: offset.dx,
            top: offset.dy + size.height + 5.h,
            width: widget.width ?? 250.w,
            child: FadeTransition(
              opacity: _animation,
              child: Material(
                color: AppColors.transparent,
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: calculatedHeight,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: AppColors.primaryBlue,
                      width: 2.w,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withOpacity(0.1),
                        blurRadius: 8.r,
                        offset: Offset(0, 4.h),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      shrinkWrap: true,
                      itemCount: widget.items.length,
                      itemBuilder: (context, index) {
                        final item = widget.items[index];
                        final isSelected = item == widget.value;

                        return InkWell(
                          onTap: () {
                            widget.onChanged(item);
                            _close();
                          },
                          child: Container(
                            height: itemHeight,
                            padding: EdgeInsets.symmetric(horizontal: 14.w),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryBgColor
                                  : AppColors.transparent,
                            ),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              item,
                              style: _textStyle,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? 250.w,
      child: CompositedTransformTarget(
        link: _layerLink,
        child: GestureDetector(
          onTap: _toggle,
          child: Container(
            height: 45.h,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: AppColors.primaryBlue,
                width: 2.w,
              ),
            ),
            child: Row(
              children: [
                // Text
                Expanded(
                  child: Text(
                    widget.value ?? widget.hintText,
                    style: _textStyle,
                  ),
                ),
                // Dropdown arrow icon
                Icon(
                  _isOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.primaryBlue,
                  size: 24.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}