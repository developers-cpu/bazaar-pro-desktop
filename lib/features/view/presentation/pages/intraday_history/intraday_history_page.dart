import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../bloc/intraday_history/intraday_history_bloc.dart';
import '../../bloc/intraday_history/intraday_history_event.dart';
import '../../bloc/intraday_history/intraday_history_state.dart';
import '../../widget/intraday_history/intraday_history_filter_bar.dart';
import '../../widget/intraday_history/intraday_history_table.dart';
import '../../widget/intraday_history/intraday_seconds_filter_bar.dart';
import '../../widget/intraday_history/intraday_seconds_table.dart';

class IntradayHistoryPage extends StatefulWidget {
  const IntradayHistoryPage({Key? key}) : super(key: key);

  @override
  State<IntradayHistoryPage> createState() => _IntradayHistoryPageState();
}

class _IntradayHistoryPageState extends State<IntradayHistoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<IntradayHistoryBloc>().add(const LoadIntradayHistoryEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<IntradayHistoryBloc, IntradayHistoryState>(
      listener: _handleStateChange,
      child: BlocBuilder<IntradayHistoryBloc, IntradayHistoryState>(
        builder: (context, state) {
          return Container(
            color: AppColors.white,
            child: Column(
              children: [

                if (state is IntradayHistoryLoaded)
                  const IntradayHistoryFilterBar()
                else if (state is IntradayHistorySecondsView)
                  const IntradaySecondsFilterBar(),

                Container(
                  height: 1.h,
                  color: AppColors.greyBorder,
                ),

                Expanded(
                  child: state is IntradayHistorySecondsView
                      ? const IntradaySecondsTable()
                      : const IntradayHistoryTable(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleStateChange(BuildContext context, IntradayHistoryState state) {
    if (state is IntradayHistoryExportSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.successColor,
          duration: const Duration(seconds: 2),
        ),
      );
    }

    if (state is IntradayHistoryError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.errorColor,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}