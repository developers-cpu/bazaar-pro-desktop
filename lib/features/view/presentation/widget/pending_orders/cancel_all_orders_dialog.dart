import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../domain/entities/pending_orders/pending_order.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../../../../core/widget/table/success_dialog.dart';
import 'trade_details_dialog.dart';
import '../../../../../core/widget/custom_action_button.dart';
import '../../../../../core/widget/custom_outlined_button.dart';
class CancelAllOrdersDialog extends StatefulWidget {
  final List<PendingOrder> pendingOrders;
  final bool isDarkMode;
  const CancelAllOrdersDialog({
    Key? key,
    required this.pendingOrders,
    this.isDarkMode = false,
  }) : super(key: key);
  static void show({
    required BuildContext context,
    required List<PendingOrder> pendingOrders,
    bool isDarkMode = false,
  }) {
    showDialog(
      context: context,
      barrierColor: AppColors.black.withOpacity(0.54),
      builder: (_) => CancelAllOrdersDialog(
        pendingOrders: pendingOrders,
        isDarkMode: isDarkMode,
      ),
    );
  }
  @override
  State<CancelAllOrdersDialog> createState() => _CancelAllOrdersDialogState();
}
class _CancelAllOrdersDialogState extends State<CancelAllOrdersDialog> {
  final Set<String> _selectedOrderIds = {};
  String? _selectedUser;
  List<String> _users = ['All Users'];
  @override
  void initState() {
    super.initState();
    _users.addAll(widget.pendingOrders.map((o) => o.userId).toSet().toList());
  }
  List<PendingOrder> get _filteredOrders {
    if (_selectedUser == null || _selectedUser == 'All Users') {
      return widget.pendingOrders;
    }
    return widget.pendingOrders
        .where((o) => o.userId == _selectedUser)
        .toList();
  }
  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: 'Cancel Order',
      isDarkMode: widget.isDarkMode,
      width: 900.w,
      height: 650.h,
      headerColor: AppColors.primaryBlue,
      showButtons: false,
      autoPop: false,
      onCancel: () {
        Navigator.pop(context);
        if (_filteredOrders.isNotEmpty) {
          Future.delayed(Duration.zero, () {
            TradeDetailsDialog.show(
              context: context,
              order: _filteredOrders.first,
              isDarkMode: widget.isDarkMode,
            );
          });
        }
      },
      onSave: () {
        Future.delayed(Duration.zero, () {
          SuccessDialog.show(
            context: context,
            title: 'Successful Deleted !',
            subtitle: 'Your Order is Successfully Deleted',
          );
        });
      },
      scrollable: false,
      contentPadding: EdgeInsets.zero,
      content: Column(
        children: [
          _buildFilterBar(),
          Expanded(child: _buildTable()),
          SizedBox(height: 8.h),
          _buildActionButtons(context),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
  Widget _buildFilterBar() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          SizedBox(
            width: 250.w,
            height: 35.h,
            child: AppDropdown(
              type: AppDropdownType.search,
              hintText: 'User',
              value: _selectedUser,
              items: _users,
              onChanged: (value) {
                setState(() {
                  _selectedUser = value;
                  _selectedOrderIds.clear();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomOutlinedActionButton(
            text: 'No',
            width: 200.w,
            height: 40.h,
            borderRadius: 8.r,
            fontSize: 14.sp,
            borderColor: widget.isDarkMode
                ? Colors.white
                : const Color(0xFF1F4A66),
            textColor: widget.isDarkMode
                ? Colors.white
                : const Color(0xFF1F4A66),
            onPressed: () {
              Navigator.pop(context);
              if (_filteredOrders.isNotEmpty) {
                Future.delayed(Duration.zero, () {
                  TradeDetailsDialog.show(
                    context: context,
                    order: _filteredOrders.first,
                    isDarkMode: widget.isDarkMode,
                  );
                });
              }
            },
          ),
          SizedBox(width: 16.w),
          CustomActionButton(
            text: 'Yes',
            width: 200.w,
            height: 40.h,
            borderRadius: 8.r,
            fontSize: 14.sp,
            backgroundColor: widget.isDarkMode
                ? const Color(0xFF1F4A66)
                : const Color(0xFF1F4A66),
            textColor: Colors.white,
            onPressed: () {
              Navigator.pop(context);
              Future.delayed(Duration.zero, () {
                SuccessDialog.show(
                  context: context,
                  title: 'Successful Deleted !',
                  subtitle: 'Your Order is Successfully Deleted',
                );
              });
            },
          ),
        ],
      ),
    );
  }
  List<ViewTableColumn> _getColumns() {
    final allSelected =
        _filteredOrders.isNotEmpty &&
        _filteredOrders.every((o) => _selectedOrderIds.contains(o.id));
    return [
      ViewTableColumn(
        id: 'checkbox',
        label: '',
        width: 50,
        sortable: false,
        customHeaderWidget: Checkbox(
          value: allSelected,
          onChanged: (bool? value) {
            setState(() {
              if (value == true) {
                _selectedOrderIds.addAll(_filteredOrders.map((o) => o.id));
              } else {
                _selectedOrderIds.clear();
              }
            });
          },
          activeColor: AppColors.primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.r),
          ),
          side: BorderSide(color: AppColors.primaryBlue, width: 1.5.w),
        ),
      ),
      ViewTableColumn(id: 'exchange', label: 'EXCH', width: 100),
      ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 160),
      ViewTableColumn(id: 'buySell', label: 'B/S', width: 220),
      ViewTableColumn(id: 'qty', label: 'QTY', width: 120, isNumeric: true),
      ViewTableColumn(id: 'lot', label: 'LOT', width: 100, isNumeric: true),
      ViewTableColumn(id: 'price', label: 'PRICE', width: 120, isNumeric: true),
      ViewTableColumn(id: 'orderDateTime', label: 'ORDER D/T', width: 220),
      ViewTableColumn(
        id: 'modifyOrderDateTime',
        label: 'MODIFY ORDER D/T',
        width: 220,
      ),
      ViewTableColumn(id: 'cmp', label: 'CMP', width: 120, isNumeric: true),
    ];
  }
  Widget _buildCell(PendingOrder item, ViewTableColumn column, bool isDark) {
    switch (column.id) {
      case 'checkbox':
        return Center(
          child: Checkbox(
            value: _selectedOrderIds.contains(item.id),
            onChanged: (bool? value) {
              setState(() {
                if (value == true) {
                  _selectedOrderIds.add(item.id);
                } else {
                  _selectedOrderIds.remove(item.id);
                }
              });
            },
            activeColor: AppColors.primaryBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.r),
            ),
            side: BorderSide(color: AppColors.primaryBlue, width: 1.5.w),
          ),
        );
      case 'exchange':
        return ViewTextCell(text: item.exchange, isDark: isDark);
      case 'symbol':
        return ViewLinkCell(text: item.symbol, isDark: isDark);
      case 'buySell':
        return ViewTextCell(
          text: item.buySell,
          color: item.buySell.toUpperCase().startsWith('BUY')
              ? AppColors.blue
              : AppColors.red,
          isDark: isDark,
        );
      case 'qty':
        return ViewNumberCell(
          value: item.qty,
          fixedColor: item.buySell.toUpperCase().startsWith('BUY')
              ? AppColors.blue
              : AppColors.red,
          isDark: isDark,
        );
      case 'lot':
        return ViewTextCell(text: item.lot.toStringAsFixed(2), isDark: isDark);
      case 'price':
        return ViewNumberCell(
          value: item.triggerPrice,
          fixedColor: item.buySell.toUpperCase().startsWith('BUY')
              ? AppColors.blue
              : AppColors.red,
          isDark: isDark,
        );
      case 'orderDateTime':
        return ViewDateTimeCell(dateTime: item.orderDateTime, isDark: isDark);
      case 'modifyOrderDateTime':
        return item.modifyOrderDateTime != item.orderDateTime
            ? ViewDateTimeCell(
                dateTime: item.modifyOrderDateTime,
                isDark: isDark,
              )
            : ViewTextCell(text: '-', isDark: isDark);
      case 'cmp':
        return ViewNumberCell(
          value: item.cmp,
          fixedColor: item.buySell.toUpperCase().startsWith('BUY')
              ? AppColors.blue
              : AppColors.red,
          isDark: isDark,
        );
      default:
        return const SizedBox.shrink();
    }
  }
  Widget _buildTable() {
    final data = _filteredOrders;
    return ViewDataTable<PendingOrder>(
      columns: _getColumns(),
      data: data,
      idExtractor: (item) => item.id,
      isDarkMode: widget.isDarkMode,
      autoFit: true,
      headerBgColor: const Color(0xFFD3E3EC),
      emptyMessage: 'No pending orders found',
      onRowTap: (item) {
        TradeDetailsDialog.show(
          context: context,
          order: item,
          isDarkMode: widget.isDarkMode,
        );
      },
      cellBuilder: (item, column) =>
          _buildCell(item, column, widget.isDarkMode),
    );
  }
}
