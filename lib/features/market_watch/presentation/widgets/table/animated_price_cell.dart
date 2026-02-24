import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import 'table_text_style_helper.dart';

class AnimatedPriceCell extends StatefulWidget {
  final String text;
  final bool isDark;
  final String fontFamily;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;
  const AnimatedPriceCell({
    super.key,
    required this.text,
    required this.isDark,
    required this.fontFamily,
    required this.fontSize,
    required this.fontWeight,
    required this.textColor,
  });
  @override
  State<AnimatedPriceCell> createState() => _AnimatedPriceCellState();
}

class _AnimatedPriceCellState extends State<AnimatedPriceCell> {
  final Random _random = Random();
  Color? _bgColor;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
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
        _bgColor = _random.nextBool()
            ? AppColors.buyColor
            : AppColors.sellColor;
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        setState(() {
          _bgColor = null;
        });
        _scheduleNext();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        color: _bgColor,
        alignment: Alignment.center,
        child: Text(
          widget.text,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TableTextStyleHelper.getTextStyle(
            fontFamily: widget.fontFamily,
            fontSize: widget.fontSize.sp,
            fontWeight: widget.fontWeight,
            color: _bgColor != null ? Colors.white : widget.textColor,
          ),
        ),
      ),
    );
  }
}
