import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../bloc/activity_detail/activity_detail_bloc.dart';
import '../../bloc/activity_detail/activity_detail_event.dart';
import '../../../domain/entities/activity_report.dart';
import 'dialogs/bet_detail_view.dart';
import 'dialogs/brokerage_detail_view.dart';
import 'dialogs/exchange_group_detail_view.dart';
import 'dialogs/exchange_toggle_detail_view.dart';
import 'dialogs/general_detail_view.dart';
import 'dialogs/leverage_detail_view.dart';
import 'dialogs/simple_toggle_detail_view.dart';
import 'dialogs/trade_margin_detail_view.dart';
class ActivityDetailDialog extends StatelessWidget {
  final ActivityReport activity;
  final bool isDarkMode;
  const ActivityDetailDialog({
    super.key,
    required this.activity,
    this.isDarkMode = false,
  });
  static void show(BuildContext context, ActivityReport activity) {
    CommonDialog.show(
      context: context,
      title: activity.activityName,
      width: 1000.w,
      height: 600.h,
      content: ActivityDetailDialog(activity: activity),
      showButtons: false,
    );
  }
  @override
  Widget build(BuildContext context) {
    String? valueType;
    switch (activity.activityName) {
      case 'Profit Square off':
      case 'Time Restriction for SL / Limit':
        valueType = 'time';
        break;
      case 'Lock User':
        valueType = 'yesNo';
        break;
    }
    return BlocProvider(
      create: (context) => ActivityDetailBloc()
        ..add(
          FetchActivityDetails(
            activityName: activity.activityName,
            valueType: valueType,
          ),
        ),
      child: _buildContent(context),
    );
  }
  Widget _buildContent(BuildContext context) {
    switch (activity.activityName) {
      case 'Leverage':
        return LeverageDetailView(isDarkMode: isDarkMode);
      case 'Brokerage':
        return BrokerageDetailView(isDarkMode: isDarkMode);
      case 'Trade margin':
        return TradeMarginDetailView(isDarkMode: isDarkMode);
      case 'Bet':
        return BetDetailView(isDarkMode: isDarkMode);
      case 'Exchange Group':
        return ExchangeGroupDetailView(isDarkMode: isDarkMode);
      case 'Profit Square off':
      case 'Time Restriction for SL / Limit':
        return ExchangeToggleDetailView(
          oldLabel: 'OLD TIME (In min.)',
          newLabel: 'NEW TIME (In min.)',
          valueType: 'time',
          isDarkMode: isDarkMode,
        );
      case 'Allowed Exchange':
      case 'High Low Between Limit / SL':
      case 'Intraday Square off':
        return ExchangeToggleDetailView(isDarkMode: isDarkMode);
      case 'Close Only':
        return SimpleToggleDetailView(
          oldLabel: 'OLD CLOSE ONLY',
          newLabel: 'NEW CLOSE ONLY',
          isDarkMode: isDarkMode,
        );
      case 'View Only':
        return SimpleToggleDetailView(
          oldLabel: 'OLD VIEW ONLY',
          newLabel: 'NEW VIEW ONLY',
          isDarkMode: isDarkMode,
        );
      case 'Status':
      case 'Stauts':
        return SimpleToggleDetailView(
          oldLabel: 'OLD STATUS',
          newLabel: 'NEW STATUS',
          isDarkMode: isDarkMode,
        );
      case 'Lock User':
        return SimpleToggleDetailView(
          oldLabel: 'OLD DETAILS',
          newLabel: 'NEW DETAILS',
          valueType: 'yesNo',
          isDarkMode: isDarkMode,
        );
      case 'Allow Chat with Super Admin':
      case 'Fresh Order':
      case 'Fifteen Days':
        return SimpleToggleDetailView(
          oldLabel: 'OLD DETAILES',
          newLabel: 'NEW DETAILS',
          isDarkMode: isDarkMode,
        );
      default:
        return GeneralDetailView(activity: activity, isDarkMode: isDarkMode);
    }
  }
}
