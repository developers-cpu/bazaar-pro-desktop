import 'package:bazarpro/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../../market_watch/presentation/widgets/order/order_number_field.dart';
import '../../../domain/entities/pending_orders/pending_order.dart';
import '../../../../../core/widget/table/animated_price_box.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../auth/presentation/bloc/auth_state.dart';
import 'order_status_dialog.dart';

class ModifyOrderDialog extends StatefulWidget {
  final PendingOrder order;
  final bool isDarkMode;
  const ModifyOrderDialog({
    Key? key,
    required this.order,
    this.isDarkMode = false,
  }) : super(key: key);
  static void show({
    required BuildContext context,
    required PendingOrder order,
    bool isDarkMode = false,
  }) {
    showDialog(
      context: context,
      barrierColor: AppColors.black.withOpacity(0.54),
      builder: (_) => ModifyOrderDialog(order: order, isDarkMode: isDarkMode),
    );
  }

  @override
  State<ModifyOrderDialog> createState() => _ModifyOrderDialogState();
}

class _ModifyOrderDialogState extends State<ModifyOrderDialog> {
  static const _depthData = [
    {'price': '25639', 'orders': '2', 'qty': '2'},
    {'price': '25639', 'orders': '1', 'qty': '1'},
    {'price': '25639', 'orders': '1', 'qty': '1'},
    {'price': '25639', 'orders': '5', 'qty': '5'},
    {'price': '25639', 'orders': '2', 'qty': '2'},
  ];
  late int _price;
  late int _lot;
  bool _isLimit = false;
  @override
  void initState() {
    super.initState();
    _price = widget.order.triggerPrice.toInt();
    _lot = widget.order.lot.toInt();
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
      title: 'Modify  Order',
      isDarkMode: widget.isDarkMode,
      width: 450.w,
      height: isClient ? 700.h : 780.h,
      headerColor: AppColors.primaryBlue,
      showButtons: false,
      scrollable: true,
      contentPadding: EdgeInsets.zero,
      content: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          children: [
            _buildSymbolRow(),
            if (!isClient) ...[
              SizedBox(height: 10.h),
              _buildUserIdField(isClient),
            ],
            SizedBox(height: 8.h),
            _buildOrderControls(),
            SizedBox(height: 12.h),
            _buildActionButtons(),
            SizedBox(height: 12.h),
            _buildPositionInfo(),
            SizedBox(height: 8.h),
            _buildInfoCards(),
            SizedBox(height: 8.h),
            _buildDepthCards(),
          ],
        ),
      ),
    );
  }

  Widget _buildSymbolRow() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.order.symbol,
                  style: GoogleFonts.openSans(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlue,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Q.${widget.order.qty.toStringAsFixed(6)}',
                  style: GoogleFonts.openSans(
                    fontSize: 14.sp,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedPriceBox(price: '2588212', isDarkMode: widget.isDarkMode),
              SizedBox(width: 8.w),
              AnimatedPriceBox(price: '2588212', isDarkMode: widget.isDarkMode),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserIdField(bool isClient) {
    if (isClient) return const SizedBox.shrink();
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.greyBorder),
            borderRadius: BorderRadius.circular(8.r),
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            widget.order.userId,
            style: GoogleFonts.openSans(
              fontSize: 16.sp,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        SizedBox(height: 12.h),
      ],
    );
  }

  Widget _buildOrderControls() {
    return Container(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isLimit = true),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      color: _isLimit
                          ? const Color(0xFF1F4A66)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Limit',
                      style: GoogleFonts.openSans(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: _isLimit
                            ? Colors.white
                            : const Color(0xFF1F4A66),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isLimit = false),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      color: !_isLimit
                          ? const Color(0xFF1F4A66)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'SL',
                      style: GoogleFonts.openSans(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: !_isLimit
                            ? Colors.white
                            : const Color(0xFF1F4A66),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          _buildStepperRow(
            'Price',
            _price,
            (val) => setState(() => _price = val),
          ),
          SizedBox(height: 8.h),
          _buildStepperRow('Lot', _lot, (val) => setState(() => _lot = val)),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        _buildOrderButton(
          label: _isLimit ? 'Sell Limit' : 'Sell Stop',
          price: '25800',
          color: AppColors.red,
          isSuccess: false,
        ),
        SizedBox(width: 16.w),
        _buildOrderButton(
          label: _isLimit ? 'Buy Limit' : 'Buy Stop',
          price: '25800',
          color: const Color(0xFF0052FF),
          isSuccess: true,
        ),
      ],
    );
  }

  Widget _buildOrderButton({
    required String label,
    required String price,
    required Color color,
    required bool isSuccess,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          OrderStatusDialog.show(
            context: context,
            isSuccess: isSuccess,
            order: widget.order,
            actionName: label,
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: GoogleFonts.openSans(
                  fontSize: 13.sp,
                  color: AppColors.white,
                ),
              ),
              Text(
                price,
                style: GoogleFonts.openSans(
                  fontSize: 12.sp,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPositionInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Open Position: 25 SELL',
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.red,
          ),
        ),
        Text(
          'AVG: 1000000',
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2C5F7A),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCards() {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard({
            'Lot Size': '35',
            'LTP': '60013',
            'Volume': '422590',
            'Avg. Price': '52402',
            'L.CRKT': '80254',
          }),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _buildInfoCard({
            'Open': '35',
            'High': '60013',
            'Low': '422590',
            'Close': '52402',
            'U.CRKT': '80254',
          }),
        ),
      ],
    );
  }

  Widget _buildDepthCards() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildDepthSection(
            title: 'Bid',
            bgColor: const Color(0xFFEAF1FA),
            dataColor: const Color(0xFF1A60FF),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _buildDepthSection(
            title: 'Asked',
            bgColor: const Color(0xFFFBEBEA),
            dataColor: AppColors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildDepthSection({
    required String title,
    required Color bgColor,
    required Color dataColor,
  }) {
    const headerStyle = Color(0xFF1E4C6B);
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [title, 'Orders', 'Qty']
                .map(
                  (t) => Text(
                    t,
                    style: GoogleFonts.openSans(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: headerStyle,
                    ),
                  ),
                )
                .toList(),
          ),
          SizedBox(height: 4.h),
          ..._depthData.map(
            (row) => _buildDepthRow(
              row['price']!,
              row['orders']!,
              row['qty']!,
              dataColor,
            ),
          ),
          _buildDepthRow('Total', '', '1241', dataColor, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildDepthRow(
    String price,
    String orders,
    String qty,
    Color color, {
    bool isTotal = false,
  }) {
    final fontSize = isTotal ? 14.sp : 13.sp;
    final fontWeight = isTotal ? FontWeight.w600 : FontWeight.w500;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              price,
              style: GoogleFonts.openSans(
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: color,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              orders,
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              qty,
              textAlign: TextAlign.right,
              style: GoogleFonts.openSans(
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(Map<String, String> items) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.greyBorder),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.entries
            .map(
              (e) => Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      e.key,
                      style: GoogleFonts.openSans(
                        fontSize: 12.sp,
                        color: AppColors.black,
                      ),
                    ),
                    Text(
                      e.value,
                      style: GoogleFonts.openSans(
                        fontSize: 12.sp,
                        color: const Color(0xFF2C5F7A),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildStepperRow(
    String label,
    int value,
    ValueChanged<int> onChanged,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            label,
            style: GoogleFonts.openSans(
              fontSize: 14.sp,
              color: const Color(0xFF2C5F7A),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: OrderNumberField(
            label: '',
            value: value,
            onChanged: onChanged,
            borderColor: const Color(0xFF2C5F7A),
          ),
        ),
      ],
    );
  }
}
