import 'package:bazarpro/core/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../../../../core/utils/number_formatter.dart';
import '../../../../../core/widget/svg_icon.dart';

import '../../../domain/entities/market_item.dart';
import 'animated_price_cell.dart';
import 'table_text_style_helper.dart';

class TableCellBuilder extends StatelessWidget {
  final String columnId;
  final MarketItem item;
  final bool isDark;
  final String fontFamily;
  final double fontSize;
  final FontWeight fontWeight;
  const TableCellBuilder({
    Key? key,
    required this.columnId,
    required this.item,
    required this.isDark,
    required this.fontFamily,
    required this.fontSize,
    required this.fontWeight,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return _buildCellContent();
  }

  Widget _buildCellContent() {
    switch (columnId) {
      case 'exchange':
        return _buildExchangeWithArrowCell();
      case 'symbol':
        return AnimatedPriceCell(
          text: item.symbol,
          isDark: isDark,
          fontFamily: fontFamily,
          fontSize: fontSize,
          textColor: _getTextColor(),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 8.w),
          textAlign: TextAlign.left,
          fontWeight: _effectiveFontWeight,
        );
      case 'buyQty':
        return _buildTextCell(
          NumberFormatter.formatQuantity(item.buyQty),
          alignRight: true,
        );
      case 'buyPrice':
        return _buildAnimatedPriceCell(
          NumberFormatter.formatPrice(item.buyPrice),
        );
      case 'sellPrice':
        return _buildAnimatedPriceCell(
          NumberFormatter.formatPrice(item.sellPrice),
        );
      case 'sellQty':
        return _buildTextCell(
          NumberFormatter.formatQuantity(item.sellQty),
          alignRight: true,
        );
      case 'netChange':
        return _buildTextCell(
          NumberFormatter.formatChange(item.netChange),
          alignRight: true,
        );
      case 'high':
        return _buildTextCell(
          NumberFormatter.formatPrice(item.high),
          alignRight: true,
        );
      case 'low':
        return _buildTextCell(
          NumberFormatter.formatPrice(item.low),
          alignRight: true,
        );
      case 'open':
        return _buildTextCell(
          NumberFormatter.formatPrice(item.open),
          alignRight: true,
        );
      case 'close':
        return _buildTextCell(
          NumberFormatter.formatPrice(item.close),
          alignRight: true,
        );
      case 'ltp':
        return _buildAnimatedPriceCell(NumberFormatter.formatPrice(item.ltp));
      case 'netChangePercent':
        return _buildTextCell(
          NumberFormatter.formatPercentage(item.netChangePercent),
          alignRight: true,
        );
      case 'expiry':
        return _buildTextCell(
          item.expiry != null
              ? DateFormatter.formatToShortDate(item.expiry!)
              : AppStrings.dashPlaceholder,
        );
      case 'lut':
        return _buildTextCell(DateFormatter.formatToDateTimeWithAmPm(item.lut));
      case 'strikePrice':
        return _buildTextCell(
          NumberFormatter.formatPrice(item.strikePrice),
          alignRight: true,
        );
      case 'lowerCkt':
        return _buildTextCell(
          NumberFormatter.formatPrice(item.lowerCkt),
          alignRight: true,
        );
      case 'upperCkt':
        return _buildTextCell(
          NumberFormatter.formatPrice(item.upperCkt),
          alignRight: true,
        );
      case 'tbq':
        return _buildAnimatedPriceCell(
          NumberFormatter.formatQuantity(item.tbq),
        );
      case 'tsq':
        return _buildAnimatedPriceCell(
          NumberFormatter.formatQuantity(item.tsq),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildExchangeWithArrowCell() {
    final isPositive = item.netChange > 0;
    final isNegative = item.netChange < 0;
    Color iconColor;
    if (isPositive) {
      iconColor = isDark
          ? DarkThemeColors.positiveTextColor
          : LightThemeColors.positiveTextColor;
    } else if (isNegative) {
      iconColor = isDark
          ? DarkThemeColors.negativeTextColor
          : LightThemeColors.negativeTextColor;
    } else {
      iconColor = isDark
          ? DarkThemeColors.textColor
          : LightThemeColors.textColor;
    }
    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgIcon(
            assetPath: isPositive ? AppImages.buyIcon : AppImages.sellIcon,
            isActive: true,
            size: (fontSize * 1.1).sp,
            activeColor: iconColor,
          ),
          SizedBox(width: 3.w),
          Flexible(
            child: Text(
              item.exchange,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TableTextStyleHelper.getTextStyle(
                fontFamily: fontFamily,
                fontSize: fontSize.sp,
                fontWeight: fontWeight,
                color: _getTextColor(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedPriceCell(String text) {
    return AnimatedPriceCell(
      text: text,
      isDark: isDark,
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      textColor: _getTextColor(),
      padding: EdgeInsets.only(right: 8.w),
    );
  }

  Widget _buildTextCell(
    String text, {
    bool isBold = false,
    Color? color,
    bool alignLeft = false,
    bool alignRight = false,
  }) {
    final alignment = alignLeft
        ? Alignment.centerLeft
        : alignRight
        ? Alignment.centerRight
        : Alignment.center;
    final textAlign = alignLeft
        ? TextAlign.left
        : alignRight
        ? TextAlign.right
        : TextAlign.center;
    return Container(
      padding: alignRight ? EdgeInsets.only(right: 8.w) : EdgeInsets.zero,
      alignment: alignment,
      child: Text(
        text,
        textAlign: textAlign,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TableTextStyleHelper.getTextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize.sp,
          fontWeight: isBold ? FontWeight.w600 : _effectiveFontWeight,
          color: color ?? _getTextColor(),
        ),
      ),
    );
  }

  FontWeight get _effectiveFontWeight {
    if (isDark) return fontWeight;
    if (fontWeight == FontWeight.w400 || fontWeight == FontWeight.normal) {
      return FontWeight.w500;
    }
    return fontWeight;
  }

  Color _getTextColor() {
    return isDark ? DarkThemeColors.textColor : AppColors.black;
  }
}
