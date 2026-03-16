import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../../data/models/order_dialog_type.dart';
import '../../bloc/order/order_dialog_bloc.dart';
import '../../bloc/order/order_dialog_event.dart';
import '../../bloc/order/order_dialog_state.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../auth/presentation/bloc/auth_state.dart';
import 'order_number_field.dart';
import 'order_action_button.dart';
import 'order_success_dialog.dart';

class CommonOrderDialog extends StatefulWidget {
  final OrderDialogType type;
  const CommonOrderDialog({Key? key, required this.type}) : super(key: key);
  static Future<void> showBuyOrder(
    BuildContext context, {
    String? exchange,
    String? symbol,
  }) {
    context.read<OrderDialogBloc>().add(
      OpenBuyOrderEvent(exchange: exchange, symbol: symbol),
    );
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (context) => const CommonOrderDialog(type: OrderDialogType.buy),
    );
  }

  static Future<void> showSellOrder(
    BuildContext context, {
    String? exchange,
    String? symbol,
  }) {
    context.read<OrderDialogBloc>().add(
      OpenSellOrderEvent(exchange: exchange, symbol: symbol),
    );
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (context) => const CommonOrderDialog(type: OrderDialogType.sell),
    );
  }

  @override
  State<CommonOrderDialog> createState() => _CommonOrderDialogState();
}

