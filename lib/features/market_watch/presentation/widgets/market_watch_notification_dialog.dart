import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widget/common_dilog_box.dart';
import '../../../../injection_container.dart';
import '../bloc/notification/market_watch_notification_bloc.dart';

class MarketWatchNotificationDialog {
  static void show(BuildContext context) {
    CommonDialog.show(
      context: context,
      title: 'Notifications',
      width: 420.w,
      height: 620.h,
      showButtons: false,
      scrollable: false,
      contentPadding: EdgeInsets.zero,
      contentBuilder: (context, onClose) => BlocProvider(
        create: (_) =>
            sl<MarketWatchNotificationBloc>()
              ..add(LoadMarketWatchNotifications()),
        child: _MarketWatchNotificationContent(onClose: onClose),
      ),
    );
  }
}

class _MarketWatchNotificationContent extends StatelessWidget {
  final VoidCallback onClose;

  const _MarketWatchNotificationContent({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      MarketWatchNotificationBloc,
      MarketWatchNotificationState
    >(
      builder: (context, state) {
        if (state is MarketWatchNotificationLoading) {
          return const SizedBox.shrink();
        }
        if (state is MarketWatchNotificationError) {
          return Center(child: Text(state.message));
        }
        if (state is MarketWatchNotificationLoaded) {
          return _buildNotificationList(state.notifications);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildNotificationList(
    List<MarketWatchNotificationItem> notifications,
  ) {
    final grouped = <String, List<MarketWatchNotificationItem>>{};
    for (final item in notifications) {
      final key = _getDateKey(item.timestamp);
      grouped.putIfAbsent(key, () => []).add(item);
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final dateKey = grouped.keys.elementAt(index);
        final items = grouped[dateKey]!;
        return Column(
          children: [
            _buildDateHeader(dateKey),
            ...items.map(_buildNotificationCard),
          ],
        );
      },
    );
  }

  String _getDateKey(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final date = DateTime(timestamp.year, timestamp.month, timestamp.day);
    if (date == today) return 'Today';
    if (date == yesterday) return 'Yesterday';
    return DateFormat('dd/MM/yy').format(timestamp);
  }

  Widget _buildDateHeader(String date) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: const Color(0xFFCFDEE7),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            date,
            style: GoogleFonts.openSans(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlue,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(MarketWatchNotificationItem notification) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.notifications_active_outlined,
                color: AppColors.primaryBlue,
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: GoogleFonts.openSans(
                        fontSize: 12.sp,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      notification.body,
                      style: GoogleFonts.openSans(
                        fontSize: 10.sp,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),
              _CopyNotificationButton(
                text: '${notification.title}\n${notification.body}',
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.schedule, size: 14.sp, color: AppColors.primaryBlue),
                SizedBox(width: 4.w),
                Text(
                  DateFormat('h:mm:ss a').format(notification.timestamp),
                  style: GoogleFonts.openSans(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CopyNotificationButton extends StatefulWidget {
  final String text;

  const _CopyNotificationButton({required this.text});

  @override
  State<_CopyNotificationButton> createState() =>
      _CopyNotificationButtonState();
}

class _CopyNotificationButtonState extends State<_CopyNotificationButton> {
  bool _copied = false;

  void _onCopy() {
    Clipboard.setData(ClipboardData(text: widget.text));
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _copied = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _copied ? null : _onCopy,
      child: Icon(
        _copied ? Icons.check : Icons.copy,
        color: AppColors.primaryBlue,
        size: 18.sp,
      ),
    );
  }
}
