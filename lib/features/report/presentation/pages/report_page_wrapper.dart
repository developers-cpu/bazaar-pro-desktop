import 'package:bazarpro/core/widget/table/table_export_service.dart';
import 'package:bazarpro/core/widget/table/view_data_table.dart';
import 'package:bazarpro/features/report/presentation/pages/bill_generate_page.dart';
import 'package:bazarpro/features/report/presentation/pages/symbol_wise_pl_report_page.dart';
import 'package:bazarpro/features/report/presentation/pages/profit_and_loss_report_page.dart';
import 'package:bazarpro/features/report/presentation/pages/settlement_report_page.dart';
import 'package:bazarpro/features/report/presentation/pages/settlement_sharing_report_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../injection_container.dart';
import '../bloc/activity_report/activity_report_bloc.dart';
import '../bloc/activity_report/activity_report_event.dart';
import '../bloc/activity_report/activity_report_state.dart';
import '../bloc/back_office_activity_report/back_office_activity_report_bloc.dart';
import '../bloc/back_office_activity_report/back_office_activity_report_event.dart';
import '../bloc/back_office_activity_report/back_office_activity_report_state.dart';
import '../bloc/bill_generate/bill_generate_bloc.dart';
import '../bloc/bill_generate/bill_generate_event.dart';
import '../bloc/bill_generate/bill_generate_state.dart';
import '../bloc/credit_history/credit_history_bloc.dart';
import '../bloc/credit_history/credit_history_event.dart';
import '../bloc/credit_history/credit_history_state.dart';
import '../bloc/exchange_wise_pl/exchange_wise_pl_bloc.dart';
import '../bloc/exchange_wise_pl/exchange_wise_pl_event.dart';
import '../bloc/exchange_wise_pl/exchange_wise_pl_state.dart';
import '../bloc/profit_and_loss_report/profit_and_loss_report_bloc.dart';
import '../bloc/profit_and_loss_report/profit_and_loss_report_event.dart';
import '../bloc/profit_and_loss_report/profit_and_loss_report_state.dart';
import '../bloc/settlement_report/settlement_report_bloc.dart';
import '../bloc/settlement_report/settlement_report_event.dart';
import '../bloc/settlement_report/settlement_report_state.dart';
import '../bloc/settlement_sharing_report/settlement_sharing_report_bloc.dart';
import '../bloc/settlement_sharing_report/settlement_sharing_report_event.dart';
import '../bloc/settlement_sharing_report/settlement_sharing_report_state.dart';
import '../bloc/symbol_wise_pl/symbol_wise_pl_bloc.dart';
import '../bloc/symbol_wise_pl/symbol_wise_pl_event.dart';
import '../bloc/symbol_wise_pl/symbol_wise_pl_state.dart';
import '../bloc/symbol_wise_position_report/symbol_wise_position_report_bloc.dart';
import '../bloc/symbol_wise_position_report/symbol_wise_position_report_event.dart';
import '../bloc/symbol_wise_position_report/symbol_wise_position_report_state.dart';
import '../bloc/trade_log/trade_log_bloc.dart';
import '../bloc/trade_log/trade_log_event.dart';
import '../bloc/trade_log/trade_log_state.dart';
import '../bloc/user_script_position_tracking/user_script_position_tracking_bloc.dart';
import '../bloc/user_script_position_tracking/user_script_position_tracking_event.dart';
import '../bloc/user_script_position_tracking/user_script_position_tracking_state.dart';
import '../bloc/user_wise_profit_and_loss/user_wise_profit_and_loss_bloc.dart';
import '../bloc/user_wise_profit_and_loss/user_wise_profit_and_loss_event.dart';
import '../bloc/user_wise_profit_and_loss/user_wise_profit_and_loss_state.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_state.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../core/widget/app_bar_section.dart';
import 'trade_logs_page.dart';
import 'credit_history_page.dart';
import 'activity_report_page.dart';
import 'back_office_activity_report_page.dart';
import 'symbol_wise_position_report_page.dart';
import 'user_script_position_tracking_page.dart';
import 'user_wise_profit_and_loss_page.dart';
import 'exchange_wise_pl_report_page.dart';

class ReportPageWrapper extends StatelessWidget {
  final String pageTitle;
  final Widget child;
  final VoidCallback? onExportPdf;
  final VoidCallback? onExportExcel;
  const ReportPageWrapper({
    Key? key,
    required this.pageTitle,
    required this.child,
    this.onExportPdf,
    this.onExportExcel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String? userRole;
        if (state is AuthAuthenticated) {
          userRole = state.user.role;
        }
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBarSection(
            selectedTabIndex: userRole == 'Client' ? 3 : 4,
            userRole: userRole,
            currentPageTitle: pageTitle,
            onTabSelected: (_) {},
            onExportPdf: onExportPdf,
            onExportExcel: onExportExcel,
            showExportByDefault: true,
          ),
          body: child,
        );
      },
    );
  }
}