class _CommonOrderDialogState extends State<CommonOrderDialog> {
  Offset? _position;
  bool _isDragging = false;
  Color get _primaryColor => widget.type == OrderDialogType.buy
      ? AppColors.buyColor
      : AppColors.sellColor;
  Color get _backgroundColor => _primaryColor;
  String get _title =>
      widget.type == OrderDialogType.buy ? 'Buy Order' : 'Sell Order';
  String get _actionButtonText =>
      widget.type == OrderDialogType.buy ? 'Buy' : 'Sell';
  OrderType get _orderType =>
      widget.type == OrderDialogType.buy ? OrderType.buy : OrderType.sell;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_position == null) {
      final screenSize = MediaQuery.of(context).size;
      _position = Offset(20, screenSize.height * 0.75);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isClient = false;
    String clientName = 'client1';
    try {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        if (authState.user.role.toLowerCase() == 'client') {
          isClient = true;
        }
      }
    } catch (_) {}
    return BlocConsumer<OrderDialogBloc, OrderDialogState>(
      listener: (context, state) {
        if (state.isSubmitted) {
          Navigator.of(context).pop();
          OrderSuccessDialog.show(
            context,
            orderType: _orderType,
            symbol: state.symbol.isNotEmpty ? state.symbol : null,
            exchange: state.exchange.isNotEmpty ? state.exchange : null,
            quantity: state.quantity,
            price: state.price,
          );
          context.read<OrderDialogBloc>().add(const ResetSubmittedEvent());
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                context.read<OrderDialogBloc>().add(
                  const CloseOrderDialogEvent(),
                );
                Navigator.of(context).pop();
              },
              child: Container(color: Colors.transparent),
            ),
            Positioned(
              left: _position!.dx,
              top: _position!.dy,
              child: GestureDetector(
                onPanStart: (_) => _isDragging = true,
                onPanUpdate: (details) {
                  setState(() {
                    _position = Offset(
                      _position!.dx + details.delta.dx,
                      _position!.dy + details.delta.dy,
                    );
                  });
                },
                onPanEnd: (_) => _isDragging = false,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: 600,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context),
                        _buildContent(context, state, isClient, clientName),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _position = Offset(
            _position!.dx + details.delta.dx,
            _position!.dy + details.delta.dy,
          );
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _title,
              style: GoogleFonts.openSans(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: _primaryColor,
              ),
            ),
            GestureDetector(
              onTap: () {
                context.read<OrderDialogBloc>().add(
                  const CloseOrderDialogEvent(),
                );
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.close,
                size: 16.sp,
                color: LightThemeColors.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    OrderDialogState state,
    bool isClient,
    String clientName,
  ) {
    return Container(
      margin: EdgeInsets.fromLTRB(6.w, 0, 6.w, 4.w),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        children: [
          _buildFirstRow(context, state, isClient, clientName),
          SizedBox(height: 4.h),
          _buildSecondRow(context, state),
        ],
      ),
    );
  }

  Widget _buildFirstRow(
    BuildContext context,
    OrderDialogState state,
    bool isClient,
    String clientName,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: isClient
              ? _buildStaticClientField(clientName)
              : AppDropdown(
                  type: AppDropdownType.simple,
                  hintText: 'Username',
                  value: state.clientName.isEmpty ? null : state.clientName,
                  items: const ['Client 1', 'Client 2', 'Client 3'],
                  label: 'Client Name',
                  labelColor: AppColors.white,
                  height: 26.h,
                  borderColor: LightThemeColors.primaryColor,
                  onChanged: (value) {
                    if (value != null) {
                      context.read<OrderDialogBloc>().add(
                        UpdateClientNameEvent(value),
                      );
                    }
                  },
                ),
        ),
        SizedBox(width: 6.w),
        Expanded(
          flex: 2,
          child: AppDropdown(
            type: AppDropdownType.simple,
            hintText: 'Type',
            value: state.orderType.isEmpty ? null : state.orderType,
            items: const ['Market', 'Limit', 'Stop Loss', 'Stop Limit'],
            label: 'Order Type',
            labelColor: AppColors.white,
            height: 26.h,
            borderColor: LightThemeColors.primaryColor,
            onChanged: (value) {
              if (value != null) {
                context.read<OrderDialogBloc>().add(
                  UpdateOrderTypeEvent(value),
                );
              }
            },
          ),
        ),
        SizedBox(width: 6.w),
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
        SizedBox(width: 6.w),
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
        SizedBox(width: 6.w),
        Expanded(
          flex: 2,
          child: OrderNumberField(
            label: 'Price',
            value: state.price.toInt(),
            labelColor: AppColors.white,
            borderColor: LightThemeColors.primaryColor,
            onChanged: (value) {
              context.read<OrderDialogBloc>().add(
                UpdatePriceEvent(value.toDouble()),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStaticClientField(String clientName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Client Name',
          style: GoogleFonts.openSans(
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
        SizedBox(height: 2.sp),
        Container(
          height: 26.h,
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(
              color: LightThemeColors.primaryColor,
              width: 1.w,
            ),
          ),
          child: Text(
            clientName,
            style: GoogleFonts.openSans(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlue,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSecondRow(BuildContext context, OrderDialogState state) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: AppDropdown(
            type: AppDropdownType.simple,
            hintText: 'Exchange',
            value: state.exchange.isEmpty ? null : state.exchange,
            items: const ['NSE', 'BSE', 'MCX', 'NFO'],
            label: 'Exchange',
            labelColor: AppColors.white,
            height: 26.h,
            borderColor: LightThemeColors.primaryColor,
            onChanged: (value) {
              if (value != null) {
                context.read<OrderDialogBloc>().add(UpdateExchangeEvent(value));
              }
            },
          ),
        ),
        SizedBox(width: 6.w),
        Expanded(
          flex: 2,
          child: AppDropdown(
            type: AppDropdownType.simple,
            hintText: 'Symbol',
            value: state.symbol.isEmpty ? null : state.symbol,
            items: const ['NIFTY', 'BANKNIFTY', 'RELIANCE', 'TCS', 'INFY'],
            label: 'Symbol',
            labelColor: AppColors.white,
            height: 26.h,
            borderColor: LightThemeColors.primaryColor,
            onChanged: (value) {
              if (value != null) {
                context.read<OrderDialogBloc>().add(UpdateSymbolEvent(value));
              }
            },
          ),
        ),
        SizedBox(width: 6.w),
        Expanded(
          flex: 3,
          child: OrderActionButton(
            label: 'Cancel',
            borderColor: LightThemeColors.primaryColor,
            onPressed: () {
              context.read<OrderDialogBloc>().add(
                const CloseOrderDialogEvent(),
              );
              Navigator.of(context).pop();
            },
          ),
        ),
        SizedBox(width: 6.w),
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
