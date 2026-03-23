import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/table/view_data_table.dart';
import '../../../../../../core/widget/table/view_record_count.dart';
import '../../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../../../../../injection_container.dart';
import '../../../../domain/entities/user.dart';
import '../../../../domain/entities/user_group_settings/user_group_settings.dart';
import '../../../bloc/user_group_settings/user_group_settings_bloc.dart';

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
                child: ViewRecordCount(count: state.settings.length),
              ),
              Expanded(
                child: ViewDataTable<UserGroupSettings>(
                  autoFit: true,
                  columns: [
                    ViewTableColumn(id: 'name', label: 'Group', width: 400.w),
                    ViewTableColumn(
                      id: 'lastUpdated',
                      label: 'LAST UPDATED',
                      width: 400.w,
                    ),
                    ViewTableColumn(id: 'view', label: 'VIEW', width: 160.w),
                  ],
                  data: state.settings,
                  idExtractor: (item) => item.id,
                  comparatorBuilder: (item, columnId) {
                    switch (columnId) {
                      case 'name':
                        return item.groupName;
                      case 'lastUpdated':
                        return item.lastUpdated ?? DateTime(0);
                      default:
                        return '';
                    }
                  },
                  cellBuilder: (item, column) {
                    final isDark =
                        Theme.of(context).brightness == Brightness.dark;
                    switch (column.id) {
                      case 'name':
                        return ViewTextCell(
                          text: item.groupName,
                          color: AppColors.primaryBlue,
                          isDark: isDark,
                        );
                      case 'lastUpdated':
                        return ViewDateTimeCell(
                          dateTime: item.lastUpdated ?? DateTime.now(),
                          isDark: isDark,
                        );
                      case 'view':
                        return Center(
                          child: GestureDetector(
                            onTap: () => onViewSettings(item.groupName),
                            child: Icon(
                              Icons.remove_red_eye,
                              size: 16.sp,
                              color: AppColors.primaryBlue,
                            ),
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
