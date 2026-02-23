import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/app_checkbox.dart';
import '../../../../../../core/widget/app_dropdown.dart';
import '../../../bloc/user_form/user_form_bloc.dart';
import '../../../bloc/user_form/user_form_event.dart';
import '../../../bloc/user_form/user_form_state.dart';
class MasterExchangeAllowStep extends StatelessWidget {
  const MasterExchangeAllowStep({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserFormBloc, UserFormState>(
      builder: (context, state) {
        final exchanges = UserFormState.availableExchanges;
        final isAllSelected =
            state.selectedExchanges.length == exchanges.length;
        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryBlue, width: 1.5),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCheckbox(
                label: 'Allow All',
                value: isAllSelected,
                size: 16.w,
                activeColor: AppColors.primaryBlue,
                borderColor: AppColors.secondaryTextColor,
                labelColor: isAllSelected
                    ? AppColors.primaryBlue
                    : AppColors.secondaryTextColor,
                labelFontSize: 11.sp,
                onChanged: (value) {
                  context.read<UserFormBloc>().add(
                    ToggleAllExchangesEvent(value ?? false),
                  );
                },
              ),
              SizedBox(height: 8.h),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.w,
                  mainAxisSpacing: 8.h,
                  mainAxisExtent: 85.h,
                ),
                itemCount: exchanges.length,
                itemBuilder: (context, index) {
                  final exchange = exchanges[index];
                  return _buildExchangeCard(context, state, exchange);
                },
              ),
            ],
          ),
        );
      },
    );
  }
  Widget _buildExchangeCard(
    BuildContext context,
    UserFormState state,
    String exchange,
  ) {
    final isSelected = state.selectedExchanges.contains(exchange);
    List<String> selectedGroups = [];
    final groupData = state.exchangeGroups[exchange];
    if (groupData != null) {
      if (groupData is List<String>) {
        selectedGroups = groupData as List<String>;
      } else if (groupData is String) {
        selectedGroups = [groupData];
      }
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected
              ? AppColors.primaryBlue
              : AppColors.grey.withValues(alpha: 0.3),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppCheckbox(
            label: exchange,
            value: isSelected,
            size: 16.w,
            activeColor: AppColors.primaryBlue,
            borderColor: AppColors.secondaryTextColor,
            labelColor: isSelected
                ? AppColors.primaryBlue
                : AppColors.secondaryTextColor,
            labelFontSize: 11.sp,
            onChanged: (value) {
              context.read<UserFormBloc>().add(
                UpdateExchangeSelectionEvent(
                  exchange: exchange,
                  isSelected: value ?? false,
                ),
              );
            },
          ),
          SizedBox(height: 4.h),
          AppDropdown(
            type: AppDropdownType.multiSelectRightNoSearch,
            height: 35.h,
            hintText: 'Select Group',
            selectedValues: selectedGroups,
            items: state.exchangeGroupOptions.isNotEmpty
                ? state.exchangeGroupOptions
                : const ['NSE_X', 'NSE_2X', 'NSE_3X', 'NSE_4X', 'NSE_5X'],
            searchHint: 'Search Groups',
            onMultiChanged: (values) {
              context.read<UserFormBloc>().add(
                UpdateExchangeGroupEvent(exchange: exchange, group: values),
              );
            },
          ),
        ],
      ),
    );
  }
}
