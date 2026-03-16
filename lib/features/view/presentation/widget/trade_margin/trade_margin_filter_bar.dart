import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/app_images.dart';
import '../../../../../../core/widget/app_dropdown.dart';
import '../../../../../../core/widget/custom_input_field.dart';
import '../../../../../core/widget/table/view_reset_buttons.dart';
import '../../bloc/trade_margin/trade_margin_bloc.dart';
import '../../bloc/trade_margin/trade_margin_event.dart';
import '../../bloc/trade_margin/trade_margin_state.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_state.dart';
class TradeMarginFilterBar extends StatelessWidget {
  final bool isDialogMode;
  const TradeMarginFilterBar({super.key, this.isDialogMode = false});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TradeMarginBloc, TradeMarginState>(
      builder: (context, state) {
        if (state is! TradeMarginLoaded) {
          return const SizedBox.shrink();
        }
        final authState = context.read<AuthBloc>().state;
        final isClient =
            authState is AuthAuthenticated &&
            authState.user.role.toLowerCase() == 'client';
        final isMaster =
            authState is AuthAuthenticated &&
            authState.user.role.toLowerCase() == 'master';
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              if (!(isMaster && isDialogMode)) ...[
                AppDropdown(
                  width: 200.w,
                  height: 35.h,
                  type: AppDropdownType.simple,
                  hintText: 'Exchange',
                  value: state.selectedExchange,
                  items: state.exchanges,
                  onChanged: (value) {
                    context.read<TradeMarginBloc>().add(
                      UpdateTradeMarginFilters(exchange: value),
                    );
                  },
                ),
              ],
              if (!isClient) ...[
                SizedBox(width: 12.w),
                CustomInputField(
                  hintText: 'Search',
                  height: 35.h,
                  width: 200.w,
                  prefixSvgPath: AppImages.searchIcon,
                  onChanged: (value) {
                    context.read<TradeMarginBloc>().add(
                      UpdateTradeMarginFilters(search: value),
                    );
                  },
                ),
              ],
              if (!(isMaster && isDialogMode)) ...[
                const Spacer(),
                ViewResetButtons(
                  showReset: !isClient,
                  onReset: () {
                    context.read<TradeMarginBloc>().add(
                      const ResetTradeMarginFilters(),
                    );
                  },
                  onView: () {
                    context.read<TradeMarginBloc>().add(
                      const ViewTradeMargins(),
                    );
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
