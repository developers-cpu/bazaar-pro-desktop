import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../domain/entities/user.dart';

/// Edit User Dialog - Opens when clicking edit icon in user list
/// Pre-fills form with user data for editing
class EditUserDialog extends StatefulWidget {
  final User user;
  final VoidCallback? onUserUpdated;

  const EditUserDialog({super.key, required this.user, this.onUserUpdated});

  /// Show the edit user dialog
  static void show({
    required BuildContext context,
    required User user,
    VoidCallback? onUserUpdated,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColors.black.withValues(alpha: 0.54),
      builder: (_) => EditUserDialog(user: user, onUserUpdated: onUserUpdated),
    );
  }

  @override
  State<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  int _currentStep = 0;
  final int _totalSteps = 4;

  final List<String> _stepTitles = [
    'Personal Details',
    'Credit & Leverage',
    'P/L Settings',
    'Confirmation',
  ];

  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _mobileController;
  late TextEditingController _creditController;
  late TextEditingController _creditLimitController;
  late TextEditingController _remarkController;
  late TextEditingController _plSharingController;
  late TextEditingController _brokerageSharingController;

  String? _selectedLeverage;

  @override
  void initState() {
    super.initState();
    // Pre-fill with user data
    _nameController = TextEditingController(text: widget.user.name);
    _usernameController = TextEditingController(text: widget.user.userName);
    _mobileController = TextEditingController();
    _creditController = TextEditingController(
      text: widget.user.credit.toStringAsFixed(0),
    );
    _creditLimitController = TextEditingController();
    _remarkController = TextEditingController();
    _plSharingController = TextEditingController(
      text: widget.user.plPercent.toStringAsFixed(0),
    );
    _brokerageSharingController = TextEditingController(
      text: widget.user.brkPercent.toStringAsFixed(0),
    );
    _selectedLeverage = widget.user.leverage;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _mobileController.dispose();
    _creditController.dispose();
    _creditLimitController.dispose();
    _remarkController.dispose();
    _plSharingController.dispose();
    _brokerageSharingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      backgroundColor: Colors.transparent,
      child: Container(
        width: 600.w,
        constraints: BoxConstraints(maxHeight: 550.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            _buildStepIndicator(),
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: _buildStepContent(),
              ),
            ),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.r),
        topRight: Radius.circular(16.r),
      ),
      child: Container(
        height: 50.h,
        color: AppColors.primaryBlue,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Edit ${widget.user.type} - ${widget.user.userName}',
                style: GoogleFonts.openSans(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
                overflow: TextOverflow.ellipsis,
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

  Widget _buildStepIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      child: Row(
        children: List.generate(_totalSteps, (index) {
          bool isCompleted = index < _currentStep;
          bool isCurrent = index == _currentStep;

          return Expanded(
            child: Row(
              children: [
                if (isCurrent)
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Text(
                        _stepTitles[index],
                        style: GoogleFonts.openSans(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  )
                else
                  Container(
                    width: 14.w,
                    height: 14.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? AppColors.primaryBlue
                          : AppColors.grey.withValues(alpha: 0.5),
                    ),
                  ),
                if (index < _totalSteps - 1)
                  Expanded(
                    child: Container(
                      height: 2.h,
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      color: index < _currentStep
                          ? AppColors.primaryBlue
                          : AppColors.grey.withValues(alpha: 0.3),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildPersonalDetailsStep();
      case 1:
        return _buildCreditLeverageStep();
      case 2:
        return _buildPLSettingsStep();
      case 3:
        return _buildConfirmationStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPersonalDetailsStep() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildTextField('Name', _nameController)),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildTextField(
                'Username',
                _usernameController,
                enabled: false,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(child: _buildTextField('Mobile No', _mobileController)),
            SizedBox(width: 16.w),
            Expanded(child: _buildTextField('Remark', _remarkController)),
          ],
        ),
      ],
    );
  }

  Widget _buildCreditLeverageStep() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildTextField('Credit', _creditController)),
            SizedBox(width: 16.w),
            Expanded(child: _buildLeverageDropdown()),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                'Credit Limit Per Client',
                _creditLimitController,
              ),
            ),
            SizedBox(width: 16.w),
            const Expanded(child: SizedBox()),
          ],
        ),
      ],
    );
  }

  Widget _buildPLSettingsStep() {
    return Row(
      children: [
        Expanded(
          child: _buildFieldWithHelper(
            'P/L Sharing (%)',
            _plSharingController,
            'Our:60 | Downline: 20 |Upline: 20',
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildFieldWithHelper(
            'Brokerage Sharing (%)',
            _brokerageSharingController,
            'Our:60 | Downline: 20 |Upline: 20',
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmationStep() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Confirm Changes',
            style: GoogleFonts.openSans(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlue,
            ),
          ),
          SizedBox(height: 16.h),
          _buildConfirmRow('Name', _nameController.text),
          _buildConfirmRow('Username', _usernameController.text),
          _buildConfirmRow('Credit', _creditController.text),
          _buildConfirmRow('Leverage', _selectedLeverage ?? ''),
          _buildConfirmRow('P/L Sharing', '${_plSharingController.text}%'),
          _buildConfirmRow(
            'Brokerage Sharing',
            '${_brokerageSharingController.text}%',
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.openSans(
                fontSize: 12.sp,
                color: AppColors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: GoogleFonts.openSans(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool enabled = true,
  }) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(8.r),
        color: enabled ? null : AppColors.grey.withValues(alpha: 0.1),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(fontSize: 14.sp, color: AppColors.primaryBlue),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildLeverageDropdown() {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: _selectedLeverage,
          hint: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              'Leverage',
              style: TextStyle(fontSize: 14.sp, color: AppColors.primaryBlue),
            ),
          ),
          items: ['1:1', '1:2', '1:5', '1:10', '1:20', '1:50', '1:100'].map((
            e,
          ) {
            return DropdownMenuItem(
              value: e,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(e),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedLeverage = value;
            });
          },
          icon: Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: Icon(Icons.keyboard_arrow_down, size: 20.sp),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldWithHelper(
    String label,
    TextEditingController controller,
    String helperText,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 48.h,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderColor),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: label,
              hintStyle: TextStyle(
                fontSize: 14.sp,
                color: AppColors.primaryBlue,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
              border: InputBorder.none,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          helperText,
          style: TextStyle(fontSize: 12.sp, color: AppColors.primaryBlue),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: SizedBox(
                height: 44.h,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentStep--;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Back',
                    style: GoogleFonts.openSans(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            )
          else
            const Spacer(),
          SizedBox(width: 16.w),
          Expanded(
            child: SizedBox(
              height: 44.h,
              child: ElevatedButton(
                onPressed: () {
                  if (_currentStep < _totalSteps - 1) {
                    setState(() {
                      _currentStep++;
                    });
                  } else {
                    // Submit changes
                    Navigator.pop(context);
                    widget.onUserUpdated?.call();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  _currentStep < _totalSteps - 1 ? 'Next' : 'Save Changes',
                  style: GoogleFonts.openSans(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
