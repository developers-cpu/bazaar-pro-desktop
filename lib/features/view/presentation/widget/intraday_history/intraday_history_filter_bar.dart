import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../../../../core/widget/table/view_reset_buttons.dart';
import '../../bloc/intraday_history/intraday_history_bloc.dart';
import '../../bloc/intraday_history/intraday_history_event.dart';
import '../../bloc/intraday_history/intraday_history_state.dart';
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
              SizedBox(
                width: 200.w,
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
              SizedBox(
                width: 200.w,
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
              SizedBox(
                width: 200.w,
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
}
