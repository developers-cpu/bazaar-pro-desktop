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
      fontSize: fontSize ?? 13.sp,
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
  final bool isStart;
  final double? fontSize;
  final Alignment? alignment;

  const ViewTextCell({
    Key? key,
    required this.text,
    this.color,
    this.fontWeight,
    this.isDark = false,
    this.isStart = false,
    this.fontSize,
    this.alignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: alignment ?? (isStart ? Alignment.centerLeft : Alignment.centerLeft),
      child: Text(
        text,
        style: ViewTableCellStyles.getTextStyle(
          isDark: isDark,
          color: color,
          fontWeight: fontWeight,
          fontSize: fontSize,
        ),
        textAlign: alignment == Alignment.centerRight
            ? TextAlign.end
            : (alignment == Alignment.center ? TextAlign.center : TextAlign.start),
        maxLines: 1,
        softWrap: false,
      ),
    );
  }
}

class ViewBuySellCell extends StatelessWidget {
  final String text;
  final bool isDark;
  final bool isStart;
  final double? fontSize;

  const ViewBuySellCell({
    Key? key,
    required this.text,
    this.isDark = false,
    this.isStart = false,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: isStart ? EdgeInsets.only(left: 14.w) : null,
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: ViewTableCellStyles.getTextStyle(
          isDark: isDark,
          color: ViewTableCellStyles.getBuySellColor(text, isDark: isDark),
          fontSize: fontSize,
        ),
        textAlign: TextAlign.start,
        maxLines: 1,
        softWrap: false,
      ),
    );
  }
}

class ViewNumberCell extends StatelessWidget {
  final double value;
  final String? displayText;
  final bool colorByValue;
  final Color? fixedColor;
  final bool isDark;
  final bool isStart;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;

  const ViewNumberCell({
    Key? key,
    required this.value,
    this.displayText,
    this.colorByValue = true,
    this.fixedColor,
    this.isDark = false,
    this.isStart = false,
    this.padding,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = displayText ?? _formatNumber(value);
    final color =
        fixedColor ??
        (colorByValue
            ? ViewTableCellStyles.getValueColor(value, isDark: isDark)
            : null);

    return Container(
      width: double.infinity,
      padding: padding,
      alignment: Alignment.centerRight,
      child: Text(
        text,
        style: ViewTableCellStyles.getTextStyle(
          isDark: isDark,
          color: color,
          fontSize: fontSize,
        ),
        textAlign: TextAlign.end,
        maxLines: 1,
        softWrap: false,
      ),
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
  final bool isStart;
  final bool isEnd;
  final bool isDark;
  final double? fontSize;

  const ViewLinkCell({
    Key? key,
    required this.text,
    this.onTap,
    this.isDark = false,
    this.isStart = false,
    this.isEnd = false,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        alignment: isEnd ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.only(bottom: 2),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.primaryBlue, width: 2.0),
            ),
          ),
          child: Text(
            text,
            style: ViewTableCellStyles.getTextStyle(
              isDark: isDark,
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w600,
              fontSize: fontSize,
            ),
            textAlign: isEnd ? TextAlign.end : TextAlign.start,
            maxLines: 1,
            softWrap: false,
          ),
        ),
      ),
    );
  }
}

class ViewDateTimeCell extends StatelessWidget {
  final DateTime dateTime;
  final String format;
  final bool isDark;
  final Color? color;
  final double? fontSize;

  const ViewDateTimeCell({
    Key? key,
    required this.dateTime,
    this.format = 'dd/MM/yy hh:mm:ss a',
    this.isDark = false,
    this.color,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.centerRight,
      child: Text(
        _formatDateTime(),
        style: ViewTableCellStyles.getTextStyle(
          isDark: isDark,
          color: color,
          fontSize: fontSize,
        ),
        textAlign: TextAlign.end,
        maxLines: 1,
        softWrap: false,
      ),
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
