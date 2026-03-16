import '../../../../../../core/widget/table/view_data_table.dart';
import '../../../../../../core/widget/table/view_record_count.dart';
import '../../../../../../core/widget/table/view_reset_buttons.dart';
import '../../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../../../../../injection_container.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_images.dart';
import '../../../../../../core/widget/app_dropdown.dart';
import '../../../../domain/entities/user.dart';
import '../../../../domain/entities/user_pending_order/user_pending_order.dart';
import '../../../bloc/user_pending_order/user_pending_order_bloc.dart';
import '../../../bloc/user_pending_order/user_pending_order_event.dart';
import '../../../bloc/user_pending_order/user_pending_order_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserPendingOrdersTab extends StatelessWidget {
  final User user;
  const UserPendingOrdersTab({super.key, required this.user});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<UserPendingOrderBloc>()..add(LoadUserPendingOrders(user.id)),
      child: const UserPendingOrdersTabView(),
    );
  }
}

class UserPendingOrdersTabView extends StatelessWidget {
  const UserPendingOrdersTabView({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilterBar(context),
        _buildRecordCount(context),
        Expanded(child: _buildContent(context)),
      ],
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      color: AppColors.white,
      child: BlocBuilder<UserPendingOrderBloc, UserPendingOrderState>(
        builder: (context, state) {
          List<String> exchangeItems = [];
          List<String> symbolItems = [];
          List<String> orderTypeItems = [];
          String? selectedExchange;
          String? selectedSymbol;
          String? selectedOrderType;
          if (state is UserPendingOrderLoaded) {
            selectedExchange = state.selectedExchange;
            selectedSymbol = state.selectedSymbol;
            selectedOrderType = state.selectedOrderType;
            if (state.metadata != null) {
              exchangeItems = state.metadata!.exchanges;
              symbolItems = state.metadata!.symbols;
              orderTypeItems = state.metadata!.orderTypes;
            }
          }
          return Row(
            children: [
              AppDropdown(
                hintText: 'Exchange',
                items: exchangeItems,
                value: selectedExchange,
                onChanged: (val) {
                  context.read<UserPendingOrderBloc>().add(
                    FilterUserPendingOrders(
                      exchange: val,
                      symbol: selectedSymbol,
                      orderType: selectedOrderType,
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
                  context.read<UserPendingOrderBloc>().add(
                    FilterUserPendingOrders(
                      exchange: selectedExchange,
                      symbol: val,
                      orderType: selectedOrderType,
                    ),
                  );
                },
                width: 160.w,
                height: 35.h,
                type: AppDropdownType.search,
                searchHint: 'Search & Add',
              ),
              SizedBox(width: 8.w),
              AppDropdown(
                hintText: 'Order Type',
                items: orderTypeItems,
                value: selectedOrderType,
                onChanged: (val) {
                  context.read<UserPendingOrderBloc>().add(
                    FilterUserPendingOrders(
                      exchange: selectedExchange,
                      symbol: selectedSymbol,
                      orderType: val,
                    ),
                  );
                },
                width: 160.w,
                height: 35.h,
                type: AppDropdownType.simple,
              ),
              const Spacer(),
              ViewResetButtons(
                onReset: () {
                  context.read<UserPendingOrderBloc>().add(
                    const FilterUserPendingOrders(
                      exchange: null,
                      symbol: null,
                      orderType: null,
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
      child: BlocBuilder<UserPendingOrderBloc, UserPendingOrderState>(
        builder: (context, state) {
          int count = 0;
          if (state is UserPendingOrderLoaded) {
            count = state.filteredOrders.length;
          }
          return ViewRecordCount(count: count);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return BlocBuilder<UserPendingOrderBloc, UserPendingOrderState>(
      builder: (context, state) {
        if (state is UserPendingOrderLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        List<UserPendingOrder> data = [];
        if (state is UserPendingOrderLoaded) {
          data = state.filteredOrders;
        }
        if (data.isEmpty && state is! UserPendingOrderLoading) {
          return Center(
            child: SvgPicture.asset(
              AppImages.pendingOrdersIcon,
              width: 300.w,
              height: 300.h,
            ),
          );
        }
        return ViewDataTable<UserPendingOrder>(
          autoFit: true,
          columns: [
            ViewTableColumn(id: 'time', label: 'TIME', width: 200.w),
            ViewTableColumn(id: 'exchange', label: 'EXCH', width: 120.w),
            ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 200.w),
            ViewTableColumn(id: 'type', label: 'TYPE', width: 100.w),
            ViewTableColumn(
              id: 'lot',
              label: 'LOT',
              width: 100.w,
              isNumeric: true,
            ),
            ViewTableColumn(
              id: 'price',
              label: 'PRICE',
              width: 150.w,
              isNumeric: true,
            ),
            ViewTableColumn(id: 'status', label: 'STATUS', width: 120.w),
          ],
          data: data,
          idExtractor: (item) => item.id,
          comparatorBuilder: (item, columnId) {
            switch (columnId) {
              case 'time':
                return item.time;
              case 'exchange':
                return item.exchange;
              case 'symbol':
                return item.symbol;
              case 'type':
                return item.type;
              case 'lot':
                return item.lot;
              case 'price':
                return item.price;
              case 'status':
                return item.status;
              default:
                return '';
            }
          },
          cellBuilder: (item, column) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            switch (column.id) {
              case 'time':
                return ViewDateTimeCell(dateTime: item.time, isDark: isDark);
              case 'exchange':
                return ViewTextCell(text: item.exchange, isDark: isDark);
              case 'symbol':
                return ViewTextCell(text: item.symbol, isDark: isDark);
              case 'type':
                return ViewBuySellCell(text: item.type, isDark: isDark);
              case 'lot':
                return ViewNumberCell(
                  value: double.tryParse(item.lot) ?? 0.0,
                  colorByValue: false,
                  isDark: isDark,
                );
              case 'price':
                return ViewNumberCell(
                  value: item.price,
                  colorByValue: false,
                  isDark: isDark,
                );
              case 'status':
                return ViewTextCell(text: item.status, isDark: isDark);
              default:
                return const SizedBox();
            }
          },
        );
      },
    );
  }
}
