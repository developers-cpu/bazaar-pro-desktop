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
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryBlue, width: 1.5),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCheckbox(
                label: 'Select All',
                value: isAllSelected,
                size: 14.w,
                activeColor: AppColors.primaryBlue,
                borderColor: AppColors.secondaryTextColor,
                labelColor: isAllSelected
                    ? AppColors.primaryBlue
                    : AppColors.secondaryTextColor,
                labelFontSize: 10.sp,
                onChanged: (value) {
                  context.read<UserFormBloc>().add(
                    ToggleAllTradeLimitsEvent(value ?? false),
                  );
                },
              ),
              SizedBox(height: 4.h),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  crossAxisSpacing: 4.w,
                  mainAxisSpacing: 6.h,
                  mainAxisExtent: 24.h,
                ),
                itemCount: exchanges.length,
                itemBuilder: (context, index) {
                  final exchange = exchanges[index];
                  final isSelected = state.selectedTradeLimits.contains(
                    exchange,
                  );
                  return AppCheckbox(
                    label: exchange,
                    value: isSelected,
                    size: 14.w,
                    activeColor: AppColors.primaryBlue,
                    borderColor: AppColors.secondaryTextColor,
                    labelColor: isSelected
                        ? AppColors.primaryBlue
                        : AppColors.secondaryTextColor,
                    labelFontSize: 10.sp,
                    onChanged: (value) {
                      context.read<UserFormBloc>().add(
                        UpdateTradeLimitEvent(
                          exchange: exchange,
                          isSelected: value ?? false,
                        ),
                      );
                    },
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
