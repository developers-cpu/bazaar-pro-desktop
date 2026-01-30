import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/app_dropdown.dart';
import '../../../../../../core/widget/custom_input_field.dart';
import '../../../../domain/entities/user.dart';
import '../../../../domain/entities/user_trade_margin.dart';
import '../../../bloc/user_trade_margin/user_trade_margin_bloc.dart';
import '../../../bloc/user_trade_margin/user_trade_margin_event.dart';
import '../../../bloc/user_trade_margin/user_trade_margin_state.dart';
import '../../common/user_data_table.dart';
import '../../common/user_record_count.dart';
import '../../common/user_reset_buttons.dart';
import '../../common/user_update_button.dart'; // Reusing this generic button

class UserTradeMarginTab extends StatelessWidget {
  final User user;

  const UserTradeMarginTab({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UserTradeMarginBloc()..add(LoadUserTradeMargins(user.id)),
      child: const UserTradeMarginTabView(),
    );
  }
}

class UserTradeMarginTabView extends StatelessWidget {
  const UserTradeMarginTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilterBar(context),
        _buildActionRow(context),
        _buildRecordCount(context),
        Expanded(child: _buildTable(context)),
      ],
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      color: AppColors.white,
      child: BlocBuilder<UserTradeMarginBloc, UserTradeMarginState>(
        builder: (context, state) {
          String? selectedExchange;
          String? selectedSymbol;
          String searchQuery = '';

          if (state is UserTradeMarginLoaded) {
            selectedExchange = state.selectedExchange;
            selectedSymbol = state.selectedSymbol;
            searchQuery = state.searchQuery ?? '';
          }

          return Row(
            children: [
              AppDropdown(
                hintText: 'Exchange',
                items: const ['NSE', 'MCX'],
                value: selectedExchange,
                onChanged: (val) {
                  context.read<UserTradeMarginBloc>().add(
                    FilterUserTradeMargins(
                      exchange: val,
                      symbol: selectedSymbol,
                      searchQuery: searchQuery,
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
                  '360NE',
                  'AARTIND',
                  'ABB',
                  'ABBOTINDIA',
                  'ABCAPITAL',
                  'ACC',
                  'AMBER',
                  'ALKEM',
                  'AMBUJACEM',
                ],
                value: selectedSymbol,
                onChanged: (val) {
                  context.read<UserTradeMarginBloc>().add(
                    FilterUserTradeMargins(
                      exchange: selectedExchange,
                      symbol: val,
                      searchQuery: searchQuery,
                    ),
                  );
                },
                width: 200.w,
                height: 35.h,
                type: AppDropdownType.search,
              ),
              SizedBox(width: 12.w),
              SizedBox(
                width: 200.w,
                child: CustomInputField(
                  hintText: 'Search',
                
                  height: 35.h,
                  onChanged: (val) {
                    context.read<UserTradeMarginBloc>().add(
                      FilterUserTradeMargins(
                        exchange: selectedExchange,
                        symbol: selectedSymbol,
                        searchQuery: val,
                      ),
                    );
                  },
                ),
              ),
              const Spacer(),
              UserResetButtons(
                onReset: () {
                  context.read<UserTradeMarginBloc>().add(
                    const FilterUserTradeMargins(
                      exchange: null,
                      symbol: null,
                      searchQuery: null,
                    ),
                  );
                },
                onView: () {}, // View logic if needed
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActionRow(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      color: AppColors.white,
      child: Row(
        children: [
          AppDropdown(
            hintText: 'Margin Type',
            items: const ['Percentage', 'Amount'], // Mock items
            value: null,
            onChanged: (val) {},
            width: 200.w,
            height: 35.h,
            type: AppDropdownType.simple,
          ),
          SizedBox(width: 12.w),
          SizedBox(
            width: 200.w,
            child: CustomInputField(hintText: 'Margin%', height: 35.h),
          ),
          const Spacer(),
          UserUpdateButton(
            label: 'Update',
            onPressed: () {
              // Trigger update
            },
           
          ),
        ],
      ),
    );
  }

  Widget _buildRecordCount(BuildContext context) {
    return Container(
      color: AppColors.white,
      width: double.infinity,
      child: BlocBuilder<UserTradeMarginBloc, UserTradeMarginState>(
        builder: (context, state) {
          int count = 0;
          if (state is UserTradeMarginLoaded) {
            count = state.filteredMargins.length;
          }
          return UserRecordCount(count: count);
        },
      ),
    );
  }

  Widget _buildTable(BuildContext context) {
    return BlocBuilder<UserTradeMarginBloc, UserTradeMarginState>(
      builder: (context, state) {
        if (state is UserTradeMarginLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is UserTradeMarginError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        List<UserTradeMargin> data = [];
        bool isAllSelected = false;

        if (state is UserTradeMarginLoaded) {
          data = state.filteredMargins;
          isAllSelected = state.isAllSelected;
        }

        return UserDataTable<UserTradeMargin>(
          headerColor: AppColors.primaryBlue.withOpacity(0.2),
          columns: [
            UserTableColumn(
              id: 'checkbox',
              label: '',
              width: 50.w,
              sortable: false,
              customHeader: Checkbox(
                value: isAllSelected,
                onChanged: (val) {
                  context.read<UserTradeMarginBloc>().add(
                    ToggleAllUserTradeMarginSelection(val ?? false),
                  );
                },
                activeColor: AppColors.primaryBlue,
                side: const BorderSide(color: AppColors.primaryBlue),
              ),
            ),
            UserTableColumn(id: 'exchange', label: 'EXCH', width: 100.w),
            UserTableColumn(id: 'symbol', label: 'SYMBOL', width: 150.w),
            UserTableColumn(
              id: 'expiryDate',
              label: 'EXPIRY DATE',
              width: 250.w,
            ),
            UserTableColumn(
              id: 'marginPct',
              label: 'MARGIN (%)',
              width: 250.w,
              isNumeric: true,
            ),
            UserTableColumn(
              id: 'marginAmt',
              label: 'MARGIN (A.)',
              width: 250.w,
              isNumeric: true,
            ),
          ],
          data: data,
          idExtractor: (item) => item.id,
          cellBuilder: (item, column) {
            final commonStyle = GoogleFonts.openSans(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlue,
            );

            switch (column.id) {
              case 'checkbox':
                return Checkbox(
                  value: item.isSelected,
                  onChanged: (val) {
                    context.read<UserTradeMarginBloc>().add(
                      ToggleUserTradeMarginSelection(item.id),
                    );
                  },
                  activeColor: AppColors.primaryBlue,
                  side: const BorderSide(color: AppColors.primaryBlue),
                );
              case 'exchange':
                return Text(item.exchange, style: commonStyle);
              case 'symbol':
                return Text(item.symbol, style: commonStyle);
              case 'expiryDate':
                return Text(
                  DateFormat('dd/MM/yy | hh:mm:ss a').format(item.expiryDate),
                  style: commonStyle,
                );
              case 'marginPct':
                return Text(
                  item.marginPercentage.toStringAsFixed(0),
                  style: commonStyle,
                );
              case 'marginAmt':
                return Text(
                  item.marginAmount.toStringAsFixed(0),
                  style: commonStyle,
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
