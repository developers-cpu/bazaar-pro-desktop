import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bazarpro/core/constants/app_colors.dart';
import 'package:bazarpro/core/widget/common_dilog_box.dart';
import 'package:bazarpro/features/users/domain/entities/user.dart';
import 'package:bazarpro/core/widget/custom_input_field.dart';

class UserExchangeWisePositionLimitDialog extends StatelessWidget {
  final User user;
  const UserExchangeWisePositionLimitDialog({super.key, required this.user});
  static void show(BuildContext context, User user) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => UserExchangeWisePositionLimitDialog(user: user),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: 'Exchange Wise Position Limit',
      width: 500.w,
      showButtons: false,
      content: const UserExchangeWisePositionLimitDialogContent(),
    );
  }
}

class UserExchangeWisePositionLimitDialogContent extends StatefulWidget {
  const UserExchangeWisePositionLimitDialogContent({super.key});
  @override
  State<UserExchangeWisePositionLimitDialogContent> createState() =>
      _UserExchangeWisePositionLimitDialogContentState();
}

class _UserExchangeWisePositionLimitDialogContentState
    extends State<UserExchangeWisePositionLimitDialogContent> {
  final List<String> exchanges = [
    'MCX',
    'NSE',
    'CE/PE',
    'OTHER',
    'COMEX',
    'FOREX',
    'USSTOCK',
    'GIFY',
    'CRYPTO',
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      shrinkWrap: true,
      itemCount: exchanges.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 2.8,
      ),
      itemBuilder: (context, index) {
        final exchange = exchanges[index];
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.primaryBlue, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                exchange,
                style: GoogleFonts.openSans(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue,
                ),
              ),
              SizedBox(height: 4.h),
              CustomInputField(
                hintText: 'Type here',
                height: 35.h,
                width: double.infinity,
                onChanged: (val) {},
              ),
            ],
          ),
        );
      },
    );
  }
}
