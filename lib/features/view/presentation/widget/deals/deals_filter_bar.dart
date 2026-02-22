import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../../../../core/widget/date_range_picker_dialog.dart';
import '../../bloc/deals/deals_bloc.dart';
import '../../bloc/deals/deals_event.dart';
import '../../bloc/deals/deals_state.dart';
import '../../../../../core/widget/table/view_reset_buttons.dart';

class DealsFilterBar extends StatelessWidget {
  const DealsFilterBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DealsBloc, DealsState>(
      builder: (context, state) {
        if (state is! DealsLoaded) {
          return const SizedBox.shrink();
        }
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              Expanded(child: _buildDateRangePicker(context, state)),
              SizedBox(width: 12.w),
              Expanded(
                child: AppDropdown(
                  type: AppDropdownType.search,
                  hintText: 'Client',
                  value: state.selectedClient,
                  items: state.clients,
                  onChanged: (value) {
                    context.read<DealsBloc>().add(
                      ApplyFiltersEvent(
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
              Expanded(
                child: AppDropdown(
                  type: AppDropdownType.simple,
                  hintText: 'Exchange',
                  value: state.selectedExchange,
                  items: state.exchanges,
                  showAllOption: true,
                  onChanged: (value) {
                    context.read<DealsBloc>().add(
                      ApplyFiltersEvent(
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
              Expanded(
                child: AppDropdown(
                  type: AppDropdownType.search,
                  hintText: 'Symbol',
                  value: state.selectedSymbol,
                  items: state.symbols,
                  onChanged: (value) {
                    context.read<DealsBloc>().add(
                      ApplyFiltersEvent(
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
              Expanded(
                child: AppDropdown(
                  type: AppDropdownType.simple,
                  hintText: 'Select Type',
                  value: state.selectedOrderType,
                  items: state.orderTypes,
                  showAllOption: true,
                  onChanged: (value) {
                    context.read<DealsBloc>().add(
                      ApplyFiltersEvent(
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
              Expanded(
                child: AppDropdown(
                  type: AppDropdownType.simple,
                  hintText: 'Status',
                  value: state.selectedStatus,
                  items: state.statuses,
                  showAllOption: true,
                  onChanged: (value) {
                    context.read<DealsBloc>().add(
                      ApplyFiltersEvent(
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
              const Spacer(),
              ViewResetButtons(
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

  Widget _buildDateRangePicker(BuildContext context, DealsLoaded state) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    String displayText = 'Select Date Range';
    if (state.startDate != null && state.endDate != null) {
      displayText =
          '${dateFormat.format(state.startDate!)} - ${dateFormat.format(state.endDate!)}';
    }
    return GestureDetector(
      onTap: () async {
        final result = await CustomDateRangePickerDialog.show(
          context,
          initialStartDate: state.startDate,
          initialEndDate: state.endDate,
        );
        if (result != null) {
          context.read<DealsBloc>().add(
            ApplyFiltersEvent(
              startDate: result.start,
              endDate: result.end,
              client: state.selectedClient,
              exchange: state.selectedExchange,
              symbol: state.selectedSymbol,
              orderType: state.selectedOrderType,
              status: state.selectedStatus,
            ),
          );
        }
      },
      child: Container(
        height: 35.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.primaryBlue, width: 1.5.w),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                displayText,
                style: GoogleFonts.openSans(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: (state.startDate != null && state.endDate != null)
                      ? AppColors.primaryTextColor
                      : AppColors.primaryBlue,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.calendar_today,
              size: 16.sp,
              color: AppColors.primaryBlue,
            ),
          ],
        ),
      ),
    );
  }
}
