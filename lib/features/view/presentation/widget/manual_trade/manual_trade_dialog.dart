import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../../../../core/widget/app_switch.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../../../core/widget/custom_action_button.dart';
import '../../../../../core/widget/custom_input_field.dart';
import '../../bloc/manual_trade/manual_trade_bloc.dart';
import '../../bloc/manual_trade/manual_trade_event.dart';
import '../../bloc/manual_trade/manual_trade_state.dart';
import 'confirm_order_dialog.dart';

class ManualTradeDialog extends StatelessWidget {
  const ManualTradeDialog({Key? key}) : super(key: key);
  static void show(BuildContext context) {
    CommonDialog.show(
      context: context,
      title: 'Manual Trade',
      showButtons: false,
      width: 360.w,
      content: BlocProvider(
        create: (context) =>
            ManualTradeBloc()..add(const LoadManualTradeDataEvent()),
        child: const ManualTradeDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ManualTradeBloc, ManualTradeState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
              backgroundColor: AppColors.errorColor,
            ),
          );
        }
        if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage!),
              backgroundColor: AppColors.successColor,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.isLoading && state.users.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryBlue),
          );
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppDropdown(
              type: AppDropdownType.search,
              hintText: 'User',
              height: 28.h,
              value: state.selectedUser,
              items: state.users,
              onChanged: (val) => _updateField(context, 'selectedUser', val),
            ),
            SizedBox(height: 8.h),
            AppDropdown(
              type: AppDropdownType.search,
              hintText: 'Exchange',
              height: 28.h,
              value: state.selectedExchange,
              items: state.exchanges,
              onChanged: (val) =>
                  _updateField(context, 'selectedExchange', val),
            ),
            SizedBox(height: 8.h),
            AppDropdown(
              type: AppDropdownType.search,
              hintText: 'Symbol',
              height: 28.h,
              value: state.selectedSymbol,
              items: state.symbols,
              onChanged: (val) => _updateField(context, 'selectedSymbol', val),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Qty', style: _labelStyle()),
                      CustomInputField(
                        hintText: '1000000',
                        height: 28.h,
                        width: double.infinity,
                        keyboardType: TextInputType.number,
                        onChanged: (val) => _updateField(context, 'qty', val),
                        controller: TextEditingController(text: state.qty),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Lot', style: _labelStyle()),
                      Container(
                        height: 28.h,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primaryBlue),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove, size: 16.sp),
                              onPressed: () {
                                int current = int.tryParse(state.lot) ?? 1;
                                if (current > 1) {
                                  _updateField(
                                    context,
                                    'lot',
                                    '${current - 1}',
                                  );
                                }
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            Text('${state.lot} Lot', style: _valueStyle()),
                            IconButton(
                              icon: Icon(Icons.add, size: 16.sp),
                              onPressed: () {
                                int current = int.tryParse(state.lot) ?? 1;
                                _updateField(context, 'lot', '${current + 1}');
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Price', style: _labelStyle()),
                      CustomInputField(
                        height: 28.h,
                        hintText: '1000000',
                        width: double.infinity,
                        keyboardType: TextInputType.number,
                        onChanged: (val) => _updateField(context, 'price', val),
                        controller: TextEditingController(text: state.price),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Container(
              height: 28.h,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryBlue),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Is Brk Calculated Or Not :', style: _labelStyle()),
                  AppSwitch(
                    value: state.isBrkCalculated,
                    onChanged: (val) =>
                        _updateField(context, 'isBrkCalculated', val),
                    activeColor: AppColors.primaryBlue,
                    width: 36,
                    height: 20,
                    thumbSize: 16,
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Text('Time', style: _labelStyle()),
            GestureDetector(
              onTap: () async {
                final TimeOfDay? time = await showTimePicker(
                  context: context,
                  initialTime: state.selectedTime ?? TimeOfDay.now(),
                );
                if (time != null) {
                  _updateField(context, 'selectedTime', time);
                }
              },
              child: Container(
                height: 28.h,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primaryBlue),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      state.selectedTime != null
                          ? state.selectedTime!.format(context)
                          : 'Select Time',
                      style: _valueStyle(),
                    ),
                    Icon(
                      Icons.calendar_today,
                      size: 16.sp,
                      color: AppColors.primaryBlue,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Text('Date', style: _labelStyle()),
            GestureDetector(
              onTap: () async {
                final DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: state.selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  _updateField(context, 'selectedDate', date);
                }
              },
              child: Container(
                height: 28.h,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primaryBlue),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      state.selectedDate != null
                          ? DateFormat('dd/MM/yy').format(state.selectedDate!)
                          : 'Select Date',
                      style: _valueStyle(),
                    ),
                    Icon(
                      Icons.calendar_today,
                      size: 16.sp,
                      color: AppColors.primaryBlue,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8.h),
            AppDropdown(
              type: AppDropdownType.simple,
              hintText: 'Trade Display For',
              height: 28.h,
              value: state.selectedTradeDisplay,
              items: state.tradeDisplayOptions,
              onChanged: (val) =>
                  _updateField(context, 'selectedTradeDisplay', val),
            ),
            SizedBox(height: 8.h),
            CustomInputField(
              height: 28.h,
              hintText: 'Device ID',
              width: double.infinity,
              controller: TextEditingController(text: state.deviceId),
              onChanged: (val) => _updateField(context, 'deviceId', val),
            ),
            SizedBox(height: 8.h),
            CustomInputField(
              hintText: 'Device',
              height: 28.h,
              width: double.infinity,
              controller: TextEditingController(text: state.device),
              onChanged: (val) => _updateField(context, 'device', val),
            ),
            SizedBox(height: 8.h),
            CustomInputField(
              hintText: 'IP Address',
              height: 28.h,
              width: double.infinity,
              controller: TextEditingController(text: state.ipAddress),
              onChanged: (val) => _updateField(context, 'ipAddress', val),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: CustomActionButton(
                    text: 'Buy',
                    backgroundColor: AppColors.buyColor,
                    width: double.infinity,
                    height: 32.h,
                    onPressed: () {
                      context.read<ManualTradeBloc>().add(
                        const SubmitManualTradeEvent(isBuy: true),
                      );
                      ConfirmOrderDialog.show(context, state, true);
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CustomActionButton(
                    text: 'Sell',
                    backgroundColor: AppColors.sellColor,
                    width: double.infinity,
                    height: 32.h,
                    onPressed: () {
                      context.read<ManualTradeBloc>().add(
                        const SubmitManualTradeEvent(isBuy: false),
                      );
                      ConfirmOrderDialog.show(context, state, false);
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _updateField(BuildContext context, String field, dynamic value) {
    context.read<ManualTradeBloc>().add(
      UpdateManualTradeFieldEvent(field: field, value: value),
    );
  }

  TextStyle _labelStyle() {
    return GoogleFonts.openSans(
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.primaryBlue,
    );
  }

  TextStyle _valueStyle() {
    return GoogleFonts.openSans(
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.black,
    );
  }
}
