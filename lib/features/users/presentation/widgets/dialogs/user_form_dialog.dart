import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';

/// Create/Edit User Dialog - Multi-step form for creating or editing Master/Client users
/// Shared dialog used for both Create and Edit with different title
class UserFormDialog extends StatefulWidget {
  final String userType; // Master or Client
  final bool isEditMode;
  final String? userName; // For edit mode
  final VoidCallback? onUserCreated;
  final VoidCallback? onUserUpdated;

  // Pre-filled data for edit mode
  final String? name;
  final String? mobile;
  final String? credit;
  final String? leverage;
  final String? creditLimit;
  final String? remark;
  final String? allowedDevice;
  final String? plSharing;
  final String? brokerageSharing;

  const UserFormDialog({
    super.key,
    required this.userType,
    this.isEditMode = false,
    this.userName,
    this.onUserCreated,
    this.onUserUpdated,
    this.name,
    this.mobile,
    this.credit,
    this.leverage,
    this.creditLimit,
    this.remark,
    this.allowedDevice,
    this.plSharing,
    this.brokerageSharing,
  });

  /// Show create user dialog
  static void showCreate({
    required BuildContext context,
    required String userType,
    VoidCallback? onUserCreated,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColors.black.withValues(alpha: 0.54),
      builder: (_) => UserFormDialog(
        userType: userType,
        isEditMode: false,
        onUserCreated: onUserCreated,
      ),
    );
  }

  /// Show edit user dialog
  static void showEdit({
    required BuildContext context,
    required String userType,
    required String userName,
    String? name,
    String? mobile,
    String? credit,
    String? leverage,
    String? creditLimit,
    String? remark,
    String? allowedDevice,
    String? plSharing,
    String? brokerageSharing,
    VoidCallback? onUserUpdated,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColors.black.withValues(alpha: 0.54),
      builder: (_) => UserFormDialog(
        userType: userType,
        isEditMode: true,
        userName: userName,
        name: name,
        credit: credit,
        leverage: leverage,
        plSharing: plSharing,
        brokerageSharing: brokerageSharing,
        onUserUpdated: onUserUpdated,
      ),
    );
  }

  @override
  State<UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends State<UserFormDialog> {
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

  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _mobileController;
  late TextEditingController _creditController;
  late TextEditingController _creditLimitController;
  late TextEditingController _remarkController;
  late TextEditingController _allowedDeviceController;
  late TextEditingController _plSharingController;
  late TextEditingController _brokerageSharingController;

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
  void initState() {
    super.initState();
    // Initialize controllers with pre-filled data if in edit mode
    _nameController = TextEditingController(text: widget.name ?? '');
    _usernameController = TextEditingController(text: widget.userName ?? '');
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _mobileController = TextEditingController(text: widget.mobile ?? '');
    _creditController = TextEditingController(text: widget.credit ?? '');
    _creditLimitController = TextEditingController(
      text: widget.creditLimit ?? '',
    );
    _remarkController = TextEditingController(text: widget.remark ?? '');
    _allowedDeviceController = TextEditingController(
      text: widget.allowedDevice ?? '',
    );
    _plSharingController = TextEditingController(text: widget.plSharing ?? '');
    _brokerageSharingController = TextEditingController(
      text: widget.brokerageSharing ?? '',
    );
    _selectedLeverage = widget.leverage;
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
    _plSharingController.dispose();
    _brokerageSharingController.dispose();
    super.dispose();
  }

  String get _dialogTitle {
    if (widget.isEditMode) {
      return 'Edit ${widget.userType}';
    }
    return 'Create ${widget.userType}';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      backgroundColor: Colors.transparent,
      child: Container(
        width: 750.w,
        constraints: BoxConstraints(maxHeight: 580.h),
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
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
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
        height: 55.h,
        color: AppColors.primaryBlue,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _dialogTitle,
                style: GoogleFonts.openSans(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.close, size: 24.sp, color: AppColors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_totalSteps * 2 - 1, (index) {
          // Even indices are steps, odd indices are connectors
          if (index.isEven) {
            final stepIndex = index ~/ 2;
            return _buildStepItem(stepIndex);
          } else {
            // Connector line
            final beforeStepIndex = index ~/ 2;
            return _buildConnectorLine(beforeStepIndex);
          }
        }),
      ),
    );
  }

