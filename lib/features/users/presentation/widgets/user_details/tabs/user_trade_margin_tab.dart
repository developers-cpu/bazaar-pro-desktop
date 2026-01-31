import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_images.dart';
import '../../../../../../core/widget/app_dropdown.dart';
import '../../../../../../core/widget/custom_input_field.dart';
import '../../../../../../core/widget/custom_action_button.dart';
import '../../../../domain/entities/user.dart';
import '../../../../domain/entities/user_trade_margin/user_trade_margin.dart';
import '../../../bloc/user_trade_margin/user_trade_margin_bloc.dart';
import '../../../bloc/user_trade_margin/user_trade_margin_event.dart';
import '../../../bloc/user_trade_margin/user_trade_margin_state.dart';
import '../../common/user_data_table.dart';
import '../../common/user_record_count.dart';
import '../../common/user_reset_buttons.dart';

import '../../../../../../injection_container.dart';

class UserTradeMarginTab extends StatelessWidget {
  final User user;

  const UserTradeMarginTab({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<UserTradeMarginBloc>()..add(LoadUserTradeMargin(user.id)),
      child: const UserTradeMarginTabView(),
    );
  }
}

class UserTradeMarginTabView extends StatefulWidget {
  const UserTradeMarginTabView({super.key});

  @override
  State<UserTradeMarginTabView> createState() => _UserTradeMarginTabViewState();
}

class _UserTradeMarginTabViewState extends State<UserTradeMarginTabView> {
  final TextEditingController _marginController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _marginController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onUpdate(BuildContext context) {

  }

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
      child: BlocBuilder<UserTradeMarginBloc, UserTradeMarginState>(
        builder: (context, state) {
          List<String> exchangeItems = [];
          List<String> symbolItems = [];
          String? selectedExchange;
          String? selectedSymbol;

          if (state is UserTradeMarginLoaded) {
            selectedExchange = state.selectedExchange;
            selectedSymbol = state.selectedSymbol;

            if (state.metadata != null) {
              exchangeItems = state.metadata!.exchanges;
              symbolItems = state.metadata!.symbols;
            }
          }

          return Column(
            children: [
              Row(
                children: [
                  AppDropdown(
                    hintText: 'Exchange',
                    items: exchangeItems,
                    value: selectedExchange,
                    onChanged: (val) {
                      context.read<UserTradeMarginBloc>().add(
                        FilterUserTradeMargins(
                          exchange: val,
                          symbol: selectedSymbol,
                        ),
                      );
                    },
                    width: 160.w,
                    height: 35.h,
                    type: AppDropdownType.simple,
                  ),
                  SizedBox(width: 8.w),
                  AppDropdown(
                    hintText: 'Symbol',
                    items: symbolItems,
                    value: selectedSymbol,
                    onChanged: (val) {
                      context.read<UserTradeMarginBloc>().add(
                        FilterUserTradeMargins(
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
                  SizedBox(width: 8.w),
                  CustomInputField(
                    hintText: 'Search',
                    controller: _searchController,
                    height: 35.h,
                    width: 200.w,
                    prefixSvgPath: AppImages.searchIcon,
                    onChanged: (val) {

                    },
                  ),
                  const Spacer(),
                  UserResetButtons(
                    height: 35.h,
                    width: 100.w,
                    onReset: () {
                      context.read<UserTradeMarginBloc>().add(
                        const FilterUserTradeMargins(
                          exchange: null,
                          symbol: null,
                        ),
                      );
                      _searchController.clear();
                    },
                    onView: () {},
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  AppDropdown(
                    hintText: 'Margin Type',
                    items: const ['Percentage', 'Amount'],
                    value: null,
                    onChanged: (val) {},
                    width: 160.w,
                    height: 35.h,
                    type: AppDropdownType.simple,
                  ),
                  SizedBox(width: 8.w),
                  CustomInputField(
                    hintText: 'Margin%',
                    controller: _marginController,
                    height: 35.h,
                    width: 160.w,
                  ),
                  const Spacer(),
                  CustomActionButton(
                    text: 'Update',
                    onPressed: () => _onUpdate(context),
                    width: 212.w,
                    height: 35.h,
                    backgroundColor: AppColors.primaryBlue,
                    borderRadius: 8.r,
                  ),
                ],
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
                side: const BorderSide(
                  color: AppColors.primaryBlue,
                  width: 1.5,
                ),
              ),
            ),
            UserTableColumn(id: 'exchange', label: 'EXCH', width: 120.w),
            UserTableColumn(id: 'symbol', label: 'SYMBOL', width: 200.w),
            UserTableColumn(
              id: 'expiryDate',
              label: 'EXPIRY DATE',
              width: 250.w,
            ),
            UserTableColumn(
              id: 'marginPct',
              label: 'MARGIN (%)',
              width: 150.w,
              isNumeric: true,
            ),
            UserTableColumn(
              id: 'marginAmt',
              label: 'MARGIN (A.)',
              width: 150.w,
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
                      ToggleUserTradeMarginSelection(item.id, val ?? false),
                    );
                  },
                  activeColor: AppColors.primaryBlue,
                  side: const BorderSide(
                    color: AppColors.primaryBlue,
                    width: 1.5,
                  ),
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
