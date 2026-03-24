import 'package:bazarpro/core/widget/client_profit_loss_widget.dart';
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
  final bool isDialog;
  const NetPositionFilterBar({Key? key, this.isDialog = false})
    : super(key: key);
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
    double totalRealisedPnl = 0;
    double totalBrokerage = 0;
    for (final pos in state.filteredPositions) {
      totalM2M += pos.m2mAmount;
      totalRealisedPnl += pos.netQty * pos.netAvgPrice;
    }
    final totalPnl = totalRealisedPnl + totalM2M;
    final isNegative = totalPnl < 0;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppDropdown(
            type: AppDropdownType.simple,
            hintText: 'Exchange',
            value: state.selectedExchange,
            items: state.exchanges,
            width: 200.w,
            height: 35.h,
            onChanged: (value) {
              context.read<NetPositionBloc>().add(
                UpdateFiltersEvent(
                  exchange: value,
                  symbol: state.selectedSymbol,
                ),
              );
            },
          ),
          SizedBox(width: 8.w),
          AppDropdown(
            type: AppDropdownType.search,
            hintText: 'Symbol',
            value: state.selectedSymbol,
            items: state.symbols,
            width: 200.w,
            height: 35.h,
            onChanged: (value) {
              context.read<NetPositionBloc>().add(
                UpdateFiltersEvent(
                  exchange: state.selectedExchange,
                  symbol: value,
                ),
              );
            },
          ),
          SizedBox(width: 8.w),
          ViewResetButtons(
            showReset: false,
            onView: () {
              context.read<NetPositionBloc>().add(
                ApplyFiltersEvent(
                  exchange: state.selectedExchange,
                  symbol: state.selectedSymbol,
                ),
              );
            },
          ),
          const Spacer(),
          if (!isDialog) ...[
            const ClientProfitLossWidget(),
            SizedBox(width: 12.w),
          ],
          if (!isDialog)
            _buildPageFormula(totalRealisedPnl, totalM2M, totalBrokerage)
          else
            _buildDialogFormula(
              totalRealisedPnl,
              totalM2M,
              totalPnl,
              isNegative,
            ),
        ],
      ),
    );
  }

  Widget _buildPageFormula(double realised, double m2m, double brokerage) {
    final total = realised + m2m + brokerage;
    final isNegative = total < 0;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        _columnBox('Realised P&L', realised.toStringAsFixed(2)),
        SizedBox(width: 8.w),
        Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: _operator('+'),
        ),
        SizedBox(width: 8.w),
        _columnBox('M2M', m2m.toStringAsFixed(2)),
        SizedBox(width: 8.w),
        Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: _operator('+'),
        ),
        SizedBox(width: 8.w),
        _columnBox('Brokerage', brokerage.toStringAsFixed(2)),
        SizedBox(width: 12.w),
        Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: _operator('='),
        ),
        SizedBox(width: 12.w),
        Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Text(
            total.toStringAsFixed(2),
            style: GoogleFonts.openSans(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: isNegative ? AppColors.sellColor : AppColors.buyColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDialogFormula(
    double realised,
    double m2m,
    double total,
    bool isNegative,
  ) {
    return IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 32.h,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFD3E3EC),
              borderRadius: BorderRadius.circular(6.r),
            ),
            alignment: Alignment.center,
            child: Text(
              'Credit : 500000.00',
              style: GoogleFonts.openSans(
                fontSize: 12.sp,
                color: AppColors.primaryBlue,
              ),
            ),
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _compactBox('Realised P&L : ${realised.toStringAsFixed(2)}'),
              SizedBox(width: 6.w),
              _operator('+'),
              SizedBox(width: 6.w),
              _compactBox('M2M : ${m2m.toStringAsFixed(2)}'),
              SizedBox(width: 6.w),
              _operator('='),
              SizedBox(width: 6.w),
              Text(
                total.toStringAsFixed(2),
                style: GoogleFonts.openSans(
                  fontSize: 12.sp,
                  color: isNegative ? AppColors.red : AppColors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _columnBox(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF224E69),
          ),
        ),
        SizedBox(height: 4.h),
        Container(
          height: 30.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: const Color(0xFFC6DBE8),
            borderRadius: BorderRadius.circular(8.r),
          ),
          alignment: Alignment.center,
          child: Text(
            value,
            style: GoogleFonts.openSans(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF224E69),
            ),
          ),
        ),
      ],
    );
  }

  Widget _compactBox(String text) {
    return Container(
      height: 30.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: const Color(0xFFD3E3EC),
        borderRadius: BorderRadius.circular(6.r),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: GoogleFonts.openSans(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.primaryBlue,
        ),
      ),
    );
  }

  Widget _operator(String text) {
    return Text(
      text,
      style: GoogleFonts.openSans(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );
  }

  Widget _buildAdminFilterBar(BuildContext context, NetPositionLoaded state) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          AppDropdown(
            type: AppDropdownType.simple,
            hintText: 'User Type',
            value: state.selectedUserType,
            items: state.userTypes,
            width: 150.w,
            height: 35.h,
            showAllOption: false,
            onChanged: (value) {
              context.read<NetPositionBloc>().add(
                UpdateFiltersEvent(
                  userType: value,
                  client: state.selectedClient,
                  exchange: state.selectedExchange,
                  symbol: state.selectedSymbol,
                ),
              );
            },
          ),
          SizedBox(width: 8.w),
          AppDropdown(
            type: AppDropdownType.search,
            hintText: 'Username',
            value: state.selectedClient,
            items: state.clients,
            width: 150.w,
            height: 35.h,
            onChanged: (value) {
              context.read<NetPositionBloc>().add(
                UpdateFiltersEvent(
                  userType: state.selectedUserType,
                  client: value,
                  exchange: state.selectedExchange,
                  symbol: state.selectedSymbol,
                ),
              );
            },
          ),
          SizedBox(width: 8.w),
          AppDropdown(
            type: AppDropdownType.simple,
            hintText: 'Exchange',
            value: state.selectedExchange,
            items: state.exchanges,
            width: 150.w,
            height: 35.h,
            onChanged: (value) {
              context.read<NetPositionBloc>().add(
                UpdateFiltersEvent(
                  userType: state.selectedUserType,
                  client: state.selectedClient,
                  exchange: value,
                  symbol: state.selectedSymbol,
                ),
              );
            },
          ),
          SizedBox(width: 8.w),
          AppDropdown(
            type: AppDropdownType.search,
            hintText: 'Symbol',
            value: state.selectedSymbol,
            items: state.symbols,
            width: 150.w,
            height: 35.h,
            onChanged: (value) {
              context.read<NetPositionBloc>().add(
                UpdateFiltersEvent(
                  userType: state.selectedUserType,
                  client: state.selectedClient,
                  exchange: state.selectedExchange,
                  symbol: value,
                ),
              );
            },
          ),
          const Spacer(),
          if (!isDialog) ...[
            const ClientProfitLossWidget(),
            SizedBox(width: 12.w),
          ],
          ViewResetButtons(
            onReset: () {
              context.read<NetPositionBloc>().add(const ResetFiltersEvent());
              context.read<NetPositionBloc>().add(
                const LoadNetPositionsEvent(isClient: false),
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
  }
}
