import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../../../../core/widget/date_range_picker_button.dart';
import '../../../../../core/widget/date_range_picker_dialog.dart';
import '../../../../../core/widget/table/view_reset_buttons.dart';
import '../../bloc/trade/trades_bloc.dart';
import '../../bloc/trade/trades_event.dart';
import '../../bloc/trade/trades_state.dart';

class TradesFilterBar extends StatelessWidget {
  const TradesFilterBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TradesBloc, TradesState>(
      builder: (context, state) {
        if (state is! TradesLoaded) {
          return const SizedBox.shrink();
        }
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              Expanded(
                child: DateRangePickerButton(
                  selectedDateRange:
                      state.startDate != null && state.endDate != null
                      ? DateTimeRange(
                          start: state.startDate!,
                          end: state.endDate!,
                        )
                      : null,
                  onTap: () async {
                    final result = await CustomDateRangePickerDialog.show(
                      context,
                      initialStartDate: state.startDate,
                      initialEndDate: state.endDate,
                    );
                    if (result != null) {
                      context.read<TradesBloc>().add(
                        ApplyFiltersEvent(
                          startDate: result.start,
                          endDate: result.end,
                          client: state.selectedClient,
                          exchange: state.selectedExchange,
                          symbol: state.selectedSymbol,
                          orderType: state.selectedOrderType,
                        ),
                      );
                    }
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: AppDropdown(
                  type: AppDropdownType.search,
                  hintText: 'Client',
                  value: state.selectedClient,
                  items: state.clients,
                  onChanged: (value) {
                    context.read<TradesBloc>().add(
                      ApplyFiltersEvent(
                        startDate: state.startDate,
                        endDate: state.endDate,
                        client: value,
                        exchange: state.selectedExchange,
                        symbol: state.selectedSymbol,
                        orderType: state.selectedOrderType,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: AppDropdown(
                  type: AppDropdownType.simple,
                  hintText: 'Exchange',
                  value: state.selectedExchange,
                  items: state.exchanges,
                  showAllOption: true,
                  onChanged: (value) {
                    context.read<TradesBloc>().add(
                      ApplyFiltersEvent(
                        startDate: state.startDate,
                        endDate: state.endDate,
                        client: state.selectedClient,
                        exchange: value,
                        symbol: state.selectedSymbol,
                        orderType: state.selectedOrderType,
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
                    context.read<TradesBloc>().add(
                      ApplyFiltersEvent(
                        startDate: state.startDate,
                        endDate: state.endDate,
                        client: state.selectedClient,
                        exchange: state.selectedExchange,
                        symbol: value,
                        orderType: state.selectedOrderType,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: AppDropdown(
                  type: AppDropdownType.simple,
                  hintText: 'Select Type',
                  value: state.selectedOrderType,
                  items: state.orderTypes,
                  showAllOption: true,
                  onChanged: (value) {
                    context.read<TradesBloc>().add(
                      ApplyFiltersEvent(
                        startDate: state.startDate,
                        endDate: state.endDate,
                        client: state.selectedClient,
                        exchange: state.selectedExchange,
                        symbol: state.selectedSymbol,
                        orderType: value,
                      ),
                    );
                  },
                ),
              ),
              const Spacer(),
              ViewResetButtons(
                onReset: () {
                  context.read<TradesBloc>().add(const ResetFiltersEvent());
                },
                onView: () {
                  context.read<TradesBloc>().add(
                    ApplyFiltersEvent(
                      startDate: state.startDate,
                      endDate: state.endDate,
                      client: state.selectedClient,
                      exchange: state.selectedExchange,
                      symbol: state.selectedSymbol,
                      orderType: state.selectedOrderType,
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
