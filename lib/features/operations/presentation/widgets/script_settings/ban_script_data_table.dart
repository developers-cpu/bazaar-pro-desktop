import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/app_switch.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../domain/entities/script_settings/script_setting.dart';

class BanScriptDataTable extends StatelessWidget {
  final List<ScriptSetting> data;
  final Set<String> selectedIds;
  final ValueChanged<Set<String>> onSelectionChanged;
  final Function(String id, bool isBanned) onToggleStatus;
  const BanScriptDataTable({
    super.key,
    required this.data,
    required this.selectedIds,
    required this.onSelectionChanged,
    required this.onToggleStatus,
  });
  @override
  Widget build(BuildContext context) {
    return ViewDataTable(
      data: data,
      columns: _buildColumns(),
      comparatorBuilder: (item, columnId) {
        switch (columnId) {
          case 'symbol':
            return item.symbol;
          case 'updatedOn':
            return item.updatedOn;
          case 'updatedBy':
            return item.updatedBy;
          case 'status':
            return item.isBanned ? 1 : 0;
          default:
            return '';
        }
      },
      cellBuilder: (item, column) {
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
        if (column.id == 'status') {
          return AppSwitch(
            value: item.isBanned,
            onChanged: (val) => onToggleStatus(item.id, val),
          );
        }
        return _buildCell(item, column.id);
      },
      idExtractor: (item) => item.id,
      selectedId: selectedIds.isNotEmpty ? selectedIds.first : null,
      onRowTap: (item) {
        final newSelection = Set<String>.from(selectedIds);
        if (newSelection.contains(item.id)) {
          newSelection.remove(item.id);
        } else {
          newSelection.add(item.id);
        }
        onSelectionChanged(newSelection);
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
              onSelectionChanged(data.map((e) => e.id).toSet());
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
      ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 200.w),
      ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 250.w),
      ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 200.w),
      ViewTableColumn(id: 'status', label: 'STATUS', width: 120.w),
    ];
  }

  Widget _buildCell(ScriptSetting item, String colId) {
    String text = '';
    switch (colId) {
      case 'symbol':
        text = item.symbol;
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
