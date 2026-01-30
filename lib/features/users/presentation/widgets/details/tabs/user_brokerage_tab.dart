import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/app_dropdown.dart';
import 'package:bazarpro/features/users/domain/entities/user.dart';
import '../../common/user_reset_buttons.dart';

class UserBrokerageTab extends StatefulWidget {
  final User user;

  const UserBrokerageTab({super.key, required this.user});

  @override
  State<UserBrokerageTab> createState() => _UserBrokerageTabState();
}

class _UserBrokerageTabState extends State<UserBrokerageTab> {
  String _viewType = 'Exchange'; // Exchange or Symbol

  // Mock data for Brk
  final List<Map<String, dynamic>> _brkData = [
    {'exchange': 'NSE', 'turnover': '15000', 'symbolBrk': '15000'},
    {'exchange': 'MCX', 'turnover': '5000', 'symbolBrk': '5000'},
    {'exchange': 'OTHERS', 'turnover': '00', 'symbolBrk': '00'},
    {'exchange': 'FOREX', 'turnover': '00', 'symbolBrk': '00'},
    {'exchange': 'USSTOCKS', 'turnover': '5000', 'symbolBrk': '5000'},
    {'exchange': 'CRYPTO', 'turnover': '30003', 'symbolBrk': '30003'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildControls(),
        SizedBox(height: 8.h),
        Expanded(child: _buildTable(context)),
      ],
    );
  }

  Widget _buildControls() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildRadio('Exchange Wise', 'Exchange'),
              SizedBox(width: 16.w),
              _buildRadio('Symbol Wise', 'Symbol'),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              AppDropdown(
                hintText: 'Exchange',
                items: const ['NSE', 'MCX'],
                value: null, // Select value
                onChanged: (val) {},
                width: 150.w,
                height: 35.h,
              ),
              SizedBox(width: 8.w),

              Container(
                width: 150.w,
                height: 35.h,
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(color: AppColors.primaryBlue),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Type exchange wise brk',
                  style: GoogleFonts.openSans(
                    fontSize: 12.sp,
                    color: AppColors.textColor(context),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                width: 150.w,
                height: 35.h,
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(color: AppColors.primaryBlue),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Type symbol wise brk',
                  style: GoogleFonts.openSans(
                    fontSize: 12.sp,
                    color: AppColors.textColor(context),
                  ),
                ),
              ),

              const Spacer(),

              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                    0xFF1F4A66,
                  ), // Dark blue from image
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  minimumSize: Size(120.w, 35.h),
                ),
                child: Text(
                  'Update',
                  style: GoogleFonts.openSans(fontSize: 14.sp),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          const Align(
            alignment: Alignment.centerRight,
            child: UserRecordCountWidget(count: 12550),
          ),
        ],
      ),
    );
  }

  Widget _buildRadio(String label, String value) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: _viewType,
          onChanged: (val) {
            setState(() {
              _viewType = val!;
            });
          },
          visualDensity: VisualDensity.compact,
          activeColor: const Color(0xFF1F4A66),
        ),
        Text(
          label,
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textColor(context),
          ),
        ),
      ],
    );
  }

  Widget _buildTable(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: ListView.builder(
            itemCount: _brkData.length,
            itemBuilder: (context, index) {
              return _buildItem(context, _brkData[index], index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      color: AppColors.primaryBlue.withOpacity(0.2),
      child: Row(
        children: [
          Expanded(child: _buildHeaderText('EXCHANGE', TextAlign.center)),
          Container(width: 1, height: 20.h, color: AppColors.white),
          Expanded(
            flex: 2,
            child: _buildHeaderText(
              'TURNOVER WISE (Rs.PER1/CR)',
              TextAlign.center,
            ),
          ),
          Container(width: 1, height: 20.h, color: AppColors.white),
          Expanded(
            flex: 2,
            child: _buildHeaderText('SYMBOL WISE BRK (Rs.)', TextAlign.center),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderText(String text, TextAlign align) {
    return Text(
      text,
      textAlign: align,
      style: GoogleFonts.openSans(
        fontSize: 12.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryBlue,
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    Map<String, dynamic> item,
    int index,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.greyBorder.withOpacity(0.5)),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      child: Row(
        children: [
          SizedBox(
            width: 24.w,
            child: Checkbox(value: false, onChanged: (v) {}),
          ), // Checkbox as seen in image
          Expanded(
            child: Text(
              item['exchange']!,
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 12.sp,
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item['turnover']!,
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 12.sp,
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item['symbolBrk']!,
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 12.sp,
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
