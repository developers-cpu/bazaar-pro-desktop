import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widget/svg_icon.dart' show SvgIcon;
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
            child: SvgIcon(
              assetPath: AppImages.banIcon,
              isActive: true,
              size: 12.w,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w500,
                fontSize: 11.sp,
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
