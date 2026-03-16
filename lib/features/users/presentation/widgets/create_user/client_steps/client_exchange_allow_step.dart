import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/app_checkbox.dart';
import '../../../../../../core/widget/app_dropdown.dart';
import '../../../bloc/user_form/user_form_bloc.dart';
import '../../../bloc/user_form/user_form_event.dart';
import '../../../bloc/user_form/user_form_state.dart';
class ClientExchangeAllowStep extends StatelessWidget {
  const ClientExchangeAllowStep({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserFormBloc, UserFormState>(
      builder: (context, state) {
        final exchanges = UserFormState.availableExchanges;
        final isAllSelected =
            state.selectedExchanges.length == exchanges.length;
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryBlue, width: 1.0),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              _buildTableHeader(context, state, isAllSelected),
              ...exchanges.asMap().entries.map((entry) {
                final index = entry.key;
                final exchange = entry.value;
                final isLast = index == exchanges.length - 1;
                return _buildTableRow(context, state, exchange, isLast);
              }),
            ],
          ),
        );
      },
    );
  }
  Widget _buildTableHeader(
    BuildContext context,
    UserFormState state,
    bool isAllSelected,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Exch',
                  style: GoogleFonts.openSans(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColor(context),
                  ),
                ),
                SizedBox(height: 2.h),
                AppCheckbox(
                  label: 'Select All',
                  value: isAllSelected,
                  size: 14.w,
                  labelFontSize: 10.sp,
                  onChanged: (value) {
                    context.read<UserFormBloc>().add(
                      ToggleAllExchangesEvent(value ?? false),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Text(
                  'Brokerage',
                  style: GoogleFonts.openSans(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColor(context),
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Text(
                        'Turnover wise',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Symbol wise',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                Text(
                  'Groups',
                  style: GoogleFonts.openSans(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColor(context),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Assign Groups',
                  style: GoogleFonts.openSans(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey,
                  ),
                ),
              ],
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
    bool isLast,
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
    final brokerageData = state.brokerageData[exchange];
    final turnoverWise = brokerageData?.turnoverWise == 'true';
    final symbolWise = brokerageData?.symbolWiseBrk == 'true';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: AppCheckbox(
              label: exchange,
              value: isSelected,
              size: 14.w,
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
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    context.read<UserFormBloc>().add(
                      UpdateBrokerageEvent(
                        exchange: exchange,
                        isSelected: isSelected,
                        turnoverWise: turnoverWise ? 'false' : 'true',
                      ),
                    );
                  },
                  child: Container(
                    width: 18.w,
                    height: 18.w,
                    decoration: BoxDecoration(
                      color: turnoverWise
                          ? AppColors.primaryBlue
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(
                        color: turnoverWise
                            ? AppColors.primaryBlue
                            : AppColors.grey,
                        width: 1.0,
                      ),
                    ),
                    child: turnoverWise
                        ? Icon(Icons.check, size: 12.sp, color: AppColors.white)
                        : null,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    context.read<UserFormBloc>().add(
                      UpdateBrokerageEvent(
                        exchange: exchange,
                        isSelected: isSelected,
                        symbolWiseBrk: symbolWise ? 'false' : 'true',
                      ),
                    );
                  },
                  child: Container(
                    width: 18.w,
                    height: 18.w,
                    decoration: BoxDecoration(
                      color: symbolWise
                          ? AppColors.primaryBlue
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(
                        color: symbolWise
                            ? AppColors.primaryBlue
                            : AppColors.grey,
                        width: 1.0,
                      ),
                    ),
                    child: symbolWise
                        ? Icon(Icons.check, size: 12.sp, color: AppColors.white)
                        : null,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: AppDropdown(
              type: AppDropdownType.multiSelectRightNoSearch,
              hintText: 'Select Group',
              selectedValues: selectedGroups,
              items: state.exchangeGroupOptions.isNotEmpty
                  ? state.exchangeGroupOptions
                  : const ['NSE_X', 'NSE_2X', 'NSE_3X', 'NSE_4X', 'NSE_5X'],
              height: 28.h,
              searchHint: 'Search Groups',
              onMultiChanged: (values) {
                context.read<UserFormBloc>().add(
                  UpdateExchangeGroupEvent(exchange: exchange, group: values),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
