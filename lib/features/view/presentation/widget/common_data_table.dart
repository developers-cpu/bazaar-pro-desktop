import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import 'common_table_header.dart';


/// Generic Data Table Widget
/// T is the data type for each row
class CommonDataTable<T> extends StatefulWidget {
  final List<TableColumn> columns;
  final List<T> data;
  final Widget Function(T item, int index) rowBuilder;
  final String? sortColumn;
  final bool sortAscending;
  final Function(String columnId, bool ascending)? onSort;
  final String? selectedId;
  final String Function(T item)? idExtractor;
  final Function(T item)? onRowTap;
  final Function(T item)? onRowDoubleTap;
  final double? headerHeight;
  final double? rowHeight;
  final Color? headerBackgroundColor;
  final String? emptyMessage;
  final Widget? emptyWidget;
  final bool showScrollbar;

  const CommonDataTable({
    Key? key,
    required this.columns,
    required this.data,
    required this.rowBuilder,
    this.sortColumn,
    this.sortAscending = true,
    this.onSort,
    this.selectedId,
    this.idExtractor,
    this.onRowTap,
    this.onRowDoubleTap,
    this.headerHeight,
    this.rowHeight,
    this.headerBackgroundColor,
    this.emptyMessage,
    this.emptyWidget,
    this.showScrollbar = true,
  }) : super(key: key);

  @override
  State<CommonDataTable<T>> createState() => _CommonDataTableState<T>();
}

class _CommonDataTableState<T> extends State<CommonDataTable<T>> {
  final ScrollController _horizontalController = ScrollController();
  final ScrollController _verticalController = ScrollController();

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  double get _totalWidth {
    return widget.columns
        .where((c) => c.isVisible)
        .fold<double>(0, (sum, col) => sum + col.width);
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _horizontalController,
      thumbVisibility: widget.showScrollbar,
      child: SingleChildScrollView(
        controller: _horizontalController,
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: _totalWidth,
          child: Column(
            children: [
              // Header
              CommonTableHeader(
                columns: widget.columns,
                sortColumn: widget.sortColumn,
                sortAscending: widget.sortAscending,
                onSort: widget.onSort,
                backgroundColor: widget.headerBackgroundColor,
                height: widget.headerHeight,
              ),
              // Data rows
              Expanded(
                child: _buildDataRows(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataRows() {
    if (widget.data.isEmpty) {
      return widget.emptyWidget ??
          Center(
            child: Text(
              widget.emptyMessage ?? 'No data found',
              style: GoogleFonts.openSans(
                fontSize: 14.sp,
                color: LightThemeColors.supportiveTextColor,
              ),
            ),
          );
    }

    return Scrollbar(
      controller: _verticalController,
      thumbVisibility: widget.showScrollbar,
      child: ListView.builder(
        controller: _verticalController,
        itemCount: widget.data.length,
        itemBuilder: (context, index) {
          final item = widget.data[index];
          final itemId = widget.idExtractor?.call(item);
          final isSelected = itemId != null && itemId == widget.selectedId;

          return GestureDetector(
            onTap: widget.onRowTap != null ? () => widget.onRowTap!(item) : null,
            onDoubleTap: widget.onRowDoubleTap != null
                ? () => widget.onRowDoubleTap!(item)
                : null,
            child: Container(
              height: widget.rowHeight ?? 40.h,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryBlue.withOpacity(0.1)
                    : (index % 2 == 0
                    ? AppColors.white
                    : AppColors.primaryBgColor.withOpacity(0.3)),
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.greyBorder.withOpacity(0.5),
                    width: 0.5,
                  ),
                ),
              ),
              child: widget.rowBuilder(item, index),
            ),
          );
        },
      ),
    );
  }
}

/// Simple table for quick use without generics
class SimpleDataTable extends StatelessWidget {
  final List<TableColumn> columns;
  final List<List<String>> rows;
  final String? sortColumn;
  final bool sortAscending;
  final Function(String columnId, bool ascending)? onSort;
  final int? selectedIndex;
  final Function(int index)? onRowTap;
  final String? emptyMessage;

  const SimpleDataTable({
    Key? key,
    required this.columns,
    required this.rows,
    this.sortColumn,
    this.sortAscending = true,
    this.onSort,
    this.selectedIndex,
    this.onRowTap,
    this.emptyMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonDataTable<List<String>>(
      columns: columns,
      data: rows,
      sortColumn: sortColumn,
      sortAscending: sortAscending,
      onSort: onSort,
      selectedId: selectedIndex?.toString(),
      idExtractor: (row) => rows.indexOf(row).toString(),
      onRowTap: onRowTap != null ? (row) => onRowTap!(rows.indexOf(row)) : null,
      emptyMessage: emptyMessage,
      rowBuilder: (row, index) {
        final visibleColumns = columns.where((c) => c.isVisible).toList();
        return Row(
          children: List.generate(visibleColumns.length, (i) {
            final column = visibleColumns[i];
            return Container(
              width: column.width,
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              alignment: _getAlignment(column.align),
              child: Text(
                i < row.length ? row[i] : '',
                style: GoogleFonts.openSans(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: LightThemeColors.textColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }),
        );
      },
    );
  }

  Alignment _getAlignment(TextAlign align) {
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