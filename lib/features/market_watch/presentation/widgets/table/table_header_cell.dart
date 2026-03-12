import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_images.dart';
import '../../../../../core/widget/svg_icon.dart';
import 'table_text_style_helper.dart';

class TableHeaderCell extends StatefulWidget {
  final String title;
  final String columnId;
  final bool isDark;
  final String fontFamily;
  final double fontSize;
  final FontWeight fontWeight;
  final bool showSortIcon;
  final bool isLast;
  final bool isFirst;
  final bool showGrid;
  final bool isSorted;
  final bool sortAscending;
  final VoidCallback? onSort;
  final void Function(String fromColumnId, String toColumnId)? onColumnReorder;
  const TableHeaderCell({
    Key? key,
    required this.title,
    required this.columnId,
    required this.isDark,
    required this.fontFamily,
    required this.fontSize,
    required this.fontWeight,
    this.showSortIcon = true,
    this.isLast = false,
    this.isFirst = false,
    this.showGrid = false,
    this.isSorted = false,
    this.sortAscending = true,
    this.onSort,
    this.onColumnReorder,
  }) : super(key: key);

  @override
  State<TableHeaderCell> createState() => _TableHeaderCellState();
}

class _TableHeaderCellState extends State<TableHeaderCell> {
  bool _isDragOver = false;

  @override
  Widget build(BuildContext context) {
    if (widget.title.isEmpty) {
      return const SizedBox.shrink();
    }
    final headerTitle = widget.title.toUpperCase();
    final textStyle = TableTextStyleHelper.getTextStyle(
      fontFamily: widget.fontFamily,
      fontSize: (widget.fontSize - 1).sp,
      fontWeight: FontWeight.w500,
      color: AppColors.primaryTextColor,
    );
    Widget content;
    if (!widget.showSortIcon) {
      content = Center(
        child: Text(
          headerTitle,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textStyle,
        ),
      );
    } else {
      content = Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                headerTitle,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textStyle,
              ),
            ),
            if (widget.showSortIcon) ...[
              SizedBox(width: 4.w),
              SvgIcon(
                assetPath: AppImages.sortIcon,
                isActive: widget.isSorted,
                size: widget.fontSize.sp,
                activeColor: widget.isSorted ? AppColors.primaryBlue : null,
              ),
            ],
          ],
        ),
      );
    }

    Widget headerWidget = Container(
      constraints: const BoxConstraints.expand(),
      padding: EdgeInsets.only(left: widget.columnId == 'exchange' ? 8.w : 0.w),
      child: Align(
        alignment: widget.columnId == 'exchange'
            ? Alignment.centerLeft
            : Alignment.center,
        child: content,
      ),
    );

    if (widget.onColumnReorder != null) {
      final originalHeaderWidget = headerWidget;
      headerWidget = DragTarget<String>(
        onWillAcceptWithDetails: (details) {
          if (details.data != widget.columnId) {
            setState(() => _isDragOver = true);
            return true;
          }
          return false;
        },
        onLeave: (_) {
          setState(() => _isDragOver = false);
        },
        onAcceptWithDetails: (details) {
          setState(() => _isDragOver = false);
          widget.onColumnReorder!(details.data, widget.columnId);
        },
        builder: (context, candidateData, rejectedData) {
          return LongPressDraggable<String>(
            data: widget.columnId,
            axis: Axis.horizontal,
            delay: const Duration(milliseconds: 150),
            feedback: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(4),
              color: LightThemeColors.tableColumnHeadColor,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                child: Text(
                  headerTitle,
                  style: textStyle.copyWith(color: AppColors.primaryTextColor),
                ),
              ),
            ),
            childWhenDragging: Opacity(
              opacity: 0.4,
              child: originalHeaderWidget,
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: widget.isFirst
                      ? BorderSide.none
                      : BorderSide(
                          color: _isDragOver
                              ? AppColors.blue
                              :AppColors.white,
                          width: _isDragOver ? 2.5 : 1.0,
                        ),
                ),
              ),
              child: originalHeaderWidget,
            ),
          );
        },
      );
    }

    if (widget.onSort != null) {
      headerWidget = InkWell(onTap: widget.onSort, child: headerWidget);
    }

    return headerWidget;
  }
}
