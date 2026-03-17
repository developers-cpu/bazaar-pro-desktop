import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../bloc/activity_detail/activity_detail_bloc.dart';
import '../../bloc/activity_detail/activity_detail_event.dart';
import '../../../domain/entities/back_office_activity_report.dart';
import '../activity_report/dialogs/general_detail_view.dart';
import '../../../domain/entities/activity_report.dart';
import 'exchange_settings_detail_dialog.dart';
import 'group_detail_dialog.dart';
import 'trade_setting_detail_dialog.dart';
import 'date_setting_detail_dialog.dart';
import 'script_setting_detail_dialog.dart';
import 'bulk_order_detail_dialog.dart';
import 'vpn_restriction_detail_dialog.dart';
import 'server_detail_dialog.dart';
import 'inactivity_management_detail_dialog.dart';

class BackOfficeActivityDetailDialog extends StatelessWidget {
  final BackOfficeActivityReport activity;
  const BackOfficeActivityDetailDialog({super.key, required this.activity});

  static void show(BuildContext context, BackOfficeActivityReport activity) {
    if (activity.activityName == 'Exchange Settings') {
      ExchangeSettingsDetailDialog.show(context, activity);
      return;
    }
    if (activity.activityName == 'Group') {
      GroupDetailDialog.show(context, activity);
      return;
    }
    if (activity.activityName == 'Trade Setting') {
      TradeSettingDetailDialog.show(context, activity);
      return;
    }
    if (activity.activityName == 'Date Setting') {
      DateSettingDetailDialog.show(context, activity);
      return;
    }
    if (activity.activityName == 'Script Setting') {
      ScriptSettingDetailDialog.show(context, activity);
      return;
    }
    if (activity.activityName == 'Bulk Order') {
      BulkOrderDetailDialog.show(context, activity);
      return;
    }
    if (activity.activityName == 'VPN Restriction') {
      VpnRestrictionDetailDialog.show(context, activity);
      return;
    }
    if (activity.activityName == 'Server') {
      ServerDetailDialog.show(context, activity);
      return;
    }
    if (activity.activityName == 'Inactivity Management') {
      InactivityManagementDetailDialog.show(context, activity);
      return;
    }
    CommonDialog.show(
      context: context,
      title: activity.activityName,
      width: 1000.w,
      height: 600.h,
      content: BackOfficeActivityDetailDialog(activity: activity),
      showButtons: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ActivityDetailBloc()
            ..add(FetchActivityDetails(activityName: activity.activityName)),
      child: GeneralDetailView(
        activity: ActivityReport(
          id: activity.id,
          activityName: activity.activityName,
          createdOn: activity.createdOn,
          createdBy: activity.createdBy,
          updatedOn: activity.updatedOn,
          updatedBy: activity.updatedBy,
        ),
      ),
    );
  }
}
