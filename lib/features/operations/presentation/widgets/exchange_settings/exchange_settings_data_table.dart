import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/app_switch.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';

class ExchangeSettingsDataTable extends StatelessWidget {
  final List<dynamic> data;
  final Set<String> selectedIds;
  final ValueChanged<Set<String>> onSelectionChanged;
  final List<ViewTableColumn> columns;
  final int activeTab;
  final Map<String, TextEditingController>? sequenceControllers;
  final Map<String, bool>? watchlistStates;
  final ValueChanged<String>? onWatchlistToggle;
  const ExchangeSettingsDataTable({
    super.key,
    required this.data,
    required this.selectedIds,
    required this.onSelectionChanged,
    required this.columns,
    this.activeTab = 0,
    this.sequenceControllers,
    this.watchlistStates,
    this.onWatchlistToggle,
  });
  @override
  Widget build(BuildContext context) {
    final allColumns = [_checkboxColumn(), ...columns];
    return ViewDataTable<dynamic>(
      autoFit: true,
      columns: allColumns,
      data: data,
      idExtractor: (item) => item.id,
      comparatorBuilder: (item, columnId) {
        return '';
      },
      cellBuilder: (item, column) => _buildCell(item, column),
    );
  }

  ViewTableColumn _checkboxColumn() {
    return ViewTableColumn(
      id: 'checkbox',
      label: '',
      width: 40.w,
      sortable: false,
      customHeaderWidget: Checkbox(
        value: selectedIds.length == data.length && data.isNotEmpty,
        onChanged: (val) {
          if (val == true) {
            onSelectionChanged(data.map((e) => e.id as String).toSet());
          } else {
            onSelectionChanged({});
          }
        },
        activeColor: AppColors.primaryBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
      ),
    );
  }

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
    if (column.id == 'sequence') {
      final ctrl = sequenceControllers?[item.id];
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
        child: TextField(
          controller: ctrl,
          textAlign: TextAlign.center,
          style: GoogleFonts.openSans(
            fontSize: 10.sp,
            color: AppColors.primaryBlue,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 8.h,
            ),
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.r),
              borderSide: BorderSide(color: AppColors.primaryBlue, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.r),
              borderSide: BorderSide(color: AppColors.primaryBlue, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.r),
              borderSide: BorderSide(color: AppColors.primaryBlue, width: 2),
            ),
          ),
        ),
      );
    }
    if (column.id == 'showInWatchlist') {
      final isOn = watchlistStates?[item.id] ?? item.showInWatchlist ?? false;
      return AppSwitch(
        value: isOn,
        onChanged: (val) => onWatchlistToggle?.call(item.id),
      );
    }
    String value = '';
    switch (column.id) {
      case 'exchange':
        value = item.exchange;
        break;
      case 'betweenHighLow':
        value = item.betweenHighLowLimitPlace ? 'Yes' : 'No';
        break;
      case 'autoTickSize':
        value = item.autoTickSize ? 'Yes' : 'No';
        break;
      case 'tickSize':
        value = item.tickSize;
        break;
      case 'orderType':
        value = (item.orderType as List).join(', ');
        break;
      case 'oddLot':
        value = item.oddLot ? 'Yes' : 'No';
        break;
      case 'marketPriceType':
        value = item.marketPriceType;
        break;
      case 'updatedOn':
        value = item.updatedOn;
        break;
      case 'updatedBy':
        value = item.updatedBy;
        break;
      case 'symbol':
        value = item.symbol;
        break;
      default:
        value = '';
    }
    final isNumericCol = const {'tickSize', 'updatedOn'}.contains(column.id);
    return ViewTextCell(text: value, isDark: false, isNumeric: isNumericCol);
  }
}
