import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/app_checkbox.dart';
import '../../../bloc/user_form/user_form_bloc.dart';
import '../../../bloc/user_form/user_form_event.dart';
import '../../../bloc/user_form/user_form_state.dart';


class HighLowLimitStep extends StatelessWidget {
  const HighLowLimitStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserFormBloc, UserFormState>(
      builder: (context, state) {
        final exchanges = UserFormState.availableExchanges;
        final isAllSelected =
            state.selectedTradeLimits.length == exchanges.length;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryBlue, width: 2.w),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCheckbox(
                label: 'Select All',
                value: isAllSelected,
                onChanged: (value) {
                  context.read<UserFormBloc>().add(
                    ToggleAllTradeLimitsEvent(value ?? false),
                  );
                },
              ),
              SizedBox(height: 20.h),

              LayoutBuilder(
                builder: (context, constraints) {
                  final availableWidth = constraints.maxWidth;
                  final itemWidth = (availableWidth - (4 * 32.w)) / 5; 

                  return Wrap(
                    spacing: 32.w,
                    runSpacing: 16.h,
                    children: exchanges.map((exchange) {
                      return SizedBox(
                        width: itemWidth,
                        child: AppCheckbox(
                          label: exchange,
                          value: state.selectedTradeLimits.contains(exchange),
                          onChanged: (value) {
                            context.read<UserFormBloc>().add(
                              UpdateTradeLimitEvent(
                                exchange: exchange,
                                isSelected: value ?? false,
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}