import 'package:bazarpro/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../../../injection_container.dart';
import '../../../domain/entities/announcement_entity.dart';
import '../../bloc/announcement/announcement_bloc.dart';

class AnnouncementDialog {
  static void show(BuildContext context) {
    CommonDialog.show(
      context: context,
      title: 'Announcement',
      width: 420.w,
      height: 650.h,
      showButtons: false,
      scrollable: false,
      contentPadding: EdgeInsets.zero,
      contentBuilder: (context, onClose) => BlocProvider(
        create: (context) => sl<AnnouncementBloc>()..add(LoadAnnouncements()),
        child: _AnnouncementContent(onClose: onClose),
      ),
    );
  }
}

class _AnnouncementContent extends StatelessWidget {
  final VoidCallback onClose;
  const _AnnouncementContent({Key? key, required this.onClose})
    : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnnouncementBloc, AnnouncementState>(
      builder: (context, state) {
        if (state is AnnouncementLoading) {
          return const SizedBox.shrink();
        } else if (state is AnnouncementError) {
          return Center(child: Text(state.message));
        } else if (state is AnnouncementLoaded) {
          return _buildAnnouncementList(context, state.announcements);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildAnnouncementList(
    BuildContext context,
    List<AnnouncementEntity> announcements,
  ) {
    final groupedAnnouncements = <String, List<AnnouncementEntity>>{};
    for (var announcement in announcements) {
      final dateKey = _getDateKey(announcement.timestamp);
      if (!groupedAnnouncements.containsKey(dateKey)) {
        groupedAnnouncements[dateKey] = [];
      }
      groupedAnnouncements[dateKey]!.add(announcement);
    }
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      itemCount: groupedAnnouncements.length,
      itemBuilder: (context, index) {
        final dateKey = groupedAnnouncements.keys.elementAt(index);
        final dateAnnouncements = groupedAnnouncements[dateKey]!;
        return Column(
          children: [
            _buildDateHeader(dateKey),
            ...dateAnnouncements.map(
              (msg) => _buildAnnouncementCard(context, msg),
            ),
          ],
        );
      },
    );
  }

  String _getDateKey(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(
      timestamp.year,
      timestamp.month,
      timestamp.day,
    );
    if (messageDate == today) {
      return 'Today';
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('dd/MM/yy').format(timestamp);
    }
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

  Widget _buildAnnouncementCard(
    BuildContext context,
    AnnouncementEntity announcement,
  ) {
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
              Icon(Icons.campaign, color: AppColors.primaryBlue, size: 24.sp),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      announcement.title,
                      style: GoogleFonts.openSans(
                        fontSize: 12.sp,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      announcement.body,
                      style: GoogleFonts.openSans(
                        fontSize: 10.sp,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),
              _CopyButton(text: '${announcement.title}\n${announcement.body}'),
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
                  DateFormat('h:mm:ss a').format(announcement.timestamp),
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

class _CopyButton extends StatefulWidget {
  final String text;
  const _CopyButton({required this.text});
  @override
  State<_CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<_CopyButton> {
  bool _copied = false;
  void _onCopy() {
    Clipboard.setData(ClipboardData(text: widget.text));
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
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