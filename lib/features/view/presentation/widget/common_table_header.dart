import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/widget/svg_icon.dart';

/// Column configuration for table
class TableColumn {
  final String id;
  final String label;
  final double width;
  final bool sortable;
  final TextAlign align;
  final bool isVisible;

  const TableColumn({
    required this.id,
    required this.label,
    required this.width,
    this.sortable = true,
    this.align = TextAlign.center,
    this.isVisible = true,
  });

  TableColumn copyWith({
    String? id,
    String? label,
    double? width,
    bool? sortable,
    TextAlign? align,
    bool? isVisible,
  }) {
    return TableColumn(
      id: id ?? this.id,
      label: label ?? this.label,
      width: width ?? this.width,
      sortable: sortable ?? this.sortable,
      align: align ?? this.align,
      isVisible: isVisible ?? this.isVisible,
    );
  }
}

/// Reusable Table Header Widget
class CommonTableHeader extends StatelessWidget {
  final List<TableColumn> columns;
  final String? sortColumn;
  final bool sortAscending;
  final Function(String columnId, bool ascending)? onSort;
  final Color? backgroundColor;
  final Color? textColor;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const CommonTableHeader({
    Key? key,
    required this.columns,
    this.sortColumn,
    this.sortAscending = true,
    this.onSort,
    this.backgroundColor,
    this.textColor,
    this.height,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final visibleColumns = columns.where((c) => c.isVisible).toList();

    return Container(
      height: height ?? 48.h,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primaryBgColor,
        border: Border(
          bottom: BorderSide(color: AppColors.greyBorder, width: 1),
        ),
      ),
      child: Row(
        children: visibleColumns.map((column) {
          return _buildHeaderCell(column);
        }).toList(),
      ),
    );
  }

  Widget _buildHeaderCell(TableColumn column) {
    final isSorted = sortColumn == column.id;

    return GestureDetector(
      onTap: column.sortable && onSort != null
          ? () {
        onSort!(
          column.id,
          isSorted ? !sortAscending : true,
        );
      }
          : null,
      child: Container(
        width: column.width,
        padding: padding ?? EdgeInsets.symmetric(horizontal: 8.w),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                column.label,
                style: GoogleFonts.openSans(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: textColor ?? LightThemeColors.textColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              if (column.sortable) ...[
                SizedBox(width: 4.w),
                SvgIcon(
                  assetPath: AppImages.sortIcon,
                  isActive: isSorted,
                  size: 14.sp,
                  activeColor: isSorted ? AppColors.primaryBlue : null,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Simplified header cell for single use
class CommonHeaderCell extends StatelessWidget {
  final String label;
  final double width;
  final bool sortable;
  final bool isSorted;
  final bool sortAscending;
  final VoidCallback? onTap;
  final Color? textColor;

  const CommonHeaderCell({
    Key? key,
    required this.label,
    required this.width,
    this.sortable = true,
    this.isSorted = false,
    this.sortAscending = true,
    this.onTap,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: sortable ? onTap : null,
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: GoogleFonts.openSans(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: textColor ?? LightThemeColors.textColor,
                ),
              ),
              if (sortable) ...[
                SizedBox(width: 4.w),
                SvgIcon(
                  assetPath: AppImages.sortIcon,
                  isActive: isSorted,
                  size: 14.sp,
                  activeColor: isSorted ? AppColors.primaryBlue : null,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}