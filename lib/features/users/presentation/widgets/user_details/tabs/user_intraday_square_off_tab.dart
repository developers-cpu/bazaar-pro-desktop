import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/app_switch.dart';
import '../../../../../../injection_container.dart';
import '../../../../domain/entities/user.dart';
import '../../../bloc/user_intraday/user_intraday_bloc.dart';
import '../../../bloc/user_intraday/user_intraday_event.dart';
import '../../../bloc/user_intraday/user_intraday_state.dart';
class UserIntradaySquareOffTab extends StatelessWidget {
  final User user;
  const UserIntradaySquareOffTab({super.key, required this.user});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<UserIntradayBloc>()..add(LoadUserIntradaySettings(user.id)),
      child: const UserIntradaySquareOffTabView(),
    );
  }
}
class UserIntradaySquareOffTabView extends StatelessWidget {
  const UserIntradaySquareOffTabView({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: BlocBuilder<UserIntradayBloc, UserIntradayState>(
        builder: (context, state) {
          if (state is UserIntradayLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is UserIntradayError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is UserIntradayLoaded) {
            final settings = state.settings;
            return GridView.builder(
              itemCount: settings.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 5,
              ),
              itemBuilder: (context, index) {
                final setting = settings[index];
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: AppColors.primaryBlue.withOpacity(0.5),
                    ),
                  ),
                  child: AppSwitchRow(
                    label: setting.exchange,
                    value: setting.isEnabled,
                    onChanged: (val) {
                      context.read<UserIntradayBloc>().add(
                        ToggleIntradaySetting(setting.exchange, val),
                      );
                    },
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
