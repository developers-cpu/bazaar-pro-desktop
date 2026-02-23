import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/app_switch.dart';
import '../../../../../core/widget/table/view_data_table.dart';

class GroupDataTable extends StatelessWidget {
  final int viewLevel;
  final List<dynamic> groups;
  final Set<String> selectedIds;
  final Map<String, bool> hideGroupState;
  final ValueChanged<Set<String>> onSelectionChanged;
  final ValueChanged<MapEntry<String, bool>> onHideGroupChanged;
  final void Function(String exchange) onExchangeTap;
  final void Function(dynamic item) onGroupNameTap;
  final void Function(dynamic item) onActionTap;
  final void Function() onImportTap;

  const GroupDataTable({
    super.key,
    required this.viewLevel,
    required this.groups,
    required this.selectedIds,
    required this.hideGroupState,
    required this.onSelectionChanged,
    required this.onHideGroupChanged,
    required this.onExchangeTap,
    required this.onGroupNameTap,
    required this.onActionTap,
    required this.onImportTap,
  });

  @override
  Widget build(BuildContext context) {
    final columns = _buildColumns();

    return ViewDataTable<dynamic>(
      autoFit: true,
      columns: columns,
      data: groups,
      idExtractor: (item) => item.id,
      cellBuilder: (item, column) => _buildCell(item, column),
    );
  }

  List<ViewTableColumn> _buildColumns() {
    final List<ViewTableColumn> columns = [_checkboxColumn()];

    switch (viewLevel) {
      case 0:
        columns.addAll(_level0Columns());
        break;
      case 1:
        columns.addAll(_level1Columns());
        break;
      default:
        columns.addAll(_level2Columns());
    }

    return columns;
  }

  ViewTableColumn _checkboxColumn() {
    return ViewTableColumn(
      id: 'checkbox',
      label: '',
      width: 40.w,
      sortable: false,
      customHeaderWidget: Checkbox(
        value: selectedIds.length == groups.length && groups.isNotEmpty,
        onChanged: (val) {
          if (val == true) {
            onSelectionChanged(groups.map((e) => e.id as String).toSet());
          } else {
            onSelectionChanged({});
          }
        },
        activeColor: AppColors.primaryBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
      ),
    );
  }

  List<ViewTableColumn> _level0Columns() => [
    ViewTableColumn(id: 'exchange', label: 'EXCHANGE', width: 120.w),
    ViewTableColumn(id: 'groups_summary', label: 'GROUP NAME', width: 350.w),
    ViewTableColumn(id: 'count', label: 'COUNT', width: 100.w),
    ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 220.w),
    ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 150.w),
  ];

  List<ViewTableColumn> _level1Columns() => [
    ViewTableColumn(id: 'groupName', label: 'GROUP NAME', width: 150.w),
    ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 180.w),
    ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 120.w),
    ViewTableColumn(id: 'defaultGroup', label: 'DEFAULT GROUP', width: 120.w),
    ViewTableColumn(id: 'import', label: 'IMPORT', width: 120.w),
    ViewTableColumn(id: 'hideGroup', label: 'HIDE GROUP', width: 120.w),
    ViewTableColumn(id: 'action', label: 'ACTION', width: 80.w),
  ];

  List<ViewTableColumn> _level2Columns() => [
    ViewTableColumn(id: 'groupName', label: 'GROUP NAME', width: 150.w),
    ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 200.w),
    ViewTableColumn(id: 'lotSize', label: 'LOT SIZE', width: 100.w),
    ViewTableColumn(id: 'maxQty', label: 'MAX QUANTITY', width: 150.w),
    ViewTableColumn(id: 'breakupQty', label: 'BREAKUP QUANTITY', width: 150.w),
    ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 200.w),
    ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 120.w),
  ];

  Widget _buildCell(dynamic item, ViewTableColumn column) {
    if (column.id == 'checkbox') {
      return Checkbox(
        value: selectedIds.contains(item.id),
        onChanged: (val) {
          final updated = Set<String>.from(selectedIds);
          if (val == true) {
            updated.add(item.id);
          } else {
            updated.remove(item.id);
          }
          onSelectionChanged(updated);
        },
        activeColor: AppColors.primaryBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
      );
    }

    switch (column.id) {
      case 'import':
        return _importCell();
      case 'hideGroup':
        return _hideGroupCell(item);
      case 'action':
        return _actionCell(item);
    }

    final cellInfo = _textCellInfo(item, column.id);
    return InkWell(
      onTap: cellInfo.onTap,
      child: Text(
        cellInfo.value,
        style: GoogleFonts.openSans(
          fontSize: 12.sp,
          color: AppColors.primaryBlue,
          decoration: cellInfo.underlined ? TextDecoration.underline : null,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _importCell() {
    return InkWell(
      onTap: onImportTap,
      child: Text(
        'Choose File',
        style: GoogleFonts.openSans(
          fontSize: 12.sp,
          color: AppColors.primaryBlue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _hideGroupCell(dynamic item) {
    final key = '${item.id}';
    final isHidden = hideGroupState[key] ?? false;
    return AppSwitch(
      value: isHidden,
      onChanged: (val) => onHideGroupChanged(MapEntry(key, val)),
    );
  }

  Widget _actionCell(dynamic item) {
    return IconButton(
      icon: Icon(Icons.edit, size: 18.sp, color: AppColors.primaryBlue),
      onPressed: () => onActionTap(item),
    );
  }

  _CellInfo _textCellInfo(dynamic item, String columnId) {
    switch (columnId) {
      case 'exchange':
        return _CellInfo(
          value: item.exchange,
          underlined: true,
          onTap: () => onExchangeTap(item.exchange),
        );
      case 'groups_summary':
        return _CellInfo(value: item.groupName);
      case 'groupName':
        if (viewLevel == 1) {
          return _CellInfo(
            value: item.groupName,
            underlined: true,
            onTap: () => onGroupNameTap(item),
          );
        }
        return _CellInfo(value: item.groupName);
      case 'count':
        return _CellInfo(value: item.count);
      case 'updatedOn':
        return _CellInfo(value: item.updatedOn);
      case 'updatedBy':
        return _CellInfo(value: item.updatedBy);
      case 'defaultGroup':
        return _CellInfo(value: 'Yes');
      case 'symbol':
        return _CellInfo(value: 'ABB25DECFUT');
      case 'lotSize':
        return _CellInfo(value: '125');
      case 'maxQty':
        return _CellInfo(value: '2500');
      case 'breakupQty':
        return _CellInfo(value: '5');
      default:
        return _CellInfo(value: '');
    }
  }
}

class _CellInfo {
  final String value;
  final bool underlined;
  final VoidCallback? onTap;

  _CellInfo({required this.value, this.underlined = false, this.onTap});
}
