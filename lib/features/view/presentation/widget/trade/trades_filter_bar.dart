import 'package:flutter/material.dart' hide DateRangePickerDialog;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../../../../core/widget/date_range_picker_dialog.dart';
import '../../bloc/trade/trades_bloc.dart';
import '../../bloc/trade/trades_event.dart';
import '../../bloc/trade/trades_state.dart';
import '../common/view_reset_buttons.dart';

/// Filter bar for Trades page
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
              // Date Range Picker
              Expanded(
                child: _buildDateRangePicker(context, state),
              ),
              SizedBox(width: 12.w),

              // Client Dropdown
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

              // Exchange Dropdown
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

              // Symbol Dropdown
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

              // Order Type Dropdown
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

              // Reset and View Buttons
              ViewResetButtons(
                onReset: () {
                  context.read<TradesBloc>().add(
                    const ResetFiltersEvent(),
                  );
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

  Widget _buildDateRangePicker(BuildContext context, TradesLoaded state) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    String displayText = 'Select Date Range';

    if (state.startDate != null && state.endDate != null) {
      displayText = '${dateFormat.format(state.startDate!)} - ${dateFormat.format(state.endDate!)}';
    }

    return GestureDetector(
      onTap: () async {
        final result = await DateRangePickerDialog.show(
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
                  color: (state.startDate != null && state.endDate != null)
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