import 'package:bazarpro/core/constants/app_colors.dart';
import 'package:bazarpro/core/constants/app_images.dart';
import 'package:bazarpro/core/widget/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewTableColumn {
  final String id;
  final String label;
  final double width;
  final bool isNumeric;
  final bool sortable;
  final Widget? customHeaderWidget;
  const ViewTableColumn({
    required this.id,
    required this.label,
    required this.width,
    this.isNumeric = false,
    this.sortable = true,
    this.customHeaderWidget,
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
  final bool autoFit;
  final Color? headerBgColor;
  final bool shrinkWrap;
  final Comparable Function(T item, String columnId)? comparatorBuilder;
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
    this.autoFit = false,
    this.headerBgColor,
    this.shrinkWrap = false,
    this.comparatorBuilder,
  }) : super(key: key);
  @override
  State<ViewDataTable<T>> createState() => _ViewDataTableState<T>();
}

class _ViewDataTableState<T> extends State<ViewDataTable<T>> {
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();
  String? _internalSortColumn;
  bool _internalSortAscending = true;
  List<T>? _sortedData;

  bool get _useInternalSort =>
      widget.comparatorBuilder != null && widget.onSort == null;

  String? get _activeSortColumn =>
      _useInternalSort ? _internalSortColumn : widget.sortColumn;
  bool get _activeSortAscending =>
      _useInternalSort ? _internalSortAscending : widget.sortAscending;

  List<T> get _displayData {
    if (_useInternalSort && _sortedData != null) {
      return _sortedData!;
    }
    return widget.data;
  }

  void _handleSort(String columnId) {
    if (_useInternalSort) {
      setState(() {
        if (_internalSortColumn == columnId) {
          _internalSortAscending = !_internalSortAscending;
        } else {
          _internalSortColumn = columnId;
          _internalSortAscending = true;
        }
        _sortedData = List<T>.from(widget.data);
        _sortedData!.sort((a, b) {
          final aVal = widget.comparatorBuilder!(a, columnId);
          final bVal = widget.comparatorBuilder!(b, columnId);
          final comparison = aVal.compareTo(bVal);
          return _internalSortAscending ? comparison : -comparison;
        });
      });
    } else if (widget.onSort != null) {
      final newAscending = _activeSortColumn == columnId
          ? !_activeSortAscending
          : true;
      widget.onSort!(columnId, newAscending);
    }
  }

  @override
  void didUpdateWidget(covariant ViewDataTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_useInternalSort && oldWidget.data != widget.data) {
      if (_internalSortColumn != null) {
        _sortedData = List<T>.from(widget.data);
        _sortedData!.sort((a, b) {
          final aVal = widget.comparatorBuilder!(a, _internalSortColumn!);
          final bVal = widget.comparatorBuilder!(b, _internalSortColumn!);
          final comparison = aVal.compareTo(bVal);
          return _internalSortAscending ? comparison : -comparison;
        });
      } else {
        _sortedData = null;
      }
    }
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  double get _totalFixedScaleWidth {
    return widget.columns.fold<double>(0, (sum, col) => sum + col.width);
  }

