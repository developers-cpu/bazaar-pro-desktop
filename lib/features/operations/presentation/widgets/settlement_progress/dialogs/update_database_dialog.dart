import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/common_dilog_box.dart';
import '../../../../../../core/widget/custom_action_button.dart';
import 'settlement_dialog.dart';

class UpdateDatabaseDialog {
  static void show(BuildContext context) {
    CommonDialog.show(
      context: context,
      title: 'Update Database',
      width: 1000.w,
      height: 450.h,
      showButtons: false,
      scrollable: false,
      contentPadding: EdgeInsets.zero,
      contentBuilder: (context, onClose) =>
          _UpdateDatabaseContent(onClose: onClose),
    );
  }
}

class _UpdateDatabaseContent extends StatelessWidget {
  final VoidCallback onClose;
  const _UpdateDatabaseContent({Key? key, required this.onClose})
    : super(key: key);
  final List<String> _exchanges = const [
    'MCX',
    'NSE',
    'CE/PE',
    'GIFT',
    'OTHERS',
    'CRYPTO',
    'COMEX FUTURE',
    'FOREX',
    'USSTOCK',
  ];
  void _openSettlementDialog(BuildContext context) {
    onClose();
    SettlementDialog.show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: CustomActionButton(
              text: 'Update Database',
              onPressed: () {},
              width: 160.w,
              height: 35.h,
              borderRadius: 8.r,
            ),
          ),
          SizedBox(height: 20.h),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.greyBorder),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                itemCount: _exchanges.length,
                separatorBuilder: (context, index) => Divider(
                  color: AppColors.greyBorder,
                  height: 1,
                  thickness: 1,
                ),
                itemBuilder: (context, index) {
                  final exchange = _exchanges[index];
                  return TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: const Duration(seconds: 2),
                    builder: (context, value, child) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.w,
                          vertical: 8.h,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 100.w,
                              child: Text(
                                exchange,
                                style: GoogleFonts.openSans(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                            ),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: LinearProgressIndicator(
                                  value: value,
                                  backgroundColor: AppColors.primaryBlue
                                      .withOpacity(0.2),
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                        AppColors.primaryBlue,
                                      ),
                                  minHeight: 8.h,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 100.w,
                              child: Text(
                                value == 1.0
                                    ? 'Completed'
                                    : '${(value * 100).toInt()}% Done',
                                textAlign: TextAlign.right,
                                style: GoogleFonts.openSans(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 120.w,
                height: 35.h,
                child: ElevatedButton(
                  onPressed: onClose,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    side: const BorderSide(color: AppColors.primaryBlue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.openSans(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 15.w),
              CustomActionButton(
                text: 'Settlement',
                onPressed: () => _openSettlementDialog(context),
                width: 120.w,
                height: 35.h,
                borderRadius: 8.r,
              ),
            ],
          ),
        ],
      ),
    );
  }
}