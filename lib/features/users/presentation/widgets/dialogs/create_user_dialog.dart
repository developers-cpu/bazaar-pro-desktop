import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';

/// Create User Dialog - Multi-step form for creating Master/Client users
class CreateUserDialog extends StatefulWidget {
  final String userType;
  final VoidCallback? onUserCreated;

  const CreateUserDialog({
    super.key,
    required this.userType,
    this.onUserCreated,
  });

  @override
  State<CreateUserDialog> createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends State<CreateUserDialog> {
  int _currentStep = 0;
  final int _totalSteps = 6;

  final List<String> _stepTitles = [
    'Personal Details',
    'Exchange Allow',
    'Profit & Loss Sharing Details',
    'Trade Settings',
    'Limit Settings',
    'Confirmation',
  ];

  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _mobileController = TextEditingController();
  final _creditController = TextEditingController();
  final _creditLimitController = TextEditingController();
  final _remarkController = TextEditingController();
  final _allowedDeviceController = TextEditingController();
  final _plSharingController = TextEditingController();
  final _brokerageSharingController = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  String? _selectedLeverage;
  bool _allowAll = false;
  final Map<String, bool> _exchangeSelections = {
    'MCX': false,
    'NSE': false,
    'CE/PE': false,
    'COMEX': false,
    'FOREX': false,
    'USSTOCK': false,
    'GIFTNIFTY': false,
    'OTHERS': false,
    'CRYPTO': false,
  };
  final Map<String, String?> _exchangeGroups = {};

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
        width: 700.w,
        constraints: BoxConstraints(maxHeight: 600.h),
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
                'Create ${widget.userType}',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
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
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      child: Row(
        children: List.generate(_totalSteps, (index) {
          bool isCompleted = index < _currentStep;

          return Expanded(
            child: Row(
              children: [
                if (index == _currentStep)
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
                        style: TextStyle(
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
        return _buildExchangeAllowStep();
      case 2:
        return _buildPnlSharingStep();
      default:
        return Center(
          child: Text(
            '${_stepTitles[_currentStep]} - Coming Soon',
            style: TextStyle(fontSize: 16.sp),
          ),
        );
    }
  }

  Widget _buildPersonalDetailsStep() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildTextField('Name', _nameController)),
            SizedBox(width: 16.w),
            Expanded(child: _buildTextField('Username', _usernameController)),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: _buildPasswordField(
                'Password',
                _passwordController,
                _passwordVisible,
                () => setState(() => _passwordVisible = !_passwordVisible),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildPasswordField(
                'Confirm Password',
                _confirmPasswordController,
                _confirmPasswordVisible,
                () => setState(
                  () => _confirmPasswordVisible = !_confirmPasswordVisible,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(child: _buildTextField('Mobile No', _mobileController)),
            SizedBox(width: 16.w),
            Expanded(child: _buildTextField('Credit', _creditController)),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(child: _buildLeverageDropdown()),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildTextField(
                'Credit Limit Per Client',
                _creditLimitController,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(child: _buildTextField('Remark', _remarkController)),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildTextField(
                'Allowed Device for login',
                _allowedDeviceController,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExchangeAllowStep() {
    List<String> exchanges = _exchangeSelections.keys.toList();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildCheckbox('Allow All', _allowAll, (value) {
                setState(() {
                  _allowAll = value ?? false;
                  _exchangeSelections.updateAll((key, val) => _allowAll);
                });
              }),
            ],
          ),
          SizedBox(height: 16.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 1.8,
            ),
            itemCount: exchanges.length,
            itemBuilder: (context, index) {
              String exchange = exchanges[index];
              return _buildExchangeItem(exchange);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExchangeItem(String exchange) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: _buildCheckbox(
              exchange,
              _exchangeSelections[exchange] ?? false,
              (value) {
                setState(() {
                  _exchangeSelections[exchange] = value ?? false;
                });
              },
            ),
          ),
          SizedBox(height: 4.h),
          Flexible(
            child: Container(
              height: 32.h,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderColor),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _exchangeGroups[exchange],
                  hint: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(
                      'Select Group',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.primaryBlue,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  items: ['Group 1', 'Group 2', 'Group 3']
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Text(e, style: TextStyle(fontSize: 11.sp)),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _exchangeGroups[exchange] = value;
                    });
                  },
                  icon: Padding(
                    padding: EdgeInsets.only(right: 4.w),
                    child: Icon(Icons.keyboard_arrow_down, size: 16.sp),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPnlSharingStep() {
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

  Widget _buildTextField(String label, TextEditingController controller) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(fontSize: 14.sp, color: AppColors.primaryBlue),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    String label,
    TextEditingController controller,
    bool isVisible,
    VoidCallback toggleVisibility,
  ) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextField(
        controller: controller,
        obscureText: !isVisible,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(fontSize: 14.sp, color: AppColors.primaryBlue),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              size: 20.sp,
              color: AppColors.primaryBlue,
            ),
            onPressed: toggleVisibility,
          ),
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
          items: ['1:1', '1:5', '1:10', '1:20', '1:50', '1:100']
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(e),
                  ),
                ),
              )
              .toList(),
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

  Widget _buildCheckbox(
    String label,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 20.w,
          height: 20.w,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(fontSize: 13.sp, color: AppColors.primaryBlue),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: SizedBox(
                height: 48.h,
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
                    style: TextStyle(
                      fontSize: 16.sp,
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
              height: 48.h,
              child: ElevatedButton(
                onPressed: () {
                  if (_currentStep < _totalSteps - 1) {
                    setState(() {
                      _currentStep++;
                    });
                  } else {
                    // Submit and navigate to user list
                    Navigator.pop(context);
                    widget.onUserCreated?.call();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  _currentStep < _totalSteps - 1 ? 'Next' : 'Submit',
                  style: TextStyle(
                    fontSize: 16.sp,
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