class TradeLogsPageWithAppBar extends StatelessWidget {
  const TradeLogsPageWithAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TradeLogBloc>()..add(const LoadTradeLogsEvent()),
      child: Builder(
        builder: (context) {
          return ReportPageWrapper(
            pageTitle: 'Trade Logs',
            onExportPdf: () {
              final state = context.read<TradeLogBloc>().state;
              if (state is TradeLogLoaded) {
                final dtf = DateFormat('dd/MM/yy HH:mm');
                TableExportService.exportAsPdf(
                  title: 'Trade Logs',
                  columns: const [
                    ViewTableColumn(
                      id: 'userName',
                      label: 'U.NAME',
                      width: 100,
                    ),
                    ViewTableColumn(id: 'exchange', label: 'EXCH', width: 70),
                    ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 120),
                    ViewTableColumn(
                      id: 'orderUpdateType',
                      label: 'TYPE',
                      width: 120,
                    ),
                    ViewTableColumn(
                      id: 'oldQty',
                      label: 'OLD QTY',
                      width: 80,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'qty',
                      label: 'QTY',
                      width: 80,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'oldPrice',
                      label: 'OLD PRICE',
                      width: 90,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'price',
                      label: 'PRICE',
                      width: 90,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'updateTime',
                      label: 'UPD TIME',
                      width: 140,
                    ),
                    ViewTableColumn(
                      id: 'orderDateTime',
                      label: 'ORDER D/T',
                      width: 140,
                    ),
                    ViewTableColumn(
                      id: 'modifyBy',
                      label: 'MOD BY',
                      width: 100,
                    ),
                  ],
                  data: state.filteredTradeLogs,
                  cellValueExtractor: (item, col) {
                    switch (col.id) {
                      case 'userName':
                        return item.userName;
                      case 'exchange':
                        return item.exchange;
                      case 'symbol':
                        return item.symbol;
                      case 'orderUpdateType':
                        return item.orderUpdateType;
                      case 'oldQty':
                        return item.oldQty.toStringAsFixed(2);
                      case 'qty':
                        return item.qty.toStringAsFixed(2);
                      case 'oldPrice':
                        return item.oldPrice.toStringAsFixed(2);
                      case 'price':
                        return item.price.toStringAsFixed(2);
                      case 'updateTime':
                        return dtf.format(item.updateTime);
                      case 'orderDateTime':
                        return dtf.format(item.orderDateTime);
                      case 'modifyBy':
                        return item.modifyBy;
                      default:
                        return '-';
                    }
                  },
                );
              }
            },
            onExportExcel: () {
              final state = context.read<TradeLogBloc>().state;
              if (state is TradeLogLoaded) {
                final dtf = DateFormat('dd/MM/yy HH:mm');
                TableExportService.exportAsExcel(
                  title: 'Trade Logs',
                  columns: const [
                    ViewTableColumn(
                      id: 'userName',
                      label: 'U.NAME',
                      width: 100,
                    ),
                    ViewTableColumn(id: 'exchange', label: 'EXCH', width: 70),
                    ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 120),
                    ViewTableColumn(
                      id: 'orderUpdateType',
                      label: 'TYPE',
                      width: 120,
                    ),
                    ViewTableColumn(
                      id: 'oldQty',
                      label: 'OLD QTY',
                      width: 80,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'qty',
                      label: 'QTY',
                      width: 80,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'oldPrice',
                      label: 'OLD PRICE',
                      width: 90,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'price',
                      label: 'PRICE',
                      width: 90,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'updateTime',
                      label: 'UPD TIME',
                      width: 140,
                    ),
                    ViewTableColumn(
                      id: 'orderDateTime',
                      label: 'ORDER D/T',
                      width: 140,
                    ),
                    ViewTableColumn(
                      id: 'modifyBy',
                      label: 'MOD BY',
                      width: 100,
                    ),
                  ],
                  data: state.filteredTradeLogs,
                  cellValueExtractor: (item, col) {
                    switch (col.id) {
                      case 'userName':
                        return item.userName;
                      case 'exchange':
                        return item.exchange;
                      case 'symbol':
                        return item.symbol;
                      case 'orderUpdateType':
                        return item.orderUpdateType;
                      case 'oldQty':
                        return item.oldQty.toStringAsFixed(2);
                      case 'qty':
                        return item.qty.toStringAsFixed(2);
                      case 'oldPrice':
                        return item.oldPrice.toStringAsFixed(2);
                      case 'price':
                        return item.price.toStringAsFixed(2);
                      case 'updateTime':
                        return dtf.format(item.updateTime);
                      case 'orderDateTime':
                        return dtf.format(item.orderDateTime);
                      case 'modifyBy':
                        return item.modifyBy;
                      default:
                        return '-';
                    }
                  },
                );
              }
            },
            child: const TradeLogsPage(),
          );
        },
      ),
    );
  }
}

class SettlementPageWithAppBar extends StatelessWidget {
  const SettlementPageWithAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SettlementReportBloc>()..add(LoadSettlementReport()),
      child: Builder(
        builder: (context) {
          return ReportPageWrapper(
            pageTitle: 'Settlement',
            onExportPdf: () {
              final state = context.read<SettlementReportBloc>().state;
              if (state is SettlementReportLoaded) {
                final allEntries = [
                  ...state.report.profitList,
                  ...state.report.lossList,
                ];
                TableExportService.exportAsPdf(
                  title: 'Settlement',
                  columns: const [
                    ViewTableColumn(
                      id: 'username',
                      label: 'U.NAME',
                      width: 120,
                    ),
                    ViewTableColumn(id: 'userType', label: 'TYPE', width: 80),
                    ViewTableColumn(
                      id: 'pnl',
                      label: 'P&L',
                      width: 100,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'brokerage',
                      label: 'BROK',
                      width: 100,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'total',
                      label: 'TOTAL',
                      width: 100,
                      isNumeric: true,
                    ),
                  ],
                  data: allEntries,
                  cellValueExtractor: (e, col) {
                    switch (col.id) {
                      case 'username':
                        return e.username;
                      case 'userType':
                        return e.userType;
                      case 'pnl':
                        return e.pnl.toStringAsFixed(2);
                      case 'brokerage':
                        return e.brokerage.toStringAsFixed(2);
                      case 'total':
                        return e.total.toStringAsFixed(2);
                      default:
                        return '-';
                    }
                  },
                );
              }
            },
            onExportExcel: () {
              final state = context.read<SettlementReportBloc>().state;
              if (state is SettlementReportLoaded) {
                final allEntries = [
                  ...state.report.profitList,
                  ...state.report.lossList,
                ];
                TableExportService.exportAsExcel(
                  title: 'Settlement',
                  columns: const [
                    ViewTableColumn(
                      id: 'username',
                      label: 'U.NAME',
                      width: 120,
                    ),
                    ViewTableColumn(id: 'userType', label: 'TYPE', width: 80),
                    ViewTableColumn(
                      id: 'pnl',
                      label: 'P&L',
                      width: 100,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'brokerage',
                      label: 'BROK',
                      width: 100,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'total',
                      label: 'TOTAL',
                      width: 100,
                      isNumeric: true,
                    ),
                  ],
                  data: allEntries,
                  cellValueExtractor: (e, col) {
                    switch (col.id) {
                      case 'username':
                        return e.username;
                      case 'userType':
                        return e.userType;
                      case 'pnl':
                        return e.pnl.toStringAsFixed(2);
                      case 'brokerage':
                        return e.brokerage.toStringAsFixed(2);
                      case 'total':
                        return e.total.toStringAsFixed(2);
                      default:
                        return '-';
                    }
                  },
                );
              }
            },
            child: const SettlementReportPage(),
          );
        },
      ),
    );
  }
}

