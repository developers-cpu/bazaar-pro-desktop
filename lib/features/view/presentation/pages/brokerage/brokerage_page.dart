import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../bloc/brokerage/brokerage_bloc.dart';
import '../../bloc/brokerage/brokerage_event.dart';
import '../../bloc/brokerage/brokerage_state.dart';
import '../../widget/brokerage/brokerage_dialog.dart';
import '../../widget/brokerage/brokerage_filter_bar.dart';

class BrokeragePage extends StatelessWidget {
  const BrokeragePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<BrokerageBloc, BrokerageState>(
      listener: (context, state) {
        if (state is BrokerageLoaded) {
          final bloc = context.read<BrokerageBloc>();
          BrokerageDialog.showFromPage(context, state).then((_) {
            if (context.mounted) {
              bloc.add(
                RestoreBrokerageFilterEvent(
                  exchange: state.selectedExchange ?? '',
                ),
              );
            }
          });
        }
      },
      child: Container(
        color: AppColors.white,
        child: Column(
          children: [
            const BrokerageFilterBar(),
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
