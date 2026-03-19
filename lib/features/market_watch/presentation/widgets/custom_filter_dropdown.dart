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
    if (_overlayEntry != null) return;
    _overlayEntry = _createOverlay();
    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
    _controller.forward();
    setState(() => _isOpen = true);
  }

  void _close() {
    if (!_isOpen) return;
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
    final itemHeight = 32.h;
    final maxVisibleItems = 8;
    final visibleItems = widget.items.length > maxVisibleItems
        ? maxVisibleItems
        : widget.items.length;
    final calculatedHeight =
        widget.dropdownHeight ?? (visibleItems * itemHeight + 16.h);
    return OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _close,
        child: Stack(
          children: [
            Positioned(
              width: widget.width ?? size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, size.height + 6.h),
                child: FadeTransition(
                  opacity: _animation,
                  child: Material(
                    elevation: 6,
                    borderRadius: BorderRadius.circular(10.r),
                    child: Container(
                      constraints: BoxConstraints(maxHeight: calculatedHeight),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: AppColors.primaryBlue,
                          width: 2.w,
                        ),
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
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
                              color: isSelected
                                  ? AppColors.primaryBgColor
                                  : Colors.transparent,
                              alignment: Alignment.centerLeft,
                              child: Text(item, style: _textStyle),
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
              border: Border.all(color: AppColors.primaryBlue, width: 2.w),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.value ?? widget.hintText,
                    style: _textStyle,
                  ),
                ),
                Icon(
                  _isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
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