class SettlementSharingReportPageWithAppBar extends StatelessWidget {
  const SettlementSharingReportPageWithAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<SettlementSharingReportBloc>()..add(LoadSettlementSharingReport()),
      child: Builder(
        builder: (context) {
          return ReportPageWrapper(
            pageTitle: 'Settlement with % Sharing',
            onExportPdf: () {
              final state = context.read<SettlementSharingReportBloc>().state;
              if (state is SettlementSharingReportLoaded) {
                final allEntries = [
                  ...state.report.profitList,
                  ...state.report.lossList,
                ];
                TableExportService.exportAsPdf(
                  title: 'Settlement With % Sharing',
                  columns: const [
                    ViewTableColumn(
                      id: 'username',
                      label: 'U.NAME',
                      width: 120,
                    ),
                    ViewTableColumn(id: 'userType', label: 'TYPE', width: 80),
                    ViewTableColumn(
                      id: 'pnl',
                      label: 'P&L',
                      width: 100,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'percentWise',
                      label: '% WISE',
                      width: 100,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'total',
                      label: 'TOTAL',
                      width: 100,
                      isNumeric: true,
                    ),
                  ],
                  data: allEntries,
                  cellValueExtractor: (e, col) {
                    switch (col.id) {
                      case 'username':
                        return e.username;
                      case 'userType':
                        return e.userType;
                      case 'pnl':
                        return e.pnl.toStringAsFixed(2);
                      case 'percentWise':
                        return e.percentWise.toStringAsFixed(2);
                      case 'total':
                        return e.total.toStringAsFixed(2);
                      default:
                        return '-';
                    }
                  },
                );
              }
            },
            onExportExcel: () {
              final state = context.read<SettlementSharingReportBloc>().state;
              if (state is SettlementSharingReportLoaded) {
                final allEntries = [
                  ...state.report.profitList,
                  ...state.report.lossList,
                ];
                TableExportService.exportAsExcel(
                  title: 'Settlement With % Sharing',
                  columns: const [
                    ViewTableColumn(
                      id: 'username',
                      label: 'U.NAME',
                      width: 120,
                    ),
                    ViewTableColumn(id: 'userType', label: 'TYPE', width: 80),
                    ViewTableColumn(
                      id: 'pnl',
                      label: 'P&L',
                      width: 100,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'percentWise',
                      label: '% WISE',
                      width: 100,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'total',
                      label: 'TOTAL',
                      width: 100,
                      isNumeric: true,
                    ),
                  ],
                  data: allEntries,
                  cellValueExtractor: (e, col) {
                    switch (col.id) {
                      case 'username':
                        return e.username;
                      case 'userType':
                        return e.userType;
                      case 'pnl':
                        return e.pnl.toStringAsFixed(2);
                      case 'percentWise':
                        return e.percentWise.toStringAsFixed(2);
                      case 'total':
                        return e.total.toStringAsFixed(2);
                      default:
                        return '-';
                    }
                  },
                );
              }
            },
            child: const SettlementSharingReportPage(),
          );
        },
      ),
    );
  }
}

class CreditHistoryPageWithAppBar extends StatelessWidget {
  const CreditHistoryPageWithAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CreditHistoryBloc>()..add(const LoadCreditHistory()),
      child: Builder(
        builder: (context) {
          final authState = context.read<AuthBloc>().state;
          final role = authState is AuthAuthenticated
              ? authState.user.role.toLowerCase()
              : 'admin';
          return ReportPageWrapper(
            pageTitle: 'Credit History',
            onExportPdf: () {
              final state = context.read<CreditHistoryBloc>().state;
              if (state is CreditHistoryLoaded) {
                final dtf = DateFormat('dd/MM/yy HH:mm');
                final columns = [
                  if (role != 'client')
                    const ViewTableColumn(
                      id: 'userName',
                      label: 'U.NAME',
                      width: 100,
                    ),
                  if (role == 'master')
                    const ViewTableColumn(
                      id: 'parentUserName',
                      label: 'P.USER',
                      width: 100,
                    ),
                  const ViewTableColumn(
                    id: 'dateTime',
                    label: 'DATE TIME',
                    width: 140,
                  ),
                  const ViewTableColumn(id: 'type', label: 'TYPE', width: 80),
                  const ViewTableColumn(
                    id: 'amount',
                    label: 'AMOUNT',
                    width: 90,
                    isNumeric: true,
                  ),
                  const ViewTableColumn(
                    id: 'balance',
                    label: 'BALANCE',
                    width: 90,
                    isNumeric: true,
                  ),
                  const ViewTableColumn(
                    id: 'comment',
                    label: 'COMMENT',
                    width: 200,
                  ),
                ];
                TableExportService.exportAsPdf(
                  title: 'Credit History',
                  columns: columns,
                  data: state.creditHistory,
                  cellValueExtractor: (item, col) {
                    switch (col.id) {
                      case 'userName':
                        return item.userName;
                      case 'parentUserName':
                        return item.parentUserName;
                      case 'dateTime':
                        return dtf.format(item.dateTime);
                      case 'type':
                        return item.type;
                      case 'amount':
                        return item.amount.toStringAsFixed(2);
                      case 'balance':
                        return item.balance.toStringAsFixed(2);
                      case 'comment':
                        return item.comment;
                      default:
                        return '-';
                    }
                  },
                );
              }
            },
            onExportExcel: () {
              final state = context.read<CreditHistoryBloc>().state;
              if (state is CreditHistoryLoaded) {
                final dtf = DateFormat('dd/MM/yy HH:mm');
                final columns = [
                  if (role != 'client')
                    const ViewTableColumn(
                      id: 'userName',
                      label: 'U.NAME',
                      width: 100,
                    ),
                  if (role == 'master')
                    const ViewTableColumn(
                      id: 'parentUserName',
                      label: 'P.USER',
                      width: 100,
                    ),
                  const ViewTableColumn(
                    id: 'dateTime',
                    label: 'DATE TIME',
                    width: 140,
                  ),
                  const ViewTableColumn(id: 'type', label: 'TYPE', width: 80),
                  const ViewTableColumn(
                    id: 'amount',
                    label: 'AMOUNT',
                    width: 90,
                    isNumeric: true,
                  ),
                  const ViewTableColumn(
                    id: 'balance',
                    label: 'BALANCE',
                    width: 90,
                    isNumeric: true,
                  ),
                  const ViewTableColumn(
                    id: 'comment',
                    label: 'COMMENT',
                    width: 200,
                  ),
                ];
                TableExportService.exportAsExcel(
                  title: 'Credit History',
                  columns: columns,
                  data: state.creditHistory,
                  cellValueExtractor: (item, col) {
                    switch (col.id) {
                      case 'userName':
                        return item.userName;
                      case 'parentUserName':
                        return item.parentUserName;
                      case 'dateTime':
                        return dtf.format(item.dateTime);
                      case 'type':
                        return item.type;
                      case 'amount':
                        return item.amount.toStringAsFixed(2);
                      case 'balance':
                        return item.balance.toStringAsFixed(2);
                      case 'comment':
                        return item.comment;
                      default:
                        return '-';
                    }
                  },
                );
              }
            },
            child: const CreditHistoryPage(),
          );
        },
      ),
    );
  }
}

