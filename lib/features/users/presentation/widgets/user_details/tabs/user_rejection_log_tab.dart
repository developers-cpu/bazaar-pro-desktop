import 'package:flutter/material.dart' hide CustomDateRangePickerDialog;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/widget/date_range_picker_dialog.dart';
import '../../../../../../core/widget/date_range_picker_button.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/app_dropdown.dart';
import '../../../../../../injection_container.dart';
import '../../../../domain/entities/user.dart';
import '../../../../domain/entities/user_rejection_log/user_rejection_log.dart';
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
          sl<UserRejectionLogBloc>()..add(LoadUserRejectionLog(user.id)),
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
          List<String> exchangeItems = [];
          List<String> symbolItems = [];
          DateTimeRange? selectedDateRange;
          String? selectedExchange;
          String? selectedSymbol;

          if (state is UserRejectionLogLoaded) {
            selectedDateRange = state.selectedDateRange;
            selectedExchange = state.selectedExchange;
            selectedSymbol = state.selectedSymbol;
            if (state.metadata != null) {
              exchangeItems = state.metadata!.exchanges;
              symbolItems = state.metadata!.symbols;
            }
          }

          return Row(
            children: [
              DateRangePickerButton(
                selectedDateRange: selectedDateRange,
                onTap: () async {
                  final DateTimeRange? picked =
                      await CustomDateRangePickerDialog.show(
                        context,
                        initialStartDate: selectedDateRange?.start,
                        initialEndDate: selectedDateRange?.end,
                      );
                  if (picked != null) {
                    context.read<UserRejectionLogBloc>().add(
                      FilterUserRejectionLogs(
                        dateRange: picked,
                        exchange: selectedExchange,
                        symbol: selectedSymbol,
                      ),
                    );
                  }
                },
              ),
              SizedBox(width: 5.w),
              AppDropdown(
                hintText: 'Exchange',
                items: exchangeItems,
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
                width: 160.w,
                height: 35.h,
                type: AppDropdownType.simple,
              ),
              SizedBox(width: 5.w),
              AppDropdown(
                hintText: 'Symbol',
                items: symbolItems,
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
                width: 160.w,
                height: 35.h,
                type: AppDropdownType.search,
                searchHint: 'Search & Add',
              ),
              const Spacer(),
              UserResetButtons(
                height: 35.h,
                width: 100.w,
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
          columns: [
            UserTableColumn(id: 'uName', label: 'U.Name', width: 100.w),
            UserTableColumn(id: 'symbol', label: 'SYMBOL', width: 150.w),
            UserTableColumn(id: 'type', label: 'TYPE', width: 100.w),
            UserTableColumn(
              id: 'qty',
              label: 'QTY',
              width: 100.w,
              isNumeric: true,
            ),
            UserTableColumn(
              id: 'price',
              label: 'PRICE',
              width: 100.w,
              isNumeric: true,
            ),
            UserTableColumn(id: 'comment', label: 'COMMENT', width: 350.w),
            UserTableColumn(id: 'date', label: 'DATE', width: 160.w),
          ],
          data: logs,
          idExtractor: (item) => item.id,
          cellBuilder: (item, column) {
            switch (column.id) {
              case 'uName':
                return Text(item.userName, style: _cellStyle());
              case 'symbol':
                return Text(
                  item.symbol,
                  style: _cellStyle(
                    isSymbol: true,
                    color: AppColors.errorColor,
                  ),
                );
              case 'type':
                return Text(item.type, style: _cellStyle());
              case 'qty':
                return Text(item.qty.toString(), style: _cellStyle());
              case 'price':
                return Text(
                  item.price.toStringAsFixed(0),
                  style: _cellStyle(color: AppColors.errorColor),
                );
              case 'comment':
                return Text(
                  item.comment,
                  style: _cellStyle(color: AppColors.primaryBlue),
                );
              case 'date':
                return Text(
                  DateFormat('dd/MM/yy hh:mm:ss a').format(item.dateTime),
                  style: _cellStyle(color: AppColors.errorColor),
                );
              default:
                return const SizedBox();
            }
          },
        );
      },
    );
  }

  TextStyle _cellStyle({
    Color? color,
    bool isSymbol = false,
    bool isUnderline = false,
  }) {
    return GoogleFonts.openSans(
      fontSize: 11.sp,
      fontWeight: isSymbol ? FontWeight.bold : FontWeight.w600,
      color: color,
      decoration: isUnderline ? TextDecoration.underline : null,
    );
  }
}
