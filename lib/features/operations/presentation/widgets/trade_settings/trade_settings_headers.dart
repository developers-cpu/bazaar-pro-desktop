import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/custom_input_field.dart';
import '../../../../../core/widget/custom_action_button.dart';
class TradeSettingsHeaders extends StatefulWidget {
  final int activeTab;
  final String marginType;
  final ValueChanged<String> onMarginTypeChanged;
  final String brokerageType;
  final ValueChanged<String> onBrokerageTypeChanged;
  const TradeSettingsHeaders({
    super.key,
    required this.activeTab,
    required this.marginType,
    required this.onMarginTypeChanged,
    required this.brokerageType,
    required this.onBrokerageTypeChanged,
  });
  @override
  State<TradeSettingsHeaders> createState() => _TradeSettingsHeadersState();
}
class _TradeSettingsHeadersState extends State<TradeSettingsHeaders> {
  String get _marginType => widget.marginType;
  final _intMarginPercentageCtrl = TextEditingController(text: '0.05');
  final _cfMarginPercentageCtrl = TextEditingController(text: '0.05');
  final _intMarginAmtCtrl = TextEditingController(text: '0.05');
  final _cfMarginAmtCtrl = TextEditingController(text: '0.05');
  String get _brokerageType => widget.brokerageType;
  final _turnoverBrokerageCtrl = TextEditingController(text: '0.05');
  final _lotWiseBrokerageCtrl = TextEditingController(text: '0.05');
  final _leverageCtrl = TextEditingController();
  final _tradeSecondsCtrl = TextEditingController();
  @override
  void dispose() {
    _intMarginPercentageCtrl.dispose();
    _cfMarginPercentageCtrl.dispose();
    _intMarginAmtCtrl.dispose();
    _cfMarginAmtCtrl.dispose();
    _turnoverBrokerageCtrl.dispose();
    _lotWiseBrokerageCtrl.dispose();
    _leverageCtrl.dispose();
    _tradeSecondsCtrl.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    switch (widget.activeTab) {
      case 0:
        return _marginHeader(context);
      case 1:
        return _brokerageHeader(context);
      case 2:
        return _leverageHeader(context);
      case 3:
        return _tradeSecondsHeader(context);
      default:
        return const SizedBox.shrink();
    }
  }
  Widget _marginHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Margin Type', style: _labelStyle()),
                        SizedBox(height: 5.h),
                        Row(
                          children: [
                            _radioOption(
                              'Percentage Wise',
                              _marginType == 'Percentage Wise',
                              (_) =>
                                  widget.onMarginTypeChanged('Percentage Wise'),
                            ),
                            SizedBox(width: 10.w),
                            _radioOption(
                              'Amount Wise',
                              _marginType == 'Amount Wise',
                              (_) => widget.onMarginTypeChanged('Amount Wise'),
                            ),
                            SizedBox(width: 10.w),
                            _radioOption(
                              'Both',
                              _marginType == 'Both',
                              (_) => widget.onMarginTypeChanged('Both'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(width: 30.w),
                    if (_marginType == 'Percentage Wise' ||
                        _marginType == 'Both') ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Intraday Margin (%)', style: _labelStyle()),
                          SizedBox(height: 5.h),
                          CustomInputField(
                            hintText: '0.05',
                            controller: _intMarginPercentageCtrl,
                            width: 200.w,
                            height: 35.h,
                          ),
                        ],
                      ),
                      SizedBox(width: 15.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Carry Forward Margin (%)',
                            style: _labelStyle(),
                          ),
                          SizedBox(height: 5.h),
                          CustomInputField(
                            hintText: '0.05',
                            controller: _cfMarginPercentageCtrl,
                            width: 200.w,
                            height: 35.h,
                          ),
                        ],
                      ),
                    ],
                    if (_marginType == 'Both') SizedBox(width: 15.w),
                    if (_marginType == 'Amount Wise' ||
                        _marginType == 'Both') ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Intraday Margin (Amt.)', style: _labelStyle()),
                          SizedBox(height: 5.h),
                          CustomInputField(
                            hintText: '0.05',
                            controller: _intMarginAmtCtrl,
                            width: 200.w,
                            height: 35.h,
                          ),
                        ],
                      ),
                      SizedBox(width: 15.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Carry Forward Margin (Amt.)',
                            style: _labelStyle(),
                          ),
                          SizedBox(height: 5.h),
                          CustomInputField(
                            hintText: '0.05',
                            controller: _cfMarginAmtCtrl,
                            width: 200.w,
                            height: 35.h,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            SizedBox(width: 10.w),
            _updateButton(context),
          ],
        ),
      ],
    );
  }
  Widget _brokerageHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Brokerage Type', style: _labelStyle()),
                SizedBox(height: 5.h),
                Row(
                  children: [
                    _radioOption(
                      'Turnover Wise',
                      _brokerageType == 'Turnover Wise',
                      (_) => widget.onBrokerageTypeChanged('Turnover Wise'),
                    ),
                    SizedBox(width: 10.w),
                    _radioOption(
                      'Lot Wise',
                      _brokerageType == 'Lot Wise',
                      (_) => widget.onBrokerageTypeChanged('Lot Wise'),
                    ),
                    SizedBox(width: 10.w),
                    _radioOption(
                      'Both',
                      _brokerageType == 'Both',
                      (_) => widget.onBrokerageTypeChanged('Both'),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(width: 30.w),
            if (_brokerageType == 'Turnover Wise' || _brokerageType == 'Both')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Turnover wise Brokerage (Rs Per 1CR)',
                    style: _labelStyle(),
                  ),
                  SizedBox(height: 5.h),
                  CustomInputField(
                    hintText: '0.05',
                    controller: _turnoverBrokerageCtrl,
                    width: 200.w,
                    height: 35.h,
                  ),
                ],
              ),
            if (_brokerageType == 'Both') SizedBox(width: 15.w),
            if (_brokerageType == 'Lot Wise' || _brokerageType == 'Both')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lot Wise Brokerage (Amt. per Lot)',
                    style: _labelStyle(),
                  ),
                  SizedBox(height: 5.h),
                  CustomInputField(
                    hintText: '0.05',
                    controller: _lotWiseBrokerageCtrl,
                    width: 200.w,
                    height: 35.h,
                  ),
                ],
              ),
            const Spacer(),
            _updateButton(context),
          ],
        ),
      ],
    );
  }
  Widget _leverageHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Leverage', style: _labelStyle()),
                SizedBox(height: 5.h),
                CustomInputField(
                  hintText: 'Type here',
                  controller: _leverageCtrl,
                  width: 300.w,
                  height: 35.h,
                ),
              ],
            ),
            const Spacer(),
            _updateButton(context),
          ],
        ),
      ],
    );
  }
  Widget _tradeSecondsHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Trade Seconds', style: _labelStyle()),
                SizedBox(height: 5.h),
                CustomInputField(
                  hintText: 'Type here',
                  controller: _tradeSecondsCtrl,
                  width: 300.w,
                  height: 35.h,
                ),
              ],
            ),
            const Spacer(),
            _updateButton(context),
          ],
        ),
      ],
    );
  }
  Widget _radioOption(
    String label,
    bool selected,
    ValueChanged<bool?> onChanged,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<bool>(
          value: true,
          groupValue: selected,
          onChanged: onChanged,
          activeColor: AppColors.primaryBlue,
        ),
        Text(
          label,
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            color: AppColors.primaryBlue,
          ),
        ),
      ],
    );
  }
  Widget _updateButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: CustomActionButton(
        text: 'Update',
        onPressed: () {},
        width: 100.w,
        height: 35.h,
        borderRadius: 8.r,
      ),
    );
  }
  TextStyle _labelStyle() => GoogleFonts.openSans(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryBlue,
  );
}
