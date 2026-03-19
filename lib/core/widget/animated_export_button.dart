import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_images.dart';
import 'svg_icon.dart';

class AnimatedExportButton extends StatefulWidget {
  final VoidCallback? onExportPdf;
  final VoidCallback? onExportExcel;

  const AnimatedExportButton({
    super.key,
    this.onExportPdf,
    this.onExportExcel,
  });

  @override
  State<AnimatedExportButton> createState() => _AnimatedExportButtonState();
}

class _AnimatedExportButtonState extends State<AnimatedExportButton> {
  bool _isExportExpanded = false;

  void _toggleExportButtons() {
    setState(() {
      _isExportExpanded = !_isExportExpanded;
    });
  }

  void _closeExportButtons() {
    setState(() {
      _isExportExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: _isExportExpanded
          ? _buildExpandedExportButtons()
          : _buildCollapsedExportButton(),
    );
  }

  Widget _buildCollapsedExportButton() {
    return GestureDetector(
      onTap: _toggleExportButtons,
      child: Container(
        width: 35.w,
        height: 35.h,
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1F4A66),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Center(
          child: SvgIcon(
            assetPath: AppImages.fileExportIcon,
            isActive: true,
            size: 20.sp,
            activeColor: AppColors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedExportButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 35.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F4FA),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ExportSubButton(
                icon: AppImages.pdfIcon,
                label: 'PDF',
                onTap: () {
                  widget.onExportPdf?.call();
                  _closeExportButtons();
                },
              ),
              Container(
                width: 1.5.w,
                height: 25.h,
                margin: EdgeInsets.symmetric(horizontal: 8.w),
                color: const Color(0xFF1F4A66),
              ),
              _ExportSubButton(
                icon: AppImages.excelIcon,
                label: 'XLS',
                onTap: () {
                  widget.onExportExcel?.call();
                  _closeExportButtons();
                },
              ),
            ],
          ),
        ),
        SizedBox(width: 8.w),
        GestureDetector(
          onTap: _closeExportButtons,
          child: Container(
            width: 35.w,
            height: 35.h,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F4FA),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: Icon(
                Icons.close,
                size: 18.sp,
                color: const Color(0xFF1F4A66),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ExportSubButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback? onTap;

  const _ExportSubButton({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            icon,
            width: 18.w,
            height: 18.h,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 18.w,
                height: 18.h,
                decoration: BoxDecoration(
                  color: label == 'PDF'
                      ? const Color(0xFFFF6B6B)
                      : const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: GoogleFonts.openSans(
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
              );
            },
          ),
          SizedBox(width: 6.w),
          Text(
            label,
            style: GoogleFonts.openSans(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1F4A66),
            ),
          ),
        ],
      ),
    );
  }
}