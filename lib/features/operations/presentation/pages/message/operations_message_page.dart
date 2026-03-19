import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/app_radio_button.dart';
import '../../../../../core/widget/custom_action_button.dart';
import '../../bloc/message/operations_message_bloc.dart';
import '../../bloc/message/operations_message_event.dart';
import '../../bloc/message/operations_message_state.dart';
import '../../widgets/message/custom_rich_text_editor.dart';
import '../../../../../core/widget/app_tab_bar.dart';

class OperationsMessagePage extends StatefulWidget {
  const OperationsMessagePage({super.key});
  @override
  State<OperationsMessagePage> createState() => _OperationsMessagePageState();
}

class _OperationsMessagePageState extends State<OperationsMessagePage> {
  final _tabs = const ['Announcement', 'Rules & Regulation', 'Messages'];
  final _announcementCtrl = TextEditingController();
  final _rulesCtrl = TextEditingController();
  final _messagesCtrl = TextEditingController();
  @override
  void dispose() {
    _announcementCtrl.dispose();
    _rulesCtrl.dispose();
    _messagesCtrl.dispose();
    super.dispose();
  }

  void _onUpdate(BuildContext context, int activeTab, String rollType) {
    String content = '';
    if (activeTab == 0) content = _announcementCtrl.text;
    if (activeTab == 1) content = _rulesCtrl.text;
    if (activeTab == 2) content = _messagesCtrl.text;
    context.read<OperationsMessageBloc>().add(UpdateMessageEvent(content));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OperationsMessageBloc, OperationsMessageState>(
      listener: (context, state) {
        if (state.status == OperationsMessageStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message ?? 'Updated successfully')),
          );
        } else if (state.status == OperationsMessageStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message ?? 'Failed to update'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final activeTab = state.activeTab;
        final rollType = state.rollType;
        final isLoading = state.status == OperationsMessageStatus.loading;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTabBar(
                tabs: _tabs,
                activeTab: activeTab,
                onTabChanged: (i) => context.read<OperationsMessageBloc>().add(
                  ChangeMessageTabEvent(i),
                ),
              ),
              SizedBox(height: 15.h),
              if (activeTab == 0)
                _buildAnnouncementTab(context, rollType, isLoading),
              if (activeTab == 1) _buildRulesTab(context, isLoading),
              if (activeTab == 2) _buildMessagesTab(context, isLoading),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnnouncementTab(
    BuildContext context,
    String rollType,
    bool isLoading,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Roll Type',
            style: GoogleFonts.openSans(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryBlue,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              _buildRadio(context, 'All', rollType),
              SizedBox(width: 8.w),
              _buildRadio(context, 'Master', rollType),
              SizedBox(width: 8.w),
              _buildRadio(context, 'Client', rollType),
              const Spacer(),
              CustomActionButton(
                text: isLoading ? 'Updating...' : 'Update',
                onPressed: isLoading
                    ? () {}
                    : () => _onUpdate(context, 0, rollType),
                width: 100.w,
                height: 35.h,
                borderRadius: 8.r,
              ),
            ],
          ),
          SizedBox(height: 15.h),
          CustomRichTextEditor(controller: _announcementCtrl, height: 160.h),
        ],
      ),
    );
  }

  Widget _buildRadio(BuildContext context, String value, String groupValue) {
    return AppRadioButton<String>(
      value: value,
      groupValue: groupValue,
      label: value,
      labelColor: AppColors.primaryBlue,
      onChanged: (val) {
        if (val != null) {
          context.read<OperationsMessageBloc>().add(ChangeRollTypeEvent(val));
        }
      },
    );
  }

  Widget _buildRulesTab(BuildContext context, bool isLoading) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            height: 35.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomActionButton(
                  text: isLoading ? 'Updating...' : 'Update',
                  onPressed: isLoading
                      ? () {}
                      : () => _onUpdate(context, 1, ''),
                  width: 100.w,
                  height: 35.h,
                  borderRadius: 8.r,
                ),
              ],
            ),
          ),
          SizedBox(height: 15.h),
          CustomRichTextEditor(controller: _rulesCtrl, height: 200.h),
        ],
      ),
    );
  }

  Widget _buildMessagesTab(BuildContext context, bool isLoading) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            height: 35.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomActionButton(
                  text: isLoading ? 'Updating...' : 'Update',
                  onPressed: isLoading
                      ? () {}
                      : () => _onUpdate(context, 2, ''),
                  width: 100.w,
                  height: 35.h,
                  borderRadius: 8.r,
                ),
              ],
            ),
          ),
          SizedBox(height: 15.h),
          CustomRichTextEditor(controller: _messagesCtrl, height: 200.h),
        ],
      ),
    );
  }
}