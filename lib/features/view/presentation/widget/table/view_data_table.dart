import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_images.dart';
import '../../../../../core/widget/svg_icon.dart';

/// Generic column configuration for View section tables
class ViewTableColumn {
  final String id;
  final String label;
  final double width;
  final bool isNumeric;
  final bool sortable;

  const ViewTableColumn({
    required this.id,
    required this.label,
    required this.width,
    this.isNumeric = false,
    this.sortable = true,
  });
}


class ViewDataTable<T> extends StatefulWidget {
  final List<ViewTableColumn> columns;
  final List<T> data;
  final Widget Function(T item, ViewTableColumn column) cellBuilder;
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
  final Widget Function(List<ViewTableColumn> columns)? footerBuilder;

  const ViewDataTable({
    Key? key,
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
  }) : super(key: key);

  @override
  State<ViewDataTable<T>> createState() => _ViewDataTableState<T>();
}

class _ViewDataTableState<T> extends State<ViewDataTable<T>> {
  int? _sortColumnIndex;
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _updateSortIndex();
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ViewDataTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sortColumn != widget.sortColumn) {
      _updateSortIndex();
    }
  }

  void _updateSortIndex() {
    if (widget.sortColumn != null) {
      final index = widget.columns.indexWhere((c) => c.id == widget.sortColumn);
      _sortColumnIndex = index >= 0 ? index : null;
    } else {
      _sortColumnIndex = null;
    }
  }

  double get _totalWidth {
    return widget.columns.fold<double>(0, (sum, col) => sum + col.width);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty && widget.footerBuilder == null) {
      return _buildEmptyState();
    }

    return _buildTableWithFooter();
  }

  Widget _buildEmptyState() {
    return Container(
      color: widget.isDarkMode
          ? DarkThemeColors.backgroundColor
          : LightThemeColors.backgroundColor,
      child: Center(
        child: Text(
          widget.emptyMessage,
          style: GoogleFonts.openSans(
            fontSize: 16.sp,
            color: widget.isDarkMode
                ? DarkThemeColors.supportiveTextColor
                : LightThemeColors.supportiveTextColor,
          ),
        ),
      ),
    );
  }

  Widget _buildTableWithFooter() {
    final rowHeight = widget.rowHeight ?? 45.h;
    final headerHeight = widget.headerHeight ?? 50.h;
    final hasFooter = widget.footerBuilder != null;

    return Container(
      margin: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: widget.isDarkMode
            ? DarkThemeColors.backgroundColor
            : LightThemeColors.backgroundColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: Column(
          children: [
            // Scrollable table + footer area
            Expanded(
              child: Scrollbar(
                controller: _horizontalScrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: _totalWidth + 24, // Account for horizontal margins
                    child: Column(
                      children: [
                        // Table header and data rows
                        Expanded(
                          child: _buildTableContent(rowHeight, headerHeight),
                        ),
                        // Footer row (aligned with columns)
                        if (hasFooter)
                          _buildFooterRow(),
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

  Widget _buildTableContent(double rowHeight, double headerHeight) {
    if (widget.data.isEmpty) {
      return Column(
        children: [
          _buildHeaderRow(headerHeight),
          Expanded(
            child: Center(
              child: Text(
                widget.emptyMessage,
                style: GoogleFonts.openSans(
                  fontSize: 16.sp,
                  color: widget.isDarkMode
                      ? DarkThemeColors.supportiveTextColor
                      : LightThemeColors.supportiveTextColor,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      minWidth: _totalWidth,
      headingRowHeight: headerHeight,
      dataRowHeight: rowHeight,
      headingRowColor: WidgetStateProperty.all(
        LightThemeColors.tableColumnHeadColor,
      ),
      dividerThickness: 0,
      border: TableBorder(
        horizontalInside: BorderSide(
          color: AppColors.greyBorder.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      sortColumnIndex: _sortColumnIndex,
      sortAscending: widget.sortAscending,
      columns: _buildColumns(),
      rows: _buildRows(),
    );
  }

  Widget _buildHeaderRow(double headerHeight) {
    return Container(
      height: headerHeight,
      color: LightThemeColors.tableColumnHeadColor,
      child: Row(
        children: widget.columns.map((column) {
          return Container(
            width: column.width,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  column.label,
                  style: GoogleFonts.openSans(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: LightThemeColors.textColor,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  softWrap: false,
                ),
                if (column.sortable) ...[
                  SizedBox(width: 4.w),
                  SvgIcon(
                    assetPath: AppImages.sortIcon,
                    isActive: widget.sortColumn == column.id,
                    size: 12.sp,
                    activeColor: widget.sortColumn == column.id ? AppColors.primaryBlue : null,
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFooterRow() {
    return widget.footerBuilder!(widget.columns);
  }

  List<DataColumn2> _buildColumns() {
    return widget.columns.asMap().entries.map((entry) {
      final index = entry.key;
      final column = entry.value;

      return DataColumn2(
        label: _buildHeaderCell(column),
        size: ColumnSize.L,
        numeric: column.isNumeric,
        headingRowAlignment: MainAxisAlignment.center,
        onSort: column.sortable && widget.onSort != null
            ? (_, ascending) {
          setState(() {
            _sortColumnIndex = index;
          });
          widget.onSort!(column.id, ascending);
        }
            : null,
      );
    }).toList();
  }

  Widget _buildHeaderCell(ViewTableColumn column) {
    final isSorted = widget.sortColumn == column.id;

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            column.label,
            style: GoogleFonts.openSans(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: LightThemeColors.textColor,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            softWrap: false,
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
    );
  }

  List<DataRow2> _buildRows() {
    return widget.data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final itemId = widget.idExtractor(item);
      final isSelected = itemId == widget.selectedId;

      return DataRow2(
        selected: isSelected,
        color: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            return widget.isDarkMode
                ? DarkThemeColors.selectedRowBackground
                : LightThemeColors.selectedRowBackground;
          }
          // Alternate row colors
          if (index % 2 == 0) {
            return widget.isDarkMode
                ? DarkThemeColors.backgroundColor
                : AppColors.white;
          }
          return widget.isDarkMode
              ? DarkThemeColors.backgroundColor.withOpacity(0.8)
              : AppColors.primaryBgColor.withOpacity(0.3);
        }),
        onTap: widget.onRowTap != null ? () => widget.onRowTap!(item) : null,
        cells: _buildCells(item),
      );
    }).toList();
  }

  List<DataCell> _buildCells(T item) {
    return widget.columns.map((column) {
      return DataCell(
        Center(child: widget.cellBuilder(item, column)),
      );
    }).toList();
  }
}