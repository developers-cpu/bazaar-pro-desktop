import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../bloc/my_profile/my_profile_bloc.dart';
import '../../bloc/my_profile/my_profile_event.dart';
import '../../bloc/my_profile/my_profile_state.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../../../injection_container.dart';
import '../../../../users/presentation/bloc/user_form/user_form_bloc.dart';
import '../../../../users/presentation/bloc/user_form/user_form_event.dart';
import '../../../../users/presentation/bloc/user_form/user_form_state.dart';
import '../../../../users/presentation/widgets/create_user/shared/personal_details_step.dart';
import '../../../../users/presentation/widgets/create_user/master_steps/master_exchange_allow_step.dart';
import '../../../../users/presentation/widgets/create_user/shared/high_low_limit_step.dart';
import '../../../../users/presentation/widgets/create_user/shared/brokerage_setting_step.dart';
import '../../../../users/presentation/widgets/create_user/master_steps/pnl_sharing_step.dart';
import '../../../../users/presentation/widgets/create_user/master_steps/exchange_setting_step.dart';
import '../../../../users/presentation/widgets/create_user/master_steps/master_trigger_settings_step.dart';
class MyProfileDialog extends StatelessWidget {
  final Map<String, dynamic>? userData;
  final VoidCallback? onComplete;
  const MyProfileDialog({super.key, this.userData, this.onComplete});
  static void show(BuildContext context) {
    CommonDialog.show(
      context: context,
      title: 'My Profile',
      width: 650.w,
      showButtons: false,
      contentPadding: EdgeInsets.zero,
      content: MultiBlocProvider(
        providers: [
          BlocProvider<MyProfileBloc>(
            create: (_) => sl<MyProfileBloc>()..add(LoadMyProfileEvent()),
          ),
          BlocProvider<UserFormBloc>(create: (_) => sl<UserFormBloc>()),
        ],
        child: const MyProfileDialog(),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<MyProfileBloc, MyProfileState>(
      listener: (context, state) {
        if (state is MyProfileLoaded) {
          final profile = state.profile;
          final userData = {
            'userName': profile.userName,
            'name': profile.name,
            'credit': profile.credit.toString(),
            'remark': profile.remark,
            'leverage': profile.leverage,
            'creditLimit': profile.creditLimit.toString(),
            'mobile': profile.mobile,
            'plSharing': _formatSharing(profile.plSharing),
            'brokerageSharing': _formatSharing(profile.brkSharing),
            'allowedDevice': 'All',
          };
          context.read<UserFormBloc>().add(
            InitializeFormEvent(
              isEditMode: true,
              userType: 'Master',
              userData: userData,
            ),
          );
        }
      },
      child: BlocBuilder<MyProfileBloc, MyProfileState>(
        builder: (context, state) {
          if (state is MyProfileLoading) {
            return SizedBox(
              height: 400.h,
              child: const Center(child: CircularProgressIndicator()),
            );
          } else if (state is MyProfileError) {
            return SizedBox(
              height: 200.h,
              child: Center(child: Text('Error: ${state.message}')),
            );
          }
          return BlocConsumer<UserFormBloc, UserFormState>(
            listener: (context, state) {
              if (state.isSuccess) {
                Navigator.pop(context);
                onComplete?.call();
              }
              if (state.error != null) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error!)));
              }
            },
            builder: (context, state) {
              return Container(
                height: 500.h,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionHeader('Personal Details'),
                            const PersonalDetailsStep(),
                            _buildDivider(),
                            _buildSectionHeader('P&L Sharing Details'),
                            const PnlSharingStep(),
                            _buildDivider(),
                            _buildSectionHeader('Exchange Allowed'),
                            const MasterExchangeAllowStep(),
                            _buildDivider(),
                            _buildSectionHeader('Exchange Settings'),
                            const ExchangeSettingStep(),
                            _buildDivider(),
                            _buildSectionHeader('High/Low Between Trade Limit'),
                            const HighLowLimitStep(),
                            _buildDivider(),
                            _buildSectionHeader('Trigger Settings'),
                            const MasterTriggerSettingsStep(),
                            _buildDivider(),
                            _buildSectionHeader('Brokerage Settings'),
                            const BrokerageSettingStep(showUpdateButton: false),
                            SizedBox(height: 12.h),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
  String _formatSharing(Map<String, dynamic> sharing) {
    if (sharing.containsKey('our')) {
      return sharing['our'].toString();
    }
    return sharing.toString();
  }
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, top: 4.h),
      child: Text(
        title,
        style: GoogleFonts.openSans(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryBlue,
        ),
      ),
    );
  }
  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Divider(color: Colors.grey.withOpacity(0.2), thickness: 1),
    );
  }
}
