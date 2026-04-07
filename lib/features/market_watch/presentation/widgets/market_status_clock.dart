import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';

class MarketStatusClock extends StatefulWidget {
  final double maxWidth;

  const MarketStatusClock({super.key, this.maxWidth = 270});

  @override
  State<MarketStatusClock> createState() => _MarketStatusClockState();
}

class _MarketStatusClockState extends State<MarketStatusClock> {
  late DateTime _indianNow;
  Timer? _clockTimer;

  @override
  void initState() {
    super.initState();
    _indianNow = _toIndianTime(DateTime.now());
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _indianNow = _toIndianTime(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

  DateTime _toIndianTime(DateTime source) {
    return source.toUtc().add(const Duration(hours: 5, minutes: 30));
  }

  bool get _isMarketLive {
    if (_indianNow.weekday == DateTime.saturday ||
        _indianNow.weekday == DateTime.sunday) {
      return false;
    }
    final totalMinutes = (_indianNow.hour * 60) + _indianNow.minute;
    return totalMinutes >= (9 * 60) + 15 && totalMinutes <= (15 * 60) + 30;
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _isMarketLive
        ? AppColors.successColor
        : AppColors.errorColor;
    final statusText = _isMarketLive ? 'LIVE' : 'OFFLINE';
    final dateText = DateFormat('dd MMM yyyy').format(_indianNow);
    final timeText = DateFormat('hh:mm:ss a').format(_indianNow);

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: widget.maxWidth.w),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8.w,
        runSpacing: 4.h,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10.w,
                height: 10.h,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                statusText,
                style: GoogleFonts.openSans(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ],
          ),
          _SeparatorText(),
          _InfoText(text: dateText, fontWeight: FontWeight.w600),
          _SeparatorText(),
          _InfoText(text: timeText, fontWeight: FontWeight.w600),
        ],
      ),
    );
  }
}

class _InfoText extends StatelessWidget {
  final String text;
  final FontWeight fontWeight;

  const _InfoText({required this.text, required this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.openSans(
        fontSize: 12.sp,
        fontWeight: fontWeight,
        color: AppColors.primaryBlue,
      ),
    );
  }
}

class _SeparatorText extends StatelessWidget {
  const _SeparatorText();

  @override
  Widget build(BuildContext context) {
    return Text(
      '|',
      style: GoogleFonts.openSans(
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryBlue,
      ),
    );
  }
}
