import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/app_dropdown.dart';
import '../../../../../../core/widget/app_switch.dart';
import '../../../../../../core/widget/app_radio_group.dart';
import '../../../../../../core/widget/app_text_field.dart';
import '../../../bloc/user_form/user_form_bloc.dart';
import '../../../bloc/user_form/user_form_event.dart';
import '../../../bloc/user_form/user_form_state.dart';

/// Master Step: Exchange Setting
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
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryBlue, width: 2.w),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  return AppDropdown(
                    hintText: 'Exchange',
                    value: state.selectedExchangeSetting,
                    items: UserFormState.availableExchanges,
                    width: 300.w,
                    height: 50.h,
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
              SizedBox(height: 16.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primaryBlue, width: 2.w),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profit Square Off Setting',
                      style: GoogleFonts.openSans(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor(context),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        SizedBox(
                    width:140.w,
                          child: Text(
                            'Allow Square off',
                            style: GoogleFonts.openSans(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textColor(context),
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
                        if (state.allowSquareOff) ...[
                          SizedBox(width: 16.w),
                          SizedBox(
                            width: 300.w,
                            child: AppTextField(
                              controller: _squareOffTimingController,
                              hintText: 'Square off Timing (Mins)',
                              keyboardType: TextInputType.number,
                              height: 50.h,
                              onChanged: (v) {
                                context.read<UserFormBloc>().add(
                                  UpdateFormFieldEvent(
                                    fieldName: 'squareOffTiming',
                                    value: v,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primaryBlue, width: 2.w),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section title
                    Text(
                      'Market Open Time Restriction for SL / Limit',
                      style: GoogleFonts.openSans(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor(context),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        AppRadioGroup<String>(
                          options: const [
                            RadioOption(
                              value: 'No Restriction',
                              label: 'No Restiction',
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
                                settingName: 'marketOpenTimeRestriction',
                                value: value ?? 'No Restriction',
                              ),
                            );
                          },
                        ),

                        if (state.marketOpenTimeRestriction == 'Specific Time') ...[
                          SizedBox(width: 16.w),
                          SizedBox(
                            width: 300.w,
                            child: AppTextField(
                              controller: _specificTimeController,
                              hintText: 'Time (Mins)',
                              keyboardType: TextInputType.number,
                              height: 50.h,
                              onChanged: (v) {
                                context.read<UserFormBloc>().add(
                                  UpdateFormFieldEvent(
                                    fieldName: 'specificTime',
                                    value: v,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}