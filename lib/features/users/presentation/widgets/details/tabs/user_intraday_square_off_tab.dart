import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../users/domain/entities/user.dart';

class UserIntradaySquareOffTab extends StatefulWidget {
  final User user;

  const UserIntradaySquareOffTab({super.key, required this.user});

  @override
  State<UserIntradaySquareOffTab> createState() =>
      _UserIntradaySquareOffTabState();
}

class _UserIntradaySquareOffTabState extends State<UserIntradaySquareOffTab> {
  // Mock State
  final Map<String, bool> _toggles = {
    'MCX': true,
    'NSE': true,
    'CE/PE': true,
    'OTHER': true,
    'COMEX': true,
    'FOREX': true,
    'USSTOCK': true,
    'GIFY': true,
    'CRYPTO': true,
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          _buildToggleRow('MCX', 'NSE', 'CE/PE'),
          SizedBox(height: 16.h),
          _buildToggleRow('OTHER', 'COMEX', 'FOREX'),
          SizedBox(height: 16.h),
          _buildToggleRow('USSTOCK', 'GIFY', 'CRYPTO'),
          SizedBox(height: 32.h),
          // Add Update Button if needed, or assume auto-save.
          // Screenshot doesn't show button nearby, but usually needed.
        ],
      ),
    );
  }

  Widget _buildToggleRow(String label1, String label2, String label3) {
    return Row(
      children: [
        Expanded(child: _buildToggleCard(label1)),
        SizedBox(width: 16.w),
        Expanded(child: _buildToggleCard(label2)),
        SizedBox(width: 16.w),
        Expanded(child: _buildToggleCard(label3)),
      ],
    );
  }

  Widget _buildToggleCard(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.primaryBlue),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.openSans(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          ),
          Switch(
            value: _toggles[label] ?? false,
            activeColor: AppColors.primaryBlue,
            onChanged: (val) {
              setState(() {
                _toggles[label] = val;
              });
            },
          ),
        ],
      ),
    );
  }
}
