import 'package:bazarpro/core/constants/app_colors.dart';
import 'package:bazarpro/core/constants/app_images.dart';
import 'package:bazarpro/core/widget/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// Generic column configuration for User section tables
class UserTableColumn {
  final String id;
  final String label;
  final double width;
  final bool isNumeric;
  final bool sortable;

  const UserTableColumn({
    required this.id,
    required this.label,
    required this.width,
    this.isNumeric = false,
    this.sortable = true,
  });
}

/// Generic data table widget for User section
class UserDataTable<T> extends StatefulWidget {
  final List<UserTableColumn> columns;
  final List<T> data;
  final Widget Function(T item, UserTableColumn column) cellBuilder;
  final String Function(T item) idExtractor;
  final String? selectedId;
  final Function(T item)? onRowTap;
  final Function(String columnId, bool ascending)? onSort;
  final String? sortColumn;
  final bool sortAscending;
  final bool isDarkMode;
  final String emptyMessage;
  final double? rowHeight;
  final double? headerHeight;
  final Widget Function(List<UserTableColumn> columns)? footerBuilder;

  const UserDataTable({
    super.key,
    required this.columns,
    required this.data,
    required this.cellBuilder,
    required this.idExtractor,
    this.selectedId,
    this.onRowTap,
    this.onSort,
    this.sortColumn,
    this.sortAscending = true,
    this.isDarkMode = false,
    this.emptyMessage = 'No data found',
    this.rowHeight,
    this.headerHeight,
    this.footerBuilder,
  });

  @override
  State<UserDataTable<T>> createState() => _UserDataTableState<T>();
}

class _UserDataTableState<T> extends State<UserDataTable<T>> {
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  double get _totalWidth {
    return widget.columns.fold<double>(0, (sum, col) => sum + col.width);
  }

  Color get _headerBgColor => widget.isDarkMode
      ? DarkThemeColors.tableColumnHeadColor
      : LightThemeColors.tableColumnHeadColor;

  Color get _rowBgColor => widget.isDarkMode
      ? DarkThemeColors.tableRowBackground
      : LightThemeColors.tableRowBackground;

  Color get _selectedRowBgColor => widget.isDarkMode
      ? DarkThemeColors.selectedRowBackground
      : LightThemeColors.selectedRowBackground;

  Color get _dividerColor =>
      widget.isDarkMode ? DarkThemeColors.dividerColor : AppColors.greyBorder;

  Color get _headerDividerColor => widget.isDarkMode
      ? DarkThemeColors.dividerColor.withValues(alpha: 0.5)
      : AppColors.white.withValues(alpha: 0.8);

  Color get _textColor => widget.isDarkMode
      ? DarkThemeColors.textColor
      : LightThemeColors.textColor;

  @override
  Widget build(BuildContext context) {
    final rowHeight = widget.rowHeight ?? 45.h;
    final headerHeight = widget.headerHeight ?? 50.h;

    return Container(
      margin: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: _rowBgColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: _dividerColor.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: Column(
          children: [
            Expanded(
              child: Scrollbar(
                controller: _horizontalScrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: _totalWidth,
                    child: Column(
                      children: [
                        _buildHeaderRow(headerHeight),
                        Expanded(
                          child: widget.data.isEmpty
                              ? _buildEmptyState()
                              : _buildDataRows(rowHeight),
                        ),
                        if (widget.footerBuilder != null)
                          _buildFooterRow(rowHeight),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        widget.emptyMessage,
        style: GoogleFonts.openSans(
          fontSize: 16.sp,
          color: widget.isDarkMode
              ? DarkThemeColors.supportiveTextColor
              : LightThemeColors.supportiveTextColor,
        ),
      ),
    );
  }

  Widget _buildHeaderRow(double headerHeight) {
    return Container(
      height: headerHeight,
      decoration: BoxDecoration(
        color: _headerBgColor,
        border: Border(bottom: BorderSide(color: _dividerColor, width: 1)),
      ),
      child: Row(
        children: widget.columns.asMap().entries.map((entry) {
          final index = entry.key;
          final column = entry.value;
          final isLast = index == widget.columns.length - 1;

          return _buildHeaderCell(column, isLast);
        }).toList(),
      ),
    );
  }

  Widget _buildHeaderCell(UserTableColumn column, bool isLast) {
    final isSorted = widget.sortColumn == column.id;

    return GestureDetector(
      onTap: column.sortable && widget.onSort != null
          ? () => widget.onSort!(column.id, !widget.sortAscending)
          : null,
      child: Container(
        width: column.width,
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(right: BorderSide(color: _headerDividerColor, width: 1)),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  column.label,
                  style: GoogleFonts.openSans(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: _textColor,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (column.sortable) ...[
                SizedBox(width: 4.w),
                SvgIcon(
                  assetPath: AppImages.sortIcon,
                  isActive: isSorted,
                  size: 12.sp,
                  activeColor: isSorted ? AppColors.primaryBlue : null,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataRows(double rowHeight) {
    return Scrollbar(
      controller: _verticalScrollController,
      thumbVisibility: true,
      child: ListView.builder(
        controller: _verticalScrollController,
        padding: EdgeInsets.zero,
        itemCount: widget.data.length,
        itemBuilder: (context, index) {
          final item = widget.data[index];
          final itemId = widget.idExtractor(item);
          final isSelected = itemId == widget.selectedId;
          final isLast = index == widget.data.length - 1;

          return _buildDataRow(item, index, isSelected, isLast, rowHeight);
        },
      ),
    );
  }

  Widget _buildDataRow(
    T item,
    int index,
    bool isSelected,
    bool isLast,
    double rowHeight,
  ) {
    return GestureDetector(
      onTap: widget.onRowTap != null ? () => widget.onRowTap!(item) : null,
      child: Container(
        height: rowHeight,
        decoration: BoxDecoration(
          color: isSelected ? _selectedRowBgColor : _rowBgColor,
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(
                    color: _dividerColor.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
        ),
        child: Row(
          children: widget.columns.map((column) {
            return Container(
              width: column.width,
              alignment: Alignment.center,
              child: widget.cellBuilder(item, column),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFooterRow(double rowHeight) {
    return Container(
      height: rowHeight,
      decoration: BoxDecoration(
        color: _headerBgColor,
        border: Border(top: BorderSide(color: _dividerColor, width: 1)),
      ),
      child: widget.footerBuilder!(widget.columns),
    );
  }
}
