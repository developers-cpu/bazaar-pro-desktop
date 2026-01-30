import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import 'package:bazarpro/features/users/domain/entities/user.dart';
import '../../common/user_reset_buttons.dart';

class UserGroupSettingsTab extends StatelessWidget {
  final User user;

  const UserGroupSettingsTab({super.key, required this.user});

  // Mock data
  static const List<Map<String, String>> _groups = [
    {'name': 'NSE 4X', 'date': '30/10/25 05:02:07 PM'},
    {'name': 'MCX 3X', 'date': '30/10/25 05:02:07 PM'},
    {'name': 'CE/PE 3X', 'date': '30/10/25 05:02:07 PM'},
    {'name': 'OTHERS 3X', 'date': '30/10/25 05:02:07 PM'},
    {'name': 'COMEX 4X', 'date': '30/10/25 05:02:07 PM'},
    {'name': 'CRYPTO 3X', 'date': '30/10/25 05:02:07 PM'},
    {'name': 'GIFT 3X', 'date': '30/10/25 05:02:07 PM'},
    {'name': 'US-STOCK 3X', 'date': '30/10/25 05:02:07 PM'},
    {'name': 'FOREX 3X', 'date': '30/10/25 05:02:07 PM'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          color: AppColors.white,
          alignment: Alignment.centerRight,
          child: const UserRecordCountWidget(count: 12550),
        ),
        Expanded(child: _buildList(context)),
      ],
    );
  }

  Widget _buildList(BuildContext context) {
    return ListView.builder(
      itemCount: _groups.length + 1, // Header + items
      itemBuilder: (context, index) {
        if (index == 0) return _buildHeader(context);
        return _buildItem(context, _groups[index - 1], index - 1);
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      color: AppColors.primaryBlue.withOpacity(0.2),
      child: Row(
        children: [
          Expanded(child: _buildHeaderText('Group', TextAlign.center)),
          Container(width: 1, height: 20.h, color: AppColors.white),
          Expanded(child: _buildHeaderText('LAST UPDATED', TextAlign.center)),
          Container(width: 1, height: 20.h, color: AppColors.white),
          Expanded(child: _buildHeaderText('VIEW', TextAlign.center)),
        ],
      ),
    );
  }

  Widget _buildHeaderText(String text, TextAlign align) {
    return Text(
      text,
      textAlign: align,
      style: GoogleFonts.openSans(
        fontSize: 12.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryBlue,
      ),
    );
  }

  Widget _buildItem(BuildContext context, Map<String, String> item, int index) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.greyBorder.withOpacity(0.5)),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item['name']!,
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 12.sp,
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              item['date']!,
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 12.sp,
                color: AppColors.textColor(context),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Icon(
                Icons.remove_red_eye,
                size: 16.sp,
                color: AppColors.primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
