import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../bloc/rejection_log/rejection_log_bloc.dart';
import '../../bloc/rejection_log/rejection_log_event.dart';
import '../../bloc/rejection_log/rejection_log_state.dart';
import '../common/view_reset_buttons.dart';

class RejectionLogFilterBar extends StatelessWidget {
  const RejectionLogFilterBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RejectionLogBloc, RejectionLogState>(
      builder: (context, state) {
        if (state is! RejectionLogLoaded) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [

              
              SizedBox(
                width: 230.w,
                child: AppDropdown(
                  type: AppDropdownType.search,
                  hintText: 'Client',
                  value: state.selectedClient,
                  items: state.clients,
                  onChanged: (value) {
                    context.read<RejectionLogBloc>().add(
                      ApplyRejectionLogFiltersEvent(
                        startDate: state.startDate,
                        endDate: state.endDate,
                        client: value,
                        exchange: state.selectedExchange,
                        symbol: state.selectedSymbol,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 12.w),

              
              SizedBox(
                width: 230.w,
                child: AppDropdown(
                  type: AppDropdownType.simple,
                  hintText: 'Exchange',
                  value: state.selectedExchange,
                  items: state.exchanges,
                  onChanged: (value) {
                    context.read<RejectionLogBloc>().add(
                      ApplyRejectionLogFiltersEvent(
                        startDate: state.startDate,
                        endDate: state.endDate,
                        client: state.selectedClient,
                        exchange: value,
                        symbol: state.selectedSymbol,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 12.w),

              
              SizedBox(
                width: 230.w,
                child: AppDropdown(
                  type: AppDropdownType.search,
                  hintText: 'Symbol',
                  value: state.selectedSymbol,
                  items: state.symbols,
                  onChanged: (value) {
                    context.read<RejectionLogBloc>().add(
                      ApplyRejectionLogFiltersEvent(
                        startDate: state.startDate,
                        endDate: state.endDate,
                        client: state.selectedClient,
                        exchange: state.selectedExchange,
                        symbol: value,
                      ),
                    );
                  },
                ),
              ),

              const Spacer(),

              
              ViewResetButtons(
                onReset: () {
                  context.read<RejectionLogBloc>().add(
                    const ResetRejectionLogFiltersEvent(),
                  );
                },
                onView: () {
                  context.read<RejectionLogBloc>().add(
                    ApplyRejectionLogFiltersEvent(
                      startDate: state.startDate,
                      endDate: state.endDate,
                      client: state.selectedClient,
                      exchange: state.selectedExchange,
                      symbol: state.selectedSymbol,
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