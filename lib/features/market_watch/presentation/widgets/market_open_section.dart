import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';

class MarketOpenSection extends StatelessWidget {
  const MarketOpenSection({super.key});

  static const List<String> _markets = [
    'NSE',
    'CE/PE',
    'MCX',
    'OTHER',
    'COMEX',
    'GIFT',
  ];

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 9.w,
              height: 9.h,
              decoration: const BoxDecoration(
                color: AppColors.successColor,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              'MARKET OPEN',
              style: TextStyle(
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w600,
                fontSize: 11.sp,
                color: AppColors.successColor,
                height: 1.0,
              ),
            ),
            SizedBox(width: 14.w),
            ...List.generate(_markets.length, (index) {
              final isLast = index == _markets.length - 1;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _markets[index],
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w600,
                      fontSize: 11.sp,
                      color: AppColors.primaryBlue,
                      height: 1.0,
                    ),
                  ),
                  if (!isLast) ...[
                    SizedBox(width: 6.w),
                    Text(
                      '•',
                      style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w700,
                        fontSize: 11.sp,
                        color: AppColors.greyDark,
                        height: 1.0,
                      ),
                    ),
                    SizedBox(width: 6.w),
                  ],
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
