import 'package:bazarpro/core/widget/custom_input_field.dart';
import 'package:bazarpro/features/operations/domain/entities/exchange_settings/market_timing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_images.dart';
import '../../../../../../core/widget/app_dropdown.dart';
import '../../../../../../core/widget/custom_input_field.dart';
import '../../../../../../core/widget/date_range_picker_button.dart';
import '../../../../../../core/widget/table/view_data_table.dart';
import '../../../../../../core/widget/table/view_reset_buttons.dart';
import '../manage_market_timing_dialog.dart';
import '../add_market_timing_dialog.dart';
import 'package:bazarpro/core/widget/app_switch.dart';
import '../../../../../../core/widget/custom_action_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/exchange_settings/exchange_settings_bloc.dart';
import '../../../bloc/exchange_settings/exchange_settings_event.dart';
import '../../../bloc/exchange_settings/exchange_settings_state.dart';
import 'package:intl/intl.dart';

class MarketTimingTab extends StatelessWidget {
  final List<ExchangeMarketTiming> timings;
  final TextEditingController searchCtrl;
  final ValueChanged<String> onSearchChanged;
  final Function(ExchangeMarketTiming, bool)? onStatusChanged;

  const MarketTimingTab({
    super.key,
    required this.timings,
    required this.searchCtrl,
    required this.onSearchChanged,
    this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExchangeSettingsBloc, ExchangeSettingsState>(
      builder: (context, state) {
        if (state is! ExchangeSettingsLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        
        final groupedTimings = _groupTimings(state.marketTimings);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _filterBar(context, state),
            SizedBox(height: 10.h),
            Expanded(
              child: ViewDataTable<_GroupedTiming>(
                columns: [
                  ViewTableColumn(
                    id: 'exchange',
                    label: 'EXCHANGE NAME',
                    width: 150.w,
                    alignment: Alignment.centerLeft,
                    sortable: true,
                  ),
                  ViewTableColumn(
                    id: 'date',
                    label: 'CLOSE DATE',
                    width: 150.w,
                    alignment: Alignment.centerLeft,
                    sortable: true,
                  ),
                  ViewTableColumn(
                    id: 'day',
                    label: 'DAY',
                    width: 100.w,
                    alignment: Alignment.centerLeft,
                    sortable: true,
                  ),
                  ViewTableColumn(
                    id: 'timing',
                    label: 'MARKET TIMING SLOT',
                    width: 250.w,
                    alignment: Alignment.centerLeft,
                    sortable: true,
                  ),
                  ViewTableColumn(
                    id: 'status',
                    label: 'ON / OFF',
                    width: 100.w,
                    alignment: Alignment.center,
                    sortable: true,
                  ),
                ],
                data: groupedTimings,
                idExtractor: (item) => item.id,
                autoFit: true,
                cellBuilder: (item, column) {
                  switch (column.id) {
                    case 'exchange':
                      return _clickableExchange(context, item);
                    case 'date':
                      return _cellText(item.dates.join(', '));
                    case 'day':
                      return _cellText(item.days.join(', '));
                    case 'timing':
                      return _multiTimingCell(item.timings);
                    case 'status':
                      return _toggleSwitch(item.original);
                    default:
                      return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _multiTimingCell(List<String> timings) {
    return _cellText(timings.join(', '));
  }

  String _getDayName(String dateStr) {
    try {
      final parts = dateStr.split('-');
      if (parts.length != 3) return '';
      final date = DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
      return DateFormat('EEEE').format(date);
    } catch (_) {
      return '';
    }
  }

  List<_GroupedTiming> _groupTimings(List<ExchangeMarketTiming> list) {
    final Map<String, _GroupedTiming> grouped = {};
    for (var item in list) {
      
      final key = '${item.exchange}_${item.timing}';
      final dayName = _getDayName(item.date);
      
      if (grouped.containsKey(key)) {
        if (!grouped[key]!.dates.contains(item.date)) {
          grouped[key]!.dates.add(item.date);
        }
        if (!grouped[key]!.days.contains(dayName)) {
          grouped[key]!.days.add(dayName);
        }
      } else {
        grouped[key] = _GroupedTiming(
          id: item.id,
          exchange: item.exchange,
          dates: [item.date],
          days: [dayName],
          timings: [item.timing],
          original: item,
        );
      }
    }
    return grouped.values.toList();
  }

  Widget _filterBar(BuildContext context, ExchangeSettingsLoaded state) {
    return Row(
      children: [
        DateRangePickerButton(
          width: 200.w,
          selectedDateRange: state.startDate != null && state.endDate != null
              ? DateTimeRange(start: state.startDate!, end: state.endDate!)
              : null,
          onTap: () {},
          onDateRangeSelected: (range) {
            context.read<ExchangeSettingsBloc>().add(
                  UpdateMarketTimingFiltersEvent(
                    startDate: range.start,
                    endDate: range.end,
                    exchange: state.selectedExchange,
                  ),
                );
          },
        ),
        SizedBox(width: 12.w),
        AppDropdown(
          width: 150.w,
          hintText: 'Exchange',
          value: state.selectedExchange,
          items: const ['All', 'NSE', 'MCX', 'CE/PE', 'GIFT'],
          onChanged: (val) {
            context.read<ExchangeSettingsBloc>().add(
                  UpdateMarketTimingFiltersEvent(
                    startDate: state.startDate,
                    endDate: state.endDate,
                    exchange: val,
                  ),
                );
          },
        ),
        SizedBox(width: 12.w),
        const Spacer(),
        CustomActionButton(
          text: 'Add Market Timing',
          onPressed: () => AddMarketTimingDialog.show(
            context,
            initialExchange: state.selectedExchange,
          ),
          width: 160.w,
          height: 38.h,
          borderRadius: 8.r,
        ),
      ],
    );
  }

  Widget _cellText(String text) {
    return Text(
      text,
      style: GoogleFonts.openSans(
        fontSize: 12.sp,
        color: AppColors.primaryBlue,
        fontWeight: FontWeight.w600,
      ),
      textAlign: TextAlign.left,
    );
  }

  Widget _toggleSwitch(ExchangeMarketTiming item) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
        child: AppSwitch(
          value: item.isOn,
          onChanged: onStatusChanged != null 
            ? (val) => onStatusChanged!(item, val) 
            : (_) {},
        ),
      ),
    );
  }

  Widget _searchAndRecord(int recordCount) {
    return Row(
      children: [
        CustomInputField(
          hintText: 'Search',
          controller: searchCtrl,
          prefixSvgPath: AppImages.searchIcon,
          width: 200.w,
          height: 35.h,
          onChanged: onSearchChanged,
        ),
        const Spacer(),
        Text(
          'RECORD : $recordCount',
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryBlue,
          ),
        ),
      ],
    );
  }

  Widget _clickableExchange(BuildContext context, _GroupedTiming item) {
    return InkWell(
      onTap: () {
        DateTime? date;
        try {
          date = DateFormat('dd-MM-yyyy').parse(item.dates.first);
        } catch (_) {}

        final List<Map<String, String>> slots = [];
        for (var tStr in item.timings) {
          final parts = tStr.split(' - ');
          if (parts.length == 2) {
            slots.add({
              'start': parts[0],
              'end': parts[1],
              'remark': '', 
            });
          }
        }

        AddMarketTimingDialog.show(
          context,
          initialExchange: item.exchange,
          initialDate: date,
          isUpdate: true,
          initialSlots: slots,
        );
      },
      borderRadius: BorderRadius.circular(4.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
        child: Container(
          padding: EdgeInsets.only(bottom: 2.h),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColors.primaryBlue,
                width: 1.5.w,
              ),
            ),
          ),
          child: Text(
            item.exchange,
            style: GoogleFonts.openSans(
              fontSize: 12.sp,
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ),
    );
  }
}

class _GroupedTiming {
  final String id;
  final String exchange;
  final List<String> dates;
  final List<String> days;
  final List<String> timings;
  final ExchangeMarketTiming original;

  _GroupedTiming({
    required this.id,
    required this.exchange,
    required this.dates,
    required this.days,
    required this.timings,
    required this.original,
  });
}
