import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../../../../core/widget/date_range_picker_button.dart';
import '../../bloc/deals/deals_bloc.dart';
import '../../bloc/deals/deals_event.dart';
import '../../bloc/deals/deals_state.dart';
import '../../../../../core/widget/table/view_reset_buttons.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_state.dart';

class DealsFilterBar extends StatelessWidget {
  const DealsFilterBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DealsBloc, DealsState>(
      builder: (context, state) {
        if (state is! DealsLoaded) {
          return const SizedBox.shrink();
        }
        final authState = context.read<AuthBloc>().state;
        final isClient =
            authState is AuthAuthenticated &&
            authState.user.role.toLowerCase() == 'client';
        return Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 190.w,
                        child: DateRangePickerButton(
                          width: 190.w,
                          height: 35.h,
                          selectedDateRange:
                              state.startDate != null && state.endDate != null
                              ? DateTimeRange(
                                  start: state.startDate!,
                                  end: state.endDate!,
                                )
                              : null,
                          onTap: () {},
                          onDateRangeSelected: (range) {
                            context.read<DealsBloc>().add(
                              UpdateFiltersEvent(
                                startDate: range.start,
                                endDate: range.end,
                                client: state.selectedClient,
                                exchange: state.selectedExchange,
                                symbol: state.selectedSymbol,
                                orderType: state.selectedOrderType,
                                status: state.selectedStatus,
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 12.w),
                      if (!isClient) ...[
                        SizedBox(
                          width: 190.w,
                          child: AppDropdown(
                            type: AppDropdownType.search,
                            hintText: 'Username',
                            value: state.selectedClient,
                            items: state.clients,
                            onChanged: (value) {
                              context.read<DealsBloc>().add(
                                UpdateFiltersEvent(
                                  startDate: state.startDate,
                                  endDate: state.endDate,
                                  client: value,
                                  exchange: state.selectedExchange,
                                  symbol: state.selectedSymbol,
                                  orderType: state.selectedOrderType,
                                  status: state.selectedStatus,
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 12.w),
                      ],
                      SizedBox(
                        width: 190.w,
                        child: AppDropdown(
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
                            context.read<DealsBloc>().add(
                              UpdateFiltersEvent(
                                startDate: state.startDate,
                                endDate: state.endDate,
                                client: state.selectedClient,
                                exchange: value,
                                symbol: state.selectedSymbol,
                                orderType: state.selectedOrderType,
                                status: state.selectedStatus,
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 12.w),
                      SizedBox(
                        width: 190.w,
                        child: AppDropdown(
                          type: AppDropdownType.search,
                          hintText: 'Symbol',
                          value: state.selectedSymbol,
                          items: state.symbols,
                          onChanged: (value) {
                            context.read<DealsBloc>().add(
                              UpdateFiltersEvent(
                                startDate: state.startDate,
                                endDate: state.endDate,
                                client: state.selectedClient,
                                exchange: state.selectedExchange,
                                symbol: value,
                                orderType: state.selectedOrderType,
                                status: state.selectedStatus,
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 12.w),
                      SizedBox(
                        width: 190.w,
                        child: AppDropdown(
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
                            context.read<DealsBloc>().add(
                              UpdateFiltersEvent(
                                startDate: state.startDate,
                                endDate: state.endDate,
                                client: state.selectedClient,
                                exchange: state.selectedExchange,
                                symbol: state.selectedSymbol,
                                orderType: value,
                                status: state.selectedStatus,
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 12.w),
                      if (!isClient) ...[
                        SizedBox(
                          width: 190.w,
                          child: AppDropdown(
                            type: AppDropdownType.simple,
                            hintText: 'Status',
                            value: state.selectedStatus,
                            items: state.statuses,
                            showAllOption: true,
                            onChanged: (value) {
                              context.read<DealsBloc>().add(
                                UpdateFiltersEvent(
                                  startDate: state.startDate,
                                  endDate: state.endDate,
                                  client: state.selectedClient,
                                  exchange: state.selectedExchange,
                                  symbol: state.selectedSymbol,
                                  orderType: state.selectedOrderType,
                                  status: value,
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 12.w),
                      ],
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              ViewResetButtons(
                showReset: !isClient,
                onReset: () {
                  context.read<DealsBloc>().add(const ResetFiltersEvent());
                },
                onView: () {
                  context.read<DealsBloc>().add(
                    ApplyFiltersEvent(
                      startDate: state.startDate,
                      endDate: state.endDate,
                      client: state.selectedClient,
                      exchange: state.selectedExchange,
                      symbol: state.selectedSymbol,
                      orderType: state.selectedOrderType,
                      status: state.selectedStatus,
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
