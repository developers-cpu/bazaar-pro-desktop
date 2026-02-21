import 'package:bazarpro/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../../market_watch/presentation/widgets/order/order_number_field.dart';
import '../../../domain/entities/pending_orders/pending_order.dart';
import '../../../../../core/widget/custom_toggle_switch.dart';
import '../common/animated_price_box.dart';

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
    final headerColor = const Color(0xFF2C5F7A);
    final borderColor = AppColors.greyBorder;

    return CommonDialog(
      title: 'Modify Order',
      isDarkMode: widget.isDarkMode,
      width: 500.w,
      height: 700.h,
      headerColor: headerColor,
      showButtons: false,
      scrollable: true,
      contentPadding: EdgeInsets.zero,
      content: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          children: [

            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.greyBorder),
                borderRadius: BorderRadius.circular(8.r),
              ),
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
                            color: headerColor,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Q.${widget.order.qty.toStringAsFixed(6)}',
                          style: GoogleFonts.openSans(
                            fontSize: 14.sp,
                            color: headerColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedPriceBox(
                        price: '2588212',
                        isDarkMode: widget.isDarkMode,
                      ),
                      SizedBox(width: 8.w),
                      AnimatedPriceBox(
                        price: '2588212',
                        isDarkMode: widget.isDarkMode,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                border: Border.all(color: borderColor),
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
            SizedBox(height: 16.h),

            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                children: [
                  CustomToggleSwitch(
                    leftLabel: 'Limit',
                    rightLabel: 'SL',
                    isLeftSelected: _isLimit,
                    onChanged: (val) => setState(() => _isLimit = val),
                    activeColor: headerColor,
                  ),
                  SizedBox(height: 24.h),
                  _buildStepperRow(
                    'Price',
                    _price,
                    (val) => setState(() => _price = val),
                  ),
                  SizedBox(height: 16.h),
                  _buildStepperRow(
                    'Lot',
                    _lot,
                    (val) => setState(() => _lot = val),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Order Modified')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _isLimit ? 'Sell Limit' : 'Sell Stop',
                          style: GoogleFonts.openSans(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        Text(
                          '25800',
                          style: GoogleFonts.openSans(
                            fontSize: 14.sp,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Order Modified')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        0xFF0052FF,
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _isLimit ? 'Buy Limit' : 'Buy Stop',
                          style: GoogleFonts.openSans(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        Text(
                          '25800',
                          style: GoogleFonts.openSans(
                            fontSize: 14.sp,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            Row(
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
            ),
            SizedBox(height: 12.h),

            Row(
              children: [
                Expanded(
                  child: _buildInfoCard([
                    'Lot Size: 35',
                    'LTP: 60013',
                    'Volume: 422590',
                    'Avg. Price: 52402',
                    'L.CRKT: 80254',
                  ]),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _buildInfoCard([
                    'Open: 35',
                    'High: 60013',
                    'Low: 422590',
                    'Close: 52402',
                    'U.CRKT: 80254',
                  ]),
                ),
              ],
            ),
            SizedBox(height: 8.h),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF1FA),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Bid',
                              style: GoogleFonts.openSans(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1E4C6B),
                              ),
                            ),
                            Text(
                              'Orders',
                              style: GoogleFonts.openSans(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1E4C6B),
                              ),
                            ),
                            Text(
                              'Qty',
                              style: GoogleFonts.openSans(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1E4C6B),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),

                        _buildDepthRow(
                          '25639',
                          '2',
                          '2',
                          const Color(0xFF1A60FF),
                          isTotal: false,
                        ),
                        _buildDepthRow(
                          '25639',
                          '1',
                          '1',
                          const Color(0xFF1A60FF),
                          isTotal: false,
                        ),
                        _buildDepthRow(
                          '25639',
                          '1',
                          '1',
                          const Color(0xFF1A60FF),
                          isTotal: false,
                        ),
                        _buildDepthRow(
                          '25639',
                          '5',
                          '5',
                          const Color(0xFF1A60FF),
                          isTotal: false,
                        ),
                        _buildDepthRow(
                          '25639',
                          '2',
                          '2',
                          const Color(0xFF1A60FF),
                          isTotal: false,
                        ),
                        _buildDepthRow(
                          'Total',
                          '',
                          '1241',
                          const Color(0xFF1A60FF),
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBEBEA),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Asked',
                              style: GoogleFonts.openSans(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1E4C6B),
                              ),
                            ),
                            Text(
                              'Orders',
                              style: GoogleFonts.openSans(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1E4C6B),
                              ),
                            ),
                            Text(
                              'Qty',
                              style: GoogleFonts.openSans(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1E4C6B),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),

                        _buildDepthRow(
                          '25639',
                          '2',
                          '2',
                          AppColors.red,
                          isTotal: false,
                        ),
                        _buildDepthRow(
                          '25639',
                          '1',
                          '1',
                          AppColors.red,
                          isTotal: false,
                        ),
                        _buildDepthRow(
                          '25639',
                          '1',
                          '1',
                          AppColors.red,
                          isTotal: false,
                        ),
                        _buildDepthRow(
                          '25639',
                          '5',
                          '5',
                          AppColors.red,
                          isTotal: false,
                        ),
                        _buildDepthRow(
                          '25639',
                          '2',
                          '2',
                          AppColors.red,
                          isTotal: false,
                        ),
                        _buildDepthRow(
                          'Total',
                          '',
                          '1241',
                          AppColors.red,
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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
                fontSize: isTotal ? 14.sp : 13.sp,
                fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
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
                fontSize: isTotal ? 14.sp : 13.sp,
                fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(List<String> items) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.greyBorder),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((e) {
          final parts = e.split(': ');
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  parts[0],
                  style: GoogleFonts.openSans(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                Text(
                  parts[1],
                  style: GoogleFonts.openSans(
                    fontSize: 12.sp,
                    color: const Color(0xFF2C5F7A),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
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
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          flex: 2,
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
