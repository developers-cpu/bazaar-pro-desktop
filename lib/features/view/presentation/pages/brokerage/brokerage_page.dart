import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/app_dropdown.dart';
import '../../bloc/brokerage/brokerage_bloc.dart';
import '../../bloc/brokerage/brokerage_event.dart';
import '../../bloc/brokerage/brokerage_state.dart';
import '../../widget/brokerage/brokerage_dialog.dart';

class BrokeragePage extends StatelessWidget {
  const BrokeragePage({super.key});

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
    return BlocListener<BrokerageBloc, BrokerageState>(
      listener: (context, state) {
        if (state is BrokerageLoaded) {
          final bloc = context.read<BrokerageBloc>();
          BrokerageDialog.showFromPage(context, state).then((_) {
            bloc.add(const ResetBrokerageEvent());
          });
        }
      },
      child: Container(
        color: AppColors.white,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<BrokerageBloc, BrokerageState>(
              builder: (context, state) {
                return Row(
                  children: [
                    AppDropdown(
                      width: 200.w,
                      height: 35.h,
                      type: AppDropdownType.simple,
                      hintText: 'Exchange',
                      value: null,
                      items: _exchanges,
                      showAllOption: false,
                      onChanged: (value) {
                        if (value != null) {
                          context.read<BrokerageBloc>().add(
                            LoadBrokeragesEvent(exchange: value),
                          );
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
                  ],
                );
              },
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Select Exchange to see brokerage details',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
