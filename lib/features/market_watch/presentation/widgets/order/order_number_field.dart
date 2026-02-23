import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
class OrderNumberField extends StatefulWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  final int minValue;
  final int maxValue;
  final int step;
  final Color? labelColor;
  final Color? borderColor;
  final bool isDarkMode;
  const OrderNumberField({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.minValue = 0,
    this.maxValue = 999999999,
    this.step = 1,
    this.labelColor,
    this.borderColor,
    this.isDarkMode = false,
  }) : super(key: key);
  @override
  State<OrderNumberField> createState() => _OrderNumberFieldState();
}
class _OrderNumberFieldState extends State<OrderNumberField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isEditing = false;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }
  @override
  void didUpdateWidget(OrderNumberField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && !_isEditing) {
      _controller.text = widget.value.toString();
    }
  }
  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }
  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      _isEditing = false;
      _validateAndUpdate();
    } else {
      _isEditing = true;
      _controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _controller.text.length,
      );
    }
  }
  void _validateAndUpdate() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      _controller.text = widget.minValue.toString();
      widget.onChanged(widget.minValue);
      return;
    }
    final parsed = int.tryParse(text);
    if (parsed == null) {
      _controller.text = widget.value.toString();
      return;
    }
    final clamped = parsed.clamp(widget.minValue, widget.maxValue);
    if (clamped != parsed) {
      _controller.text = clamped.toString();
    }
    widget.onChanged(clamped);
  }
  void _increment() {
    final newValue = (widget.value + widget.step).clamp(
      widget.minValue,
      widget.maxValue,
    );
    _controller.text = newValue.toString();
    widget.onChanged(newValue);
  }
  void _decrement() {
    final newValue = (widget.value - widget.step).clamp(
      widget.minValue,
      widget.maxValue,
    );
    _controller.text = newValue.toString();
    widget.onChanged(newValue);
  }
  Color get _borderColor => widget.borderColor ?? LightThemeColors.primaryColor;
  Color get _textColor => LightThemeColors.textColor;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty) ...[
          Text(
            widget.label,
            style: GoogleFonts.openSans(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: widget.labelColor ?? AppColors.white,
            ),
          ),
          SizedBox(height: 5.h),
        ],
        Container(
          height: 45.h,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: _borderColor, width: 2),
          ),
          child: Row(
            children: [
              _buildButton(icon: '−', onTap: _decrement, isLeft: true),
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  style: GoogleFonts.openSans(
                    fontSize: 14.sp,
                    color: _textColor,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  onSubmitted: (_) => _validateAndUpdate(),
                ),
              ),
              _buildButton(icon: '+', onTap: _increment, isLeft: false),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildButton({
    required String icon,
    required VoidCallback onTap,
    required bool isLeft,
  }) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.horizontal(
          left: isLeft ? Radius.circular(8.r) : Radius.zero,
          right: !isLeft ? Radius.circular(8.r) : Radius.zero,
        ),
        child: Container(
          width: 40.w,
          height: double.infinity,
          alignment: Alignment.center,
          child: Text(
            icon,
            style: GoogleFonts.openSans(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: _textColor,
            ),
          ),
        ),
      ),
    );
  }
}
