import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';

/// Reusable Table Cell Widget
class CommonTableCell extends StatelessWidget {
  final String text;
  final double width;
  final TextAlign align;
  final Color? textColor;
  final FontWeight? fontWeight;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final int maxLines;

  const CommonTableCell({
    Key? key,
    required this.text,
    required this.width,
    this.align = TextAlign.center,
    this.textColor,
    this.fontWeight,
    this.fontSize,
    this.padding,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding ?? EdgeInsets.symmetric(horizontal: 8.w),
      alignment: _getAlignment(),
      child: Text(
        text,
        style: GoogleFonts.openSans(
          fontSize: fontSize ?? 12.sp,
          fontWeight: fontWeight ?? FontWeight.w500,
          color: textColor ?? LightThemeColors.textColor,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: maxLines,
        textAlign: align,
      ),
    );
  }

  Alignment _getAlignment() {
    switch (align) {
      case TextAlign.left:
        return Alignment.centerLeft;
      case TextAlign.right:
        return Alignment.centerRight;
      default:
        return Alignment.center;
    }
  }
}

/// Colored text cell - for values that can be positive/negative
class ColoredTableCell extends StatelessWidget {
  final String text;
  final double width;
  final double? value;
  final TextAlign align;
  final Color? positiveColor;
  final Color? negativeColor;
  final Color? neutralColor;
  final FontWeight? fontWeight;
  final double? fontSize;

  const ColoredTableCell({
    Key? key,
    required this.text,
    required this.width,
    this.value,
    this.align = TextAlign.center,
    this.positiveColor,
    this.negativeColor,
    this.neutralColor,
    this.fontWeight,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonTableCell(
      text: text,
      width: width,
      align: align,
      textColor: _getColor(),
      fontWeight: fontWeight,
      fontSize: fontSize,
    );
  }

  Color _getColor() {
    if (value == null) return neutralColor ?? LightThemeColors.textColor;

    if (value! > 0) {
      return positiveColor ?? LightThemeColors.positiveTextColor;
    } else if (value! < 0) {
      return negativeColor ?? LightThemeColors.negativeTextColor;
    }
    return neutralColor ?? LightThemeColors.textColor;
  }
}

/// Buy/Sell cell - colors based on BUY or SELL text
class BuySellTableCell extends StatelessWidget {
  final String text;
  final double width;
  final TextAlign align;
  final FontWeight? fontWeight;
  final double? fontSize;

  const BuySellTableCell({
    Key? key,
    required this.text,
    required this.width,
    this.align = TextAlign.center,
    this.fontWeight,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isBuy = text.toUpperCase().startsWith('BUY');

    return CommonTableCell(
      text: text,
      width: width,
      align: align,
      textColor: isBuy
          ? LightThemeColors.positiveTextColor
          : LightThemeColors.negativeTextColor,
      fontWeight: fontWeight,
      fontSize: fontSize,
    );
  }
}

/// Link-style cell - for clickable/highlighted values like Symbol
class LinkTableCell extends StatelessWidget {
  final String text;
  final double width;
  final TextAlign align;
  final VoidCallback? onTap;
  final Color? linkColor;
  final FontWeight? fontWeight;
  final double? fontSize;

  const LinkTableCell({
    Key? key,
    required this.text,
    required this.width,
    this.align = TextAlign.center,
    this.onTap,
    this.linkColor,
    this.fontWeight,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CommonTableCell(
        text: text,
        width: width,
        align: align,
        textColor: linkColor ?? AppColors.primaryBlue,
        fontWeight: fontWeight ?? FontWeight.w600,
        fontSize: fontSize,
      ),
    );
  }
}