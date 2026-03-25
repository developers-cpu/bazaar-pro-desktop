import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/custom_input_field.dart';
import '../../../../../core/widget/app_radio_group.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../domain/entities/symbol_settings/symbol_setting.dart';

class TradeMarginDialog extends StatefulWidget {
  final SymbolSetting item;
  final void Function({
    required String marginType,
    required String intradayMarginPercent,
    required String carryForwardMarginPercent,
    required String intradayMarginAmount,
    required String carryForwardMarginAmount,
  })
  onSave;

  const TradeMarginDialog({
    super.key,
    required this.item,
    required this.onSave,
  });

  static void show(
    BuildContext context, {
    required SymbolSetting item,
    required void Function({
      required String marginType,
      required String intradayMarginPercent,
      required String carryForwardMarginPercent,
      required String intradayMarginAmount,
      required String carryForwardMarginAmount,
    })
    onSave,
  }) {
    CommonDialog.show(
      context: context,
      title: 'Trade Margin - ${item.symbol}',
      width: 700.w,
      height: 260.h,
      contentPadding: EdgeInsets.all(20.w),
      contentBuilder: (ctx, close) => TradeMarginDialog(
        item: item,
        onSave:
            ({
              required marginType,
              required intradayMarginPercent,
              required carryForwardMarginPercent,
              required intradayMarginAmount,
              required carryForwardMarginAmount,
            }) {
              onSave(
                marginType: marginType,
                intradayMarginPercent: intradayMarginPercent,
                carryForwardMarginPercent: carryForwardMarginPercent,
                intradayMarginAmount: intradayMarginAmount,
                carryForwardMarginAmount: carryForwardMarginAmount,
              );
              close();
            },
      ),
      showButtons: false,
    );
  }

  @override
  State<TradeMarginDialog> createState() => _TradeMarginDialogState();
}

class _TradeMarginDialogState extends State<TradeMarginDialog> {
  late String _marginType;
  late TextEditingController _intraPercentCtrl;
  late TextEditingController _cfPercentCtrl;
  late TextEditingController _intraAmountCtrl;
  late TextEditingController _cfAmountCtrl;

  @override
  void initState() {
    super.initState();
    _marginType = _normalizeMarginType(widget.item.marginType);
    _intraPercentCtrl = TextEditingController(
      text: widget.item.intradayMarginPercent,
    );
    _cfPercentCtrl = TextEditingController(
      text: widget.item.carryForwardMarginPercent,
    );
    _intraAmountCtrl = TextEditingController(
      text: widget.item.intradayMarginAmount,
    );
    _cfAmountCtrl = TextEditingController(
      text: widget.item.carryForwardMarginAmount,
    );
  }

  String _normalizeMarginType(String value) {
    if (value == 'Percentage' || value == 'Percentage Wise') {
      return 'Percentage Wise';
    }
    if (value == 'Fixed Amount' || value == 'Amount Wise') {
      return 'Amount Wise';
    }
    if (value == 'Both') {
      return 'Both';
    }
    return 'Percentage Wise';
  }

  @override
  void dispose() {
    _intraPercentCtrl.dispose();
    _cfPercentCtrl.dispose();
    _intraAmountCtrl.dispose();
    _cfAmountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Margin Type',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor,
              ),
            ),
            SizedBox(height: 10.h),
            AppRadioGroup<String>(
              value: _marginType,
              options: const [
                RadioOption(label: 'Percentage Wise', value: 'Percentage Wise'),
                RadioOption(label: 'Amount Wise', value: 'Amount Wise'),
                RadioOption(label: 'Both', value: 'Both'),
              ],
              onChanged: (val) => setState(() => _marginType = val!),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_marginType == 'Percentage Wise' || _marginType == 'Both')
                _buildField('Intraday Margin (%)', _intraPercentCtrl),
              if (_marginType == 'Percentage Wise' || _marginType == 'Both')
                SizedBox(width: 15.w),
              if (_marginType == 'Percentage Wise' || _marginType == 'Both')
                _buildField('Carry Forward Margin (%)', _cfPercentCtrl),
              if (_marginType == 'Both') SizedBox(width: 15.w),
              if (_marginType == 'Amount Wise' || _marginType == 'Both')
                _buildField('Intraday Margin Amount', _intraAmountCtrl),
              if (_marginType == 'Amount Wise' || _marginType == 'Both')
                SizedBox(width: 15.w),
              if (_marginType == 'Amount Wise' || _marginType == 'Both')
                _buildField('Carry Forward Margin Amount', _cfAmountCtrl),
            ],
          ),
        ),
        SizedBox(height: 30.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: () {
                widget.onSave(
                  marginType: _marginType,
                  intradayMarginPercent: _intraPercentCtrl.text,
                  carryForwardMarginPercent: _cfPercentCtrl.text,
                  intradayMarginAmount: _intraAmountCtrl.text,
                  carryForwardMarginAmount: _cfAmountCtrl.text,
                );
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildField(String label, TextEditingController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor,
          ),
        ),
        SizedBox(height: 5.h),
        CustomInputField(
          controller: ctrl,
          hintText: 'Enter value',
          width: 150.w,
          height: 35.h,
        ),
      ],
    );
  }
}
