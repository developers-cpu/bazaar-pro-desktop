import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_images.dart';
import '../../../../../core/widget/svg_icon.dart';
import 'table_text_style_helper.dart';
class AnimatedExchangeCell extends StatefulWidget {
  final String text;
  final bool isDark;
  final String fontFamily;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;
  const AnimatedExchangeCell({
    Key? key,
    required this.text,
    required this.isDark,
    required this.fontFamily,
    required this.fontSize,
    required this.fontWeight,
    required this.textColor,
  }) : super(key: key);
  @override
  State<AnimatedExchangeCell> createState() => _AnimatedExchangeCellState();
}
class _AnimatedExchangeCellState extends State<AnimatedExchangeCell> {
  final Random _random = Random();
  bool _isBuy = true;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _isBuy = _random.nextBool();
    _scheduleNext();
  }
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  void _scheduleNext() {
    final delayMs = 1500 + _random.nextInt(3000);
    _timer = Timer(Duration(milliseconds: delayMs), () {
      if (!mounted) return;
      setState(() {
        _isBuy = _random.nextBool();
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        setState(() {
          _isBuy = _random.nextBool();
        });
        _scheduleNext();
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    final iconColor = _isBuy
        ? (widget.isDark
              ? DarkThemeColors.positiveTextColor
              : LightThemeColors.positiveTextColor)
        : (widget.isDark
              ? DarkThemeColors.negativeTextColor
              : LightThemeColors.negativeTextColor);
    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgIcon(
            assetPath: _isBuy ? AppImages.buyIcon : AppImages.sellIcon,
            isActive: true,
            size: (widget.fontSize * 1.1).sp,
            activeColor: iconColor,
          ),
          SizedBox(width: 3.w),
          Flexible(
            child: Text(
              widget.text,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TableTextStyleHelper.getTextStyle(
                fontFamily: widget.fontFamily,
                fontSize: widget.fontSize.sp,
                fontWeight: widget.fontWeight,
                color: widget.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
