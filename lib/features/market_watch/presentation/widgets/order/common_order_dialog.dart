import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../data/models/order_dialog_type.dart';
import '../../bloc/order/order_dialog_bloc.dart';
import '../../bloc/order/order_dialog_event.dart';
import '../../bloc/order/order_dialog_state.dart';
import 'order_dropdown_field.dart';
import 'order_number_field.dart';
import 'order_action_button.dart';
import 'order_success_dialog.dart';


class CommonOrderDialog extends StatelessWidget {
  final OrderDialogType type;

  const CommonOrderDialog({
    Key? key,
    required this.type,
  }) : super(key: key);

  // Theme colors based on order type
  Color get _primaryColor => type == OrderDialogType.buy
      ? const Color(0xFF0066FF)  // Blue for Buy
      : const Color(0xFFFF0000); // Red for Sell

  Color get _backgroundColor => _primaryColor;

  String get _title => type == OrderDialogType.buy ? 'Buy Order' : 'Sell Order';

  String get _actionButtonText => type == OrderDialogType.buy ? 'Buy' : 'Sell';

  OrderType get _orderType =>
      type == OrderDialogType.buy ? OrderType.buy : OrderType.sell;

  static Future<void> showBuyOrder(BuildContext context) {
    context.read<OrderDialogBloc>().add(const OpenBuyOrderEvent());
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const CommonOrderDialog(type: OrderDialogType.buy),
    );
  }


  static Future<void> showSellOrder(BuildContext context) {
    context.read<OrderDialogBloc>().add(const OpenSellOrderEvent());
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const CommonOrderDialog(type: OrderDialogType.sell),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderDialogBloc, OrderDialogState>(
      listener: (context, state) {
        if (state.isSubmitted) {
          Navigator.of(context).pop();
          // Show success dialog
          OrderSuccessDialog.show(
            context,
            orderType: _orderType,
            symbol: state.symbol.isNotEmpty ? state.symbol : null,
            exchange: state.exchange.isNotEmpty ? state.exchange : null,
            quantity: state.quantity,
            price: state.price,
          );
          // Reset submitted state
          context.read<OrderDialogBloc>().add(const ResetSubmittedEvent());
        }
      },
      builder: (context, state) {
        return Dialog(
          backgroundColor: AppColors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Container(
            width: 1100.w,
            constraints: BoxConstraints(maxWidth: 1100.w),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                _buildContent(context, state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _title,
            style: GoogleFonts.openSans(
              fontSize: 22.sp,
              fontWeight: FontWeight.w400,
              color: _primaryColor,
            ),
          ),
          IconButton(
            onPressed: () {
              context.read<OrderDialogBloc>().add(const CloseOrderDialogEvent());
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.close,
              size: 24.sp,
              color: LightThemeColors.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, OrderDialogState state) {
    return Container(
      margin: EdgeInsets.fromLTRB(10.w, 0, 10.w, 10.w),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          _buildFirstRow(context, state),
          SizedBox(height: 10.h),
          _buildSecondRow(context, state),
        ],
      ),
    );
  }

  Widget _buildFirstRow(BuildContext context, OrderDialogState state) {
    return Row(
      children: [
        // Client Name
        Expanded(
          flex: 2,
          child: OrderDropdownField(
            label: 'Client Name',
            value: state.clientName.isEmpty ? null : state.clientName,
            hint: 'Client',
            items: const ['Client 1', 'Client 2', 'Client 3'],
            labelColor: AppColors.white,
            borderColor: LightThemeColors.primaryColor,
            onChanged: (value) {
              if (value != null) {
                context.read<OrderDialogBloc>().add(UpdateClientNameEvent(value));
              }
            },
          ),
        ),
        SizedBox(width: 10.w),

        // Order Type
        Expanded(
          flex: 2,
          child: OrderDropdownField(
            label: 'Order Type',
            value: state.orderType.isEmpty ? null : state.orderType,
            hint: 'Type',
            items: const ['Market', 'Limit', 'Stop Loss', 'Stop Limit'],
            labelColor: AppColors.white,
            borderColor: LightThemeColors.primaryColor,
            onChanged: (value) {
              if (value != null) {
                context.read<OrderDialogBloc>().add(UpdateOrderTypeEvent(value));
              }
            },
          ),
        ),
        SizedBox(width: 10.w),

        // Qty
        Expanded(
          flex: 2,
          child: OrderNumberField(
            label: 'Qty',
            value: state.quantity,
            labelColor: AppColors.white,
            borderColor: LightThemeColors.primaryColor,
            onChanged: (value) {
              context.read<OrderDialogBloc>().add(UpdateQuantityEvent(value));
            },
          ),
        ),
        SizedBox(width: 10.w),

        // Lot
        Expanded(
          flex: 2,
          child: OrderNumberField(
            label: 'Lot',
            value: state.lot,
            labelColor: AppColors.white,
            borderColor: LightThemeColors.primaryColor,
            onChanged: (value) {
              context.read<OrderDialogBloc>().add(UpdateLotEvent(value));
            },
          ),
        ),
        SizedBox(width: 10.w),

        // Price
        Expanded(
          flex: 2,
          child: OrderNumberField(
            label: 'Price',
            value: state.price.toInt(),
            labelColor: AppColors.white,
            borderColor: LightThemeColors.primaryColor,
            onChanged: (value) {
              context.read<OrderDialogBloc>().add(UpdatePriceEvent(value.toDouble()));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSecondRow(BuildContext context, OrderDialogState state) {
    return Row(
      children: [
        // Exchange
        Expanded(
          flex: 2,
          child: OrderDropdownField(
            label: 'Exchange',
            value: state.exchange.isEmpty ? null : state.exchange,
            hint: 'Exchange',
            items: const ['NSE', 'BSE', 'MCX', 'NFO'],
            labelColor: AppColors.white,
            borderColor: LightThemeColors.primaryColor,
            onChanged: (value) {
              if (value != null) {
                context.read<OrderDialogBloc>().add(UpdateExchangeEvent(value));
              }
            },
          ),
        ),
        SizedBox(width: 10.w),

        // Symbol
        Expanded(
          flex: 2,
          child: OrderDropdownField(
            label: 'Symbol',
            value: state.symbol.isEmpty ? null : state.symbol,
            hint: 'Symbol',
            items: const ['NIFTY', 'BANKNIFTY', 'RELIANCE', 'TCS', 'INFY'],
            labelColor: AppColors.white,
            borderColor: LightThemeColors.primaryColor,
            onChanged: (value) {
              if (value != null) {
                context.read<OrderDialogBloc>().add(UpdateSymbolEvent(value));
              }
            },
          ),
        ),
        SizedBox(width: 10.w),

        // Cancel Button
        Expanded(
          flex: 3,
          child: OrderActionButton(
            label: 'Cancel',
            borderColor: LightThemeColors.primaryColor,
            onPressed: () {
              context.read<OrderDialogBloc>().add(const CloseOrderDialogEvent());
              Navigator.of(context).pop();
            },
          ),
        ),
        SizedBox(width: 10.w),

        Expanded(
          flex: 3,
          child: OrderActionButton(
            label: _actionButtonText,
            borderColor: LightThemeColors.primaryColor,
            isLoading: state.isLoading,
            onPressed: () {
              context.read<OrderDialogBloc>().add(const SubmitOrderEvent());
            },
          ),
        ),
      ],
    );
  }
}