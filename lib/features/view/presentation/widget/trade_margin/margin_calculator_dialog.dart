import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bazarpro/core/widget/common_dilog_box.dart';
import 'package:bazarpro/core/constants/app_colors.dart';
import 'package:bazarpro/core/widget/custom_input_field.dart';
import 'package:bazarpro/features/view/domain/entities/trade_margin/trade_margin.dart';

class MarginCalculatorDialog {
  static void show(BuildContext context, TradeMargin marginData) {
    CommonDialog.show(
      context: context,
      title: 'Margin Calculator',
      width: 500.w,
      showButtons: false,
      contentPadding: EdgeInsets.all(24.w),
      contentBuilder: (context, onClose) {
        return _MarginCalculatorContent(marginData: marginData);
      },
    );
  }
}

class _MarginCalculatorContent extends StatefulWidget {
  final TradeMargin marginData;

  const _MarginCalculatorContent({Key? key, required this.marginData}) : super(key: key);

  @override
  State<_MarginCalculatorContent> createState() => _MarginCalculatorContentState();
}

class _MarginCalculatorContentState extends State<_MarginCalculatorContent> {
  int quantity = 1000000;
  
  late TextEditingController intradayMarginPctCtrl;
  late TextEditingController carryForwardMarginPctCtrl;
  late TextEditingController intradayMarginAmtCtrl;
  late TextEditingController carryForwardMarginAmtCtrl;

  @override
  void initState() {
    super.initState();
    intradayMarginPctCtrl = TextEditingController(text: widget.marginData.intMarginPct.toString());
    carryForwardMarginPctCtrl = TextEditingController(text: widget.marginData.cfMarginPct.toString());
    intradayMarginAmtCtrl = TextEditingController(text: widget.marginData.intMarginAmt.toString());
    carryForwardMarginAmtCtrl = TextEditingController(text: widget.marginData.cfMarginAmt.toString());
  }

  @override
  void dispose() {
    intradayMarginPctCtrl.dispose();
    carryForwardMarginPctCtrl.dispose();
    intradayMarginAmtCtrl.dispose();
    carryForwardMarginAmtCtrl.dispose();
    super.dispose();
  }

  void _incrementQuantity() {
    setState(() {
      quantity += 100;
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (quantity > 100) {
        quantity -= 100;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.marginData.symbol,
                  style: GoogleFonts.openSans(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlue,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  widget.marginData.exchange,
                  style: GoogleFonts.openSans(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondaryTextColor,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quantity / Lots',
                  style: GoogleFonts.openSans(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlue,
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  height: 35.h,
                  width: 200.w,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryBlue, width: 1.5),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: _decrementQuantity,
                        child: Padding(
                           padding: EdgeInsets.symmetric(horizontal: 12.w),
                           child: Icon(Icons.remove, size: 16.sp, color: AppColors.primaryBlue),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '$quantity',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: _incrementQuantity,
                        child: Padding(
                           padding: EdgeInsets.symmetric(horizontal: 12.w),
                           child: Icon(Icons.add, size: 16.sp, color: AppColors.primaryBlue),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 24.h),
        Row(
          children: [
            Expanded(child: _buildFormField('Intraday Margin (%)', intradayMarginPctCtrl)),
            SizedBox(width: 16.w),
            Expanded(child: _buildFormField('Carry Forward Margin (%)', carryForwardMarginPctCtrl)),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(child: _buildFormField('Intraday Margin (Amt.)', intradayMarginAmtCtrl)),
            SizedBox(width: 16.w),
            Expanded(child: _buildFormField('Carry Forward Margin (Amt.)', carryForwardMarginAmtCtrl)),
          ],
        ),
      ],
    );
  }

  Widget _buildFormField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.openSans(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryBlue,
          ),
        ),
        SizedBox(height: 4.h),
        CustomInputField(
          hintText: '',
          controller: controller,
          height: 35.h,
          enabled: true,
        ),
      ],
    );
  }
}
