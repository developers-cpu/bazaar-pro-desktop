import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';

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
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        width: 350.w,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0052FF),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              widget.subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 16.sp,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
