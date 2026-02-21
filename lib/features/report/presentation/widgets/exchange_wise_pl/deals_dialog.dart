import 'package:bazarpro/core/widget/common_dilog_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bazarpro/injection_container.dart';
import 'package:bazarpro/features/view/presentation/bloc/deals/deals_bloc.dart';
import 'package:bazarpro/features/view/presentation/bloc/deals/deals_event.dart';
import 'package:bazarpro/features/view/presentation/bloc/deals/deals_state.dart';
import 'package:bazarpro/features/view/presentation/widget/deals/deals_filter_bar.dart';
import 'package:bazarpro/features/view/presentation/widget/deals/deals_table.dart';
class DealsDialog extends StatelessWidget {
  final String? exchange;
  const DealsDialog({Key? key, this.exchange}) : super(key: key);
  static void show(BuildContext context, {String? exchange}) {
    CommonDialog.show(
      context: context,
      title: 'Deals',
      width: 1400.w,
      height: 700.h,
      content: DealsDialog(exchange: exchange),
      showButtons: false,
    );
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DealsBloc>()
        ..add(const LoadDealsEvent())
        ..add(ApplyFiltersEvent(exchange: exchange)),
      child: BlocBuilder<DealsBloc, DealsState>(
        builder: (context, state) {
          return SizedBox(
            height: 600.h,
            child: Column(
              children: [
                const DealsFilterBar(),
                Expanded(child: DealsTable(showDeviceInfo: true)),
              ],
            ),
          );
        },
      ),
    );
  }
}
