import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';

class SuccessDialog extends StatefulWidget {
  final String title;
  final String subtitle;
  const SuccessDialog({Key? key, required this.title, required this.subtitle})
    : super(key: key);
  static void show({
    required BuildContext context,
    required String title,
    required String subtitle,
  }) {
    showDialog(
      context: context,
      barrierColor: AppColors.black.withOpacity(0.54),
      useRootNavigator: true,
      builder: (_) => SuccessDialog(title: title, subtitle: subtitle),
    );
  }

  @override
  State<SuccessDialog> createState() => _SuccessDialogState();
}

class _SuccessDialogState extends State<SuccessDialog> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const statusColor = Color(0xFF0052FF);

    return Dialog(
      alignment: Alignment.bottomRight,
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.only(right: 16.w, bottom: 12.h),
      child: Container(
        width: 260.w,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: statusColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: statusColor,
              offset: Offset(3.w, 3.h),
              blurRadius: 0,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              widget.subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 11.sp,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
