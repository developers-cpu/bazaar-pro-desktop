import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/custom_action_button.dart';
import '../../../../../core/widget/custom_input_field.dart';
import '../../../domain/entities/exchange_settings/exchange_holiday.dart';
import '../../bloc/exchange_settings/exchange_settings_bloc.dart';
import '../../bloc/exchange_settings/exchange_settings_event.dart';

class HolidayManagementSection extends StatefulWidget {
  final String exchange;
  final List<ExchangeHoliday> holidays;

  const HolidayManagementSection({
    super.key,
    required this.exchange,
    required this.holidays,
  });

  @override
  State<HolidayManagementSection> createState() => _HolidayManagementSectionState();
}

class _HolidayManagementSectionState extends State<HolidayManagementSection> {
  final Map<String, TextEditingController> _remarkControllers = {};
  final Map<String, TextEditingController> _dateControllers = {};
  
  final _newDateCtrl = TextEditingController();
  final _newRemarkCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    for (var holiday in widget.holidays) {
      _remarkControllers[holiday.id] = TextEditingController(text: holiday.remark);
      _dateControllers[holiday.id] = TextEditingController(text: holiday.date);
    }
  }

  @override
  void didUpdateWidget(HolidayManagementSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.holidays != widget.holidays) {
      _initControllers();
    }
  }

  @override
  void dispose() {
    for (var ctrl in _remarkControllers.values) {
      ctrl.dispose();
    }
    for (var ctrl in _dateControllers.values) {
      ctrl.dispose();
    }
    _newDateCtrl.dispose();
    _newRemarkCtrl.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('MM/dd/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Holiday - ${widget.exchange}',
          style: GoogleFonts.openSans(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlue,
          ),
        ),
        SizedBox(height: 16.h),
        ...widget.holidays.map((holiday) => _buildHolidayItem(holiday)),
        _buildNewHolidayItem(),
      ],
    );
  }

  Widget _buildHolidayItem(ExchangeHoliday holiday) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildField(
            label: 'Date',
            child: CustomInputField(
              controller: _dateControllers[holiday.id]!,
              hintText: 'mm/dd/yyyy',
              readOnly: true,
              suffixIcon: Icons.calendar_today,
            //  onTap: () => _selectDate(context, _dateControllers[holiday.id]!),
              height: 38.h,
              width: 150.w,
            ),
          ),
          SizedBox(width: 16.w),
          _buildField(
            label: 'Remark',
            child: CustomInputField(
              controller: _remarkControllers[holiday.id]!,
              hintText: 'Remark',
              height: 38.h,
              width: 250.w,
            ),
          ),
          SizedBox(width: 16.w),
          CustomActionButton(
            text: 'Update',
            onPressed: () {
              context.read<ExchangeSettingsBloc>().add(
                UpdateExchangeHolidayEvent(
                  holiday: ExchangeHoliday(
                    id: holiday.id,
                    date: _dateControllers[holiday.id]!.text,
                    remark: _remarkControllers[holiday.id]!.text,
                    exchange: widget.exchange,
                  ),
                ),
              );
            },
            height: 38.h,
            width: 100.w,
            borderRadius: 8.r,
          ),
          SizedBox(width: 8.w),
          IconButton(
            icon: const Icon(Icons.delete, color: AppColors.red),
            onPressed: () {
              context.read<ExchangeSettingsBloc>().add(
                DeleteExchangeHolidayEvent(
                  id: holiday.id,
                  exchange: widget.exchange,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNewHolidayItem() {
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildField(
            label: 'Date',
            child: CustomInputField(
              controller: _newDateCtrl,
              hintText: 'mm/dd/yyyy',
              readOnly: true,
              suffixIcon: Icons.calendar_today,
            //  onTap: () => _selectDate(context, _newDateCtrl),
              height: 38.h,
              width: 150.w,
            ),
          ),
          SizedBox(width: 16.w),
          _buildField(
            label: 'Remark',
            child: CustomInputField(
              controller: _newRemarkCtrl,
              hintText: 'Remark',
              height: 38.h,
              width: 250.w,
            ),
          ),
          SizedBox(width: 16.w),
          CustomActionButton(
            text: 'Submit',
            onPressed: () {
              if (_newDateCtrl.text.isNotEmpty && _newRemarkCtrl.text.isNotEmpty) {
                context.read<ExchangeSettingsBloc>().add(
                  UpdateExchangeHolidayEvent(
                    holiday: ExchangeHoliday(
                      id: '', // New holiday
                      date: _newDateCtrl.text,
                      remark: _newRemarkCtrl.text,
                      exchange: widget.exchange,
                    ),
                  ),
                );
                _newDateCtrl.clear();
                _newRemarkCtrl.clear();
              }
            },
            height: 38.h,
            width: 100.w,
            borderRadius: 8.r,
          ),
          SizedBox(width: 8.w),
          const SizedBox(width: 48), // Spacer for align
        ],
      ),
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
