import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/app_checkbox.dart';
import '../../../../../../core/widget/app_dropdown.dart';
import '../../../../../../core/widget/app_radio_group.dart';
import '../../../../../../core/widget/app_text_field.dart';
import '../../../../../../core/widget/custom_action_button.dart';
import '../../../bloc/user_form/user_form_bloc.dart';
import '../../../bloc/user_form/user_form_event.dart';
import '../../../bloc/user_form/user_form_state.dart';
import '../../common/user_record_count.dart';

class BrokerageSettingStep extends StatefulWidget {
  const BrokerageSettingStep({super.key});

  @override
  State<BrokerageSettingStep> createState() => _BrokerageSettingStepState();
}

class _BrokerageSettingStepState extends State<BrokerageSettingStep> {
  late TextEditingController _exchangeWiseBrkController;
  late TextEditingController _symbolWiseBrkController;

  @override
  void initState() {
    super.initState();
    final state = context.read<UserFormBloc>().state;
    _exchangeWiseBrkController = TextEditingController(
      text: state.exchangeWiseBrk,
    );
    _symbolWiseBrkController = TextEditingController(text: state.symbolWiseBrk);
  }

  @override
  void dispose() {
    _exchangeWiseBrkController.dispose();
    _symbolWiseBrkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserFormBloc, UserFormState>(
      builder: (context, state) {
        final isExchangeWise = state.brokerageViewMode == 'Exchange Wise';

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryBlue, width: 2.w),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppRadioGroup<String>(
                options: const [
                  RadioOption(value: 'Exchange Wise', label: 'Exchange Wise'),
                  RadioOption(value: 'Symbol Wise', label: 'Symbol Wise'),
                ],
                value: state.brokerageViewMode,
                onChanged: (value) {
                  context.read<UserFormBloc>().add(
                    UpdateBrokerageViewModeEvent(value ?? 'Exchange Wise'),
                  );
                },
              ),
              SizedBox(height: 20.h),

              if (isExchangeWise)
                _buildExchangeWiseInputs(state)
              else
                _buildSymbolWiseInputs(state),
              SizedBox(height: 16.h),

              UserRecordCount(count: UserFormState.availableExchanges.length),
              SizedBox(height: 8.h),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Column(
                    children: [
                      _buildTableHeader(context, state),

                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey.withOpacity(0.2),
                      ),

                      ...UserFormState.availableExchanges.map((exchange) {
                        final data = state.brokerageData[exchange];
                        return Column(
                          children: [
                            _buildTableRow(context, state, exchange, data),

                            Divider(
                              height: 1,
                              thickness: 1,
                              color: Colors.grey.withOpacity(0.15),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              Center(
                child: CustomActionButton(
                  text: 'Update',
                  width: 200.w,
                  height: 35.h,
                  borderRadius: 10.r,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExchangeWiseInputs(UserFormState state) {
    return Row(
      children: [
        Expanded(
          child: AppDropdown(
            hintText: 'Exchange',
            value: state.selectedBrokerageExchange,
            items: UserFormState.availableExchanges,
            height: 50.h,
            onChanged: (value) {
              context.read<UserFormBloc>().add(
                UpdateFormFieldEvent(
                  fieldName: 'selectedBrokerageExchange',
                  value: value,
                ),
              );
            },
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: AppTextField(
            controller: _exchangeWiseBrkController,
            hintText: 'Type exch wise brk',
            height: 50.h,
            keyboardType: TextInputType.number,
            onChanged: (v) {
              context.read<UserFormBloc>().add(
                UpdateFormFieldEvent(fieldName: 'exchangeWiseBrk', value: v),
              );
            },
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: AppTextField(
            controller: _symbolWiseBrkController,
            hintText: 'Type symbol wise brk',
            height: 50.h,
            keyboardType: TextInputType.number,
            onChanged: (v) {
              context.read<UserFormBloc>().add(
                UpdateFormFieldEvent(fieldName: 'symbolWiseBrk', value: v),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSymbolWiseInputs(UserFormState state) {
    return Row(
      children: [
        Expanded(
          child: AppDropdown(
            hintText: 'Exchange',
            value: state.selectedBrokerageExchange,
            items: UserFormState.availableExchanges,
            height: 50.h,
            onChanged: (value) {
              context.read<UserFormBloc>().add(
                UpdateFormFieldEvent(
                  fieldName: 'selectedBrokerageExchange',
                  value: value,
                ),
              );
            },
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: AppTextField(
            controller: _exchangeWiseBrkController,
            hintText: 'Type brokerage price',
            height: 50.h,
            keyboardType: TextInputType.number,
            onChanged: (v) {
              context.read<UserFormBloc>().add(
                UpdateFormFieldEvent(fieldName: 'exchangeWiseBrk', value: v),
              );
            },
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(child: SizedBox()),
      ],
    );
  }

  Widget _buildTableHeader(BuildContext context, UserFormState state) {
    final isAllSelected =
        state.selectedBrokerageExchanges.length ==
        UserFormState.availableExchanges.length;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.15),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.r),
          topRight: Radius.circular(8.r),
        ),
        border: Border(
          bottom: BorderSide(
            color: AppColors.primaryBlue.withOpacity(0.3),
            width: 1.5,
          ),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 40.w,
            child: AppCheckbox(
              value: isAllSelected,
              onChanged: (value) {
                context.read<UserFormBloc>().add(
                  ToggleAllBrokerageExchangesEvent(value ?? false),
                );
              },
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            flex: 2,
            child: Text(
              'EXCHANGE',
              style: GoogleFonts.openSans(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryBlue,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                'TURNOVER WISE\n(Rs.PER1/CR)',
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryBlue,
                  height: 1.3,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                'SYMBOL WISE BRK (Rs.)',
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(
    BuildContext context,
    UserFormState state,
    String exchange,
    BrokerageData? data,
  ) {
    final isSelected = state.selectedBrokerageExchanges.contains(exchange);
    final index = UserFormState.availableExchanges.indexOf(exchange);
    final isLast = index == UserFormState.availableExchanges.length - 1;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primaryBlue.withOpacity(0.05)
            : Colors.transparent,
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: AppColors.grey.withOpacity(0.2),
                  width: 1,
                ),
              ),
        borderRadius: isLast
            ? BorderRadius.only(
                bottomLeft: Radius.circular(8.r),
                bottomRight: Radius.circular(8.r),
              )
            : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 40.w,
            child: AppCheckbox(
              value: isSelected,
              onChanged: (value) {
                context.read<UserFormBloc>().add(
                  UpdateBrokerageEvent(
                    exchange: exchange,
                    isSelected: value ?? false,
                  ),
                );
              },
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            flex: 2,
            child: Text(
              exchange,
              style: GoogleFonts.openSans(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor(context),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                data?.turnoverWise ?? '00',
                style: GoogleFonts.openSans(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor(context),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                data?.symbolWiseBrk ?? '00',
                style: GoogleFonts.openSans(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
