import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/app_calendar.dart';
import '../../../../../injection_container.dart';
import 'package:bazarpro/features/tools/domain/entities/market_timing_entity.dart';
import '../../bloc/market_timing/market_timing_bloc.dart';
import '../../bloc/market_timing/market_timing_event.dart';
import '../../bloc/market_timing/market_timing_state.dart';

class MarketTimingDialog extends StatefulWidget {
  final DateTime? initialDate;
  final String exchange;
  const MarketTimingDialog({Key? key, this.initialDate, required this.exchange})
    : super(key: key);
  static Future<DateTime?> show(
    BuildContext context, {
    DateTime? initialDate,
    required String exchange,
  }) async {
    return await showDialog<DateTime>(
      context: context,
      barrierColor: AppColors.black.withOpacity(0.5),
      builder: (context) => BlocProvider(
        create: (context) => sl<MarketTimingBloc>(),
        child: MarketTimingDialog(initialDate: initialDate, exchange: exchange),
      ),
    );
  }

  @override
  State<MarketTimingDialog> createState() => _MarketTimingDialogState();
}

class _MarketTimingDialogState extends State<MarketTimingDialog> {
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
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        width: 350.w,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
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
        ),
      ),
    );
  }

  Widget _buildStateFooter(MarketTimingState state) {
    if (state is MarketTimingLoading) {
      return SizedBox(
        height: 100.h,
        child: const Center(child: CircularProgressIndicator()),
      );
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

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1F4A66),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Market Timing',
            style: GoogleFonts.openSans(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.white,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close, size: 20.sp, color: AppColors.white),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
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
