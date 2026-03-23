import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/table/view_data_table.dart';

class SharedSettlementTable<T> extends StatelessWidget {
  final String title;
  final Color headerColor;
  final List<T> entries;
  final bool isProfitSection;
  final bool showTotalColumn;
  final bool isDrilledDown;

  final String Function(T) getUserId;
  final String Function(T) getUsername;
  final String Function(T) getUserType;
  final double Function(T) getPnl;
  final double Function(T) getMiddleValue;
  final double Function(T) getTotal;

  final String pnlColumnName;
  final String middleColumnName;
  final Function(String userId, String username) onUserSelected;

  const SharedSettlementTable({
    super.key,
    required this.title,
    required this.headerColor,
    required this.entries,
    required this.isProfitSection,
    required this.showTotalColumn,
    this.isDrilledDown = false,
    required this.getUserId,
    required this.getUsername,
    required this.getUserType,
    required this.getPnl,
    required this.getMiddleValue,
    required this.getTotal,
    this.pnlColumnName = 'Net P&L',
    required this.middleColumnName,
    required this.onUserSelected,
  });

  @override
  Widget build(BuildContext context) {
    double computedTotalPnl = entries.fold(
      0.0,
      (sum, item) => sum + getPnl(item),
    );
    double computedTotalMiddle = entries.fold(
      0.0,
      (sum, item) => sum + getMiddleValue(item),
    );
    double computedTotalAmount = entries.fold(
      0.0,
      (sum, item) => sum + getTotal(item),
    );

    final columns = [
      ViewTableColumn(
        id: 'username',
        label: 'Username',
        width: 170,
        alignment: Alignment.centerLeft,
      ),
      ViewTableColumn(
        id: 'pnl',
        label: pnlColumnName,
        width: 120,
        isNumeric: true,
        alignment: Alignment.center,
      ),
      ViewTableColumn(
        id: 'middle',
        label: middleColumnName,
        width: 120,
        isNumeric: true,
        alignment: showTotalColumn ? Alignment.center : Alignment.centerRight,
      ),
      if (showTotalColumn)
        ViewTableColumn(
          id: 'total',
          label: 'Total',
          width: 120,
          isNumeric: true,
          alignment: Alignment.centerRight,
        ),
    ];

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: headerColor, width: 1.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(color: headerColor),
            alignment: Alignment.center,
            child: Text(
              title,
              style: GoogleFonts.openSans(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
          ),

          Expanded(
            child: ViewDataTable<T>(
              columns: columns,
              data: entries,
              autoFit: true,
              headerBgColor: Colors.white,
              tableBoxDecoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              showRowBorders: false,
              rowBackgroundBuilder: (item, index) {
                if (index % 2 == 0) {
                  return isProfitSection
                      ? AppColors.headerBgColor
                      : LightThemeColors.chipBgRed;
                }
                return Colors.transparent;
              },
              idExtractor: (item) => getUserId(item),
              comparatorBuilder: (item, columnId) {
                switch (columnId) {
                  case 'username':
                    return getUsername(item);
                  case 'pnl':
                    return getPnl(item);
                  case 'middle':
                    return getMiddleValue(item);
                  case 'total':
                    return getTotal(item);
                  default:
                    return 0;
                }
              },
              cellBuilder: (item, column) {
                switch (column.id) {
                  case 'username':
                    final uType = getUserType(item);
                    final isMaster =
                        uType.isNotEmpty && uType.toUpperCase() != 'C';
                    final uName = getUsername(item);

                    final usernameDisplay = isDrilledDown && !isProfitSection
                        ? '$uName ($uType)'
                        : uType.isNotEmpty
                        ? '$uName [$uType]'
                        : uName;

                    final textWidget = Text(
                      usernameDisplay,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.openSans(
                        color: isMaster && !isDrilledDown
                            ? Colors.transparent
                            : AppColors.billDataText,
                        fontSize: 14.sp,
                        shadows: isMaster && !isDrilledDown
                            ? [
                                const Shadow(
                                  color: AppColors.billDataText,
                                  offset: Offset(0, -5),
                                ),
                              ]
                            : null,
                        decoration: isMaster && !isDrilledDown
                            ? TextDecoration.underline
                            : null,
                        decorationColor: AppColors.billDataText,
                        decorationThickness: 4,
                      ),
                    );

                    if (isMaster && !isDrilledDown) {
                      return InkWell(
                        onTap: () =>
                            onUserSelected(getUserId(item), usernameDisplay),
                        child: textWidget,
                      );
                    }
                    return textWidget;

                  case 'pnl':
                    return Text(
                      getPnl(item).toStringAsFixed(0),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.openSans(
                        fontSize: 14.sp,
                        color: AppColors.billDataText,
                      ),
                    );

                  case 'middle':
                    return Text(
                      getMiddleValue(item).toStringAsFixed(0),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.openSans(
                        fontSize: 14.sp,
                        color: AppColors.billDataText,
                      ),
                    );

                  case 'total':
                    return Text(
                      getTotal(item).toStringAsFixed(0),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.openSans(
                        fontSize: 14.sp,
                        color: isProfitSection
                            ? AppColors.buyColor
                            : AppColors.sellColor,
                      ),
                    );

                  default:
                    return const SizedBox.shrink();
                }
              },
              footerBuilder: (scaledColumns) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    children: scaledColumns.map((col) {
                      Widget child = const SizedBox.shrink();
                      final isLastColumn = col == scaledColumns.last;
                      final effectiveAlignment =
                          col.alignment ?? Alignment.center;

                      TextAlign getTextAlign(Alignment alignment) {
                        if (alignment == Alignment.centerLeft)
                          return TextAlign.left;
                        if (alignment == Alignment.centerRight)
                          return TextAlign.right;
                        return TextAlign.center;
                      }

                      if (col.id == 'username') {
                        child = Text(
                          'Total',
                          textAlign: getTextAlign(effectiveAlignment),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.openSans(
                            color: AppColors.billDataText,
                            fontSize: 14.sp,
                          ),
                        );
                      } else if (col.id == 'pnl') {
                        child = Text(
                          computedTotalPnl.toStringAsFixed(0),
                          textAlign: getTextAlign(effectiveAlignment),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.openSans(
                            fontSize: 14.sp,
                            color: AppColors.billDataText,
                          ),
                        );
                      } else if (col.id == 'middle') {
                        child = Text(
                          computedTotalMiddle.toStringAsFixed(0),
                          textAlign: getTextAlign(effectiveAlignment),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.openSans(
                            fontSize: 14.sp,
                            color: AppColors.billDataText,
                          ),
                        );
                      } else if (col.id == 'total') {
                        child = Text(
                          computedTotalAmount.toStringAsFixed(0),
                          textAlign: getTextAlign(effectiveAlignment),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.openSans(
                            fontSize: 14.sp,
                            color: isProfitSection
                                ? AppColors.buyColor
                                : AppColors.sellColor,
                          ),
                        );
                      }

                      return Container(
                        width: col.width,
                        alignment: effectiveAlignment,
                        decoration: BoxDecoration(
                          border: isLastColumn
                              ? null
                              : const Border(
                                  right: BorderSide(
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
                                ),
                        ),
                        padding: EdgeInsets.only(
                          left:
                              15.w +
                              (effectiveAlignment == Alignment.centerLeft
                                  ? 8.w
                                  : 0),
                          right:
                              (isLastColumn ? 14.w : 15.w) +
                              (effectiveAlignment == Alignment.centerRight
                                  ? 8.w
                                  : 0),
                        ),
                        child: child,
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
