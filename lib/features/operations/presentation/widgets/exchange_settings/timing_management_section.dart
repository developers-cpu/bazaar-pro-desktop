import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bazarpro/core/widget/app_checkbox.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/custom_action_button.dart';
import '../../../../../core/widget/custom_input_field.dart';
import '../../../domain/entities/exchange_settings/exchange_timing_detail.dart';
import '../../bloc/exchange_settings/exchange_settings_bloc.dart';
import '../../bloc/exchange_settings/exchange_settings_event.dart';

class TimingManagementSection extends StatefulWidget {
  final String exchange;
  final List<ExchangeTimingDetail> timings;

  const TimingManagementSection({
    super.key,
    required this.exchange,
    required this.timings,
  });

  @override
  State<TimingManagementSection> createState() => _TimingManagementSectionState();
}

class _TimingManagementSectionState extends State<TimingManagementSection> {
  final List<String> _allDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  final Map<String, List<_TimingSlotController>> _dayControllers = {};
  final Map<String, _TimingSlotController> _newSlotControllers = {};

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    
    for (var list in _dayControllers.values) {
      for (var ctrl in list) ctrl.dispose();
    }
    _dayControllers.clear();
    for (var ctrl in _newSlotControllers.values) ctrl.dispose();
    _newSlotControllers.clear();

    for (var day in _allDays) {
      _dayControllers[day] = [];
      _newSlotControllers[day] = _TimingSlotController();
    }

