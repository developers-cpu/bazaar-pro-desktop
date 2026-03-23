import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bazarpro/core/constants/app_colors.dart';
import 'package:bazarpro/core/widget/app_switch.dart';
import 'package:bazarpro/core/widget/common_dilog_box.dart';
import 'package:bazarpro/injection_container.dart';
import 'package:bazarpro/features/users/domain/entities/user.dart';
import 'package:bazarpro/features/users/presentation/bloc/user_intraday/user_intraday_bloc.dart';
import 'package:bazarpro/features/users/presentation/bloc/user_intraday/user_intraday_event.dart';
import 'package:bazarpro/features/users/presentation/bloc/user_intraday/user_intraday_state.dart';

class UserIntradaySquareOffDialog {
  static void show(BuildContext context, User user) {
    CommonDialog.show(
      context: context,
      title: 'Intraday Square off',
      width: 400.w,
      showButtons: false,
      contentBuilder: (context, onClose) => BlocProvider(
        create: (context) =>
            sl<UserIntradayBloc>()..add(LoadUserIntradaySettings(user.id)),
        child: const _UserIntradaySquareOffContent(),
      ),
    );
  }
}

class _UserIntradaySquareOffContent extends StatelessWidget {
  const _UserIntradaySquareOffContent({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserIntradayBloc, UserIntradayState>(
      builder: (context, state) {
        if (state is UserIntradayLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is UserIntradayError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        if (state is UserIntradayLoaded) {
          final settings = state.settings;
          return ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            shrinkWrap: true,
            itemCount: settings.length,
            separatorBuilder: (context, index) => SizedBox(height: 8.h),
            itemBuilder: (context, index) {
              final setting = settings[index];
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.primaryBlue, width: 1.5),
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
    );
  }
}
