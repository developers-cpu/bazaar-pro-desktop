import 'package:bazarpro/core/widget/common_dilog_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bazarpro/injection_container.dart';
import 'package:bazarpro/features/view/presentation/bloc/net_position/net_position_bloc.dart';
import 'package:bazarpro/features/view/presentation/bloc/net_position/net_position_event.dart';
import 'package:bazarpro/features/view/presentation/bloc/net_position/net_position_state.dart';
import 'package:bazarpro/features/view/presentation/widget/net_position/net_position_filter_bar.dart';
import 'package:bazarpro/features/view/presentation/widget/net_position/net_position_table.dart';

class NetPositionDialog extends StatelessWidget {
  final String? exchange;
  final String? symbol;
  const NetPositionDialog({Key? key, this.exchange, this.symbol})
    : super(key: key);
  static void show(BuildContext context, {String? exchange, String? symbol}) {
    CommonDialog.show(
      context: context,
      title: 'M2M',
      width: 1400.w,
      height: 700.h,
      content: NetPositionDialog(exchange: exchange, symbol: symbol),
      showButtons: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NetPositionBloc>()
        ..add(const LoadNetPositionsEvent())
        ..add(ApplyFiltersEvent(exchange: exchange, symbol: symbol)),
      child: BlocBuilder<NetPositionBloc, NetPositionState>(
        builder: (context, state) {
          return SizedBox(
            height: 600.h,
            child: Column(
              children: [
                const NetPositionFilterBar(),
                Expanded(child: NetPositionTable(showDeviceInfo: true)),
              ],
            ),
          );
        },
      ),
    );
  }
}