  Color get _headerBgColor =>
      widget.headerBgColor ??
      (widget.isDarkMode
          ? DarkThemeColors.tableColumnHeadColor
          : LightThemeColors.tableColumnHeadColor);
  Color get _rowBgColor => widget.isDarkMode
      ? DarkThemeColors.tableRowBackground
      : LightThemeColors.tableRowBackground;
  Color get _selectedRowBgColor => widget.isDarkMode
      ? DarkThemeColors.selectedRowBackground
      : LightThemeColors.selectedRowBackground;
  Color get _dividerColor =>
      widget.isDarkMode ? DarkThemeColors.dividerColor : AppColors.greyBorder;
  Color get _headerDividerColor => widget.isDarkMode
      ? DarkThemeColors.dividerColor.withOpacity(0.5)
      : AppColors.white.withOpacity(0.8);
  Color get _textColor => widget.isDarkMode
      ? DarkThemeColors.textColor
      : LightThemeColors.textColor;
  @override
  Widget build(BuildContext context) {
    final rowHeight = widget.rowHeight ?? 30.h;
    final headerHeight = widget.headerHeight ?? 35.h;
    return Container(
      margin: EdgeInsets.fromLTRB(0.w, 4.h, 0.w, 10.h),
      decoration: BoxDecoration(
        color: _rowBgColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: _dividerColor.withOpacity(0.5), width: 1),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double scale = 1.0;
          double totalWidth = _totalFixedScaleWidth;
          if (widget.autoFit && constraints.maxWidth > totalWidth) {
            scale = constraints.maxWidth / totalWidth;
            totalWidth = constraints.maxWidth;
          }
          return ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: widget.shrinkWrap
                ? _buildShrinkWrapContent(
                    headerHeight,
                    rowHeight,
                    totalWidth,
                    scale,
                  )
                : _buildExpandedContent(
                    headerHeight,
                    rowHeight,
                    totalWidth,
                    scale,
                  ),
          );
        },
      ),
    );
  }

  Widget _buildExpandedContent(
    double headerHeight,
    double rowHeight,
    double totalWidth,
    double scale,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: Scrollbar(
            controller: _horizontalScrollController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _horizontalScrollController,
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: totalWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeaderRow(headerHeight, scale),
                    Flexible(
                      fit: FlexFit.loose,
                      child: _displayData.isEmpty
                          ? _buildEmptyState()
                          : _buildDataRows(rowHeight, scale),
                    ),
                    if (widget.footerBuilder != null)
                      _buildFooterRow(rowHeight, scale),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShrinkWrapContent(
    double headerHeight,
    double rowHeight,
    double totalWidth,
    double scale,
  ) {
    return SingleChildScrollView(
      controller: _horizontalScrollController,
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: totalWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeaderRow(headerHeight, scale),
            _displayData.isEmpty
                ? SizedBox(height: 50.h, child: _buildEmptyState())
                : _buildDataRows(rowHeight, scale),
            if (widget.footerBuilder != null) _buildFooterRow(rowHeight, scale),
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

  Widget _buildHeaderRow(double headerHeight, double scale) {
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
          return _buildHeaderCell(column, isLast, scale);
        }).toList(),
      ),
    );
  }

  Widget _buildHeaderCell(ViewTableColumn column, bool isLast, double scale) {
    final isSorted = _activeSortColumn == column.id;
    final cellWidth = column.width * scale;
    return GestureDetector(
      onTap: column.sortable ? () => _handleSort(column.id) : null,
      child: Container(
        width: cellWidth,
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
              if (column.customHeaderWidget != null)
                column.customHeaderWidget!
              else ...[
                Flexible(
                  child: Text(
                    column.label,
                    style: GoogleFonts.openSans(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataRows(double rowHeight, double scale) {
    return Scrollbar(
      controller: widget.shrinkWrap ? null : _verticalScrollController,
      thumbVisibility: !widget.shrinkWrap,
      child: ListView.builder(
        controller: widget.shrinkWrap ? null : _verticalScrollController,
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: widget.shrinkWrap
            ? const NeverScrollableScrollPhysics()
            : const ClampingScrollPhysics(),
        itemCount: _displayData.length,
        itemBuilder: (context, index) {
          final item = _displayData[index];
          final itemId = widget.idExtractor(item);
          final isSelected = itemId == widget.selectedId;
          final isLast = index == _displayData.length - 1;
          return _buildDataRow(
            item,
            index,
            isSelected,
            isLast,
            rowHeight,
            scale,
          );
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
    double scale,
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
                    color: _dividerColor.withOpacity(0.5),
                    width: 1,
                  ),
                ),
        ),
        child: Row(
          children: widget.columns.map((column) {
            return Container(
              width: column.width * scale,
              alignment: Alignment.center,
              child: widget.cellBuilder(item, column),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFooterRow(double rowHeight, double scale) {
    final scaledColumns = widget.columns
        .map(
          (c) => ViewTableColumn(
            id: c.id,
            label: c.label,
            width: c.width * scale,
            isNumeric: c.isNumeric,
            sortable: c.sortable,
          ),
        )
        .toList();
    return Container(
      height: rowHeight,
      decoration: BoxDecoration(
        color: _headerBgColor,
        border: Border(top: BorderSide(color: _dividerColor, width: 1)),
      ),
      child: widget.footerBuilder!(scaledColumns),
    );
  }
}
