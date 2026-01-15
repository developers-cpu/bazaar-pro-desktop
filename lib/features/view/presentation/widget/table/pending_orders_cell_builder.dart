import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../core/constants/app_colors.dart';

import '../../../../market_watch/presentation/widgets/table/table_text_style_helper.dart';
import '../../../domain/entities/pending_order.dart';

/// Widget for building Pending Orders table cell content
class PendingOrdersCellBuilder extends StatelessWidget {
  final String columnId;
  final PendingOrder item;
  final bool isDark;
  final String fontFamily;
  final double fontSize;
  final FontWeight fontWeight;

  const PendingOrdersCellBuilder({
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
      case 'userId':
        return _buildTextCell(item.userId);
      case 'upline':
        return _buildTextCell(item.upline);
      case 'exchange':
        return _buildTextCell(item.exchange);
      case 'symbol':
        return _buildTextCell(item.symbol, color: AppColors.primaryBlue, isBold: true);
      case 'buySell':
        return _buildBuySellCell(item.buySell);
      case 'qty':
        return _buildNumberCell(item.qty);
      case 'lot':
        return _buildTextCell(item.lot.toStringAsFixed(2));
      case 'triggerPrice':
        return _buildPriceCell(item.triggerPrice);
      case 'orderDateTime':
        return _buildTextCell(_formatDateTime(item.orderDateTime));
      case 'modifyOrderDateTime':
        return _buildTextCell(_formatDateTime(item.modifyOrderDateTime));
      case 'orderType':
        return _buildTextCell(item.orderType);
      case 'cmp':
        return _buildTextCell(_formatNumber(item.cmp), color: AppColors.primaryBlue);
      case 'rPrice':
        return _buildTextCell(_formatNumber(item.rPrice), color: AppColors.primaryBlue);
      case 'deviceId':
        return _buildTextCell(item.deviceId ?? '-');
      case 'ipAddress':
        return _buildTextCell(item.ipAddress ?? '-');
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTextCell(String text, {bool isBold = false, Color? color}) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TableTextStyleHelper.getTextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize.sp,
          fontWeight: isBold ? FontWeight.w600 : fontWeight,
          color: color ?? _getTextColor(),
        ),
      ),
    );
  }

  Widget _buildBuySellCell(String buySell) {
    final isBuy = buySell.toUpperCase().startsWith('BUY');
    final color = isBuy
        ? (isDark ? DarkThemeColors.positiveTextColor : LightThemeColors.positiveTextColor)
        : (isDark ? DarkThemeColors.negativeTextColor : LightThemeColors.negativeTextColor);

    return Center(
      child: Text(
        buySell,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TableTextStyleHelper.getTextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize.sp,
          fontWeight: fontWeight,
          color: color,
        ),
      ),
    );
  }

  Widget _buildNumberCell(double value) {
    final color = value >= 0
        ? _getTextColor()
        : (isDark ? DarkThemeColors.negativeTextColor : LightThemeColors.negativeTextColor);

    return Center(
      child: Text(
        _formatNumber(value),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TableTextStyleHelper.getTextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize.sp,
          fontWeight: fontWeight,
          color: color,
        ),
      ),
    );
  }

  Widget _buildPriceCell(double value) {
    final color = value >= 0
        ? AppColors.primaryBlue
        : (isDark ? DarkThemeColors.negativeTextColor : LightThemeColors.negativeTextColor);

    return Center(
      child: Text(
        _formatNumber(value),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TableTextStyleHelper.getTextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize.sp,
          fontWeight: fontWeight,
          color: color,
        ),
      ),
    );
  }

  Color _getTextColor() {
    return isDark ? DarkThemeColors.textColor : LightThemeColors.textColor;
  }

  String _formatNumber(double value) {
    if (value == value.toInt()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(2);
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yy hh:mm:ss a').format(dateTime);
  }
}