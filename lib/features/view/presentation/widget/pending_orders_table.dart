import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_images.dart';
import '../../../../../core/widget/svg_icon.dart';
import '../../domain/entities/pending_order.dart';
import '../bloc/pending_orders/pending_orders_bloc.dart';
import '../bloc/pending_orders/pending_orders_event.dart';
import '../bloc/pending_orders/pending_orders_state.dart';

/// Column configuration for Pending Orders table
class _ColumnConfig {
  final String id;
  final String label;
  final double width;
  final bool sortable;
  final TextAlign align;

  const _ColumnConfig({
    required this.id,
    required this.label,
    required this.width,
    this.sortable = true,
    this.align = TextAlign.center,
  });
}

/// Pending Orders Data Table
class PendingOrdersTable extends StatefulWidget {
  final bool showDeviceInfo;

  const PendingOrdersTable({
    Key? key,
    this.showDeviceInfo = false,
  }) : super(key: key);

  @override
  State<PendingOrdersTable> createState() => _PendingOrdersTableState();
}

class _PendingOrdersTableState extends State<PendingOrdersTable> {
  final ScrollController _horizontalController = ScrollController();
  final ScrollController _verticalController = ScrollController();

  // Column configurations
  List<_ColumnConfig> get _columns => [
    _ColumnConfig(id: 'userId', label: 'USER ID', width: 100.w),
    _ColumnConfig(id: 'upline', label: 'UPLINE', width: 100.w),
    _ColumnConfig(id: 'exchange', label: 'EXCH', width: 80.w),
    _ColumnConfig(id: 'symbol', label: 'SYMBOL', width: 120.w),
    _ColumnConfig(id: 'buySell', label: 'B/S', width: 180.w),
    _ColumnConfig(id: 'qty', label: 'QTY', width: 100.w, align: TextAlign.right),
    _ColumnConfig(id: 'lot', label: 'LOT', width: 80.w, align: TextAlign.right),
    _ColumnConfig(id: 'triggerPrice', label: 'T. PRICE', width: 120.w, align: TextAlign.right),
    _ColumnConfig(id: 'orderDateTime', label: 'ORDER D/T', width: 180.w),
    _ColumnConfig(id: 'modifyOrderDateTime', label: 'MODIFY ORDER D/T', width: 180.w),
    _ColumnConfig(id: 'orderType', label: 'TYPE', width: 80.w),
    _ColumnConfig(id: 'cmp', label: 'CMP', width: 100.w, align: TextAlign.right),
    _ColumnConfig(id: 'rPrice', label: 'R.PRICE', width: 100.w, align: TextAlign.right),
    if (widget.showDeviceInfo) ...[
      _ColumnConfig(id: 'deviceId', label: 'DEVICE ID', width: 280.w),
      _ColumnConfig(id: 'ipAddress', label: 'IP ADDRESS', width: 120.w),
    ],
  ];

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PendingOrdersBloc, PendingOrdersState>(
      builder: (context, state) {
        if (state is PendingOrdersLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is PendingOrdersError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.message,
                  style: GoogleFonts.openSans(
                    fontSize: 14.sp,
                    color: AppColors.red,
                  ),
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () {
                    context.read<PendingOrdersBloc>().add(
                      const LoadPendingOrdersEvent(),
                    );
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
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

  Widget _buildTable(PendingOrdersLoaded state) {
    final totalWidth = _columns.fold<double>(0, (sum, col) => sum + col.width);

    return Scrollbar(
      controller: _horizontalController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _horizontalController,
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: totalWidth,
          child: Column(
            children: [
              // Header
              _buildHeader(state),
              // Data rows
              Expanded(
                child: _buildDataRows(state),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(PendingOrdersLoaded state) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: AppColors.primaryBgColor,
        border: Border(
          bottom: BorderSide(color: AppColors.greyBorder, width: 1),
        ),
      ),
      child: Row(
        children: _columns.map((column) {
          return _buildHeaderCell(column, state);
        }).toList(),
      ),
    );
  }

  Widget _buildHeaderCell(_ColumnConfig column, PendingOrdersLoaded state) {
    final isSorted = state.sortColumn == column.id;

    return GestureDetector(
      onTap: column.sortable
          ? () {
        context.read<PendingOrdersBloc>().add(
          SortByColumnEvent(
            columnId: column.id,
            ascending: isSorted ? !state.sortAscending : true,
          ),
        );
      }
          : null,
      child: Container(
        width: column.width,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                column.label,
                style: GoogleFonts.openSans(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: LightThemeColors.textColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
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
    );
  }

  Widget _buildDataRows(PendingOrdersLoaded state) {
    if (state.filteredOrders.isEmpty) {
      return Center(
        child: Text(
          'No orders found',
          style: GoogleFonts.openSans(
            fontSize: 14.sp,
            color: LightThemeColors.supportiveTextColor,
          ),
        ),
      );
    }

    return Scrollbar(
      controller: _verticalController,
      thumbVisibility: true,
      child: ListView.builder(
        controller: _verticalController,
        itemCount: state.filteredOrders.length,
        itemBuilder: (context, index) {
          final order = state.filteredOrders[index];
          final isSelected = state.selectedOrderId == order.id;
          final isEven = index % 2 == 0;

          return GestureDetector(
            onTap: () {
              context.read<PendingOrdersBloc>().add(
                SelectOrderEvent(order.id),
              );
            },
            child: Container(
              height: 40.h,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryBlue.withOpacity(0.1)
                    : (isEven ? AppColors.white : AppColors.primaryBgColor.withOpacity(0.3)),
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.greyBorder.withOpacity(0.5),
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: _columns.map((column) {
                  return _buildDataCell(column, order);
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDataCell(_ColumnConfig column, PendingOrder order) {
    final value = _getCellValue(column.id, order);
    final textColor = _getCellColor(column.id, order);

    return Container(
      width: column.width,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      alignment: _getAlignment(column.align),
      child: Text(
        value,
        style: GoogleFonts.openSans(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  String _getCellValue(String columnId, PendingOrder order) {
    switch (columnId) {
      case 'userId':
        return order.userId;
      case 'upline':
        return order.upline;
      case 'exchange':
        return order.exchange;
      case 'symbol':
        return order.symbol;
      case 'buySell':
        return order.buySell;
      case 'qty':
        return _formatNumber(order.qty);
      case 'lot':
        return order.lot.toStringAsFixed(2);
      case 'triggerPrice':
        return _formatNumber(order.triggerPrice);
      case 'orderDateTime':
        return _formatDateTime(order.orderDateTime);
      case 'modifyOrderDateTime':
        return _formatDateTime(order.modifyOrderDateTime);
      case 'orderType':
        return order.orderType;
      case 'cmp':
        return _formatNumber(order.cmp);
      case 'rPrice':
        return _formatNumber(order.rPrice);
      case 'deviceId':
        return order.deviceId ?? '-';
      case 'ipAddress':
        return order.ipAddress ?? '-';
      default:
        return '-';
    }
  }

  Color _getCellColor(String columnId, PendingOrder order) {
    switch (columnId) {
      case 'symbol':
        return AppColors.primaryBlue;
      case 'buySell':
        return order.isBuy ? LightThemeColors.positiveTextColor : LightThemeColors.negativeTextColor;
      case 'qty':
        return order.qty >= 0 ? LightThemeColors.textColor : LightThemeColors.negativeTextColor;
      case 'triggerPrice':
        return order.triggerPrice >= 0 ? AppColors.primaryBlue : LightThemeColors.negativeTextColor;
      case 'cmp':
      case 'rPrice':
        return AppColors.primaryBlue;
      default:
        return LightThemeColors.textColor;
    }
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

  String _formatNumber(double value) {
    if (value == value.toInt()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(2);
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yy hh:mm:ss a').format(dateTime);
  }
}