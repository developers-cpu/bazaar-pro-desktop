import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../../../core/widget/custom_action_button.dart';
import '../../../../../core/widget/custom_input_field.dart';
import '../../../../../core/widget/app_checkbox.dart';
import '../../../../../core/widget/app_date_picker.dart';
import '../../../../../core/widget/app_time_picker.dart';
import '../../../domain/entities/exchange_settings/exchange_holiday.dart';
import '../../../domain/entities/exchange_settings/exchange_timing_detail.dart';
import '../../bloc/exchange_settings/exchange_settings_bloc.dart';
import '../../bloc/exchange_settings/exchange_settings_event.dart';

class AddMarketTimingDialog extends StatefulWidget {
  final String? initialExchange;
  final DateTime? initialDate;
  final bool isUpdate;
  final List<Map<String, String>>? initialSlots;
  final VoidCallback? onSave;

  const AddMarketTimingDialog({
    super.key,
    this.initialExchange,
    this.initialDate,
    this.isUpdate = false,
    this.initialSlots,
    this.onSave,
  });

  static void show(
    BuildContext context, {
    String? initialExchange,
    DateTime? initialDate,
    bool isUpdate = false,
    List<Map<String, String>>? initialSlots,
    VoidCallback? onSave,
  }) {
    final bloc = context.read<ExchangeSettingsBloc>();
    CommonDialog.show(
      context: context,
      title: isUpdate ? 'Update Market Timing' : 'Add Market Timing',
      width: 600.w,
      showButtons: false,
      scrollable: true,
      contentBuilder: (context, onClose) => BlocProvider.value(
        value: bloc,
        child: AddMarketTimingDialog(
          initialExchange: initialExchange,
          initialDate: initialDate,
          isUpdate: isUpdate,
          initialSlots: initialSlots,
          onSave: () {
            onSave?.call();
            onClose();
          },
        ),
      ),
    );
  }

  @override
  State<AddMarketTimingDialog> createState() => _AddMarketTimingDialogState();
}

class _AddMarketTimingDialogState extends State<AddMarketTimingDialog> {
  String? _selectedExchange;
  DateTime? _selectedDate;
  final _holidayNameController = TextEditingController();
  bool _isWeekend = false;
  bool _isHoliday = false;
  final Set<String> _selectedDays = {};
  static const _allDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  final List<_TimingSlotController> _slots = [];

  @override
  void initState() {
    super.initState();
    _selectedExchange = widget.initialExchange == 'All' ? null : widget.initialExchange;
    _selectedDate = widget.initialDate;
    
    if (_selectedDate != null) {
      _selectedDays.add(DateFormat('EEEE').format(_selectedDate!));
    }
    
    if (widget.initialSlots != null && widget.initialSlots!.isNotEmpty) {
      for (var slotData in widget.initialSlots!) {
        final slot = _TimingSlotController();
        slot.startCtrl.text = slotData['start'] ?? '';
        slot.endCtrl.text = slotData['end'] ?? '';
        slot.remarkCtrl.text = slotData['remark'] ?? '';
        _slots.add(slot);
      }
    } else {
      // Start with one empty slot
      _slots.add(_TimingSlotController());
    }
  }

  @override
  void dispose() {
    _holidayNameController.dispose();
    for (var slot in _slots) {
      slot.dispose();
    }
    super.dispose();
  }





  void _addSlot() {
    setState(() {
      _slots.add(_TimingSlotController());
    });
  }

  void _removeSlot(int index) {
    if (_slots.length > 1) {
      setState(() {
        _slots[index].dispose();
        _slots.removeAt(index);
      });
    }
  }

  void _submit() {
    if (_selectedExchange == null || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select exchange and date')),
      );
      return;
    }

    final dateStr = DateFormat('dd-MM-yyyy').format(_selectedDate!);
    final List<String> exchangesToUpdate = _selectedExchange == 'All'
        ? const [
            'NSE',
            'MCX',
            'CE/PE',
            'GIFT',
            'OTHERS',
            'CRYPTO',
            'COMEX',
            'FOREX',
            'USSTOCK'
          ]
        : [_selectedExchange!];

    for (var exch in exchangesToUpdate) {
      if (_isHoliday) {
        String remark = _holidayNameController.text.trim();
        if (_isWeekend) {
          remark = remark.isEmpty ? 'Weekend' : '$remark (Weekend)';
        } else if (remark.isEmpty) {
          remark = 'Holiday';
        }

        context.read<ExchangeSettingsBloc>().add(UpdateExchangeHolidayEvent(
              holiday: ExchangeHoliday(
                id: widget.isUpdate ? (widget.initialSlots?.first['id'] ?? '') : '',
                date: dateStr,
                remark: remark,
                exchange: exch,
              ),
            ));
      }

      for (var slot in _slots) {
        if (slot.startCtrl.text.isNotEmpty && slot.endCtrl.text.isNotEmpty) {
          context.read<ExchangeSettingsBloc>().add(UpdateExchangeTimingEvent(
                timing: ExchangeTimingDetail(
                  id: '',
                  days: _selectedDays.isEmpty && _selectedDate != null 
                      ? [DateFormat('EEEE').format(_selectedDate!)] 
                      : _selectedDays.toList(),
                  startTime: slot.startCtrl.text,
                  endTime: slot.endCtrl.text,
                  remark: slot.remarkCtrl.text,
                  exchange: exch,
                ),
              ));
        }
      }
    }

