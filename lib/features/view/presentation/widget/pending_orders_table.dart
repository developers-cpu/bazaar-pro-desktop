import 'package:bazarpro/features/view/presentation/widget/table/pending_orders_column_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../market_watch/presentation/bloc/arrangesymbol/arrange_symbol_state.dart';
import '../../../market_watch/presentation/widgets/table/table_header_cell.dart';
import '../../domain/entities/pending_order.dart' show PendingOrder;
import '../bloc/pending_orders/pending_orders_bloc.dart' show PendingOrdersBloc;
import '../bloc/pending_orders/pending_orders_event.dart';
import '../bloc/pending_orders/pending_orders_state.dart';
import 'table/pending_orders_cell_builder.dart';


/// Pending Orders Data Table using data_table_2 package
class PendingOrdersTable extends StatefulWidget {
  final bool showDeviceInfo;
  final bool isDarkMode;

  const PendingOrdersTable({
    Key? key,
    this.showDeviceInfo = false,
    this.isDarkMode = false,
  }) : super(key: key);

  @override
  State<PendingOrdersTable> createState() => _PendingOrdersTableState();
}

class _PendingOrdersTableState extends State<PendingOrdersTable> {
  int? _sortColumnIndex;
  bool _sortAscending = true;

  // Font settings - can be made dynamic via BLoC
  final String _fontFamily = 'Open Sans';
  final double _fontSize = 13.0;
  final FontWeight _fontWeight = FontWeight.w500;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PendingOrdersBloc, PendingOrdersState>(
      builder: (context, state) {
        if (state is PendingOrdersLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is PendingOrdersError) {
          return _buildErrorState(state.message);
        }

        if (state is! PendingOrdersLoaded) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            // Record count
            _buildRecordCount(state.totalRecords),
            // Table
            Expanded(
              child: _buildTable(state),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRecordCount(int count) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      alignment: Alignment.centerRight,
      child: Text(
        'RECORD : $count',
        style: GoogleFonts.openSans(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryBlue,
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: GoogleFonts.openSans(
              fontSize: 14.sp,
              color: AppColors.red,
            ),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () {
              context.read<PendingOrdersBloc>().add(const LoadPendingOrdersEvent());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(PendingOrdersLoaded state) {
    final isDark = widget.isDarkMode;
    final visibleColumns = PendingOrdersColumnHelper.getDefaultColumns(
      showDeviceInfo: widget.showDeviceInfo,
    );
    final minWidth = PendingOrdersColumnHelper.calculateMinWidth(visibleColumns, _fontSize);

    if (state.filteredOrders.isEmpty) {
      return _buildEmptyState(isDark);
    }

    return _buildTableContainer(
      isDark: isDark,
      visibleColumns: visibleColumns,
      minWidth: minWidth,
      state: state,
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Container(
      color: isDark ? DarkThemeColors.backgroundColor : LightThemeColors.backgroundColor,
      child: Center(
        child: Text(
          'No orders found',
          style: GoogleFonts.openSans(
            fontSize: 16.sp,
            color: isDark
                ? DarkThemeColors.supportiveTextColor
                : LightThemeColors.supportiveTextColor,
          ),
        ),
      ),
    );
  }

  Widget _buildTableContainer({
    required bool isDark,
    required List<ColumnItem> visibleColumns,
    required double minWidth,
    required PendingOrdersLoaded state,
  }) {
    return Container(
      margin: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: isDark ? DarkThemeColors.backgroundColor : LightThemeColors.backgroundColor,
        border: Border.all(
          color: isDark ? DarkThemeColors.dividerColor : LightThemeColors.dividerColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: _buildDataTable(
          isDark: isDark,
          visibleColumns: visibleColumns,
          minWidth: minWidth,
          state: state,
        ),
      ),
    );
  }

  Widget _buildDataTable({
    required bool isDark,
    required List<ColumnItem> visibleColumns,
    required double minWidth,
    required PendingOrdersLoaded state,
  }) {
    final rowHeight = (_fontSize * 3.2).clamp(48.0, 80.0);
    final headerHeight = (_fontSize * 3.5).clamp(55.0, 85.0);

    return DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      minWidth: minWidth,
      headingRowHeight: headerHeight.h,
      dataRowHeight: rowHeight.h,
      headingRowColor: WidgetStateProperty.all(
        LightThemeColors.tableColumnHeadColor,
      ),
      dividerThickness: 1,
      border: TableBorder.all(
        color: isDark ? AppColors.white.withOpacity(0.2) : AppColors.greyBorder,
        width: 0.5,
      ),
      sortColumnIndex: _sortColumnIndex,
      sortAscending: _sortAscending,
      columns: _buildColumns(
        visibleColumns: visibleColumns,
        isDark: isDark,
      ),
      rows: _buildRows(
        visibleColumns: visibleColumns,
        isDark: isDark,
        state: state,
      ),
    );
  }

  List<DataColumn2> _buildColumns({
    required List<ColumnItem> visibleColumns,
    required bool isDark,
  }) {
    return visibleColumns.asMap().entries.map((entry) {
      final index = entry.key;
      final column = entry.value;
      final config = PendingOrdersColumnHelper.getConfig(column.id);

      return DataColumn2(
        label: TableHeaderCell(
          title: PendingOrdersColumnHelper.getLabel(column.id),
          isDark: isDark,
          fontFamily: _fontFamily,
          fontSize: _fontSize,
          fontWeight: FontWeight.w600,
        ),
        size: _getColumnSize(visibleColumns.length),
        numeric: config?.isNumeric ?? false,
        onSort: (columnIndex, ascending) => _onSort(columnIndex, ascending, column.id),
      );
    }).toList();
  }

  ColumnSize _getColumnSize(int visibleColumnCount) {
    if (visibleColumnCount <= 5) {
      return ColumnSize.L;
    } else if (visibleColumnCount <= 10) {
      return ColumnSize.M;
    }
    return ColumnSize.S;
  }

  void _onSort(int columnIndex, bool ascending, String columnId) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });

    context.read<PendingOrdersBloc>().add(
      SortByColumnEvent(columnId: columnId, ascending: ascending),
    );
  }

  List<DataRow2> _buildRows({
    required List<ColumnItem> visibleColumns,
    required bool isDark,
    required PendingOrdersLoaded state,
  }) {
    return state.filteredOrders.map((item) {
      final isSelected = state.selectedOrderId == item.id;

      return DataRow2(
        selected: isSelected,
        color: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            return isDark
                ? DarkThemeColors.selectedRowBackground
                : LightThemeColors.selectedRowBackground;
          }
          return isDark
              ? DarkThemeColors.backgroundColor
              : LightThemeColors.backgroundColor;
        }),
        onTap: () => _onRowTap(item.id),
        cells: _buildCells(
          visibleColumns: visibleColumns,
          item: item,
          isDark: isDark,
        ),
      );
    }).toList();
  }

  void _onRowTap(String itemId) {
    context.read<PendingOrdersBloc>().add(SelectOrderEvent(itemId));
  }

  List<DataCell> _buildCells({
    required List<ColumnItem> visibleColumns,
    required PendingOrder item,
    required bool isDark,
  }) {
    return visibleColumns.map((column) {
      return DataCell(
        PendingOrdersCellBuilder(
          columnId: column.id,
          item: item,
          isDark: isDark,
          fontFamily: _fontFamily,
          fontSize: _fontSize,
          fontWeight: _fontWeight,
        ),
      );
    }).toList();
  }
}