import 'package:bazarpro/core/constants/app_colors.dart';
import 'package:bazarpro/features/tools/presentation/bloc/message/message_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../../../injection_container.dart';
import '../../../domain/entities/message_entity.dart';

class MessagesDialog extends StatelessWidget {
  const MessagesDialog({super.key});
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BlocProvider(
        create: (context) => sl<MessageBloc>()..add(LoadMessages()),
        child: const MessagesDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: 'Messages',
      width: 420.w,
      height: 650.h,
      showButtons: false,
      scrollable: false,
      contentPadding: EdgeInsets.zero,
      content: BlocBuilder<MessageBloc, MessageState>(
        builder: (context, state) {
          if (state is MessageLoading) {
            return const SizedBox.shrink();
          } else if (state is MessageError) {
            return Center(child: Text(state.message));
          } else if (state is MessageLoaded) {
            return _buildMessageList(state.messages);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildMessageList(List<MessageEntity> messages) {
    final groupedMessages = <String, List<MessageEntity>>{};
    for (var message in messages) {
      final dateKey = _getDateKey(message.timestamp);
      if (!groupedMessages.containsKey(dateKey)) {
        groupedMessages[dateKey] = [];
      }
      groupedMessages[dateKey]!.add(message);
    }
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      itemCount: groupedMessages.length,
      itemBuilder: (context, index) {
        final dateKey = groupedMessages.keys.elementAt(index);
        final dateMessages = groupedMessages[dateKey]!;
        return Column(
          children: [
            _buildDateHeader(dateKey),
            ...dateMessages.map((msg) => _buildMessageCard(context, msg)),
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

  Widget _buildMessageCard(BuildContext context, MessageEntity message) {
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
                      message.title,
                      style: GoogleFonts.openSans(
                        fontSize: 12.sp,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      message.body,
                      style: GoogleFonts.openSans(
                        fontSize: 10.sp,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),
              _CopyButton(text: '${message.title}\n${message.body}'),
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
                  DateFormat('h:mm:ss a').format(message.timestamp),
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
