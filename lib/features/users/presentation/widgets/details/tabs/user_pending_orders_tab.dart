import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_images.dart';
import '../../../../../../core/widget/app_dropdown.dart';
import '../../../../domain/entities/user.dart';
import '../../../bloc/user_pending_order/user_pending_order_bloc.dart';
import '../../../bloc/user_pending_order/user_pending_order_event.dart';
import '../../../bloc/user_pending_order/user_pending_order_state.dart';
import '../../common/user_reset_buttons.dart';

class UserPendingOrdersTab extends StatelessWidget {
  final User user;

  const UserPendingOrdersTab({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UserPendingOrderBloc()..add(LoadUserPendingOrders(user.id)),
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
          String? selectedExchange;
          String? selectedSymbol;
          String? selectedOrderType;

          if (state is UserPendingOrderLoaded) {
            selectedExchange = state.selectedExchange;
            selectedSymbol = state.selectedSymbol;
            selectedOrderType = state.selectedOrderType;
          }

          return Row(
            children: [
              AppDropdown(
                hintText: 'Exchange',
                items: const ['NSE', 'MCX'],
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
                ], // Mock items
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
                width: 250.w,
                height: 35.h,
                type: AppDropdownType.search,
                searchHint: 'Search & Add',
              ),
              SizedBox(width: 12.w),
              AppDropdown(
                hintText: 'Order Type',
                items: const [
                  'All',
                  'Buy Limit',
                  'Buy Stop',
                  'Sell Limit',
                  'Sell Stop',
                ],
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
                width: 150.w,
                height: 35.h,
                type: AppDropdownType.simple,
              ),
              const Spacer(),
              UserResetButtons(
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

  Widget _buildContent(BuildContext context) {
    return BlocBuilder<UserPendingOrderBloc, UserPendingOrderState>(
      builder: (context, state) {
        if (state is UserPendingOrderLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Always show empty state for now as per requirement/screenshot showing the illustration
        return Center(
          child: SvgPicture.asset(
            AppImages.pendingOrdersIcon,
            width: 300.w, // Adjust size as needed
            height: 300.h,
          ),
        );
      },
    );
  }
}
