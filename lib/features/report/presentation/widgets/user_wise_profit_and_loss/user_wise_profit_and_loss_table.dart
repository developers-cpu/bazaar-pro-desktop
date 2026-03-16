import 'package:bazarpro/features/users/domain/entities/user.dart';
import 'package:bazarpro/features/users/presentation/widgets/user_details/user_details_dialog.dart';
import 'package:bazarpro/features/users/presentation/widgets/create_user/master_form_dialog.dart';
import 'package:bazarpro/features/users/presentation/widgets/create_user/client_form_dialog.dart';
import 'package:bazarpro/features/users/presentation/widgets/create_user/update_access_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../report/domain/entities/user_wise_profit_and_loss_report.dart';
import '../../bloc/user_wise_profit_and_loss/user_wise_profit_and_loss_bloc.dart';
import '../../bloc/user_wise_profit_and_loss/user_wise_profit_and_loss_state.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_record_count.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../../../../core/widget/table/view_data_table_footer.dart';
import '../../../../../core/constants/app_colors.dart';

class UserWiseProfitAndLossReportTable extends StatelessWidget {
  final bool isDarkMode;
  const UserWiseProfitAndLossReportTable({super.key, this.isDarkMode = false});
  List<ViewTableColumn> _getColumns() {
    return const [
      ViewTableColumn(id: 'userName', label: 'U. NAME', width: 90),
      ViewTableColumn(id: 'parentUser', label: 'P.USER', width: 90),
      ViewTableColumn(id: 'mtm', label: 'MTM', width: 110, isNumeric: true),
      ViewTableColumn(
        id: 'releasedPL',
        label: 'REL.PL',
        width: 110,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'brokerage',
        label: 'BRK',
        width: 100,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'netPL',
        label: 'NET P/L',
        width: 120,
        isNumeric: true,
      ),
      ViewTableColumn(id: 'credit', label: 'CRD', width: 130, isNumeric: true),
      ViewTableColumn(id: 'equity', label: 'EQTY', width: 130, isNumeric: true),
      ViewTableColumn(
        id: 'margin',
        label: 'MARGIN',
        width: 120,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'usedMargin',
        label: 'USED MARGIN',
        width: 130,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'freeMargin',
        label: 'FREE MARGIN',
        width: 130,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'standingVolume',
        label: 'STANDING VOL',
        width: 140,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'marginLevelPercentage',
        label: 'MARGIN LEVEL%',
        width: 150,
        isNumeric: true,
      ),
      ViewTableColumn(id: 'createdBy', label: 'CREATED BY', width: 120),
      ViewTableColumn(id: 'createdDate', label: 'CREATE DATE', width: 160),
    ];
  }

  User _createDummyUser(UserWiseProfitAndLossReport item) {
    return User(
      id: item.id,
      userName: item.userName,
      name: item.userName,
      parentUser: item.parentUser,
      type: 'Client',
      plPercent: 0,
      brkPercent: 0,
      leverage: '',
      credit: item.credit,
      pl: item.netPL,
      equity: item.equity,
      totalMargin: item.margin,
      usedMargin: item.usedMargin,
      freeMargin: item.freeMargin,
      createdDate: item.createdDate,
      status: 'Active',
    );
  }

  Widget _buildClickableNumberCell(
    double value,
    VoidCallback onTap,
    bool isDark,
  ) {
    return ViewLinkCell(
      text: value.toStringAsFixed(2),
      onTap: onTap,
      isNumeric: true,
      isDark: isDark,
    );
  }

