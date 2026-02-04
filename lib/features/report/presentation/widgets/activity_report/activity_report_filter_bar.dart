import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../../../../core/widget/date_range_picker_button.dart';
import '../../../../../core/widget/date_range_picker_dialog.dart' as custom;
import '../../../../view/presentation/widget/common/view_reset_buttons.dart';
import '../../bloc/activity_report/activity_report_bloc.dart';
import '../../bloc/activity_report/activity_report_event.dart';
import '../../bloc/activity_report/activity_report_state.dart';

class ActivityReportFilterBar extends StatelessWidget {
  const ActivityReportFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityReportBloc, ActivityReportState>(
      builder: (context, state) {
        if (state is! ActivityReportLoaded) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              AppDropdown(
                width: 200.w,
                height: 35.h,
                type: AppDropdownType.search,
                hintText: 'User',
                searchHint: 'Search & Add',
                value: state.selectedUser,
                items: state.users,
                onChanged: (value) {
                  context.read<ActivityReportBloc>().add(
                    FilterActivityReport(user: value),
                  );
                },
              ),
              SizedBox(width: 12.w),

              DateRangePickerButton(
                width: 200.w,
                height: 35.h,
                selectedDateRange: state.selectedDateRange,
                onTap: () async {
                  final picked = await custom.CustomDateRangePickerDialog.show(
                    context,
                    initialStartDate: state.selectedDateRange?.start,
                    initialEndDate: state.selectedDateRange?.end,
                  );
                  if (picked != null && context.mounted) {
                    context.read<ActivityReportBloc>().add(
                      FilterActivityReport(dateRange: picked),
                    );
                  }
                },
              ),
              SizedBox(width: 12.w),

              AppDropdown(
                width: 200.w,
                height: 35.h,
                type: AppDropdownType.simple,
                hintText: 'Edit User',
                value: state.selectedEditUserType,
                items: const [
                  'View Only',
                  'Leverage',
                  'Edit User',
                  'Bet',
                  'Fifteen Days',
                  'Close Only',
                  'Margin Square off',
                  'Status',
                  'Turnoverwise Brk',
                  'Symbolwise Brk',
                  'Shift User',
                ],
                onChanged: (value) {
                  context.read<ActivityReportBloc>().add(
                    FilterActivityReport(editUserType: value),
                  );
                },
              ),
              const Spacer(),

              ViewResetButtons(
                onReset: () {
                  context.read<ActivityReportBloc>().add(
                    const ResetActivityReportFilters(),
                  );
                },
                onView: () {
                  context.read<ActivityReportBloc>().add(
                    FilterActivityReport(
                      user: state.selectedUser,
                      dateRange: state.selectedDateRange,
                      editUserType: state.selectedEditUserType,
                    ),
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
