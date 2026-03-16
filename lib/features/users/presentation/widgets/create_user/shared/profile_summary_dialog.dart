import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/custom_action_button.dart';
import '../../../bloc/user_form/user_form_bloc.dart';
import '../../../bloc/user_form/user_form_event.dart';
import '../../../bloc/user_form/user_form_state.dart';
class ProfileSummaryDialog extends StatelessWidget {
  const ProfileSummaryDialog({super.key});
  static void show(BuildContext parentContext) {
    final bloc = parentContext.read<UserFormBloc>();
    showDialog(
      context: parentContext,
      barrierDismissible: false,
      barrierColor: AppColors.black.withValues(alpha: 0.54),
      builder: (_) =>
          BlocProvider.value(value: bloc, child: const ProfileSummaryDialog()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserFormBloc, UserFormState>(
      builder: (context, state) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          backgroundColor: Colors.transparent,
          child: Container(
            width: 580.w,
            constraints: BoxConstraints(maxHeight: 600.h),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(context, state),
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 16.h,
                    ),
                    child: _buildContent(context, state),
                  ),
                ),
                _buildButtons(context, state),
              ],
            ),
          ),
        );
      },
    );
  }
  Widget _buildHeader(BuildContext context, UserFormState state) {
    final title = state.isEditMode
        ? 'Edit ${state.userType}'
        : 'Create ${state.userType}';
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.r),
        topRight: Radius.circular(16.r),
      ),
      child: Container(
        height: 45.h,
        color: AppColors.primaryBlue,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.openSans(
                  fontSize: 14.sp,
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
  Widget _buildContent(BuildContext context, UserFormState state) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryBlue, width: 1.0),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile Summary',
            style: GoogleFonts.openSans(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlue,
            ),
          ),
          SizedBox(height: 10.h),
          ..._buildSections(context, state),
        ],
      ),
    );
  }
  Widget _buildButtons(BuildContext context, UserFormState state) {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Row(
        children: [
          Expanded(
            child: CustomActionButton(
              text: 'Back',
              height: 35.h,
              borderRadius: 8.r,
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: CustomActionButton(
              text: state.isEditMode ? 'Update' : 'Create',
              height: 35.h,
              borderRadius: 8.r,
              isLoading: state.isSubmitting,
              onPressed: () {
                final bloc = context.read<UserFormBloc>();
                Navigator.pop(context);
                bloc.add(const SubmitFormEvent());
              },
            ),
          ),
        ],
      ),
    );
  }
  List<Widget> _buildSections(BuildContext context, UserFormState state) {
    final sections = <Widget>[];
    sections.add(_buildSectionTitle('Personal Details'));
    sections.add(SizedBox(height: 6.h));
    sections.add(_buildPersonalDetails(context, state));
    sections.add(SizedBox(height: 12.h));
    if (state.userType == 'Admin') {
      sections.add(_buildSectionTitle('Trigger Settings'));
      sections.add(SizedBox(height: 6.h));
      sections.add(_buildTriggerSettings(context, state));
      return sections;
    }
    if (state.userType == 'Master') {
      sections.add(_buildSectionTitle('Profit & Loss Sharing Details'));
      sections.add(SizedBox(height: 6.h));
      sections.add(_buildPnlSharing(context, state));
      sections.add(SizedBox(height: 12.h));
    }
    sections.add(_buildSectionTitle('Exchange Allowed'));
    sections.add(SizedBox(height: 6.h));
    sections.add(_buildExchangeAllowed(context, state));
    sections.add(SizedBox(height: 12.h));
    if (state.userType == 'Master') {
      sections.add(_buildSectionTitle('Exchange Setting'));
      sections.add(SizedBox(height: 6.h));
      sections.add(_buildExchangeSetting(context, state));
      sections.add(SizedBox(height: 12.h));
    }
    sections.add(_buildSectionTitle('High Low Between Trade Limit'));
    sections.add(SizedBox(height: 6.h));
    sections.add(_buildHighLowLimit(context, state));
    sections.add(SizedBox(height: 12.h));
    sections.add(_buildSectionTitle('Trigger Settings'));
    sections.add(SizedBox(height: 6.h));
    sections.add(_buildTriggerSettings(context, state));
    sections.add(SizedBox(height: 12.h));
    sections.add(_buildSectionTitle('Brokerage Settings'));
    sections.add(SizedBox(height: 6.h));
    sections.add(_buildBrokerageSettings(context, state));
    if (state.userType == 'Client') {
      sections.add(SizedBox(height: 12.h));
      sections.add(_buildSectionTitle('Broker Settings'));
      sections.add(SizedBox(height: 6.h));
      sections.add(_buildBrokerSettings(context, state));
    }
    return sections;
  }
  Widget _buildPersonalDetails(BuildContext context, UserFormState state) {
    final fields = <List<String>>[];
    if (state.userType == "Master's Client") {
      fields.add([state.selectedMaster ?? '-', '']);
    }
    fields.add([state.name, state.username]);
    fields.add([
      state.password.isNotEmpty ? '••••••••' : '-',
      state.confirmPassword.isNotEmpty ? '••••••••' : '-',
    ]);
    if (state.userType == 'Admin') {
      fields.add([
        state.mobile,
        state.allowedDevice.isNotEmpty ? state.allowedDevice : '-',
      ]);
    } else {
      fields.add([state.mobile, state.credit]);
      fields.add([state.cutOff, state.leverage ?? '-']);
      fields.add([
        state.creditLimit.isNotEmpty ? state.creditLimit : '-',
        state.remark.isNotEmpty ? state.remark : '-',
      ]);
    }
    return _buildSectionBox(
      child: Column(
        children: fields.asMap().entries.map((entry) {
          final i = entry.key;
          final pair = entry.value;
          return Padding(
            padding: EdgeInsets.only(bottom: i < fields.length - 1 ? 6.h : 0),
            child: Row(
              children: [
                Expanded(child: _buildFieldBox(context, pair[0])),
                SizedBox(width: 8.w),
                Expanded(
                  child: pair[1].isNotEmpty
                      ? _buildFieldBox(context, pair[1])
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
  Widget _buildPnlSharing(BuildContext context, UserFormState state) {
    return _buildSectionBox(
      child: Row(
        children: [
          Expanded(
            child: _buildFieldBox(
              context,
              state.plSharing.isNotEmpty ? state.plSharing : '-',
              label: 'PL Sharing',
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: _buildFieldBox(
              context,
              state.brokerageSharing.isNotEmpty ? state.brokerageSharing : '-',
              label: 'Brokerage Sharing',
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildExchangeAllowed(BuildContext context, UserFormState state) {
    return _buildSectionBox(
      child: Wrap(
        spacing: 8.w,
        runSpacing: 6.h,
        children: UserFormState.availableExchanges.map((exchange) {
          final isSelected = state.selectedExchanges.contains(exchange);
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                size: 16.sp,
                color: isSelected ? AppColors.primaryBlue : AppColors.grey,
              ),
              SizedBox(width: 4.w),
              Text(
                exchange,
                style: GoogleFonts.openSans(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor(context),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
  Widget _buildExchangeSetting(BuildContext context, UserFormState state) {
    return _buildSectionBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldBox(
            context,
            state.selectedExchangeSetting ?? '-',
            label: 'Exchange',
          ),
          SizedBox(height: 6.h),
          Row(
            children: [
              Expanded(
                child: _buildFieldBox(
                  context,
                  state.squareOffTiming.isNotEmpty
                      ? state.squareOffTiming
                      : '-',
                  label: 'Square Off Timing',
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildFieldBox(
                  context,
                  state.marketOpenTimeRestriction,
                  label: 'Market Open Restriction',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildHighLowLimit(BuildContext context, UserFormState state) {
    return _buildSectionBox(
      child: Wrap(
        spacing: 8.w,
        runSpacing: 6.h,
        children: UserFormState.availableExchanges.map((exchange) {
          final isSelected = state.selectedTradeLimits.contains(exchange);
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                size: 16.sp,
                color: isSelected ? AppColors.primaryBlue : AppColors.grey,
              ),
              SizedBox(width: 4.w),
              Text(
                exchange,
                style: GoogleFonts.openSans(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor(context),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
  Widget _buildTriggerSettings(BuildContext context, UserFormState state) {
    final settings = UserFormState.getTriggerSettings(state.userType);
    return _buildSectionBox(
      child: Wrap(
        spacing: 12.w,
        runSpacing: 8.h,
        children: settings.map((setting) {
          final isEnabled = state.triggerSettings[setting.key] ?? false;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isEnabled ? Icons.toggle_on : Icons.toggle_off,
                size: 22.sp,
                color: isEnabled ? AppColors.primaryBlue : AppColors.grey,
              ),
              SizedBox(width: 4.w),
              Text(
                setting.label,
                style: GoogleFonts.openSans(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor(context),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
  Widget _buildBrokerageSettings(BuildContext context, UserFormState state) {
    return _buildSectionBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                state.brokerageViewMode == 'Exchange Wise'
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                size: 16.sp,
                color: AppColors.primaryBlue,
              ),
              SizedBox(width: 4.w),
              Text(
                'Exchange Wise',
                style: GoogleFonts.openSans(
                  fontSize: 11.sp,
                  color: AppColors.textColor(context),
                ),
              ),
              SizedBox(width: 16.w),
              Icon(
                state.brokerageViewMode == 'Symbol Wise'
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                size: 16.sp,
                color: AppColors.primaryBlue,
              ),
              SizedBox(width: 4.w),
              Text(
                'Symbol Wise',
                style: GoogleFonts.openSans(
                  fontSize: 11.sp,
                  color: AppColors.textColor(context),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          if (state.brokerageData.isNotEmpty)
            ...state.brokerageData.entries.map((entry) {
              return Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Row(
                  children: [
                    SizedBox(
                      width: 80.w,
                      child: Text(
                        entry.key,
                        style: GoogleFonts.openSans(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor(context),
                        ),
                      ),
                    ),
                    Expanded(
                      child: _buildFieldBox(
                        context,
                        entry.value.turnoverWise.isNotEmpty
                            ? entry.value.turnoverWise
                            : '-',
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: _buildFieldBox(
                        context,
                        entry.value.symbolWiseBrk.isNotEmpty
                            ? entry.value.symbolWiseBrk
                            : '-',
                      ),
                    ),
                  ],
                ),
              );
            }),
          if (state.brokerageData.isEmpty)
            Text(
              'No brokerage data configured',
              style: GoogleFonts.openSans(
                fontSize: 11.sp,
                color: AppColors.grey,
              ),
            ),
        ],
      ),
    );
  }
  Widget _buildBrokerSettings(BuildContext context, UserFormState state) {
    return _buildSectionBox(
      child: Text(
        'Broker settings configured',
        style: GoogleFonts.openSans(
          fontSize: 11.sp,
          color: AppColors.textColor(context),
        ),
      ),
    );
  }
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.openSans(
        fontSize: 13.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryBlue,
      ),
    );
  }
  Widget _buildSectionBox({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryBlue, width: 1.0),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: child,
    );
  }
  Widget _buildFieldBox(BuildContext context, String text, {String? label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label,
            style: GoogleFonts.openSans(
              fontSize: 9.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.grey,
            ),
          ),
          SizedBox(height: 2.h),
        ],
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.grey.withOpacity(0.5),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            text.isNotEmpty ? text : '-',
            style: GoogleFonts.openSans(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryBlue,
            ),
          ),
        ),
      ],
    );
  }
}