    widget.onSave?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildField(
                label: 'Exchange',
                child: AppDropdown(
                  value: _selectedExchange,
                  hintText: 'Select Exchange',
                  items: const [
                    'All',
                    'NSE',
                    'MCX',
                    'CE/PE',
                    'GIFT',
                    'OTHERS',
                    'CRYPTO',
                    'COMEX',
                    'FOREX',
                    'USSTOCK'
                  ],
                  onChanged: (val) => setState(() => _selectedExchange = val),
                  height: 40.h,
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: AppDatePicker(
                label: 'Date',
                value: _selectedDate,
                onChanged: (val) {
                  setState(() {
                    _selectedDate = val;
                    if (val != null) {
                      _selectedDays.add(DateFormat('EEEE').format(val));
                    }
                  });
                },
                width: double.infinity,
                height: 40.h,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Text(
          'Select Days',
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryBlue,
          ),
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 12.w,
          runSpacing: 8.h,
          children: _allDays.map((day) {
            final isSelected = _selectedDays.contains(day);
            return InkWell(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedDays.remove(day);
                  } else {
                    _selectedDays.add(day);
                  }
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppCheckbox(
                    value: isSelected,
                    onChanged: (val) {
                      setState(() {
                        if (val == true) {
                          _selectedDays.add(day);
                        } else {
                          _selectedDays.remove(day);
                        }
                      });
                    },
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    day.substring(0, 3),
                    style: GoogleFonts.openSans(
                      fontSize: 12.sp,
                      color: AppColors.primaryBlue,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        if (_selectedDate != null) ...[
          SizedBox(height: 8.h),
          Text(
            'Day: ${DateFormat('EEEE').format(_selectedDate!)}',
            style: GoogleFonts.openSans(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlue,
            ),
          ),
        ],
        SizedBox(height: 16.h),
        Row(
          children: [
            AppCheckbox(
              value: _isHoliday,
              label: 'Mark as Holiday',
              onChanged: (val) => setState(() => _isHoliday = val ?? false),
            ),
            SizedBox(width: 24.w),
            AppCheckbox(
              value: _isWeekend,
              label: 'Weekend',
              onChanged: (val) => setState(() => _isWeekend = val ?? false),
            ),
          ],
        ),
        if (_isHoliday) ...[
          SizedBox(height: 20.h),
          _buildField(
            label: 'Holiday Name',
            child: CustomInputField(
              controller: _holidayNameController,
              hintText: 'Enter holiday name',
              height: 40.h,
            ),
          ),
        ],
        SizedBox(height: 24.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Timing Slots',
              style: GoogleFonts.openSans(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlue,
              ),
            ),
            TextButton.icon(
              onPressed: _addSlot,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Slot'),
              style: TextButton.styleFrom(foregroundColor: AppColors.primaryBlue),
            ),
          ],
        ),
        const Divider(),
        SizedBox(height: 12.h),
        ..._slots.asMap().entries.map((entry) => _buildSlotRow(entry.key, entry.value)),
        SizedBox(height: 40.h),
        Center(
          child: CustomActionButton(
            text: 'Save',
            onPressed: _submit,
            width: 180.w,
            height: 42.h,
          ),
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
            color: AppColors.primaryBlue,
          ),
        ),
        SizedBox(height: 6.h),
        child,
      ],
    );
  }

  Widget _buildSlotRow(int index, _TimingSlotController slot) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: AppTimePicker(
              label: 'Start Time',
              value: slot.startCtrl.text,
              onChanged: (val) => setState(() => slot.startCtrl.text = val),
              height: 38.h,
              width: double.infinity,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: AppTimePicker(
              label: 'End Time',
              value: slot.endCtrl.text,
              onChanged: (val) => setState(() => slot.endCtrl.text = val),
              height: 38.h,
              width: double.infinity,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            flex: 2,
            child: _buildField(
              label: 'Remark',
              child: CustomInputField(
                controller: slot.remarkCtrl,
                hintText: 'Optional remark',
                height: 38.h,
              ),
            ),
          ),
          if (_slots.length > 1) ...[
            SizedBox(width: 8.w),
            IconButton(
              onPressed: () => _removeSlot(index),
              icon: const Icon(Icons.remove_circle_outline, color: AppColors.red),
              padding: EdgeInsets.zero,
            ),
          ],
        ],
      ),
    );
  }
}

class _TimingSlotController {
  final TextEditingController startCtrl = TextEditingController();
  final TextEditingController endCtrl = TextEditingController();
  final TextEditingController remarkCtrl = TextEditingController();

  void dispose() {
    startCtrl.dispose();
    endCtrl.dispose();
    remarkCtrl.dispose();
  }
}
