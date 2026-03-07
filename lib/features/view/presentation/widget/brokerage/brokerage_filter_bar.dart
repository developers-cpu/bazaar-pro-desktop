import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/app_dropdown.dart';
import '../../../../../../core/widget/table/view_reset_buttons.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_state.dart';
import '../../bloc/brokerage/brokerage_bloc.dart';
import '../../bloc/brokerage/brokerage_event.dart';
import '../../bloc/brokerage/brokerage_state.dart';

class BrokerageFilterBar extends StatelessWidget {
  const BrokerageFilterBar({super.key});

  static const List<String> _exchanges = [
    'NSE',
    'MCX',
    'CE/PE',
    'OTHERS',
    'COMEX FUTURE',
    'COMEX SPOT',
    'CRYPTO',
    'GIFT',
    'FOREX',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrokerageBloc, BrokerageState>(
      builder: (context, state) {
        final authState = context.read<AuthBloc>().state;
        final isClient =
            authState is AuthAuthenticated &&
            authState.user.role.toLowerCase() == 'client';

        String? pendingExchange;
        if (state is BrokerageFilterUpdated) {
          pendingExchange = state.selectedExchange;
        } else if (state is BrokerageLoaded) {
          pendingExchange = state.selectedExchange;
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              AppDropdown(
                width: 200.w,
                height: 35.h,
                type: AppDropdownType.simple,
                hintText: 'Exchange',
                value: pendingExchange,
                items: _exchanges,
                showAllOption: false,
                onChanged: (value) {
                  if (value != null) {
                    if (isClient) {
                      context.read<BrokerageBloc>().add(
                        UpdateBrokerageFilterEvent(exchange: value),
                      );
                    } else {
                      context.read<BrokerageBloc>().add(
                        LoadBrokeragesEvent(exchange: value),
                      );
                    }
                  }
                },
              ),
              if (state is BrokerageLoading) ...[
                SizedBox(width: 16.w),
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ],
              if (isClient) ...[
                const Spacer(),
                ViewResetButtons(
                  showReset: false,
                  onView: () {
                    if (pendingExchange != null && pendingExchange.isNotEmpty) {
                      context.read<BrokerageBloc>().add(
                        LoadBrokeragesEvent(exchange: pendingExchange),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select Exchange'),
                          backgroundColor: AppColors.errorColor,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
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
