import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import 'package:bazarpro/features/users/domain/entities/user.dart';
import '../../common/user_record_count.dart';
import '../../common/user_data_table.dart';

class UserGroupSettingsTab extends StatelessWidget {
  final User user;
  final Function(String groupName) onViewSettings;

  const UserGroupSettingsTab({
    super.key,
    required this.user,
    required this.onViewSettings,
  });

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
          child: const UserRecordCount(count: 12550),
        ),
        Expanded(
          child: UserDataTable<Map<String, String>>(
            headerColor: AppColors.primaryBlue.withOpacity(0.2),
            columns: [
              UserTableColumn(id: 'name', label: 'Group', width: 400.w),
              UserTableColumn(id: 'date', label: 'LAST UPDATED', width: 400.w),
              UserTableColumn(id: 'view', label: 'VIEW', width: 160.w),
            ],
            data: _groups,
            idExtractor: (item) => item['name']!,
            cellBuilder: (item, column) {
              switch (column.id) {
                case 'name':
                  return Text(
                    item['name']!,
                    style: GoogleFonts.openSans(
                      fontSize: 12.sp,
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  );
                case 'date':
                  return Text(
                    item['date']!,
                    style: GoogleFonts.openSans(
                      fontSize: 12.sp,
                      color: AppColors.textColor(context),
                    ),
                    textAlign: TextAlign.center,
                  );
                case 'view':
                  return GestureDetector(
                    onTap: () => onViewSettings(item['name']!),
                    child: Icon(
                      Icons.remove_red_eye,
                      size: 16.sp,
                      color: AppColors.primaryBlue,
                    ),
                  );
                default:
                  return const SizedBox();
              }
            },
          ),
        ),
      ],
    );
  }
}
