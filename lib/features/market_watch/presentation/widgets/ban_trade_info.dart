import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_strings.dart';

class BanForTradeNotice extends StatelessWidget {
  final String message;

  const BanForTradeNotice({
    Key? key,
    this.message = AppStrings.banForTradeMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: AppColors.white,
      child: Row(
        children: [
          Center(
            child: SvgPicture.asset(
              AppImages.banIcon,
              width: 14.w,
              height: 14.h,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
                color: AppColors.red,
                letterSpacing: 0.15,
                height: 1.0,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}