class BillGeneratePageWithAppBar extends StatelessWidget {
  const BillGeneratePageWithAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BillGenerateBloc>(),
      child: Builder(
        builder: (context) {
          return ReportPageWrapper(
            pageTitle: 'Bill Generate',
            onExportPdf: () {
              final state = context.read<BillGenerateBloc>().state;
              if (state is BillGenerateLoaded) {
                context.read<BillGenerateBloc>().add(
                  LoadBillGenerateReport(
                    userId: state.selectedUserId,
                    billFormat: 'PDF',
                    billType: state.selectedBillType,
                    shouldExport: true,
                  ),
                );
              }
            },
            onExportExcel: () {
              final state = context.read<BillGenerateBloc>().state;
              if (state is BillGenerateLoaded) {
                context.read<BillGenerateBloc>().add(
                  LoadBillGenerateReport(
                    userId: state.selectedUserId,
                    billFormat: 'Excel',
                    billType: state.selectedBillType,
                    shouldExport: true,
                  ),
                );
              }
            },
            child: const BillGeneratePage(),
          );
        },
      ),
    );
  }
}

class ActivityReportPageWithAppBar extends StatelessWidget {
  const ActivityReportPageWithAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ActivityReportBloc>()..add(const LoadActivityReport()),
      child: Builder(
        builder: (context) {
          return ReportPageWrapper(
            pageTitle: 'Activity Report',
            onExportPdf: () {
              final state = context.read<ActivityReportBloc>().state;
              if (state is ActivityReportLoaded) {
                final dtf = DateFormat('dd/MM/yy HH:mm');
                TableExportService.exportAsPdf(
                  title: 'Activity Report',
                  columns: const [
                    ViewTableColumn(
                      id: 'activityName',
                      label: 'ACTIVITY',
                      width: 200,
                    ),
                    ViewTableColumn(
                      id: 'createdOn',
                      label: 'CREATED ON',
                      width: 140,
                    ),
                    ViewTableColumn(
                      id: 'createdBy',
                      label: 'CREATED BY',
                      width: 120,
                    ),
                    ViewTableColumn(
                      id: 'updatedOn',
                      label: 'UPDATED ON',
                      width: 140,
                    ),
                    ViewTableColumn(
                      id: 'updatedBy',
                      label: 'UPDATED BY',
                      width: 120,
                    ),
                  ],
                  data: state.reports,
                  cellValueExtractor: (item, col) {
                    switch (col.id) {
                      case 'activityName':
                        return item.activityName;
                      case 'createdOn':
                        return dtf.format(item.createdOn);
                      case 'createdBy':
                        return item.createdBy;
                      case 'updatedOn':
                        return dtf.format(item.updatedOn);
                      case 'updatedBy':
                        return item.updatedBy;
                      default:
                        return '-';
                    }
                  },
                );
              }
            },
            onExportExcel: () {
              final state = context.read<ActivityReportBloc>().state;
              if (state is ActivityReportLoaded) {
                final dtf = DateFormat('dd/MM/yy HH:mm');
                TableExportService.exportAsExcel(
                  title: 'Activity Report',
                  columns: const [
                    ViewTableColumn(
                      id: 'activityName',
                      label: 'ACTIVITY',
                      width: 200,
                    ),
                    ViewTableColumn(
                      id: 'createdOn',
                      label: 'CREATED ON',
                      width: 140,
                    ),
                    ViewTableColumn(
                      id: 'createdBy',
                      label: 'CREATED BY',
                      width: 120,
                    ),
                    ViewTableColumn(
                      id: 'updatedOn',
                      label: 'UPDATED ON',
                      width: 140,
                    ),
                    ViewTableColumn(
                      id: 'updatedBy',
                      label: 'UPDATED BY',
                      width: 120,
                    ),
                  ],
                  data: state.reports,
                  cellValueExtractor: (item, col) {
                    switch (col.id) {
                      case 'activityName':
                        return item.activityName;
                      case 'createdOn':
                        return dtf.format(item.createdOn);
                      case 'createdBy':
                        return item.createdBy;
                      case 'updatedOn':
                        return dtf.format(item.updatedOn);
                      case 'updatedBy':
                        return item.updatedBy;
                      default:
                        return '-';
                    }
                  },
                );
              }
            },
            child: const ActivityReportPage(),
          );
        },
      ),
    );
  }
}