  Widget _buildCell(
    BuildContext context,
    UserWiseProfitAndLossReport item,
    ViewTableColumn column,
    bool isDark,
  ) {
    switch (column.id) {
      case 'userName':
        return ViewLinkCell(
          text: item.userName,
          isDark: isDark,
          onTap: () {
            UserDetailsDialog.show(
              context,
              _createDummyUser(item),
              onEdit: (ctx) {
                if (item.parentUser.isEmpty) {
                  MasterFormDialog.showEdit(
                    context: ctx,
                    userData: {
                      'name': item.userName,
                      'username': item.userName,
                    },
                    onComplete: () {},
                  );
                } else {
                  ClientFormDialog.showEdit(
                    context: ctx,
                    userData: {
                      'name': item.userName,
                      'username': item.userName,
                    },
                    onComplete: () {},
                  );
                }
              },
              onAction: (ctx) {
                UpdateAccessDialog.show(
                  context: ctx,
                  userId: item.id,
                  userName: item.userName,
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
      case 'parentUser':
        return ViewTextCell(text: item.parentUser, isDark: isDark);
      case 'mtm':
        return _buildClickableNumberCell(item.mtm, () {
          UserDetailsDialog.show(
            context,
            _createDummyUser(item),
            onEdit: (ctx) {
              ClientFormDialog.showEdit(
                context: ctx,
                userData: {'name': item.userName, 'username': item.userName},
                onComplete: () {},
              );
            },
            onAction: (ctx) {
              UpdateAccessDialog.show(
                context: ctx,
                userId: item.id,
                userName: item.userName,
                currentSettings: {},
                onUpdate: (_) => Navigator.pop(ctx),
              );
            },
          );
        }, isDark);
      case 'releasedPL':
        return _buildClickableNumberCell(item.releasedPL, () {
          UserDetailsDialog.show(
            context,
            _createDummyUser(item),
            initialTab: 'Trades',
            onEdit: (ctx) {
              ClientFormDialog.showEdit(
                context: ctx,
                userData: {'name': item.userName, 'username': item.userName},
                onComplete: () {},
              );
            },
            onAction: (ctx) {
              UpdateAccessDialog.show(
                context: ctx,
                userId: item.id,
                userName: item.userName,
                currentSettings: {},
                onUpdate: (_) => Navigator.pop(ctx),
              );
            },
          );
        }, isDark);
      case 'brokerage':
        return ViewNumberCell(
          value: item.brokerage,
          isDark: isDark,
          colorByValue: false,
        );
      case 'netPL':
        return ViewNumberCell(value: item.netPL, isDark: isDark);
      case 'credit':
        return _buildClickableNumberCell(item.credit, () {
          UserDetailsDialog.show(
            context,
            _createDummyUser(item),
            initialTab: 'Credit',
            onEdit: (ctx) {
              ClientFormDialog.showEdit(
                context: ctx,
                userData: {'name': item.userName, 'username': item.userName},
                onComplete: () {},
              );
            },
            onAction: (ctx) {
              UpdateAccessDialog.show(
                context: ctx,
                userId: item.id,
                userName: item.userName,
                currentSettings: {},
                onUpdate: (_) => Navigator.pop(ctx),
              );
            },
          );
        }, isDark);
      case 'equity':
        return ViewNumberCell(
          value: item.equity,
          isDark: isDark,
          colorByValue: false,
        );
      case 'margin':
        return ViewNumberCell(
          value: item.margin,
          isDark: isDark,
          colorByValue: false,
        );
      case 'usedMargin':
        return ViewNumberCell(
          value: item.usedMargin,
          isDark: isDark,
          colorByValue: false,
        );
      case 'freeMargin':
        return ViewNumberCell(
          value: item.freeMargin,
          isDark: isDark,
          colorByValue: false,
        );
      case 'standingVolume':
        return ViewNumberCell(
          value: item.standingVolume,
          isDark: isDark,
          colorByValue: false,
        );
      case 'marginLevelPercentage':
        return ViewNumberCell(
          value: item.marginLevelPercentage,
          isDark: isDark,
          colorByValue: false,
        );
      case 'createdBy':
        return ViewTextCell(text: item.createdBy, isDark: isDark);
      case 'createdDate':
        return ViewDateTimeCell(
          dateTime: item.createdDate,
          format: 'dd/MM/yy',
          isDark: isDark,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserWiseProfitAndLossBloc, UserWiseProfitAndLossState>(
      builder: (context, state) {
        if (state is UserWiseProfitAndLossLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is UserWiseProfitAndLossError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        if (state is! UserWiseProfitAndLossLoaded) {
          return const SizedBox.shrink();
        }
        double totalMtm = 0;
        double totalReleasedPL = 0;
        double totalBrokerage = 0;
        double totalNetPL = 0;
        double totalCredit = 0;
        double totalEquity = 0;
        double totalMargin = 0;
        double totalUsedMargin = 0;
        double totalFreeMargin = 0;
        double totalStandingVolume = 0;
        double totalMarginLevelPercentage = 0;
        for (var item in state.reports) {
          totalMtm += item.mtm;
          totalReleasedPL += item.releasedPL;
          totalBrokerage += item.brokerage;
          totalNetPL += item.netPL;
          totalCredit += item.credit;
          totalEquity += item.equity;
          totalMargin += item.margin;
          totalUsedMargin += item.usedMargin;
          totalFreeMargin += item.freeMargin;
          totalStandingVolume += item.standingVolume;
          totalMarginLevelPercentage += item.marginLevelPercentage;
        }
        return Column(
          children: [
            ViewRecordCount(count: state.reports.length),
            Flexible(
              fit: FlexFit.loose,
              child: ViewDataTable<UserWiseProfitAndLossReport>(
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
                    case 'parentUser':
                      return item.parentUser;
                    case 'mtm':
                      return item.mtm;
                    case 'releasedPL':
                      return item.releasedPL;
                    case 'brokerage':
                      return item.brokerage;
                    case 'netPL':
                      return item.netPL;
                    case 'credit':
                      return item.credit;
                    case 'equity':
                      return item.equity;
                    case 'margin':
                      return item.margin;
                    case 'usedMargin':
                      return item.usedMargin;
                    case 'freeMargin':
                      return item.freeMargin;
                    case 'standingVolume':
                      return item.standingVolume;
                    case 'marginLevelPercentage':
                      return item.marginLevelPercentage;
                    case 'createdBy':
                      return item.createdBy;
                    case 'createdDate':
                      return item.createdDate;
                    default:
                      return '';
                  }
                },
                footerBuilder: (columns) {
                  return ViewDataTableFooter(
                    columns: columns,
                    values: {
                      'userName': 'Total',
                      'mtm': totalMtm.toStringAsFixed(2),
                      'releasedPL': totalReleasedPL.toStringAsFixed(2),
                      'brokerage': totalBrokerage.toStringAsFixed(2),
                      'netPL': totalNetPL.toStringAsFixed(2),
                      'credit': totalCredit.toStringAsFixed(2),
                      'equity': totalEquity.toStringAsFixed(2),
                      'margin': totalMargin.toStringAsFixed(2),
                      'usedMargin': totalUsedMargin.toStringAsFixed(2),
                      'freeMargin': totalFreeMargin.toStringAsFixed(2),
                      'standingVolume': totalStandingVolume.toStringAsFixed(2),
                      'marginLevelPercentage': totalMarginLevelPercentage
                          .toStringAsFixed(2),
                    },
                    columnColors: {
                      'mtm': totalMtm >= 0
                          ? AppColors.buyColor
                          : AppColors.sellColor,
                      'releasedPL': totalReleasedPL >= 0
                          ? AppColors.buyColor
                          : AppColors.sellColor,
                      'netPL': totalNetPL >= 0
                          ? AppColors.buyColor
                          : AppColors.sellColor,
                      'credit': totalCredit >= 0
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
