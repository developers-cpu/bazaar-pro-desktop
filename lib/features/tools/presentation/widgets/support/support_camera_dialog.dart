import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';



class SupportCameraDialog extends StatefulWidget {
  const SupportCameraDialog({super.key});

  
  static Future<File?> show(BuildContext context) {
    return showDialog<File?>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const SupportCameraDialog(),
    );
  }

  @override
  State<SupportCameraDialog> createState() => _SupportCameraDialogState();
}

class _SupportCameraDialogState extends State<SupportCameraDialog> {
  CameraController? _controller;
  bool _isInitializing = true;
  bool _isCapturing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() {
          _isInitializing = false;
          _errorMessage = 'No camera found on this device.';
        });
        return;
      }

      
      final camera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();

      if (!mounted) return;
      setState(() {
        _isInitializing = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isInitializing = false;
        _errorMessage = e.toString().contains('permission')
            ? 'Camera permission denied. Please allow camera access in System Settings.'
            : 'Failed to initialize camera: $e';
      });
    }
  }

  Future<void> _capturePhoto() async {
    if (_controller == null || _isCapturing) return;

    setState(() => _isCapturing = true);

    try {
      final xFile = await _controller!.takePicture();
      final file = File(xFile.path);
      if (!mounted) return;
      Navigator.of(context).pop(file);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isCapturing = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to capture photo: $e')));
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1E1E2C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: SizedBox(
        width: 520.w,
        height: 460.h,
        child: Column(
          children: [
            
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white70,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Camera',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close_rounded,
                      color: Colors.white54,
                      size: 20.sp,
                    ),
                    splashRadius: 18.r,
                  ),
                ],
              ),
            ),

            
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                clipBehavior: Clip.antiAlias,
                child: _buildPreview(),
              ),
            ),

            
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: _buildCaptureButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview() {
    if (_isInitializing) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white54),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.no_photography_rounded,
                color: Colors.white38,
                size: 48.sp,
              ),
              SizedBox(height: 12.h),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white60,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return CameraPreview(_controller!);
  }

  Widget _buildCaptureButton() {
    final enabled = !_isInitializing && _errorMessage == null && !_isCapturing;

    return GestureDetector(
      onTap: enabled ? _capturePhoto : null,
      child: Container(
        width: 56.w,
        height: 56.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white54, width: 3.w),
        ),
        padding: EdgeInsets.all(4.w),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isCapturing
                ? Colors.grey
                : enabled
                ? AppColors.primaryBlue
                : Colors.white24,
          ),
          child: _isCapturing
              ? Padding(
                  padding: EdgeInsets.all(12.w),
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.white,
                  size: 22.sp,
                ),
        ),
      ),
    );
  }
}