  Widget _buildStepItem(int stepIndex) {
    final isActive = stepIndex == _currentStep;
    final isCompleted = stepIndex < _currentStep;

    if (isActive) {
      // Active step - show label
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          _stepTitles[stepIndex],
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
      );
    } else {
      // Inactive step - show dot
      return Container(
        width: 18.w,
        height: 18.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCompleted ? AppColors.primaryBlue : AppColors.primaryBlue,
        ),
      );
    }
  }

  Widget _buildConnectorLine(int beforeStepIndex) {
    final isCompleted = beforeStepIndex < _currentStep;
    return Container(
      width: 30.w,
      height: 2.h,
      color: isCompleted
          ? AppColors.primaryBlue
          : AppColors.grey.withValues(alpha: 0.3),
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
      case 3:
        return _buildTradeSettingsStep();
      case 4:
        return _buildLimitSettingsStep();
      case 5:
        return _buildConfirmationStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPersonalDetailsStep() {
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
              Expanded(child: _buildTextField('Name', _nameController)),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildTextField(
                  'Username',
                  _usernameController,
                  enabled: !widget.isEditMode,
                ),
              ),
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
                  'Confrim Password',
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
      ),
    );
  }

  Widget _buildExchangeAllowStep() {
    List<String> exchanges = _exchangeSelections.keys.toList();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryBlue, width: 1.5),
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
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
              childAspectRatio: 2.0,
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
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryBlue, width: 1.5),
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
          SizedBox(height: 6.h),
          Flexible(
            child: Container(
              height: 36.h,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryBlue, width: 1.5),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _exchangeGroups[exchange],
                  hint: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Text(
                      'Select Group',
                      style: GoogleFonts.openSans(
                        fontSize: 12.sp,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                  items: ['Group 1', 'Group 2', 'Group 3'].map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Text(e, style: TextStyle(fontSize: 12.sp)),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _exchangeGroups[exchange] = value;
                    });
                  },
                  icon: Padding(
                    padding: EdgeInsets.only(right: 6.w),
                    child: Icon(Icons.keyboard_arrow_down, size: 18.sp),
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
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryBlue, width: 1.5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
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
      ),
    );
  }

  Widget _buildTradeSettingsStep() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryBlue, width: 1.5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Text(
          'Trade Settings - Coming Soon',
          style: GoogleFonts.openSans(
            fontSize: 16.sp,
            color: AppColors.primaryBlue,
          ),
        ),
      ),
    );
  }

  Widget _buildLimitSettingsStep() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryBlue, width: 1.5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Text(
          'Limit Settings - Coming Soon',
          style: GoogleFonts.openSans(
            fontSize: 16.sp,
            color: AppColors.primaryBlue,
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmationStep() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryBlue, width: 1.5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Confirm ${widget.isEditMode ? "Changes" : "User Details"}',
            style: GoogleFonts.openSans(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlue,
            ),
          ),
          SizedBox(height: 16.h),
          _buildConfirmRow('Name', _nameController.text),
          _buildConfirmRow('Username', _usernameController.text),
          _buildConfirmRow('Mobile', _mobileController.text),
          _buildConfirmRow('Credit', _creditController.text),
          _buildConfirmRow('Leverage', _selectedLeverage ?? '-'),
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
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.openSans(
                fontSize: 13.sp,
                color: AppColors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value.isEmpty ? '-' : value,
              style: GoogleFonts.openSans(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor(context),
              ),
            ),
          ),
        ],
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
            border: Border.all(color: AppColors.primaryBlue, width: 1.5),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: TextField(
            controller: controller,
            style: GoogleFonts.openSans(fontSize: 14.sp),
            decoration: InputDecoration(
              hintText: label,
              hintStyle: GoogleFonts.openSans(
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
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            color: AppColors.primaryBlue,
          ),
        ),
      ],
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
        border: Border.all(color: AppColors.primaryBlue, width: 1.5),
        borderRadius: BorderRadius.circular(8.r),
        color: enabled ? null : AppColors.grey.withValues(alpha: 0.1),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        style: GoogleFonts.openSans(fontSize: 14.sp),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: GoogleFonts.openSans(
            fontSize: 14.sp,
            color: AppColors.primaryBlue,
          ),
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
        border: Border.all(color: AppColors.primaryBlue, width: 1.5),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextField(
        controller: controller,
        obscureText: !isVisible,
        style: GoogleFonts.openSans(fontSize: 14.sp),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: GoogleFonts.openSans(
            fontSize: 14.sp,
            color: AppColors.primaryBlue,
          ),
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
        border: Border.all(color: AppColors.primaryBlue, width: 1.5),
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
              style: GoogleFonts.openSans(
                fontSize: 14.sp,
                color: AppColors.primaryBlue,
              ),
            ),
          ),
          items: ['1:1', '1:2', '1:5', '1:10', '1:20', '1:50', '1:100']
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
          width: 22.w,
          height: 22.w,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryBlue,
            side: BorderSide(color: AppColors.primaryBlue, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: GoogleFonts.openSans(
            fontSize: 13.sp,
            color: AppColors.primaryBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
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
                    style: GoogleFonts.openSans(
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
                    // Submit
                    Navigator.pop(context);
                    if (widget.isEditMode) {
                      widget.onUserUpdated?.call();
                    } else {
                      widget.onUserCreated?.call();
                    }
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
                  style: GoogleFonts.openSans(
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
