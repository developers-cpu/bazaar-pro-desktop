import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../bloc/net_position/net_position_bloc.dart';
import '../../bloc/net_position/net_position_event.dart';
import '../../bloc/net_position/net_position_state.dart';
import '../view_reset_buttons.dart';

/// Filter bar for Net Position page
class NetPositionFilterBar extends StatelessWidget {
  const NetPositionFilterBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NetPositionBloc, NetPositionState>(
      builder: (context, state) {
        if (state is! NetPositionLoaded) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              // User Type Dropdown
              Expanded(
                child: AppDropdown(
                  type: AppDropdownType.simple,
                  hintText: 'User Type',
                  value: state.selectedUserType,
                  items: state.userTypes,
                  showAllOption: true,
                  onChanged: (value) {
                    context.read<NetPositionBloc>().add(
                      ApplyFiltersEvent(
                        userType: value,
                        client: state.selectedClient,
                        exchange: state.selectedExchange,
                        symbol: state.selectedSymbol,
                      ),
                    );
                  },
                ),
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
                    context.read<NetPositionBloc>().add(
                      ApplyFiltersEvent(
                        userType: state.selectedUserType,
                        client: value,
                        exchange: state.selectedExchange,
                        symbol: state.selectedSymbol,
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
                    context.read<NetPositionBloc>().add(
                      ApplyFiltersEvent(
                        userType: state.selectedUserType,
                        client: state.selectedClient,
                        exchange: value,
                        symbol: state.selectedSymbol,
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
                    context.read<NetPositionBloc>().add(
                      ApplyFiltersEvent(
                        userType: state.selectedUserType,
                        client: state.selectedClient,
                        exchange: state.selectedExchange,
                        symbol: value,
                      ),
                    );
                  },
                ),
              ),

              const Spacer(),

              // Reset and View Buttons
              ViewResetButtons(
                onReset: () {
                  context.read<NetPositionBloc>().add(
                    const ResetFiltersEvent(),
                  );
                },
                onView: () {
                  context.read<NetPositionBloc>().add(
                    ApplyFiltersEvent(
                      userType: state.selectedUserType,
                      client: state.selectedClient,
                      exchange: state.selectedExchange,
                      symbol: state.selectedSymbol,
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