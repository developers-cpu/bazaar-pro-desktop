import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/app_calendar.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../../../injection_container.dart';
import 'package:bazarpro/features/tools/domain/entities/market_timing_entity.dart';
import '../../bloc/market_timing/market_timing_bloc.dart';
import '../../bloc/market_timing/market_timing_event.dart';
import '../../bloc/market_timing/market_timing_state.dart';
class MarketTimingDialog {
  static void show(
    BuildContext context, {
    DateTime? initialDate,
    required String exchange,
  }) {
    CommonDialog.show(
      context: context,
      title: 'Market Timing',
      width: 350.w,
      showButtons: false,
      scrollable: true,
      contentPadding: EdgeInsets.zero,
      contentBuilder: (context, onClose) => BlocProvider(
        create: (context) => sl<MarketTimingBloc>(),
        child: _MarketTimingContent(
          initialDate: initialDate,
          exchange: exchange,
          onClose: onClose,
        ),
      ),
    );
  }
}
class _MarketTimingContent extends StatefulWidget {
  final DateTime? initialDate;
  final String exchange;
  final VoidCallback onClose;
  const _MarketTimingContent({
    Key? key,
    this.initialDate,
    required this.exchange,
    required this.onClose,
  }) : super(key: key);
  @override
  State<_MarketTimingContent> createState() => _MarketTimingContentState();
}
class _MarketTimingContentState extends State<_MarketTimingContent> {
  DateTime? _selectedDate;
  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
    _fetchMarketTiming();
  }
  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    _fetchMarketTiming();
  }
  void _fetchMarketTiming() {
    if (_selectedDate != null) {
      context.read<MarketTimingBloc>().add(
        GetMarketTimingEvent(exchange: widget.exchange, date: _selectedDate!),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BlocConsumer<MarketTimingBloc, MarketTimingState>(
          listener: (context, state) {},
          builder: (context, state) {
            Color Function(DateTime)? colorBuilder;
            if (state is MarketTimingLoaded) {
              colorBuilder = (date) {
                if (_selectedDate != null &&
                    date.year == _selectedDate!.year &&
                    date.month == _selectedDate!.month &&
                    date.day == _selectedDate!.day) {
                  return state.data.isOpen
                      ? AppColors.primaryBlue
                      : AppColors.red;
                }
                final isWeekend =
                    date.weekday == DateTime.sunday ||
                    date.weekday == DateTime.saturday;
                return isWeekend ? AppColors.red : AppColors.primaryBlue;
              };
            } else {
              colorBuilder = (date) {
                final isWeekend =
                    date.weekday == DateTime.sunday ||
                    date.weekday == DateTime.saturday;
                return isWeekend ? AppColors.red : AppColors.primaryBlue;
              };
            }
            return Column(
              children: [
                AppCalendar(
                  initialDate: _selectedDate ?? DateTime.now(),
                  selectedDate: _selectedDate,
                  onDateSelected: _onDateSelected,
                  selectedDayColorBuilder: colorBuilder,
                ),
                SizedBox(height: 16.h),
                if (_selectedDate != null) _buildStateFooter(state),
              ],
            );
          },
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
  Widget _buildStateFooter(MarketTimingState state) {
    if (state is MarketTimingLoading) {
      return SizedBox(height: 100.h);
    } else if (state is MarketTimingError) {
      return SizedBox(
        height: 100.h,
        child: Center(
          child: Text(state.message, style: TextStyle(color: Colors.red)),
        ),
      );
    } else if (state is MarketTimingLoaded) {
      return _buildFooterStatus(state.data);
    }
    return SizedBox(height: 100.h);
  }
  Widget _buildFooterStatus(MarketTimingEntity data) {
    final dateFormat = DateFormat('dd MMM');
    final dateStr = dateFormat.format(_selectedDate!).toUpperCase();
    final dayName = DateFormat('EEE').format(_selectedDate!).toUpperCase();
    final isOpen = data.isOpen;
    final statusText = data.status;
    final timings = data.timings;
    return Center(
      child: SizedBox(
        width: 300.w,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isOpen ? AppColors.primaryBlue : AppColors.red,
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.only(
                top: 24.h,
                bottom: 16.h,
                left: 16.w,
                right: 16.w,
              ),
              alignment: Alignment.center,
              child: !isOpen
                  ? Text(
                      statusText,
                      style: GoogleFonts.openSans(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: timings.map((timing) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 4.h),
                          child: _buildTimingRow(timing.start, timing.end),
                        );
                      }).toList(),
                    ),
            ),
            Positioned(
              top: -15.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isOpen ? AppColors.primaryBlue : AppColors.red,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Text(
                  '$dateStr $dayName',
                  style: GoogleFonts.openSans(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildTimingRow(String start, String end) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          start,
          style: GoogleFonts.openSans(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Text(
            'to',
            style: GoogleFonts.openSans(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white70,
            ),
          ),
        ),
        Text(
          end,
          style: GoogleFonts.openSans(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
