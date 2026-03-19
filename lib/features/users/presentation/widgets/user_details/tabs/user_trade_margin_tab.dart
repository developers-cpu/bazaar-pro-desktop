import '../../../../../../core/widget/table/view_data_table.dart';
import '../../../../../../core/widget/table/view_record_count.dart';
import '../../../../../../core/widget/table/view_reset_buttons.dart';
import '../../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../../../../../injection_container.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _intradayMarginController =
      TextEditingController();
  final TextEditingController _carryForwardMarginController =
      TextEditingController();
  @override
  void dispose() {
    _searchController.dispose();
    _intradayMarginController.dispose();
    _carryForwardMarginController.dispose();
    super.dispose();
  }

  void _onUpdate(BuildContext context) {}
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
                    width: 180.w,
                    prefixSvgPath: AppImages.searchIcon,
                    onChanged: (val) {},
                  ),
                  const Spacer(),
                  ViewResetButtons(
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
                    hintText: 'Amount',
                    items: const ['Percentage', 'Amount'],
                    value: null,
                    onChanged: (val) {},
                    width: 160.w,
                    height: 35.h,
                    type: AppDropdownType.simple,
                  ),
                  SizedBox(width: 8.w),
                  CustomInputField(
                    hintText: 'Intraday Margin(A)',
                    controller: _intradayMarginController,
                    height: 35.h,
                    width: 160.w,
                  ),
                  SizedBox(width: 8.w),
                  CustomInputField(
                    hintText: 'Carry Forward Margin(A)',
                    controller: _carryForwardMarginController,
                    height: 35.h,
                    width: 180.w,
                  ),
                  const Spacer(),
                  CustomActionButton(
                    text: 'Update',
                    onPressed: () => _onUpdate(context),
                    width: 188.w,
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
          return ViewRecordCount(count: count);
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
        return ViewDataTable<UserTradeMargin>(
          columns: [
            ViewTableColumn(
              id: 'checkbox',
              label: '',
              width: 50.w,
              sortable: false,
              customHeaderWidget: Checkbox(
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            ViewTableColumn(id: 'exchange', label: 'EXCH', width: 80.w),
            ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 100.w),
            ViewTableColumn(
              id: 'expiryDate',
              label: 'EXPIRY DATE',
              width: 100.w,
            ),
            ViewTableColumn(
              id: 'intradayMarginAmt',
              label: 'INTRADAY MARGIN (A.)',
              width: 170.w,
              isNumeric: true,
            ),
            ViewTableColumn(
              id: 'intradayMarginPct',
              label: 'INTRADAY MARGIN (%)',
              width: 150.w,
              isNumeric: true,
            ),
            ViewTableColumn(
              id: 'cfMarginPct',
              label: 'CF MARGIN (%)',
              width: 150.w,
              isNumeric: true,
            ),
            ViewTableColumn(
              id: 'cfMarginAmt',
              label: 'CF MARGIN (A.)',
              width: 150.w,
              isNumeric: true,
            ),
          ],
          autoFit: true,
          data: data,
          idExtractor: (item) => item.id,
          comparatorBuilder: (item, columnId) {
            switch (columnId) {
              case 'exchange':
                return item.exchange;
              case 'symbol':
                return item.symbol;
              case 'expiryDate':
                return item.expiryDate;
              case 'intradayMarginAmt':
                return item.intradayMarginAmount;
              case 'intradayMarginPct':
                return item.intradayMarginPercentage;
              case 'cfMarginPct':
                return item.carryForwardMarginPercentage;
              case 'cfMarginAmt':
                return item.carryForwardMarginAmount;
              default:
                return '';
            }
          },
          cellBuilder: (item, column) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                );
              case 'exchange':
                return ViewTextCell(text: item.exchange, isDark: isDark);
              case 'symbol':
                return ViewTextCell(text: item.symbol, isDark: isDark);
              case 'expiryDate':
                return ViewDateTimeCell(
                  dateTime: item.expiryDate,
                  isDark: isDark,
                );
              case 'intradayMarginAmt':
                return ViewNumberCell(
                  value: item.intradayMarginAmount,
                  colorByValue: false,
                  isDark: isDark,
                );
              case 'intradayMarginPct':
                return ViewNumberCell(
                  value: item.intradayMarginPercentage,
                  colorByValue: false,
                  isDark: isDark,
                );
              case 'cfMarginPct':
                return ViewNumberCell(
                  value: item.carryForwardMarginPercentage,
                  colorByValue: false,
                  isDark: isDark,
                );
              case 'cfMarginAmt':
                return ViewNumberCell(
                  value: item.carryForwardMarginAmount,
                  colorByValue: false,
                  isDark: isDark,
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