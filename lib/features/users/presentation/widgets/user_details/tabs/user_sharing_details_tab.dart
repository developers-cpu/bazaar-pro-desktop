import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';

import '../../../../domain/entities/user.dart';
import '../../../../domain/entities/user_sharing_info.dart';
import '../../../bloc/user_sharing/user_sharing_bloc.dart';
import '../../../bloc/user_sharing/user_sharing_event.dart';
import '../../../bloc/user_sharing/user_sharing_state.dart';
import '../../../../../../injection_container.dart';

class UserSharingDetailsTab extends StatelessWidget {
  final User user;
  const UserSharingDetailsTab({super.key, required this.user});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<UserSharingBloc>()..add(LoadUserSharingDetails(user.id)),
      child: const UserSharingDetailsTabView(),
    );
  }
}

class UserSharingDetailsTabView extends StatelessWidget {
  const UserSharingDetailsTabView({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserSharingBloc, UserSharingState>(
      builder: (context, state) {
        if (state is UserSharingLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is UserSharingError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        if (state is UserSharingLoaded) {
          return Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildSharingCard(
                    context,
                    title: 'PL Sharing',
                    data: state.plSharing,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildSharingCard(
                    context,
                    title: 'Brokerage Sharing',
                    data: state.brokerageSharing,
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildSharingCard(
    BuildContext context, {
    required String title,
    required List<UserSharingInfo> data,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primaryBlue, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
              fontSize: 16.sp,
              fontWeight: FontWeight.normal,
              color: AppColors.primaryBlue,
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Person',
                style: GoogleFonts.openSans(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue.withOpacity(0.8),
                ),
              ),
              Text(
                'Share',
                style: GoogleFonts.openSans(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue.withOpacity(0.8),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.length,
            separatorBuilder: (context, index) => SizedBox(height: 24.h),
            itemBuilder: (context, index) {
              final info = data[index];
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    info.person,
                    style: GoogleFonts.openSans(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  Text(
                    info.share,
                    style: GoogleFonts.openSans(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
