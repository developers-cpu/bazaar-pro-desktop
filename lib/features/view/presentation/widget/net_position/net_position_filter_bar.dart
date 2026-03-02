import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../../../../core/widget/table/view_reset_buttons.dart';
import '../../bloc/net_position/net_position_bloc.dart';
import '../../bloc/net_position/net_position_event.dart';
import '../../bloc/net_position/net_position_state.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_state.dart';

class NetPositionFilterBar extends StatelessWidget {
  const NetPositionFilterBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NetPositionBloc, NetPositionState>(
      builder: (context, state) {
        if (state is! NetPositionLoaded) {
          return const SizedBox.shrink();
        }
        final authState = context.read<AuthBloc>().state;
        final isClient =
            authState is AuthAuthenticated &&
            authState.user.role.toLowerCase() == 'client';

        if (isClient) {
          return _buildClientFilterBar(context, state);
        }
        return _buildAdminFilterBar(context, state);
      },
    );
  }

  Widget _buildClientFilterBar(BuildContext context, NetPositionLoaded state) {
    double totalM2M = 0;
    double totalBrokerage = 0;
    double totalRealisedPnl = 0;
    for (final pos in state.filteredPositions) {
      totalM2M += pos.m2mAmount;
      totalBrokerage += pos.ourPercentage;
      totalRealisedPnl += pos.netQty * pos.netAvgPrice;
    }
    final totalPnl = totalRealisedPnl + totalM2M + totalBrokerage;
    final isNegative = totalPnl < 0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 200.w,
            child: AppDropdown(
              type: AppDropdownType.simple,
              hintText: 'Exchange',
              value: state.selectedExchange,
              items: state.exchanges,
              showAllOption: true,
              onChanged: (value) {
                context.read<NetPositionBloc>().add(
                  ApplyFiltersEvent(
                    exchange: value,
                    symbol: state.selectedSymbol,
                  ),
                );
              },
            ),
          ),
          SizedBox(width: 12.w),

          SizedBox(
            width: 200.w,
            child: AppDropdown(
              type: AppDropdownType.search,
              hintText: 'Symbol',
              value: state.selectedSymbol,
              items: state.symbols,
              onChanged: (value) {
                context.read<NetPositionBloc>().add(
                  ApplyFiltersEvent(
                    exchange: state.selectedExchange,
                    symbol: value,
                  ),
                );
              },
            ),
          ),
          const Spacer(),

          _buildPnlSummary(
            context,
            realisedPnl: totalRealisedPnl,
            m2m: totalM2M,
            brokerage: totalBrokerage,
            total: totalPnl,
            isNegative: isNegative,
          ),
        ],
      ),
    );
  }

  Widget _buildPnlSummary(
    BuildContext context, {
    required double realisedPnl,
    required double m2m,
    required double brokerage,
    required double total,
    required bool isNegative,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildLabeledBox(context, 'Realised P& L', realisedPnl),
        _buildOperatorText('+'),
        _buildLabeledBox(context, 'M2M', m2m),
        _buildOperatorText('+'),
        _buildLabeledBox(context, 'Brokerage', brokerage),
        SizedBox(width: 8.w),
        Text(
          '=',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor,
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          total.toStringAsFixed(2),
          style: GoogleFonts.openSans(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: isNegative ? AppColors.sellColor : AppColors.buyColor,
          ),
        ),
      ],
    );
  }

  Widget _buildLabeledBox(BuildContext context, String label, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11.sp, color: AppColors.primaryTextColor),
        ),
        SizedBox(height: 3.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: const Color(0xFFD3E3EC),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            value.toStringAsFixed(2),
            style: GoogleFonts.openSans(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTextColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOperatorText(String op) {
    return Padding(
      padding: EdgeInsets.only(top: 14.h, left: 6.w, right: 6.w),
      child: Text(
        op,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryTextColor,
        ),
      ),
    );
  }

  Widget _buildAdminFilterBar(BuildContext context, NetPositionLoaded state) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
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
          ViewResetButtons(
            onReset: () {
              context.read<NetPositionBloc>().add(const ResetFiltersEvent());
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
  }
}