class ProfitAndLossPageWithAppBar extends StatelessWidget {
  const ProfitAndLossPageWithAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<ProfitAndLossReportBloc>()..add(const LoadProfitAndLossReport()),
      child: Builder(
        builder: (context) {
          return ReportPageWrapper(
            pageTitle: 'Profit & Loss',
            onExportPdf: () {
              final state = context.read<ProfitAndLossReportBloc>().state;
              if (state is ProfitAndLossReportLoaded) {
                TableExportService.exportAsPdf(
                  title: 'Profit & Loss',
                  columns: const [
                    ViewTableColumn(
                      id: 'userName',
                      label: 'U.NAME',
                      width: 120,
                    ),
                    ViewTableColumn(
                      id: 'percentage',
                      label: '%',
                      width: 70,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'releasePL',
                      label: 'RELEASE P&L',
                      width: 110,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'brokerage',
                      label: 'BROK',
                      width: 90,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'm2m',
                      label: 'M2M',
                      width: 90,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'netPL',
                      label: 'NET P&L',
                      width: 100,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'ourBrokerage',
                      label: 'OUR BROK',
                      width: 100,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'ourPercentage',
                      label: 'OUR %',
                      width: 80,
                      isNumeric: true,
                    ),
                  ],
                  data: state.reports,
                  cellValueExtractor: (item, col) {
                    switch (col.id) {
                      case 'userName':
                        return item.userName;
                      case 'percentage':
                        return item.percentage.toStringAsFixed(2);
                      case 'releasePL':
                        return item.releasePL.toStringAsFixed(2);
                      case 'brokerage':
                        return item.brokerage.toStringAsFixed(2);
                      case 'm2m':
                        return item.m2m.toStringAsFixed(2);
                      case 'netPL':
                        return item.netPL.toStringAsFixed(2);
                      case 'ourBrokerage':
                        return item.ourBrokerage.toStringAsFixed(2);
                      case 'ourPercentage':
                        return item.ourPercentage.toStringAsFixed(2);
                      default:
                        return '-';
                    }
                  },
                );
              }
            },
            onExportExcel: () {
              final state = context.read<ProfitAndLossReportBloc>().state;
              if (state is ProfitAndLossReportLoaded) {
                TableExportService.exportAsExcel(
                  title: 'Profit & Loss',
                  columns: const [
                    ViewTableColumn(
                      id: 'userName',
                      label: 'U.NAME',
                      width: 120,
                    ),
                    ViewTableColumn(
                      id: 'percentage',
                      label: '%',
                      width: 70,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'releasePL',
                      label: 'RELEASE P&L',
                      width: 110,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'brokerage',
                      label: 'BROK',
                      width: 90,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'm2m',
                      label: 'M2M',
                      width: 90,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'netPL',
                      label: 'NET P&L',
                      width: 100,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'ourBrokerage',
                      label: 'OUR BROK',
                      width: 100,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'ourPercentage',
                      label: 'OUR %',
                      width: 80,
                      isNumeric: true,
                    ),
                  ],
                  data: state.reports,
                  cellValueExtractor: (item, col) {
                    switch (col.id) {
                      case 'userName':
                        return item.userName;
                      case 'percentage':
                        return item.percentage.toStringAsFixed(2);
                      case 'releasePL':
                        return item.releasePL.toStringAsFixed(2);
                      case 'brokerage':
                        return item.brokerage.toStringAsFixed(2);
                      case 'm2m':
                        return item.m2m.toStringAsFixed(2);
                      case 'netPL':
                        return item.netPL.toStringAsFixed(2);
                      case 'ourBrokerage':
                        return item.ourBrokerage.toStringAsFixed(2);
                      case 'ourPercentage':
                        return item.ourPercentage.toStringAsFixed(2);
                      default:
                        return '-';
                    }
                  },
                );
              }
            },
            child: const ProfitAndLossReportPage(),
          );
        },
      ),
    );
  }
}

class UserWisePLPageWithAppBar extends StatelessWidget {
  const UserWisePLPageWithAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<UserWiseProfitAndLossBloc>()..add(LoadUserWiseProfitAndLoss()),
      child: Builder(
        builder: (context) {
          return ReportPageWrapper(
            pageTitle: 'User Wise Profit & Loss',
            onExportPdf: () {
              final state = context.read<UserWiseProfitAndLossBloc>().state;
              if (state is UserWiseProfitAndLossLoaded) {
                TableExportService.exportAsPdf(
                  title: 'User Wise P&L',
                  columns: const [
                    ViewTableColumn(
                      id: 'userName',
                      label: 'U.NAME',
                      width: 100,
                    ),
                    ViewTableColumn(
                      id: 'parentUser',
                      label: 'P.USER',
                      width: 100,
                    ),
                    ViewTableColumn(
                      id: 'mtm',
                      label: 'MTM',
                      width: 90,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'releasedPL',
                      label: 'RELEASE P&L',
                      width: 110,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'brokerage',
                      label: 'BROK',
                      width: 90,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'netPL',
                      label: 'NET P&L',
                      width: 100,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'credit',
                      label: 'CREDIT',
                      width: 90,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'equity',
                      label: 'EQUITY',
                      width: 90,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'margin',
                      label: 'MARGIN',
                      width: 90,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'usedMargin',
                      label: 'USED MRG',
                      width: 100,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'freeMargin',
                      label: 'FREE MRG',
                      width: 100,
                      isNumeric: true,
                    ),
                  ],
                  data: state.reports,
                  cellValueExtractor: (item, col) {
                    switch (col.id) {
                      case 'userName':
                        return item.userName;
                      case 'parentUser':
                        return item.parentUser;
                      case 'mtm':
                        return item.mtm.toStringAsFixed(2);
                      case 'releasedPL':
                        return item.releasedPL.toStringAsFixed(2);
                      case 'brokerage':
                        return item.brokerage.toStringAsFixed(2);
                      case 'netPL':
                        return item.netPL.toStringAsFixed(2);
                      case 'credit':
                        return item.credit.toStringAsFixed(2);
                      case 'equity':
                        return item.equity.toStringAsFixed(2);
                      case 'margin':
                        return item.margin.toStringAsFixed(2);
                      case 'usedMargin':
                        return item.usedMargin.toStringAsFixed(2);
                      case 'freeMargin':
                        return item.freeMargin.toStringAsFixed(2);
                      default:
                        return '-';
                    }
                  },
                );
              }
            },
            onExportExcel: () {
              final state = context.read<UserWiseProfitAndLossBloc>().state;
              if (state is UserWiseProfitAndLossLoaded) {
                TableExportService.exportAsExcel(
                  title: 'User Wise P&L',
                  columns: const [
                    ViewTableColumn(
                      id: 'userName',
                      label: 'U.NAME',
                      width: 100,
                    ),
                    ViewTableColumn(
                      id: 'parentUser',
                      label: 'P.USER',
                      width: 100,
                    ),
                    ViewTableColumn(
                      id: 'mtm',
                      label: 'MTM',
                      width: 90,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'releasedPL',
                      label: 'RELEASE P&L',
                      width: 110,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'brokerage',
                      label: 'BROK',
                      width: 90,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'netPL',
                      label: 'NET P&L',
                      width: 100,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'credit',
                      label: 'CREDIT',
                      width: 90,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'equity',
                      label: 'EQUITY',
                      width: 90,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'margin',
                      label: 'MARGIN',
                      width: 90,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'usedMargin',
                      label: 'USED MRG',
                      width: 100,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'freeMargin',
                      label: 'FREE MRG',
                      width: 100,
                      isNumeric: true,
                    ),
                  ],
                  data: state.reports,
                  cellValueExtractor: (item, col) {
                    switch (col.id) {
                      case 'userName':
                        return item.userName;
                      case 'parentUser':
                        return item.parentUser;
                      case 'mtm':
                        return item.mtm.toStringAsFixed(2);
                      case 'releasedPL':
                        return item.releasedPL.toStringAsFixed(2);
                      case 'brokerage':
                        return item.brokerage.toStringAsFixed(2);
                      case 'netPL':
                        return item.netPL.toStringAsFixed(2);
                      case 'credit':
                        return item.credit.toStringAsFixed(2);
                      case 'equity':
                        return item.equity.toStringAsFixed(2);
                      case 'margin':
                        return item.margin.toStringAsFixed(2);
                      case 'usedMargin':
                        return item.usedMargin.toStringAsFixed(2);
                      case 'freeMargin':
                        return item.freeMargin.toStringAsFixed(2);
                      default:
                        return '-';
                    }
                  },
                );
              }
            },
            child: const UserWiseProfitAndLossPage(),
          );
        },
      ),
    );
  }
}

