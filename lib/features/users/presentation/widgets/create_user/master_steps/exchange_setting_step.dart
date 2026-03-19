import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/app_dropdown.dart';
import '../../../../../../core/widget/app_switch.dart';
import '../../../../../../core/widget/app_radio_group.dart';
import '../../../../../../core/widget/custom_input_field.dart';
import '../../../bloc/user_form/user_form_bloc.dart';
import '../../../bloc/user_form/user_form_event.dart';
import '../../../bloc/user_form/user_form_state.dart';

class ExchangeSettingStep extends StatefulWidget {
  const ExchangeSettingStep({super.key});
  @override
  State<ExchangeSettingStep> createState() => _ExchangeSettingStepState();
}

class _ExchangeSettingStepState extends State<ExchangeSettingStep> {
  late TextEditingController _squareOffTimingController;
  late TextEditingController _specificTimeController;
  @override
  void initState() {
    super.initState();
    final state = context.read<UserFormBloc>().state;
    _squareOffTimingController = TextEditingController(
      text: state.squareOffTiming,
    );
    _specificTimeController = TextEditingController(
      text: state.specificTime ?? '',
    );
  }

  @override
  void dispose() {
    _squareOffTimingController.dispose();
    _specificTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<UserFormBloc, UserFormState>(
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: constraints.maxWidth,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryBlue, width: 1.5),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return AppDropdown(
                                hintText: 'Exchange',
                                value: state.selectedExchangeSetting,
                                items: UserFormState.availableExchanges,
                                width: constraints.maxWidth,
                                height: 35.h,
                                onChanged: (value) {
                                  context.read<UserFormBloc>().add(
                                    UpdateExchangeSettingEvent(
                                      settingName: 'selectedExchange',
                                      value: value,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(child: const SizedBox.shrink()),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primaryBlue,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Profit Square Off Setting',
                            style: GoogleFonts.openSans(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Allow Square off',
                                        style: GoogleFonts.openSans(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primaryBlue,
                                        ),
                                      ),
                                    ),
                                    AppSwitch(
                                      value: state.allowSquareOff,
                                      onChanged: (value) {
                                        context.read<UserFormBloc>().add(
                                          UpdateExchangeSettingEvent(
                                            settingName: 'allowSquareOff',
                                            value: value,
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(width: 8.w),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: state.allowSquareOff
                                    ? CustomInputField(
                                        controller: _squareOffTimingController,
                                        hintText: 'Square off Timing (Mins)',
                                        keyboardType: TextInputType.number,
                                        height: 35.h,
                                        onChanged: (v) {
                                          context.read<UserFormBloc>().add(
                                            UpdateFormFieldEvent(
                                              fieldName: 'squareOffTiming',
                                              value: v,
                                            ),
                                          );
                                        },
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primaryBlue,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Market Open Time Restriction for SL / Limit',
                            style: GoogleFonts.openSans(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Expanded(
                                child: AppRadioGroup<String>(
                                  spacing: 4.w,
                                  fontSize: 11.sp,
                                  radioSize: 16.w,
                                  options: const [
                                    RadioOption(
                                      value: 'No Restriction',
                                      label: 'No Restriction',
                                    ),
                                    RadioOption(
                                      value: 'Specific Time',
                                      label: 'Specific Time',
                                    ),
                                  ],
                                  value: state.marketOpenTimeRestriction,
                                  onChanged: (value) {
                                    context.read<UserFormBloc>().add(
                                      UpdateExchangeSettingEvent(
                                        settingName:
                                            'marketOpenTimeRestriction',
                                        value: value ?? 'No Restriction',
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child:
                                    state.marketOpenTimeRestriction ==
                                        'Specific Time'
                                    ? CustomInputField(
                                        controller: _specificTimeController,
                                        hintText: 'Time (Mins)',
                                        keyboardType: TextInputType.number,
                                        height: 35.h,
                                        onChanged: (v) {
                                          context.read<UserFormBloc>().add(
                                            UpdateFormFieldEvent(
                                              fieldName: 'specificTime',
                                              value: v,
                                            ),
                                          );
                                        },
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}