    for (var timing in widget.timings) {
      for (var day in timing.days) {
        if (_dayControllers.containsKey(day)) {
          _dayControllers[day]!.add(_TimingSlotController(
            id: timing.id,
            startTime: timing.startTime,
            endTime: timing.endTime,
            remark: timing.remark,
          ));
        }
      }
    }
  }

  @override
  void didUpdateWidget(TimingManagementSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.timings != widget.timings) {
      _initControllers();
    }
  }

  @override
  void dispose() {
    for (var list in _dayControllers.values) {
      for (var ctrl in list) ctrl.dispose();
    }
    for (var ctrl in _newSlotControllers.values) ctrl.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        final localContext = context;
        controller.text = picked.format(localContext);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Exchange Timing - ${widget.exchange}',
          style: GoogleFonts.openSans(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlue,
          ),
        ),
        SizedBox(height: 16.h),
        ..._allDays.map((day) => _buildDaySection(day)),
      ],
    );
  }

  Widget _buildDaySection(String day) {
    final slots = _dayControllers[day] ?? [];
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppCheckbox(
                value: slots.isNotEmpty,
                label: day,
                labelFontSize: 14.sp,
                activeColor: AppColors.primaryBlue,
                onChanged: (val) {
                  
                  
                },
              ),
              const Expanded(child: Divider(indent: 16)),
            ],
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.only(left: 30.w),
            child: Column(
              children: [
                ...slots.map((slot) => _buildSlotItem(day, slot)),
                _buildNewSlotItem(day),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlotItem(String day, _TimingSlotController slot) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildField(
            label: 'Start Time',
            child: CustomInputField(
              controller: slot.startTimeCtrl,
              hintText: '00:00 AM',
              readOnly: true,
              suffixIcon: Icons.access_time,
              onTap: () => _selectTime(context, slot.startTimeCtrl),
              height: 38.h,
              width: 120.w,
            ),
          ),
          SizedBox(width: 16.w),
          _buildField(
            label: 'End Time',
            child: CustomInputField(
              controller: slot.endTimeCtrl,
              hintText: '00:00 PM',
              readOnly: true,
              suffixIcon: Icons.access_time,
              onTap: () => _selectTime(context, slot.endTimeCtrl),
              height: 38.h,
              width: 120.w,
            ),
          ),
          SizedBox(width: 16.w),
          _buildField(
            label: 'Remark',
            child: CustomInputField(
              controller: slot.remarkCtrl,
              hintText: 'Remark',
              height: 38.h,
              width: 200.w,
            ),
          ),
          SizedBox(width: 16.w),
          CustomActionButton(
            text: 'Update',
            onPressed: () {
              context.read<ExchangeSettingsBloc>().add(
                UpdateExchangeTimingEvent(
                  timing: ExchangeTimingDetail(
                    id: slot.id!,
                    days: [day],
                    startTime: slot.startTimeCtrl.text,
                    endTime: slot.endTimeCtrl.text,
                    remark: slot.remarkCtrl.text,
                    exchange: widget.exchange,
                  ),
                ),
              );
            },
            height: 38.h,
            width: 90.w,
            borderRadius: 8.r,
          ),
          SizedBox(width: 8.w),
          CustomActionButton(
            text: 'Delete',
            backgroundColor: AppColors.red,
            onPressed: () {
              context.read<ExchangeSettingsBloc>().add(
                DeleteExchangeTimingEvent(
                  id: slot.id!,
                  exchange: widget.exchange,
                ),
              );
            },
            height: 38.h,
            width: 90.w,
            borderRadius: 8.r,
          ),
        ],
      ),
    );
  }

  Widget _buildNewSlotItem(String day) {
    final ctrl = _newSlotControllers[day]!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildField(
          label: 'Start Time',
          child: CustomInputField(
            controller: ctrl.startTimeCtrl,
            hintText: '00:00 AM',
            readOnly: true,
            suffixIcon: Icons.access_time,
            onTap: () => _selectTime(context, ctrl.startTimeCtrl),
            height: 38.h,
            width: 120.w,
          ),
        ),
        SizedBox(width: 16.w),
        _buildField(
          label: 'End Time',
          child: CustomInputField(
            controller: ctrl.endTimeCtrl,
            hintText: '00:00 PM',
            readOnly: true,
            suffixIcon: Icons.access_time,
            onTap: () => _selectTime(context, ctrl.endTimeCtrl),
            height: 38.h,
            width: 120.w,
          ),
        ),
        SizedBox(width: 16.w),
        _buildField(
          label: 'Remark',
          child: CustomInputField(
            controller: ctrl.remarkCtrl,
            hintText: 'Remark',
            height: 38.h,
            width: 200.w,
          ),
        ),
        SizedBox(width: 16.w),
        CustomActionButton(
          text: 'Add Slot',
          onPressed: () {
            if (ctrl.startTimeCtrl.text.isNotEmpty && ctrl.endTimeCtrl.text.isNotEmpty) {
              context.read<ExchangeSettingsBloc>().add(
                UpdateExchangeTimingEvent(
                  timing: ExchangeTimingDetail(
                    id: '',
                    days: [day],
                    startTime: ctrl.startTimeCtrl.text,
                    endTime: ctrl.endTimeCtrl.text,
                    remark: ctrl.remarkCtrl.text,
                    exchange: widget.exchange,
                  ),
                ),
              );
              setState(() {
                ctrl.clear();
              });
            }
          },
          height: 38.h,
          width: 120.w,
          borderRadius: 8.r,
        ),
      ],
    );
  }

  Widget _buildField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 4.h),
        child,
      ],
    );
  }
}

class _TimingSlotController {
  final String? id;
  final TextEditingController startTimeCtrl;
  final TextEditingController endTimeCtrl;
  final TextEditingController remarkCtrl;

  _TimingSlotController({
    this.id,
    String startTime = '',
    String endTime = '',
    String remark = '',
  })  : startTimeCtrl = TextEditingController(text: startTime),
        endTimeCtrl = TextEditingController(text: endTime),
        remarkCtrl = TextEditingController(text: remark);

  void clear() {
    startTimeCtrl.clear();
    endTimeCtrl.clear();
    remarkCtrl.clear();
  }

  void dispose() {
    startTimeCtrl.dispose();
    endTimeCtrl.dispose();
    remarkCtrl.dispose();
  }
}
