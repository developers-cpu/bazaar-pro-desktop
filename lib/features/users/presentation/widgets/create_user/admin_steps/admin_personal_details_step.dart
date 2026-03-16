import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/custom_input_field.dart';
import '../../../bloc/user_form/user_form_bloc.dart';
import '../../../bloc/user_form/user_form_event.dart';
import '../../../bloc/user_form/user_form_state.dart';

class AdminPersonalDetailsStep extends StatefulWidget {
  const AdminPersonalDetailsStep({super.key});
  @override
  State<AdminPersonalDetailsStep> createState() =>
      _AdminPersonalDetailsStepState();
}

class _AdminPersonalDetailsStepState extends State<AdminPersonalDetailsStep> {
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _mobileController;
  late TextEditingController _allowedDeviceController;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  @override
  void initState() {
    super.initState();
    final state = context.read<UserFormBloc>().state;
    _nameController = TextEditingController(text: state.name);
    _usernameController = TextEditingController(text: state.username);
    _passwordController = TextEditingController(text: state.password);
    _confirmPasswordController = TextEditingController(
      text: state.confirmPassword,
    );
    _mobileController = TextEditingController(text: state.mobile);
    _allowedDeviceController = TextEditingController(text: state.allowedDevice);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _mobileController.dispose();
    _allowedDeviceController.dispose();
    super.dispose();
  }

  void _updateField(String field, String value) {
    context.read<UserFormBloc>().add(
      UpdateFormFieldEvent(fieldName: field, value: value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserFormBloc, UserFormState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryBlue, width: 1.5),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomInputField(
                      controller: _nameController,
                      hintText: 'Name',
                      height: 35.h,
                      onChanged: (v) => _updateField('name', v),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: CustomInputField(
                      controller: _usernameController,
                      hintText: 'Username',
                      height: 35.h,
                      enabled: true,
                      onChanged: (v) => _updateField('username', v),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Expanded(
                    child: CustomInputField(
                      controller: _passwordController,
                      hintText: 'Password',
                      height: 35.h,
                      obscureText: _obscurePassword,
                      suffixIcon: _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      onSuffixIconPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                      onChanged: (v) => _updateField('password', v),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: CustomInputField(
                      controller: _confirmPasswordController,
                      hintText: 'Confirm Password',
                      height: 35.h,
                      obscureText: _obscureConfirmPassword,
                      suffixIcon: _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      onSuffixIconPressed: () {
                        setState(
                          () => _obscureConfirmPassword =
                              !_obscureConfirmPassword,
                        );
                      },
                      onChanged: (v) => _updateField('confirmPassword', v),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Expanded(
                    child: CustomInputField(
                      controller: _mobileController,
                      hintText: 'Mobile No',
                      keyboardType: TextInputType.phone,
                      height: 35.h,
                      onChanged: (v) => _updateField('mobile', v),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: CustomInputField(
                      controller: _allowedDeviceController,
                      hintText: 'Allowed Device for login',
                      height: 35.h,
                      keyboardType: TextInputType.number,
                      onChanged: (v) => _updateField('allowedDevice', v),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
