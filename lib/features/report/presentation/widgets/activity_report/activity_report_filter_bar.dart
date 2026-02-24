import 'package:bazarpro/core/widget/table/view_reset_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../../../../core/widget/date_range_picker_button.dart';
import '../../../../../core/widget/date_range_picker_dialog.dart' as custom;
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
              Expanded(
                child: AppDropdown(
                  type: AppDropdownType.simple,
                  hintText: 'User Type',
                  value: state.selectedUserType,
                  items: const ['Master', 'Client'],
                  onChanged: (value) {
                    context.read<ActivityReportBloc>().add(
                      FilterActivityReport(userType: value),
                    );
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: AppDropdown(
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
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: DateRangePickerButton(
                  selectedDateRange: state.selectedDateRange,
                  onTap: () async {
                    final picked =
                        await custom.CustomDateRangePickerDialog.show(
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
                      userType: state.selectedUserType,
                      user: state.selectedUser,
                      dateRange: state.selectedDateRange,
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