class UserScriptPositionTrackingPageWithAppBar extends StatelessWidget {
  const UserScriptPositionTrackingPageWithAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<UserScriptPositionTrackingBloc>()
            ..add(const LoadUserScriptPositionTracking()),
      child: Builder(
        builder: (context) {
          return ReportPageWrapper(
            pageTitle: 'User Script Position Tracking',
            onExportPdf: () {
              final state = context
                  .read<UserScriptPositionTrackingBloc>()
                  .state;
              if (state is UserScriptPositionTrackingLoaded) {
                TableExportService.exportAsPdf(
                  title: 'User Script Position Tracking',
                  columns: const [
                    ViewTableColumn(
                      id: 'positionDate',
                      label: 'DATE',
                      width: 120,
                    ),
                    ViewTableColumn(
                      id: 'userName',
                      label: 'U.NAME',
                      width: 120,
                    ),
                    ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 150),
                    ViewTableColumn(
                      id: 'position',
                      label: 'POSITION',
                      width: 90,
                    ),
                    ViewTableColumn(
                      id: 'openAPrice',
                      label: 'OPEN PRICE',
                      width: 100,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'days',
                      label: 'DAYS',
                      width: 70,
                      isNumeric: true,
                    ),
                  ],
                  data: state.reports,
                  cellValueExtractor: (item, col) {
                    switch (col.id) {
                      case 'positionDate':
                        return item.positionDate;
                      case 'userName':
                        return item.userName;
                      case 'symbol':
                        return item.symbol;
                      case 'position':
                        return item.position;
                      case 'openAPrice':
                        return item.openAPrice.toStringAsFixed(2);
                      case 'days':
                        return item.days.toString();
                      default:
                        return '-';
                    }
                  },
                );
              }
            },
            onExportExcel: () {
              final state = context
                  .read<UserScriptPositionTrackingBloc>()
                  .state;
              if (state is UserScriptPositionTrackingLoaded) {
                TableExportService.exportAsExcel(
                  title: 'User Script Position Tracking',
                  columns: const [
                    ViewTableColumn(
                      id: 'positionDate',
                      label: 'DATE',
                      width: 120,
                    ),
                    ViewTableColumn(
                      id: 'userName',
                      label: 'U.NAME',
                      width: 120,
                    ),
                    ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 150),
                    ViewTableColumn(
                      id: 'position',
                      label: 'POSITION',
                      width: 90,
                    ),
                    ViewTableColumn(
                      id: 'openAPrice',
                      label: 'OPEN PRICE',
                      width: 100,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'days',
                      label: 'DAYS',
                      width: 70,
                      isNumeric: true,
                    ),
                  ],
                  data: state.reports,
                  cellValueExtractor: (item, col) {
                    switch (col.id) {
                      case 'positionDate':
                        return item.positionDate;
                      case 'userName':
                        return item.userName;
                      case 'symbol':
                        return item.symbol;
                      case 'position':
                        return item.position;
                      case 'openAPrice':
                        return item.openAPrice.toStringAsFixed(2);
                      case 'days':
                        return item.days.toString();
                      default:
                        return '-';
                    }
                  },
                );
              }
            },
            child: const UserScriptPositionTrackingPage(),
          );
        },
      ),
    );
  }
}

