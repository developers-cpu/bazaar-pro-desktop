import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../domain/entities/pending_orders/pending_order.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../../../../core/widget/table/success_dialog.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../auth/presentation/bloc/auth_state.dart';
import 'trade_details_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  String? _tempSelectedUser;
  List<String> _users = ['All Users'];
  @override
  void initState() {
    super.initState();
    _users.addAll(widget.pendingOrders.map((o) => o.userId).toSet().toList());
    _tempSelectedUser = 'All Users';
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
    bool isClient = false;
    try {
      final authState = context.read<AuthBloc>().state;
      isClient =
          authState is AuthAuthenticated &&
          authState.user.role.toLowerCase() == 'client';
    } catch (_) {}

    return CommonDialog(
      title: 'Cancel Order',
      isDarkMode: widget.isDarkMode,
      width: 850.w,
      height: 500.h,
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
        _showConfirmationDialog(context);
      },
      scrollable: false,
      contentPadding: EdgeInsets.zero,
      content: Column(
        children: [
          _buildFilterBar(isClient),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _buildTable(isClient),
            ),
          ),
          SizedBox(height: 16.h),
          _buildActionButtons(context),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Widget _buildFilterBar(bool isClient) {
    if (isClient) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          SizedBox(
            width: 200.w,
            height: 35.h,
            child: AppDropdown(
              type: AppDropdownType.search,
              hintText: 'User',
              value: _tempSelectedUser,
              items: _users,
              onChanged: (value) {
                setState(() {
                  _tempSelectedUser = value;
                });
              },
            ),
          ),
          const Spacer(),
          CustomActionButton(
            text: 'View',
            width: 80.w,
            height: 35.h,
            borderRadius: 6.r,
            fontSize: 12.sp,
            backgroundColor: AppColors.primaryBlue,
            textColor: Colors.white,
            onPressed: () {
              setState(() {
                _selectedUser = _tempSelectedUser;
                _selectedOrderIds.clear();
              });
            },
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
            width: 140.w,
            height: 35.h,
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
            width: 140.w,
            height: 35.h,
            borderRadius: 8.r,
            fontSize: 14.sp,
            backgroundColor: widget.isDarkMode
                ? const Color(0xFF1F4A66)
                : const Color(0xFF1F4A66),
            textColor: Colors.white,
            onPressed: () {
              _showConfirmationDialog(context);
            },
          ),
        ],
      ),
    );
  }

  List<ViewTableColumn> _getColumns(bool isClient) {
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
      ViewTableColumn(id: 'exchange', label: 'EXCH', width: 90),
      ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 160),
      ViewTableColumn(id: 'buySell', label: 'B/S', width: 200),
      ViewTableColumn(id: 'qty', label: 'QTY', width: 110, isNumeric: true),
      ViewTableColumn(id: 'lot', label: 'LOT', width: 90, isNumeric: true),
      ViewTableColumn(id: 'price', label: 'PRICE', width: 110, isNumeric: true),
      ViewTableColumn(id: 'orderDateTime', label: 'ORDER D/T', width: 190),
      ViewTableColumn(
        id: 'modifyOrderDateTime',
        label: 'MODIFY ORDER D/T',
        width: 190,
      ),
      ViewTableColumn(id: 'cmp', label: 'CMP', width: 110, isNumeric: true),
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
        final symbolColor = ViewTableCellStyles.getValueColor(
          item.qty,
          isDark: isDark,
        );
        return ViewTextCell(
          text: item.symbol,
          color: symbolColor,
          isDark: isDark,
          isStart: true,
        );
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
        return ViewNumberCell(
          value: item.lot,
          displayText: item.lot.toStringAsFixed(2),
          colorByValue: false,
          isDark: isDark,
        );
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

  Widget _buildTable(bool isClient) {
    final data = _filteredOrders;
    return ViewDataTable<PendingOrder>(
      columns: _getColumns(isClient),
      data: data,
      idExtractor: (item) => item.id,
      isDarkMode: widget.isDarkMode,
      autoFit: true,
      comparatorBuilder: (item, columnId) {
        switch (columnId) {
          case 'userName':
            return item.userId;
          case 'pUser':
            return item.upline;
          case 'exchange':
            return item.exchange;
          case 'symbol':
            return item.symbol;
          case 'buySell':
            return item.buySell;
          case 'qty':
            return item.qty;
          case 'lot':
            return item.lot;
          case 'triggerPrice':
            return item.triggerPrice;
          case 'orderTime':
            return item.orderDateTime;
          default:
            return '';
        }
      },
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

  void _showConfirmationDialog(BuildContext parentContext) {
    showDialog(
      context: parentContext,
      barrierColor: AppColors.black.withOpacity(0.54),
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        backgroundColor: widget.isDarkMode
            ? const Color(0xFF1E1E1E)
            : AppColors.white,
        child: Container(
          width: 450.w,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Want to Delete Orders ?',
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                  fontSize: 22.sp,
                  color: const Color(0xFF1F4A66),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Are You Sure you want to Delete All Orders?',
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                  fontSize: 16.sp,
                  color: Colors.grey.shade500,
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomOutlinedActionButton(
                    text: 'No',
                    width: 140.w,
                    height: 40.h,
                    borderRadius: 8.r,
                    fontSize: 14.sp,
                    borderColor: widget.isDarkMode
                        ? Colors.white
                        : const Color(0xFF1F4A66),
                    textColor: widget.isDarkMode
                        ? Colors.white
                        : const Color(0xFF1F4A66),
                    onPressed: () => Navigator.of(dialogContext).pop(),
                  ),
                  SizedBox(width: 16.w),
                  CustomActionButton(
                    text: 'Yes',
                    width: 140.w,
                    height: 40.h,
                    borderRadius: 8.r,
                    fontSize: 14.sp,
                    backgroundColor: const Color(0xFF1F4A66),
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      Navigator.of(parentContext).pop();
                      Future.delayed(const Duration(milliseconds: 100), () {
                        if (parentContext.mounted) {
                          SuccessDialog.show(
                            context: parentContext,
                            title: 'Successful Deleted !',
                            subtitle: 'Your Order is Successfully Deleted',
                          );
                        }
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
