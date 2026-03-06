import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/common_dilog_box.dart';
import '../../../../../../core/widget/table/view_data_table.dart';
import '../../../../../../core/widget/table/success_dialog.dart';

class SettlementProgressDialog extends StatefulWidget {
  final List<String> exchanges;
  const SettlementProgressDialog({super.key, required this.exchanges});

  @override
  State<SettlementProgressDialog> createState() =>
      _SettlementProgressDialogState();
}

class _SettlementProgressDialogState extends State<SettlementProgressDialog> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop();
        SuccessDialog.show(
          context: context,
          title: 'Settlement Successfully Done',
          subtitle: 'Your Settlement is Successfully Done',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: 'Settlement',
      width: 1000.w,
      height: 450.h,
      showButtons: false,
      scrollable: false,
      contentPadding: EdgeInsets.zero,
      content: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(seconds: 2),
          builder: (context, value, child) {
            return ViewDataTable<String>(
              data: widget.exchanges,
              idExtractor: (item) => item,
              autoFit: true,
              columns: [
                ViewTableColumn(
                  id: 'checkbox',
                  label: '',
                  width: 50.w,
                  sortable: false,
                  customHeaderWidget: SizedBox(
                    height: 20.h,
                    width: 20.w,
                    child: Checkbox(
                      value: true,
                      onChanged: null,
                      activeColor: AppColors.primaryBlue,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                ),
                ViewTableColumn(
                  id: 'exch',
                  label: 'EXCH',
                  width: 150.w,
                  sortable: true,
                ),
                ViewTableColumn(
                  id: 'process',
                  label: 'Process',
                  width: 500.w,
                  sortable: true,
                ),
                ViewTableColumn(
                  id: 'status',
                  label: 'Status',
                  width: 150.w,
                  sortable: true,
                ),
              ],
                comparatorBuilder: (item, columnId) {
                  return item;
                },
              cellBuilder: (item, column) {
                switch (column.id) {
                  case 'checkbox':
                    return SizedBox(
                      height: 20.h,
                      width: 20.w,
                      child: Checkbox(
                        value: true,
                        onChanged: null,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        activeColor: AppColors.primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    );
                  case 'exch':
                    return Text(
                      item,
                      style: GoogleFonts.openSans(
                        fontSize: 12.sp,
                        color: AppColors.primaryBlue,
                      ),
                    );
                  case 'process':
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: LinearProgressIndicator(
                          value: value,
                          backgroundColor: AppColors.primaryBlue.withOpacity(
                            0.2,
                          ),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primaryBlue,
                          ),
                          minHeight: 8.h,
                        ),
                      ),
                    );
                  case 'status':
                    return Text(
                      value == 1.0
                          ? 'Completed'
                          : '${(value * 100).toInt()}% Done',
                      style: GoogleFonts.openSans(
                        fontSize: 12.sp,
                        color: AppColors.primaryBlue,
                      ),
                    );
                  default:
                    return const SizedBox.shrink();
                }
              },
            );
          },
        ),
      ),
    );
  }
}
