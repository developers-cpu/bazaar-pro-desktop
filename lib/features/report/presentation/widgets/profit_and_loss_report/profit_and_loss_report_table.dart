import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_record_count.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../../../../core/widget/table/view_data_table_footer.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../users/domain/entities/user.dart';
import '../../../../users/presentation/widgets/user_details/user_details_dialog.dart';
import '../../../../users/presentation/widgets/create_user/master_form_dialog.dart';
import '../../../../users/presentation/widgets/create_user/client_form_dialog.dart';
import '../../../../users/presentation/widgets/create_user/update_access_dialog.dart';
import '../../../domain/entities/profit_and_loss_report.dart';
import '../../bloc/profit_and_loss_report/profit_and_loss_report_bloc.dart';
import '../../bloc/profit_and_loss_report/profit_and_loss_report_state.dart';
import 'profit_and_loss_details_dialog.dart';
class ProfitAndLossReportTable extends StatelessWidget {
  final bool isDarkMode;
  const ProfitAndLossReportTable({super.key, this.isDarkMode = false});
  List<ViewTableColumn> _getColumns() {
    return const [
      ViewTableColumn(id: 'view', label: 'VIEW', width: 100),
      ViewTableColumn(id: 'userName', label: 'U. NAME', width: 150),
      ViewTableColumn(
        id: 'percentage',
        label: '%',
        width: 100,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'releasePL',
        label: 'RELEASE P/L',
        width: 150,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'brokerage',
        label: 'BRK',
        width: 150,
        isNumeric: true,
      ),
      ViewTableColumn(id: 'm2m', label: 'M2M', width: 150, isNumeric: true),
      ViewTableColumn(
        id: 'netPL',
        label: 'NET P/L',
        width: 150,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'ourBrokerage',
        label: 'OUR BRK',
        width: 150,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'ourPercentage',
        label: 'OUR',
        width: 150,
        isNumeric: true,
      ),
    ];
  }
  Widget _buildCell(
    BuildContext context,
    ProfitAndLossReport item,
    ViewTableColumn column,
    bool isDark,
  ) {
    switch (column.id) {
      case 'view':
        return IconButton(
          icon: Icon(
            Icons.picture_in_picture_alt,
            size: 16.sp,
            color: const Color(0xFF1F4A66),
          ),
          onPressed: () {
            ProfitAndLossDetailsDialog.show(context, [
              item,
              item,
            ], item.userName);
          },
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        );
      case 'userName':
        return ViewLinkCell(
          text: item.userName,
          isDark: isDark,
          onTap: () {
            final dummyUser = User(
              id: item.id,
              userName: item.userName,
              name: item.userName,
              parentUser: '',
              type: 'Client',
              plPercent: 0,
              brkPercent: 0,
              leverage: '',
              credit: 0,
              pl: 0,
              equity: 0,
              totalMargin: 0,
              usedMargin: 0,
              freeMargin: 0,
              createdDate: DateTime.now(),
              status: 'Active',
            );
            UserDetailsDialog.show(
              context,
              dummyUser,
              onEdit: (ctx) {
                if (dummyUser.type == 'Master') {
                  MasterFormDialog.showEdit(
                    context: ctx,
                    userData: {
                      'name': dummyUser.name,
                      'username': dummyUser.userName,
                    },
                    onComplete: () {},
                  );
                } else {
                  ClientFormDialog.showEdit(
                    context: ctx,
                    userData: {
                      'name': dummyUser.name,
                      'username': dummyUser.userName,
                    },
                    onComplete: () {},
                  );
                }
              },
              onAction: (ctx) {
                UpdateAccessDialog.show(
                  context: ctx,
                  userId: dummyUser.id,
                  userName: dummyUser.userName,
                  currentSettings: {
                    'bet': true,
                    'closeOnly': false,
                    'viewOnly': false,
                    'status': true,
                    'allowChat': true,
                    'positionCut15Days': false,
                    'freshLimitSL': true,
                    'lockUser': false,
                  },
                  onUpdate: (settings) {
                    Navigator.pop(ctx);
                  },
                );
              },
            );
          },
        );
      case 'percentage':
        return ViewNumberCell(
          value: item.percentage,
          isDark: isDark,
          colorByValue: false,
        );
      case 'releasePL':
        return ViewNumberCell(
          value: item.releasePL,
          isDark: isDark,
          fixedColor: item.releasePL >= 0 ? AppColors.buyColor : AppColors.sellColor,
        );
      case 'brokerage':
        return ViewNumberCell(
          value: item.brokerage,
          isDark: isDark,
          colorByValue: false,
        );
      case 'm2m':
        return ViewNumberCell(value: item.m2m, isDark: isDark);
      case 'netPL':
        return ViewNumberCell(value: item.netPL, isDark: isDark);
      case 'ourBrokerage':
        return ViewNumberCell(value: item.ourBrokerage, isDark: isDark);
      case 'ourPercentage':
        return ViewNumberCell(value: item.ourPercentage, isDark: isDark);
      default:
        return const SizedBox.shrink();
    }
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfitAndLossReportBloc, ProfitAndLossReportState>(
      builder: (context, state) {
        if (state is ProfitAndLossReportLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ProfitAndLossReportError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        if (state is! ProfitAndLossReportLoaded) {
          return const SizedBox.shrink();
        }
        double totalReleasePL = 0;
        double totalBrokerage = 0;
        double totalM2M = 0;
        double totalNetPL = 0;
        double totalOurBrokerage = 0;
        double totalOurPercentage = 0;
        for (var item in state.reports) {
          totalReleasePL += item.releasePL;
          totalBrokerage += item.brokerage;
          totalM2M += item.m2m;
          totalNetPL += item.netPL;
          totalOurBrokerage += item.ourBrokerage;
          totalOurPercentage += item.ourPercentage;
        }
        return Column(
          children: [
            ViewRecordCount(count: state.reports.length),
            Flexible(
              fit: FlexFit.loose,
              child: ViewDataTable<ProfitAndLossReport>(
                columns: _getColumns(),
                data: state.reports,
                idExtractor: (item) => item.id,
                autoFit: true,
                isDarkMode: isDarkMode,
                emptyMessage: 'No records found',
                cellBuilder: (item, column) =>
                    _buildCell(context, item, column, isDarkMode),
                comparatorBuilder: (item, columnId) {
                  switch (columnId) {
                    case 'userName':
                      return item.userName;
                    case 'percentage':
                      return item.percentage;
                    case 'releasePL':
                      return item.releasePL;
                    case 'brokerage':
                      return item.brokerage;
                    case 'm2m':
                      return item.m2m;
                    case 'netPL':
                      return item.netPL;
                    case 'ourBrokerage':
                      return item.ourBrokerage;
                    case 'ourPercentage':
                      return item.ourPercentage;
                    default:
                      return '';
                  }
                },
                footerBuilder: (columns) {
                  return ViewDataTableFooter(
                    columns: columns,
                    values: {
                      'view': 'Total',
                      'releasePL': totalReleasePL.toStringAsFixed(2),
                      'brokerage': totalBrokerage.toStringAsFixed(2),
                      'm2m': totalM2M.toStringAsFixed(2),
                      'netPL': totalNetPL.toStringAsFixed(2),
                      'ourBrokerage': totalOurBrokerage.toStringAsFixed(2),
                      'ourPercentage': totalOurPercentage.toStringAsFixed(2),
                    },
                    columnColors: {
                      'releasePL': totalReleasePL >= 0
                          ? AppColors.buyColor
                          : AppColors.sellColor,
                      'brokerage': totalBrokerage >= 0
                          ? AppColors.buyColor
                          : AppColors.sellColor,
                      'm2m': totalM2M >= 0
                          ? AppColors.buyColor
                          : AppColors.sellColor,
                      'netPL': totalNetPL >= 0
                          ? AppColors.buyColor
                          : AppColors.sellColor,
                      'ourBrokerage': totalOurBrokerage >= 0
                          ? AppColors.buyColor
                          : AppColors.sellColor,
                      'ourPercentage': totalOurPercentage >= 0
                          ? AppColors.buyColor
                          : AppColors.sellColor,
                    },
                    isDarkMode: isDarkMode,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
