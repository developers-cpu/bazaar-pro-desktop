import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../../../../core/widget/single_date_picker_dialog.dart';
import '../../bloc/intraday_history/intraday_history_bloc.dart';
import '../../bloc/intraday_history/intraday_history_event.dart';
import '../../bloc/intraday_history/intraday_history_state.dart';
import '../common/view_reset_buttons.dart';

class IntradayHistoryFilterBar extends StatelessWidget {
  const IntradayHistoryFilterBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IntradayHistoryBloc, IntradayHistoryState>(
      builder: (context, state) {
        if (state is! IntradayHistoryLoaded) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              
              Expanded(
                child: _buildDatePicker(context, state),
              ),
              SizedBox(width: 12.w),

              
              Expanded(
                child: AppDropdown(
                  type: AppDropdownType.simple,
                  hintText: 'Exchange',
                  value: state.selectedExchange,
                  items: state.exchanges,
                  onChanged: (value) {
                    context.read<IntradayHistoryBloc>().add(
                      ApplyIntradayFiltersEvent(
                        date: state.selectedDate,
                        exchange: value,
                        symbol: state.selectedSymbol,
                        timing: state.selectedTiming,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 12.w),

              
              Expanded(
                child: AppDropdown(
                  type: AppDropdownType.search,
                  hintText: 'Symbol',
                  value: state.selectedSymbol,
                  items: state.symbols,
                  onChanged: (value) {
                    context.read<IntradayHistoryBloc>().add(
                      ApplyIntradayFiltersEvent(
                        date: state.selectedDate,
                        exchange: state.selectedExchange,
                        symbol: value,
                        timing: state.selectedTiming,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 12.w),

              
              Expanded(
                child: AppDropdown(
                  type: AppDropdownType.simple,
                  hintText: 'Select Timing',
                  value: state.selectedTiming,
                  items: state.timings,
                  onChanged: (value) {
                    context.read<IntradayHistoryBloc>().add(
                      ApplyIntradayFiltersEvent(
                        date: state.selectedDate,
                        exchange: state.selectedExchange,
                        symbol: state.selectedSymbol,
                        timing: value,
                      ),
                    );
                  },
                ),
              ),

              const Spacer(),

              
              ViewResetButtons(
                onReset: () {
                  context.read<IntradayHistoryBloc>().add(
                    const ResetIntradayFiltersEvent(),
                  );
                },
                onView: () {
                  context.read<IntradayHistoryBloc>().add(
                    ApplyIntradayFiltersEvent(
                      date: state.selectedDate,
                      exchange: state.selectedExchange,
                      symbol: state.selectedSymbol,
                      timing: state.selectedTiming,
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

  Widget _buildDatePicker(BuildContext context, IntradayHistoryLoaded state) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    String displayText = 'Select Date';

    if (state.selectedDate != null) {
      displayText = dateFormat.format(state.selectedDate!);
    }

    return GestureDetector(
      onTap: () async {
        final result = await SingleDatePickerDialog.show(
          context,
          initialDate: state.selectedDate,
        );

        if (result != null) {
          context.read<IntradayHistoryBloc>().add(
            ApplyIntradayFiltersEvent(
              date: result,
              exchange: state.selectedExchange,
              symbol: state.selectedSymbol,
              timing: state.selectedTiming,
            ),
          );
        }
      },
      child: Container(
        height: 45.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.primaryBlue, width: 2.w),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                displayText,
                style: GoogleFonts.openSans(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: state.selectedDate != null
                      ? AppColors.primaryTextColor
                      : AppColors.primaryBlue,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.calendar_today,
              size: 20.sp,
              color: AppColors.primaryBlue,
            ),
          ],
        ),
      ),
    );
  }
}