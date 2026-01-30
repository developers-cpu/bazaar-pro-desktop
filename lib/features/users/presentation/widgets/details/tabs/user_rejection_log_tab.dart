import 'package:flutter/material.dart' hide DateRangePickerDialog;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/app_dropdown.dart';
import '../../../../../../core/widget/date_range_picker_dialog.dart';
import '../../../../domain/entities/user.dart';
import '../../../../domain/entities/user_rejection_log.dart';
import '../../../bloc/user_rejection_log/user_rejection_log_bloc.dart';
import '../../../bloc/user_rejection_log/user_rejection_log_event.dart';
import '../../../bloc/user_rejection_log/user_rejection_log_state.dart';
import '../../common/user_data_table.dart';
import '../../common/user_record_count.dart';
import '../../common/user_reset_buttons.dart';

class UserRejectionLogTab extends StatelessWidget {
  final User user;

  const UserRejectionLogTab({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UserRejectionLogBloc()..add(LoadUserRejectionLogs(user.id)),
      child: const UserRejectionLogTabView(),
    );
  }
}

class UserRejectionLogTabView extends StatelessWidget {
  const UserRejectionLogTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilterBar(context),
        _buildRecordCount(context),
        Expanded(child: _buildTable(context)),
      ],
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      color: AppColors.white,
      child: BlocBuilder<UserRejectionLogBloc, UserRejectionLogState>(
        builder: (context, state) {
          DateTimeRange? selectedDateRange;
          String? selectedExchange;
          String? selectedSymbol;

          if (state is UserRejectionLogLoaded) {
            selectedDateRange = state.selectedDateRange;
            selectedExchange = state.selectedExchange;
            selectedSymbol = state.selectedSymbol;
          }

          return Row(
            children: [
              InkWell(
                onTap: () async {
                  final result = await DateRangePickerDialog.show(
                    context,
                    initialStartDate: selectedDateRange?.start,
                    initialEndDate: selectedDateRange?.end,
                  );
                  if (result != null) {
                    context.read<UserRejectionLogBloc>().add(
                      FilterUserRejectionLogs(
                        dateRange: result,
                        exchange: selectedExchange,
                        symbol: selectedSymbol,
                      ),
                    );
                  }
                },
                child: Container(
                  height: 35.h,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryBlue),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text(
                        selectedDateRange != null
                            ? '${DateFormat('yyyy-MM-dd').format(selectedDateRange.start)} - ${DateFormat('yyyy-MM-dd').format(selectedDateRange.end)}'
                            : 'Select Date Range',
                        style: GoogleFonts.openSans(
                          fontSize: 12.sp,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.calendar_today,
                        size: 16.sp,
                        color: AppColors.primaryBlue,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.w),

              AppDropdown(
                hintText: 'Exchange',
                items: const ['NSE', 'MCX'],
                value: selectedExchange,
                onChanged: (val) {
                  context.read<UserRejectionLogBloc>().add(
                    FilterUserRejectionLogs(
                      dateRange: selectedDateRange,
                      exchange: val,
                      symbol: selectedSymbol,
                    ),
                  );
                },
                width: 150.w,
                height: 35.h,
                type: AppDropdownType.simple,
              ),
              SizedBox(width: 12.w),

              AppDropdown(
                hintText: 'Symbol',
                items: const [
                  'SGX GIFTNIFTY Oct 28',
                  'NSE NIFTY Oct 28',
                  'NSE BANKNIFTY Oct 28',
                  'MINI GOLDMINI Dec 05',
                  'MINI SILVERMINI Dec 05',
                  'OTHER DOW Dec 19',
                  'OTHER NASDAQ Dec 19',
                  'OTHER S & P Dec 19',
                ],
                value: selectedSymbol,
                onChanged: (val) {
                  context.read<UserRejectionLogBloc>().add(
                    FilterUserRejectionLogs(
                      dateRange: selectedDateRange,
                      exchange: selectedExchange,
                      symbol: val,
                    ),
                  );
                },
                width: 250.w,
                height: 35.h,
                type: AppDropdownType.search,
                searchHint: 'Search & Add',
              ),

              const Spacer(),

              UserResetButtons(
                onReset: () {
                  context.read<UserRejectionLogBloc>().add(
                    const FilterUserRejectionLogs(
                      dateRange: null,
                      exchange: null,
                      symbol: null,
                    ),
                  );
                },
                onView: () {},
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRecordCount(BuildContext context) {
    return Container(
      color: AppColors.white,
      width: double.infinity,
      child: BlocBuilder<UserRejectionLogBloc, UserRejectionLogState>(
        builder: (context, state) {
          int count = 0;
          if (state is UserRejectionLogLoaded) {
            count = state.filteredLogs.length;
          }
          return UserRecordCount(count: count);
        },
      ),
    );
  }

  Widget _buildTable(BuildContext context) {
    return BlocBuilder<UserRejectionLogBloc, UserRejectionLogState>(
      builder: (context, state) {
        if (state is UserRejectionLogLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is UserRejectionLogError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        List<UserRejectionLog> logs = [];
        if (state is UserRejectionLogLoaded) {
          logs = state.filteredLogs;
        }

        return UserDataTable<UserRejectionLog>(
          headerColor: AppColors.primaryBlue.withOpacity(0.2),
          columns: [
            UserTableColumn(id: 'uName', label: 'U.Name', width: 80.w),
            UserTableColumn(id: 'symbol', label: 'SYMBOL', width: 150.w),
            UserTableColumn(id: 'type', label: 'TYPE', width: 60.w),
            UserTableColumn(
              id: 'qty',
              label: 'QTY',
              width: 60.w,
              isNumeric: true,
            ),
            UserTableColumn(
              id: 'price',
              label: 'PRICE',
              width: 80.w,
              isNumeric: true,
            ),
            UserTableColumn(id: 'comment', label: 'COMMENT', width: 350.w),
            UserTableColumn(id: 'date', label: 'DATE', width: 160.w),
          ],
          data: logs,
          idExtractor: (item) => item.id,
          cellBuilder: (item, column) {
            final commonStyle = GoogleFonts.openSans(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlue,
            );

            switch (column.id) {
              case 'uName':
                return Text(item.userName, style: commonStyle);
              case 'symbol':
                return Text(item.symbol, style: commonStyle);
              case 'type':
                return Text(item.type, style: commonStyle);
              case 'qty':
                return Text(item.qty.toString(), style: commonStyle);
              case 'price':
                return Text(item.price.toStringAsFixed(0), style: commonStyle);
              case 'comment':
                return Text(
                  item.comment,
                  style: commonStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                  ),
                );
              case 'date':
                return Text(
                  DateFormat('dd/MM/yy hh:mm:ss a').format(item.dateTime),
                  style: commonStyle.copyWith(fontSize: 11.sp),
                );
              default:
                return const SizedBox();
            }
          },
        );
      },
    );
  }
}
