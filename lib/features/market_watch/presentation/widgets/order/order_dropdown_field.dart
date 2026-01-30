import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';


class OrderDropdownField extends StatefulWidget {
  final String label;
  final String? value;
  final String hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final Color? labelColor;
  final Color? borderColor;
  final bool isDarkMode;

  const OrderDropdownField({
    Key? key,
    required this.label,
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.labelColor,
    this.borderColor,
    this.isDarkMode = false,
  }) : super(key: key);

  @override
  State<OrderDropdownField> createState() => _OrderDropdownFieldState();
}

class _OrderDropdownFieldState extends State<OrderDropdownField>
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

  Color get _borderColor => widget.borderColor ?? LightThemeColors.primaryColor;

  Color get _textColor => widget.isDarkMode
      ? DarkThemeColors.textColor
      : LightThemeColors.textColor;

  Color get _hintColor => widget.isDarkMode
      ? DarkThemeColors.supportiveTextColor
      : LightThemeColors.supportiveTextColor;

  Color get _dropdownBgColor => widget.isDarkMode
      ? DarkThemeColors.cardBackground
      : LightThemeColors.cardBackground;

  OverlayEntry _createOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    final itemHeight = 40.h;
    final maxVisibleItems = 6;
    final visibleItems = widget.items.length > maxVisibleItems
        ? maxVisibleItems
        : widget.items.length;
    final calculatedHeight = visibleItems * itemHeight + 20.h;

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          
          Positioned.fill(
            child: GestureDetector(
              onTap: _close,
              behavior: HitTestBehavior.opaque,
              child: Container(color: AppColors.transparent),
            ),
          ),
          
          Positioned(
            left: offset.dx,
            top: offset.dy + size.height + 5.h,
            width: size.width,
            child: FadeTransition(
              opacity: _animation,
              child: Material(
                color: AppColors.transparent,
                child: Container(
                  constraints: BoxConstraints(maxHeight: calculatedHeight),
                  decoration: BoxDecoration(
                    color: _dropdownBgColor,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: _borderColor, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withOpacity(0.15),
                        blurRadius: 10.r,
                        offset: Offset(0, 4.h),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
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
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? _borderColor.withOpacity(0.1)
                                  : AppColors.transparent,
                            ),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              item,
                              style: GoogleFonts.openSans(
                                fontSize: 14.sp,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                color: _textColor,
                              ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.openSans(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: widget.labelColor ?? AppColors.white,
          ),
        ),
        SizedBox(height: 5.h),
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: _toggle,
            child: Container(
              height: 45.h,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: _borderColor, width: 2),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.value ?? widget.hint,
                      style: GoogleFonts.openSans(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: widget.value != null
                            ? LightThemeColors.textColor
                            : LightThemeColors.supportiveTextColor,
                      ),
                    ),
                  ),
                  Icon(
                    _isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: LightThemeColors.textColor,
                    size: 24.sp,
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