class SymbolWisePositionReportPageWithAppBar extends StatelessWidget {
  const SymbolWisePositionReportPageWithAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<SymbolWisePositionReportBloc>()
            ..add(const LoadSymbolWisePositionReport()),
      child: Builder(
        builder: (context) {
          return ReportPageWrapper(
            pageTitle: 'Symbol Wise Position Report',
            onExportPdf: () {
              final state = context.read<SymbolWisePositionReportBloc>().state;
              if (state is SymbolWisePositionReportLoaded) {
                TableExportService.exportAsPdf(
                  title: 'Symbol Wise Position Report',
                  columns: const [
                    ViewTableColumn(id: 'exchange', label: 'EXCH', width: 70),
                    ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 150),
                    ViewTableColumn(
                      id: 'netQty',
                      label: 'NET QTY',
                      width: 80,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'netMs',
                      label: 'NET MS',
                      width: 90,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'netAvgPrice',
                      label: 'AVG PRICE',
                      width: 100,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'cmp',
                      label: 'CMP',
                      width: 90,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'm2m',
                      label: 'M2M',
                      width: 90,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'releasePL',
                      label: 'RELEASE P&L',
                      width: 110,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'netPL',
                      label: 'NET P&L',
                      width: 100,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'brokerage',
                      label: 'BROK',
                      width: 90,
                      isNumeric: true,
                    ),
                  ],
                  data: state.reports,
                  cellValueExtractor: (item, col) {
                    switch (col.id) {
                      case 'exchange':
                        return item.exchange;
                      case 'symbol':
                        return item.symbol;
                      case 'netQty':
                        return item.netQty.toStringAsFixed(2);
                      case 'netMs':
                        return item.netMs.toStringAsFixed(2);
                      case 'netAvgPrice':
                        return item.netAvgPrice.toStringAsFixed(2);
                      case 'cmp':
                        return item.cmp.toStringAsFixed(2);
                      case 'm2m':
                        return item.m2m.toStringAsFixed(2);
                      case 'releasePL':
                        return item.releasePL.toStringAsFixed(2);
                      case 'netPL':
                        return item.netPL.toStringAsFixed(2);
                      case 'brokerage':
                        return item.brokerage.toStringAsFixed(2);
                      default:
                        return '-';
                    }
                  },
                );
              }
            },
            onExportExcel: () {
              final state = context.read<SymbolWisePositionReportBloc>().state;
              if (state is SymbolWisePositionReportLoaded) {
                TableExportService.exportAsExcel(
                  title: 'Symbol Wise Position Report',
                  columns: const [
                    ViewTableColumn(id: 'exchange', label: 'EXCH', width: 70),
                    ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 150),
                    ViewTableColumn(
                      id: 'netQty',
                      label: 'NET QTY',
                      width: 80,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'netMs',
                      label: 'NET MS',
                      width: 90,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'netAvgPrice',
                      label: 'AVG PRICE',
                      width: 100,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'cmp',
                      label: 'CMP',
                      width: 90,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'm2m',
                      label: 'M2M',
                      width: 90,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'releasePL',
                      label: 'RELEASE P&L',
                      width: 110,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'netPL',
                      label: 'NET P&L',
                      width: 100,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'brokerage',
                      label: 'BROK',
                      width: 90,
                      isNumeric: true,
                    ),
                  ],
                  data: state.reports,
                  cellValueExtractor: (item, col) {
                    switch (col.id) {
                      case 'exchange':
                        return item.exchange;
                      case 'symbol':
                        return item.symbol;
                      case 'netQty':
                        return item.netQty.toStringAsFixed(2);
                      case 'netMs':
                        return item.netMs.toStringAsFixed(2);
                      case 'netAvgPrice':
                        return item.netAvgPrice.toStringAsFixed(2);
                      case 'cmp':
                        return item.cmp.toStringAsFixed(2);
                      case 'm2m':
                        return item.m2m.toStringAsFixed(2);
                      case 'releasePL':
                        return item.releasePL.toStringAsFixed(2);
                      case 'netPL':
                        return item.netPL.toStringAsFixed(2);
                      case 'brokerage':
                        return item.brokerage.toStringAsFixed(2);
                      default:
                        return '-';
                    }
                  },
                );
              }
            },
            child: const SymbolWisePositionReportPage(),
          );
        },
      ),
    );
  }
}

class SymbolWisePLPageWithAppBar extends StatelessWidget {
  const SymbolWisePLPageWithAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final state = context.read<AuthBloc>().state;
    String title = 'Symbol Wise PL';
    if (state is AuthAuthenticated &&
        state.user.role.toLowerCase() == 'client') {
      title = 'Symbol Wise Report';
    }
    return BlocProvider(
      create: (_) => sl<SymbolWisePLBloc>()..add(const LoadSymbolWisePL()),
      child: Builder(
        builder: (context) {
          return ReportPageWrapper(
            pageTitle: title,
            onExportPdf: () {
              final blocState = context.read<SymbolWisePLBloc>().state;
              if (blocState is SymbolWisePLLoaded) {
                TableExportService.exportAsPdf(
                  title: title,
                  columns: const [
                    ViewTableColumn(id: 'exchange', label: 'EXCH', width: 70),
                    ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 150),
                    ViewTableColumn(
                      id: 'releasePL',
                      label: 'RELEASE P&L',
                      width: 110,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'm2m',
                      label: 'M2M',
                      width: 90,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'brokerage',
                      label: 'BROK',
                      width: 90,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'netPL',
                      label: 'NET P&L',
                      width: 100,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'plPercent',
                      label: 'PL %',
                      width: 80,
                      isNumeric: true,
                    ),
                  ],
                  data: blocState.reports,
                  cellValueExtractor: (item, col) {
                    switch (col.id) {
                      case 'exchange':
                        return item.exchange;
                      case 'symbol':
                        return item.symbol;
                      case 'releasePL':
                        return item.releasePL.toStringAsFixed(2);
                      case 'm2m':
                        return item.m2m.toStringAsFixed(2);
                      case 'brokerage':
                        return item.brokerage.toStringAsFixed(2);
                      case 'netPL':
                        return item.netPL.toStringAsFixed(2);
                      case 'plPercent':
                        return item.plPercent.toStringAsFixed(2);
                      default:
                        return '-';
                    }
                  },
                );
              }
            },
            onExportExcel: () {
              final blocState = context.read<SymbolWisePLBloc>().state;
              if (blocState is SymbolWisePLLoaded) {
                TableExportService.exportAsExcel(
                  title: title,
                  columns: const [
                    ViewTableColumn(id: 'exchange', label: 'EXCH', width: 70),
                    ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 150),
                    ViewTableColumn(
                      id: 'releasePL',
                      label: 'RELEASE P&L',
                      width: 110,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'm2m',
                      label: 'M2M',
                      width: 90,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'brokerage',
                      label: 'BROK',
                      width: 90,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'netPL',
                      label: 'NET P&L',
                      width: 100,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'plPercent',
                      label: 'PL %',
                      width: 80,
                      isNumeric: true,
                    ),
                  ],
                  data: blocState.reports,
                  cellValueExtractor: (item, col) {
                    switch (col.id) {
                      case 'exchange':
                        return item.exchange;
                      case 'symbol':
                        return item.symbol;
                      case 'releasePL':
                        return item.releasePL.toStringAsFixed(2);
                      case 'm2m':
                        return item.m2m.toStringAsFixed(2);
                      case 'brokerage':
                        return item.brokerage.toStringAsFixed(2);
                      case 'netPL':
                        return item.netPL.toStringAsFixed(2);
                      case 'plPercent':
                        return item.plPercent.toStringAsFixed(2);
                      default:
                        return '-';
                    }
                  },
                );
              }
            },
            child: const SymbolWisePLReportPage(),
          );
        },
      ),
    );
  }
}

