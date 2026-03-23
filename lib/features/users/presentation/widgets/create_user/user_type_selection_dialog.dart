import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/custom_action_button.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../auth/presentation/bloc/auth_state.dart';
import 'master_form_dialog.dart';
import 'client_form_dialog.dart';
import 'masters_client_form_dialog.dart';
import 'broker_form_dialog.dart';
import 'admin_form_dialog.dart';

class UserTypeSelectionDialog extends StatefulWidget {
  final VoidCallback? onUserCreated;
  const UserTypeSelectionDialog({super.key, this.onUserCreated});
  @override
  State<UserTypeSelectionDialog> createState() =>
      _UserTypeSelectionDialogState();
}

class _UserTypeSelectionDialogState extends State<UserTypeSelectionDialog> {
  String? _selectedUserType;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        bool isAdmin = false;
        if (authState is AuthAuthenticated) {
          isAdmin =
              authState.user.role.toLowerCase() == 'admin' ||
              authState.user.role.toLowerCase() == 'super admin';
        }
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          backgroundColor: Colors.transparent,
          child: Container(
            width: 380.w,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 32.w,
                            height: 32.w,
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlue.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              Icons.group,
                              color: Colors.amber,
                              size: 24.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            'User Type',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'Select',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: isAdmin
                            ? [
                                _buildRadioOption('Master'),
                                _buildRadioOption('Admin'),
                                _buildRadioOption("Master's Client"),
                              ]
                            : [
                                _buildRadioOption('Master'),
                                _buildRadioOption('Client'),
                                _buildRadioOption("Master's Client"),
                                _buildRadioOption('Broker'),
                              ],
                      ),
                      SizedBox(height: 20.h),
                      CustomActionButton(
                        text: 'Create',
                        width: double.infinity,
                        height: 35.h,
                        borderRadius: 8.r,
                        backgroundColor: _selectedUserType != null
                            ? AppColors.primaryBlue
                            : AppColors.grey,
                        onPressed: _selectedUserType != null
                            ? () => _onCreatePressed()
                            : () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.r),
        topRight: Radius.circular(16.r),
      ),
      child: Container(
        height: 35.h,
        color: AppColors.primaryBlue,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'User Type',
                style: TextStyle(fontSize: 16.sp, color: AppColors.white),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.close, size: 22.sp, color: AppColors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioOption(String value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedUserType = value;
        });
      },
      child: Row(
        children: [
          Container(
            width: 18.w,
            height: 18.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _selectedUserType == value
                    ? AppColors.primaryBlue
                    : AppColors.grey,
                width: 2,
              ),
            ),
            child: _selectedUserType == value
                ? Center(
                    child: Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  )
                : null,
          ),
          SizedBox(width: 6.w),
          Text(
            value,
            style: TextStyle(fontSize: 13.sp, color: AppColors.primaryBlue),
          ),
        ],
      ),
    );
  }

  void _onCreatePressed() {
    Navigator.pop(context);
    if (_selectedUserType == 'Master') {
      MasterFormDialog.showCreate(
        context: context,
        onComplete: () {
          widget.onUserCreated?.call();
        },
      );
    } else if (_selectedUserType == 'Client') {
      ClientFormDialog.showCreate(
        context: context,
        onComplete: () {
          widget.onUserCreated?.call();
        },
      );
    } else if (_selectedUserType == "Master's Client") {
      MastersClientFormDialog.showCreate(
        context: context,
        onComplete: () {
          widget.onUserCreated?.call();
        },
      );
    } else if (_selectedUserType == 'Broker') {
      BrokerFormDialog.showCreate(
        context: context,
        onComplete: () {
          widget.onUserCreated?.call();
        },
      );
    } else if (_selectedUserType == 'Admin') {
      AdminFormDialog.showCreate(
        context: context,
        onComplete: () {
          widget.onUserCreated?.call();
        },
      );
    }
  }
}
