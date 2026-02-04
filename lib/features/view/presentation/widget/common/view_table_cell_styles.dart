import 'package:bazarpro/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
class ViewTableCellStyles {
  ViewTableCellStyles._();
  static TextStyle getTextStyle({
    bool isDark = false,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
  }) {
    return GoogleFonts.openSans(
      fontSize: fontSize ?? 12.sp,
      fontWeight: fontWeight ?? FontWeight.w500,
      color:
          color ??
          (isDark ? DarkThemeColors.textColor : LightThemeColors.textColor),
    );
  }
  static Color getValueColor(double value, {bool isDark = false}) {
    if (value > 0) {
      return isDark
          ? DarkThemeColors.positiveTextColor
          : LightThemeColors.positiveTextColor;
    } else if (value < 0) {
      return isDark
          ? DarkThemeColors.negativeTextColor
          : LightThemeColors.negativeTextColor;
    }
    return isDark ? DarkThemeColors.textColor : LightThemeColors.textColor;
  }
  static Color getBuySellColor(String text, {bool isDark = false}) {
    final isBuy = text.toUpperCase().startsWith('BUY');
    if (isBuy) {
      return isDark
          ? DarkThemeColors.positiveTextColor
          : LightThemeColors.positiveTextColor;
    }
    return isDark
        ? DarkThemeColors.negativeTextColor
        : LightThemeColors.negativeTextColor;
  }
}
class ViewTextCell extends StatelessWidget {
  final String text;
  final Color? color;
  final FontWeight? fontWeight;
  final bool isDark;
  const ViewTextCell({
    Key? key,
    required this.text,
    this.color,
    this.fontWeight,
    this.isDark = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: ViewTableCellStyles.getTextStyle(
        isDark: isDark,
        color: color,
        fontWeight: fontWeight,
      ),
      textAlign: TextAlign.center,
      maxLines: 1,
      softWrap: false,
    );
  }
}
class ViewBuySellCell extends StatelessWidget {
  final String text;
  final bool isDark;
  const ViewBuySellCell({Key? key, required this.text, this.isDark = false})
    : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: ViewTableCellStyles.getTextStyle(
        isDark: isDark,
        color: ViewTableCellStyles.getBuySellColor(text, isDark: isDark),
      ),
      textAlign: TextAlign.center,
      maxLines: 1,
      softWrap: false,
    );
  }
}
class ViewNumberCell extends StatelessWidget {
  final double value;
  final String? displayText;
  final bool colorByValue;
  final Color? fixedColor;
  final bool isDark;
  const ViewNumberCell({
    Key? key,
    required this.value,
    this.displayText,
    this.colorByValue = true,
    this.fixedColor,
    this.isDark = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final text = displayText ?? _formatNumber(value);
    final color =
        fixedColor ??
        (colorByValue
            ? ViewTableCellStyles.getValueColor(value, isDark: isDark)
            : null);
    return Text(
      text,
      style: ViewTableCellStyles.getTextStyle(isDark: isDark, color: color),
      textAlign: TextAlign.center,
      maxLines: 1,
      softWrap: false,
    );
  }
  String _formatNumber(double value) {
    if (value == value.toInt()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(2);
  }
}
class ViewLinkCell extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isDark;
  const ViewLinkCell({
    Key? key,
    required this.text,
    this.onTap,
    this.isDark = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style:
            ViewTableCellStyles.getTextStyle(
              isDark: isDark,
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w600,
            ).copyWith(
              decoration: TextDecoration.underline,
              decorationColor: AppColors.primaryBlue,
            ),
        textAlign: TextAlign.center,
        maxLines: 1,
        softWrap: false,
      ),
    );
  }
}
class ViewDateTimeCell extends StatelessWidget {
  final DateTime dateTime;
  final String format;
  final bool isDark;
  const ViewDateTimeCell({
    Key? key,
    required this.dateTime,
    this.format = 'dd/MM/yy hh:mm:ss a',
    this.isDark = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      _formatDateTime(),
      style: ViewTableCellStyles.getTextStyle(isDark: isDark),
      textAlign: TextAlign.center,
      maxLines: 1,
      softWrap: false,
    );
  }
  String _formatDateTime() {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = (dateTime.year % 100).toString().padLeft(2, '0');
    final hour = dateTime.hour > 12
        ? dateTime.hour - 12
        : (dateTime.hour == 0 ? 12 : dateTime.hour);
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final second = dateTime.second.toString().padLeft(2, '0');
    final amPm = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$day/$month/$year ${hour.toString().padLeft(2, '0')}:$minute:$second $amPm';
  }
}
