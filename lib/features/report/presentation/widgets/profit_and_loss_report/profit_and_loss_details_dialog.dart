import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_data_table_footer.dart';
import '../../../../../core/widget/table/view_record_count.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../../domain/entities/profit_and_loss_report.dart';
import '../../../../users/domain/entities/user.dart';
import '../../../../users/presentation/widgets/user_details/user_details_dialog.dart';
import '../../../../users/presentation/widgets/create_user/master_form_dialog.dart';
import '../../../../users/presentation/widgets/create_user/client_form_dialog.dart';
import '../../../../users/presentation/widgets/create_user/update_access_dialog.dart';

class ProfitAndLossDetailsDialog extends StatelessWidget {
  final List<ProfitAndLossReport> reports;
  final String userName;
  final int level;
  const ProfitAndLossDetailsDialog({
    super.key,
    required this.reports,
    required this.userName,
    this.level = 1,
  });
  static void show(
    BuildContext context,
    List<ProfitAndLossReport> reports,
    String userName, {
    int level = 1,
  }) {
    showDialog(
      context: context,
      barrierColor: AppColors.black.withValues(alpha: 0.54),
      builder: (_) => ProfitAndLossDetailsDialog(
        reports: reports,
        userName: userName,
        level: level,
      ),
    );
  }

  List<ViewTableColumn> _getColumns() {
    return const [
      ViewTableColumn(id: 'view', label: 'VIEW', width: 120),
      ViewTableColumn(id: 'userName', label: 'U. NAME', width: 120),
      ViewTableColumn(id: 'percentage', label: '%', width: 80),
      ViewTableColumn(id: 'releasePL', label: 'RELEASE P/L', width: 120),
      ViewTableColumn(id: 'brokerage', label: 'BRK', width: 100),
      ViewTableColumn(id: 'm2m', label: 'M2M', width: 100),
      ViewTableColumn(id: 'netPL', label: 'NET P/L', width: 120),
      ViewTableColumn(id: 'ourBrokerage', label: 'OUR BRK', width: 120),
      ViewTableColumn(id: 'ourPercentage', label: 'OUR', width: 120),
    ];
  }

  Widget _buildCell(
    BuildContext context,
    ProfitAndLossReport item,
    ViewTableColumn column,
    bool isDark,
    int index,
  ) {
    switch (column.id) {
      case 'view':
        final showViewIcon = index % 2 == 0;
        if (!showViewIcon) {
          return const SizedBox.shrink();
        }
        return IconButton(
          icon: Icon(
            Icons.picture_in_picture_alt,
            size: 16.sp,
            color: const Color(0xFF1F4A66),
          ),
          onPressed: () {
            ProfitAndLossDetailsDialog.show(
              context,
              [item, item],
              item.userName,
              level: level + 1,
            );
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
        return ViewTextCell(
          text: item.percentage.toStringAsFixed(2),
          isDark: isDark,
        );
      case 'releasePL':
        return ViewTextCell(
          text: item.releasePL.toStringAsFixed(2),
          isDark: isDark,
          color: item.releasePL >= 0 ? Colors.blue : Colors.red,
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
    double totalReleasePL = 0;
    double totalBrokerage = 0;
    double totalM2M = 0;
    double totalNetPL = 0;
    double totalOurBrokerage = 0;
    double totalOurPercentage = 0;
    for (var item in reports) {
      totalReleasePL += item.releasePL;
      totalBrokerage += item.brokerage;
      totalM2M += item.m2m;
      totalNetPL += item.netPL;
      totalOurBrokerage += item.ourBrokerage;
      totalOurPercentage += item.ourPercentage;
    }
    final double dialogWidth = (1000 - ((level - 1) * 40)).w;
    final double dialogHeight = (600 - ((level - 1) * 30)).h;
    return CommonDialog(
      title: 'Profit & Loss',
      width: dialogWidth,
      height: dialogHeight,
      showButtons: false,
      scrollable: false,
      contentPadding: EdgeInsets.zero,
      content: Container(
        padding: EdgeInsets.all(10.w),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 8.h),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back,
                      color: const Color(0xFF1F4A66),
                      size: 18.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    userName,
                    style: GoogleFonts.openSans(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F4A66),
                    ),
                  ),
                ],
              ),
            ),
            ViewRecordCount(count: reports.length),
            Flexible(
              fit: FlexFit.loose,
              child: ViewDataTable<ProfitAndLossReport>(
                columns: _getColumns(),
                data: reports,
                idExtractor: (item) => item.id,
                autoFit: true,
                comparatorBuilder: (item, columnId) {
                  switch (columnId) {
                    case 'userName': return item.userName;
                    case 'percentage': return item.percentage;
                    case 'releasePL': return item.releasePL;
                    case 'brokerage': return item.brokerage;
                    case 'm2m': return item.m2m;
                    case 'netPL': return item.netPL;
                    case 'ourBrokerage': return item.ourBrokerage;
                    case 'ourPercentage': return item.ourPercentage;
                    default: return '';
                  }
                },
                emptyMessage: 'No records found',
                cellBuilder: (item, column) {
                  final index = reports.indexOf(item);
                  return _buildCell(context, item, column, false, index);
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
