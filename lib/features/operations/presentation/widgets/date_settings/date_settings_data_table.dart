import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../domain/entities/date_settings/date_setting.dart';
class DateSettingsDataTable extends StatelessWidget {
  final List<dynamic> data;
  final Set<String> selectedIds;
  final ValueChanged<Set<String>> onSelectionChanged;
  const DateSettingsDataTable({
    super.key,
    required this.data,
    required this.selectedIds,
    required this.onSelectionChanged,
  });
  @override
  Widget build(BuildContext context) {
    return ViewDataTable(
      data: data,
      columns: _buildColumns(),
      cellBuilder: (item, column) {
        if (item is! DateSetting) return const SizedBox.shrink();
        if (column.id == 'checkbox') {
          return Checkbox(
            value: selectedIds.contains(item.id),
            onChanged: (_) {
              final newSelection = Set<String>.from(selectedIds);
              if (newSelection.contains(item.id)) {
                newSelection.remove(item.id);
              } else {
                newSelection.add(item.id);
              }
              onSelectionChanged(newSelection);
            },
            activeColor: AppColors.primaryBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.r),
            ),
          );
        }
        return _buildCell(item, column.id);
      },
      idExtractor: (item) {
        if (item is! DateSetting) return '';
        return item.id;
      },
      selectedId: selectedIds.isNotEmpty ? selectedIds.first : null,
      onRowTap: (item) {
        if (item is DateSetting) {
          final newSelection = Set<String>.from(selectedIds);
          if (newSelection.contains(item.id)) {
            newSelection.remove(item.id);
          } else {
            newSelection.add(item.id);
          }
          onSelectionChanged(newSelection);
        }
      },
      autoFit: true,
    );
  }
  List<ViewTableColumn> _buildColumns() {
    return [
      ViewTableColumn(
        id: 'checkbox',
        label: '',
        width: 50.w,
        sortable: false,
        customHeaderWidget: Checkbox(
          value: selectedIds.length == data.length && data.isNotEmpty,
          onChanged: (val) {
            if (val == true) {
              onSelectionChanged(
                data.whereType<DateSetting>().map((e) => e.id).toSet(),
              );
            } else {
              onSelectionChanged({});
            }
          },
          activeColor: AppColors.primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      ),
      ViewTableColumn(id: 'exchange', label: 'EXCH', width: 100.w),
      ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 150.w),
      ViewTableColumn(id: 'expiryDate', label: 'EXPIRY DATE', width: 150.w),
      ViewTableColumn(id: 'launchDate', label: 'LAUNCH DATE', width: 150.w),
      ViewTableColumn(id: 'closeDate', label: 'CLOSE DATE', width: 150.w),
      ViewTableColumn(id: 'cutDate', label: 'CUT DATE', width: 150.w),
      ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 200.w),
      ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 120.w),
    ];
  }
  Widget _buildCell(DateSetting item, String colId) {
    String text = '';
    switch (colId) {
      case 'exchange':
        text = item.exchange;
        break;
      case 'symbol':
        text = item.symbol;
        break;
      case 'expiryDate':
        text = item.expiryDate;
        break;
      case 'launchDate':
        text = item.launchDate;
        break;
      case 'closeDate':
        text = item.closeDate;
        break;
      case 'cutDate':
        text = item.cutDate;
        break;
      case 'updatedOn':
        text = item.updatedOn;
        break;
      case 'updatedBy':
        text = item.updatedBy;
        break;
    }
    return Text(
      text,
      style: GoogleFonts.openSans(
        fontSize: 12.sp,
        color: AppColors.primaryBlue,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
