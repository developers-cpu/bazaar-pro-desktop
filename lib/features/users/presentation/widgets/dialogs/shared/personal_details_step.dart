import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/app_dropdown.dart';
import '../../../../../auth/presentation/widget/custom_input_field.dart';
import '../../../bloc/user_form/user_form_bloc.dart';
import '../../../bloc/user_form/user_form_event.dart';
import '../../../bloc/user_form/user_form_state.dart';

class PersonalDetailsStep extends StatefulWidget {
  const PersonalDetailsStep({super.key});

  @override
  State<PersonalDetailsStep> createState() => _PersonalDetailsStepState();
}

class _PersonalDetailsStepState extends State<PersonalDetailsStep> {
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _mobileController;
  late TextEditingController _creditController;
  late TextEditingController _creditLimitController;
  late TextEditingController _remarkController;
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
    _creditController = TextEditingController(text: state.credit);
    _creditLimitController = TextEditingController(text: state.creditLimit);
    _remarkController = TextEditingController(text: state.remark);
    _allowedDeviceController = TextEditingController(text: state.allowedDevice);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _mobileController.dispose();
    _creditController.dispose();
    _creditLimitController.dispose();
    _remarkController.dispose();
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
                      height: 60.h,
                      onChanged: (v) => _updateField('name', v),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: CustomInputField(
                      controller: _usernameController,
                      hintText: 'Username',
                      height: 60.h,
                      enabled: !state.isEditMode,
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
                      height: 60.h,
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
                      height: 60.h,
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
                      height: 60.h,
                      onChanged: (v) => _updateField('mobile', v),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: CustomInputField(
                      controller: _creditController,
                      hintText: 'Credit',
                      height: 60.h,
                      keyboardType: TextInputType.number,
                      onChanged: (v) => _updateField('credit', v),
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Expanded(
                    child: AppDropdown(
                      width: 350.w,
                      height: 50.h,
                      hintText: 'Leverage',
                      value: state.leverage,
                      items: const ['1:1', '1:2', '1:5'],
                      onChanged: (v) => _updateField('leverage', v ?? ''),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: CustomInputField(
                      controller: _creditLimitController,
                      hintText: 'Credit Limit Per Client',
                      height: 60.h,
                      keyboardType: TextInputType.number,
                      onChanged: (v) => _updateField('creditLimit', v),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),

              Row(
                children: [
                  Expanded(
                    child: CustomInputField(
                      controller: _remarkController,
                      hintText: 'Remark',
                      height: 60.h,
                      onChanged: (v) => _updateField('remark', v),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: CustomInputField(
                      controller: _allowedDeviceController,
                      hintText: 'Allowed Device for login',
                      height: 60.h,
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
