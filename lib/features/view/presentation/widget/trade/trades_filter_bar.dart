import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../../../../core/widget/date_range_picker_button.dart';
import '../../../../../core/widget/table/view_reset_buttons.dart';
import '../../bloc/trade/trades_bloc.dart';
import '../../bloc/trade/trades_event.dart';
import '../../bloc/trade/trades_state.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../auth/presentation/bloc/auth_state.dart';

class TradesFilterBar extends StatelessWidget {
  const TradesFilterBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TradesBloc, TradesState>(
      builder: (context, state) {
        if (state is! TradesLoaded) {
          return const SizedBox.shrink();
        }
        final authState = context.read<AuthBloc>().state;
        final isClient =
            authState is AuthAuthenticated &&
            authState.user.role.toLowerCase() == 'client';
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DateRangePickerButton(
                        width: 200.w,
                        selectedDateRange:
                            state.startDate != null && state.endDate != null
                            ? DateTimeRange(
                                start: state.startDate!,
                                end: state.endDate!,
                              )
                            : null,
                        onTap: () {},
                        onDateRangeSelected: (range) {
                          context.read<TradesBloc>().add(
                            UpdateFiltersEvent(
                              startDate: range.start,
                              endDate: range.end,
                              client: state.selectedClient,
                              exchange: state.selectedExchange,
                              symbol: state.selectedSymbol,
                              orderType: state.selectedOrderType,
                            ),
                          );
                        },
                      ),
                      if (!isClient) ...[
                        SizedBox(width: 12.w),
                        AppDropdown(
                          width: 200.w,
                          type: AppDropdownType.search,
                          hintText: 'Username',
                          value: state.selectedClient,
                          items: state.clients,
                          onChanged: (value) {
                            context.read<TradesBloc>().add(
                              UpdateFiltersEvent(
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
                      ],
                      SizedBox(width: 12.w),
                      AppDropdown(
                        width: 200.w,
                        type: AppDropdownType.simple,
                        hintText: 'Exchange',
                        value: state.selectedExchange,
                        items: const [
                          'NSE',
                          'MCX',
                          'CE/PE',
                          'OTHERS',
                          'COMEX FUTURE',
                          'COMEX SPOT',
                          'CRYPTO',
                          'GIFT',
                          'FOREX',
                        ],
                        onChanged: (value) {
                          context.read<TradesBloc>().add(
                            UpdateFiltersEvent(
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
                      SizedBox(width: 12.w),
                      AppDropdown(
                        width: 200.w,
                        type: AppDropdownType.search,
                        hintText: 'Symbol',
                        value: state.selectedSymbol,
                        items: state.symbols,
                        onChanged: (value) {
                          context.read<TradesBloc>().add(
                            UpdateFiltersEvent(
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
                      SizedBox(width: 12.w),
                      AppDropdown(
                        width: 200.w,
                        type: AppDropdownType.simple,
                        hintText: 'Select Type',
                        value: state.selectedOrderType,
                        items: const [
                          'Buy',
                          'Sell',
                          'Buy Limit',
                          'Buy Stop',
                          'Sell Limit',
                          'Sell Stop',
                        ],
                        showAllOption: true,
                        onChanged: (value) {
                          context.read<TradesBloc>().add(
                            UpdateFiltersEvent(
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
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              ViewResetButtons(
                showReset: !isClient,
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