class ExchangeWiseReportPageWithAppBar extends StatelessWidget {
  const ExchangeWiseReportPageWithAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ExchangeWisePLBloc>()..add(const LoadExchangeWisePL()),
      child: Builder(
        builder: (context) {
          return ReportPageWrapper(
            pageTitle: 'Exchange Wise Report',
            onExportPdf: () {
              final state = context.read<ExchangeWisePLBloc>().state;
              if (state is ExchangeWisePLLoaded) {
                TableExportService.exportAsPdf(
                  title: 'Exchange Wise Report',
                  columns: const [
                    ViewTableColumn(
                      id: 'exchange',
                      label: 'EXCHANGE',
                      width: 100,
                    ),
                    ViewTableColumn(
                      id: 'm2m',
                      label: 'M2M',
                      width: 90,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'realisedPL',
                      label: 'REALISED P&L',
                      width: 120,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'brokerage',
                      label: 'BROK',
                      width: 90,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'totalPL',
                      label: 'TOTAL P&L',
                      width: 100,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'ourPercent',
                      label: 'OUR %',
                      width: 80,
                      isNumeric: true,
                    ),
                  ],
                  data: state.reports,
                  cellValueExtractor: (item, col) {
                    switch (col.id) {
                      case 'exchange':
                        return item.exchange;
                      case 'm2m':
                        return item.m2m.toStringAsFixed(2);
                      case 'realisedPL':
                        return item.realisedPL.toStringAsFixed(2);
                      case 'brokerage':
                        return item.brokerage.toStringAsFixed(2);
                      case 'totalPL':
                        return item.totalPL.toStringAsFixed(2);
                      case 'ourPercent':
                        return item.ourPercent.toStringAsFixed(2);
                      default:
                        return '-';
                    }
                  },
                );
              }
            },
            onExportExcel: () {
              final state = context.read<ExchangeWisePLBloc>().state;
              if (state is ExchangeWisePLLoaded) {
                TableExportService.exportAsExcel(
                  title: 'Exchange Wise Report',
                  columns: const [
                    ViewTableColumn(
                      id: 'exchange',
                      label: 'EXCHANGE',
                      width: 100,
                    ),
                    ViewTableColumn(
                      id: 'm2m',
                      label: 'M2M',
                      width: 90,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'realisedPL',
                      label: 'REALISED P&L',
                      width: 120,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'brokerage',
                      label: 'BROK',
                      width: 90,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'totalPL',
                      label: 'TOTAL P&L',
                      width: 100,
                      isNumeric: true,
                    ),
                    ViewTableColumn(
                      id: 'ourPercent',
                      label: 'OUR %',
                      width: 80,
                      isNumeric: true,
                    ),
                  ],
                  data: state.reports,
                  cellValueExtractor: (item, col) {
                    switch (col.id) {
                      case 'exchange':
                        return item.exchange;
                      case 'm2m':
                        return item.m2m.toStringAsFixed(2);
                      case 'realisedPL':
                        return item.realisedPL.toStringAsFixed(2);
                      case 'brokerage':
                        return item.brokerage.toStringAsFixed(2);
                      case 'totalPL':
                        return item.totalPL.toStringAsFixed(2);
                      case 'ourPercent':
                        return item.ourPercent.toStringAsFixed(2);
                      default:
                        return '-';
                    }
                  },
                );
              }
            },
            child: const ExchangeWisePLReportPage(),
          );
        },
      ),
    );
  }
}

class BackOfficeActivityReportPageWithAppBar extends StatelessWidget {
  const BackOfficeActivityReportPageWithAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<BackOfficeActivityReportBloc>()
            ..add(const LoadBackOfficeActivityReport()),
      child: Builder(
        builder: (context) {
          return ReportPageWrapper(
            pageTitle: 'Back Office Activity Report',
            onExportPdf: () {
              final state = context.read<BackOfficeActivityReportBloc>().state;
              if (state is BackOfficeActivityReportLoaded) {
                final dtf = DateFormat('dd/MM/yy HH:mm');
                TableExportService.exportAsPdf(
                  title: 'Back Office Activity Report',
                  columns: const [
                    ViewTableColumn(
                      id: 'activityName',
                      label: 'ACTIVITY',
                      width: 200,
                    ),
                    ViewTableColumn(
                      id: 'createdOn',
                      label: 'CREATED ON',
                      width: 140,
                    ),
                    ViewTableColumn(
                      id: 'createdBy',
                      label: 'CREATED BY',
                      width: 120,
                    ),
                    ViewTableColumn(
                      id: 'updatedOn',
                      label: 'UPDATED ON',
                      width: 140,
                    ),
                    ViewTableColumn(
                      id: 'updatedBy',
                      label: 'UPDATED BY',
                      width: 120,
                    ),
                  ],
                  data: state.reports,
                  cellValueExtractor: (item, col) {
                    switch (col.id) {
                      case 'activityName':
                        return item.activityName;
                      case 'createdOn':
                        return dtf.format(item.createdOn);
                      case 'createdBy':
                        return item.createdBy;
                      case 'updatedOn':
                        return dtf.format(item.updatedOn);
                      case 'updatedBy':
                        return item.updatedBy;
                      default:
                        return '-';
                    }
                  },
                );
              }
            },
            onExportExcel: () {
              final state = context.read<BackOfficeActivityReportBloc>().state;
              if (state is BackOfficeActivityReportLoaded) {
                final dtf = DateFormat('dd/MM/yy HH:mm');
                TableExportService.exportAsExcel(
                  title: 'Back Office Activity Report',
                  columns: const [
                    ViewTableColumn(
                      id: 'activityName',
                      label: 'ACTIVITY',
                      width: 200,
                    ),
                    ViewTableColumn(
                      id: 'createdOn',
                      label: 'CREATED ON',
                      width: 140,
                    ),
                    ViewTableColumn(
                      id: 'createdBy',
                      label: 'CREATED BY',
                      width: 120,
                    ),
                    ViewTableColumn(
                      id: 'updatedOn',
                      label: 'UPDATED ON',
                      width: 140,
                    ),
                    ViewTableColumn(
                      id: 'updatedBy',
                      label: 'UPDATED BY',
                      width: 120,
                    ),
                  ],
                  data: state.reports,
                  cellValueExtractor: (item, col) {
                    switch (col.id) {
                      case 'activityName':
                        return item.activityName;
                      case 'createdOn':
                        return dtf.format(item.createdOn);
                      case 'createdBy':
                        return item.createdBy;
                      case 'updatedOn':
                        return dtf.format(item.updatedOn);
                      case 'updatedBy':
                        return item.updatedBy;
                      default:
                        return '-';
                    }
                  },
                );
              }
            },
            child: const BackOfficeActivityReportPage(),
          );
        },
      ),
    );
  }
}
