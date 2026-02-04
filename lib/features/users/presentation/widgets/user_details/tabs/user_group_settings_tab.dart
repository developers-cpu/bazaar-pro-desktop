import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../injection_container.dart';
import '../../../../domain/entities/user.dart';
import '../../../../domain/entities/user_group_settings/user_group_settings.dart';
import '../../../bloc/user_group_settings/user_group_settings_bloc.dart';
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
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<UserGroupSettingsBloc>()..add(LoadUserGroupSettings(user.id)),
      child: UserGroupSettingsTabView(onViewSettings: onViewSettings),
    );
  }
}
class UserGroupSettingsTabView extends StatelessWidget {
  final Function(String groupName) onViewSettings;
  const UserGroupSettingsTabView({super.key, required this.onViewSettings});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserGroupSettingsBloc, UserGroupSettingsState>(
      builder: (context, state) {
        if (state is UserGroupSettingsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is UserGroupSettingsError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        if (state is UserGroupSettingsLoaded) {
          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                color: AppColors.white,
                alignment: Alignment.centerRight,
                child: UserRecordCount(count: state.settings.length),
              ),
              Expanded(
                child: UserDataTable<UserGroupSettings>(
                  columns: [
                    UserTableColumn(id: 'name', label: 'Group', width: 400.w),
                    UserTableColumn(
                      id: 'quantity',
                      label: 'MAX QUANTITY',
                      width: 400.w,
                    ),
                    UserTableColumn(id: 'view', label: 'VIEW', width: 160.w),
                  ],
                  data: state.settings,
                  idExtractor: (item) => item.id,
                  cellBuilder: (item, column) {
                    switch (column.id) {
                      case 'name':
                        return Text(
                          item.groupName,
                          style: GoogleFonts.openSans(
                            fontSize: 12.sp,
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        );
                      case 'quantity':
                        return Text(
                          item.maxQuantity.toString(),
                          style: GoogleFonts.openSans(
                            fontSize: 12.sp,
                            color: AppColors.textColor(context),
                          ),
                          textAlign: TextAlign.center,
                        );
                      case 'view':
                        return GestureDetector(
                          onTap: () => onViewSettings(item.groupName),
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
        return const SizedBox();
      },
    );
  }
}
