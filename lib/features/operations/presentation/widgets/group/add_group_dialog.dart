import 'package:bazarpro/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../../../core/widget/custom_action_button.dart';
import '../../../../../core/widget/custom_input_field.dart'
    show CustomInputField;
import '../../bloc/group/group_bloc.dart';
import '../../bloc/group/group_event.dart';

class AddGroupDialog extends StatefulWidget {
  final bool isEdit;
  final String? initialExchange;
  final String? initialGroupName;
  final bool initialIsDefault;
  const AddGroupDialog({
    super.key,
    this.isEdit = false,
    this.initialExchange,
    this.initialGroupName,
    this.initialIsDefault = false,
  });
  @override
  State<AddGroupDialog> createState() => _AddGroupDialogState();
}

class _AddGroupDialogState extends State<AddGroupDialog> {
  String? _selectedExchange;
  final TextEditingController _groupNameController = TextEditingController();
  bool _isDefault = false;
  @override
  void initState() {
    super.initState();
    _selectedExchange = widget.initialExchange;
    _groupNameController.text = widget.initialGroupName ?? '';
    _isDefault = widget.initialIsDefault;
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: widget.isEdit ? 'Edit Group' : 'Add Group',
      width: 650.w,
      showButtons: false,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppDropdown(
                  hintText: 'Exchange',
                  height: 40.h,
                  items: const [
                    'MCX',
                    'NSE',
                    'CE/PE',
                    'GIFT',
                    'OTHERS',
                    'CRYPTO',
                    'COMEX',
                    'FOREX',
                    'USSTOCK',
                  ],
                  value: _selectedExchange,
                  onChanged: (val) {
                    setState(() {
                      _selectedExchange = val;
                    });
                  },
                ),
              ),
              SizedBox(width: 25.w),
              Expanded(
                child: CustomInputField(
                  hintText: 'Group Name',
                  controller: _groupNameController,
                  width: double.infinity,
                  height: 40.h,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Text(
            'Default Group',
            style: GoogleFonts.openSans(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlue,
            ),
          ),
          SizedBox(height: 5.h),
          Row(
            children: [
              Radio<bool>(
                value: true,
                groupValue: _isDefault,
                onChanged: (val) {
                  setState(() {
                    _isDefault = val!;
                  });
                },
                activeColor: AppColors.primaryBlue,
              ),
              Text(
                'Yes',
                style: GoogleFonts.openSans(
                  fontSize: 13.sp,
                  color: AppColors.primaryBlue,
                ),
              ),
              SizedBox(width: 15.w),
              Radio<bool>(
                value: false,
                groupValue: _isDefault,
                onChanged: (val) {
                  setState(() {
                    _isDefault = val!;
                  });
                },
                activeColor: AppColors.primaryBlue,
              ),
              Text(
                'No',
                style: GoogleFonts.openSans(
                  fontSize: 13.sp,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          SizedBox(height: 25.h),
          Center(
            child: CustomActionButton(
              text: widget.isEdit ? 'Update' : 'Add',
              onPressed: () {
                if (_selectedExchange != null &&
                    _groupNameController.text.isNotEmpty) {
                  context.read<GroupBloc>().add(
                    AddGroupEvent(
                      exchange: _selectedExchange!,
                      groupName: _groupNameController.text,
                      isDefault: _isDefault,
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              width: 150.w,
              height: 40.h,
              borderRadius: 8.r,
            ),
          ),
        ],
      ),
    );
  }
}
