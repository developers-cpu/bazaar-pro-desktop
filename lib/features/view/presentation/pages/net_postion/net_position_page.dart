import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../bloc/net_position/net_position_bloc.dart';
import '../../bloc/net_position/net_position_event.dart';
import '../../bloc/net_position/net_position_state.dart';
import '../../widget/net_position/net_position_filter_bar.dart';
import '../../widget/net_position/net_position_table.dart';
import '../../widget/net_position/select_user_dialog.dart';
import '../../widget/net_position/used_margin_dialog.dart';
import '../../../../../../core/widget/custom_action_button.dart';

class NetPositionPage extends StatefulWidget {
  const NetPositionPage({Key? key}) : super(key: key);
  @override
  State<NetPositionPage> createState() => _NetPositionPageState();
}

class _NetPositionPageState extends State<NetPositionPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NetPositionBloc>().add(const LoadNetPositionsEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NetPositionBloc, NetPositionState>(
      listener: _handleStateChange,
      child: Container(
        color: AppColors.white,
        child: Column(
          children: [
            const NetPositionFilterBar(),
            const Expanded(child: NetPositionTable(showDeviceInfo: false)),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  void _handleStateChange(BuildContext context, NetPositionState state) {
    if (state is NetPositionExportSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.successColor,
          duration: const Duration(seconds: 2),
        ),
      );
    }
    if (state is NetPositionError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.errorColor,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(color: AppColors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CustomActionButton(
                text: 'Square Off',
                backgroundColor: const Color(0xFF224E69),
                width: 110.w,
                height: 36.h,
                borderRadius: 6.r,
                onPressed: () {
                  SelectUserDialog.show(
                    context: context,
                    actionType: 'SquareOff',
                  );
                },
              ),
              SizedBox(width: 8.w),
              CustomActionButton(
                text: 'Roll Over',
                backgroundColor: const Color(0xFF224E69),
                width: 110.w,
                height: 36.h,
                borderRadius: 6.r,
                onPressed: () {
                  SelectUserDialog.show(
                    context: context,
                    actionType: 'RollOver',
                  );
                },
              ),
            ],
          ),
          Container(
            height: 35.h,
            decoration: BoxDecoration(
              color: const Color(0xFFC6DBE8),
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: Colors.transparent),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    UsedMarginDialog.show(context: context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Center(
                      child: Text(
                        'Used Margin: 7856023',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2C5F7A),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1.w,
                  height: double.infinity,
                  color: AppColors.greyBorder,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Center(
                    child: Text(
                      'Free Margin : 1000000.00',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF2C5F7A),
                      ),
                    ),
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
