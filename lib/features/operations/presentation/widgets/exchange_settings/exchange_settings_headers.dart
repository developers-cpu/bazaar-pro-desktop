import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_images.dart';
import '../../../../../core/widget/custom_input_field.dart';
import '../../../../../core/widget/custom_action_button.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../bloc/exchange_settings/exchange_settings_bloc.dart';
import '../../bloc/exchange_settings/exchange_settings_event.dart';
class ExchangeSettingsHeader extends StatelessWidget {
  final int activeTab;
  final bool tradeLimitYes;
  final ValueChanged<bool> onTradeLimitChanged;
  final bool autoTickYes;
  final ValueChanged<bool> onAutoTickChanged;
  final TextEditingController tickSizeCtrl;
  final bool orderMarket;
  final bool orderSL;
  final bool orderLimit;
  final ValueChanged<bool> onOrderMarketChanged;
  final ValueChanged<bool> onOrderSLChanged;
  final ValueChanged<bool> onOrderLimitChanged;
  final bool selectTypeYes;
  final ValueChanged<bool> onSelectTypeChanged;
  final String attributeType;
  final ValueChanged<String> onAttributeTypeChanged;
  final String? selectedExchange;
  final ValueChanged<String?> onExchangeChanged;
  final List<String> exchanges;
  final TextEditingController searchCtrl;
  final Set<String> selectedIds;
  const ExchangeSettingsHeader({
    super.key,
    required this.activeTab,
    required this.tradeLimitYes,
    required this.onTradeLimitChanged,
    required this.autoTickYes,
    required this.onAutoTickChanged,
    required this.tickSizeCtrl,
    required this.orderMarket,
    required this.orderSL,
    required this.orderLimit,
    required this.onOrderMarketChanged,
    required this.onOrderSLChanged,
    required this.onOrderLimitChanged,
    required this.selectTypeYes,
    required this.onSelectTypeChanged,
    required this.attributeType,
    required this.onAttributeTypeChanged,
    required this.selectedExchange,
    required this.onExchangeChanged,
    required this.exchanges,
    required this.searchCtrl,
    required this.selectedIds,
  });
  @override
  Widget build(BuildContext context) {
    switch (activeTab) {
      case 0:
        return _highLowHeader(context);
      case 1:
        return _autoTickHeader(context);
      case 2:
        return _orderTypeHeader(context);
      case 3:
        return _oddLotHeader(context);
      case 5:
        return _tradeAttributeHeader(context);
      case 7:
        return _defaultSymbolHeader(context);
      default:
        return const SizedBox.shrink();
    }
  }
  Widget _highLowHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Trade limit', style: _labelStyle()),
            const Spacer(),
            _updateButton(context),
          ],
        ),
        SizedBox(height: 5.h),
        Row(
          children: [
            _radioOption(
              'Yes',
              tradeLimitYes,
              (_) => onTradeLimitChanged(true),
            ),
            SizedBox(width: 10.w),
            _radioOption(
              'No',
              !tradeLimitYes,
              (_) => onTradeLimitChanged(false),
            ),
          ],
        ),
      ],
    );
  }
  Widget _autoTickHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Auto Tick Size', style: _labelStyle()),
            SizedBox(width: 80.w),
            Text('Tick Size (If No)', style: _labelStyle()),
            const Spacer(),
            _updateButton(context),
          ],
        ),
        SizedBox(height: 5.h),
        Row(
          children: [
            _radioOption('Yes', autoTickYes, (_) => onAutoTickChanged(true)),
            SizedBox(width: 10.w),
            _radioOption('No', !autoTickYes, (_) => onAutoTickChanged(false)),
            SizedBox(width: 40.w),
            CustomInputField(
              hintText: '0.05',
              controller: tickSizeCtrl,
              width: 200.w,
              height: 35.h,
            ),
          ],
        ),
      ],
    );
  }
  Widget _orderTypeHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Order Type', style: _labelStyle()),
            const Spacer(),
            _updateButton(context),
          ],
        ),
        SizedBox(height: 5.h),
        Row(
          children: [
            _checkOption(
              'Market',
              orderMarket,
              (v) => onOrderMarketChanged(v ?? false),
            ),
            SizedBox(width: 10.w),
            _checkOption('SL', orderSL, (v) => onOrderSLChanged(v ?? false)),
            SizedBox(width: 10.w),
            _checkOption(
              'Limit',
              orderLimit,
              (v) => onOrderLimitChanged(v ?? false),
            ),
          ],
        ),
      ],
    );
  }
  Widget _oddLotHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Select  Type', style: _labelStyle()),
            const Spacer(),
            _updateButton(context),
          ],
        ),
        SizedBox(height: 5.h),
        Row(
          children: [
            _radioOption(
              'Yes',
              selectTypeYes,
              (_) => onSelectTypeChanged(true),
            ),
            SizedBox(width: 10.w),
            _radioOption(
              'No',
              !selectTypeYes,
              (_) => onSelectTypeChanged(false),
            ),
          ],
        ),
      ],
    );
  }
  Widget _tradeAttributeHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Attribute Type', style: _labelStyle()),
            const Spacer(),
            _updateButton(context),
          ],
        ),
        SizedBox(height: 5.h),
        Row(
          children: [
            _radioOption(
              'Full',
              attributeType == 'Full',
              (_) => onAttributeTypeChanged('Full'),
            ),
            SizedBox(width: 10.w),
            _radioOption(
              'Close',
              attributeType == 'Close',
              (_) => onAttributeTypeChanged('Close'),
            ),
            SizedBox(width: 10.w),
            _radioOption(
              'Block',
              attributeType == 'Block',
              (_) => onAttributeTypeChanged('Block'),
            ),
          ],
        ),
      ],
    );
  }
  Widget _defaultSymbolHeader(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 200.w,
          child: AppDropdown(
            items: exchanges,
            value: selectedExchange,
            hintText: 'Exchange',
            onChanged: (val) {
              onExchangeChanged(val);
              if (val != null) {
                context.read<ExchangeSettingsBloc>().add(
                  LoadDefaultSymbolsEvent(exchange: val),
                );
              }
            },
          ),
        ),
        SizedBox(width: 15.w),
        CustomInputField(
          hintText: 'Search',
          controller: searchCtrl,
          prefixSvgPath: AppImages.searchIcon,
          width: 200.w,
          height: 35.h,
        ),
        const Spacer(),
        if (selectedExchange != null) _updateButton(context),
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
  Widget _checkOption(String label, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.r),
          ),
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
    return CustomActionButton(
      text: 'Update',
      onPressed: () {
        if (selectedIds.isNotEmpty) {
          context.read<ExchangeSettingsBloc>().add(
            UpdateExchangeSettingsEvent(ids: selectedIds.toList()),
          );
        }
      },
      width: 100.w,
      height: 35.h,
      borderRadius: 8.r,
    );
  }
  TextStyle _labelStyle() => GoogleFonts.openSans(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryBlue,
  );
}
