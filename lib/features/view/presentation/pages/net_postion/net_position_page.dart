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
import '../../widget/net_position/square_off_dialog.dart';
import '../../widget/net_position/roll_over_dialog.dart';
import '../../widget/net_position/used_margin_dialog.dart';
import '../../../../../../core/widget/custom_action_button.dart';
import '../../../../../../core/widget/table/success_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_state.dart';

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
      final authState = context.read<AuthBloc>().state;
      final isClient =
          authState is AuthAuthenticated &&
          authState.user.role.toLowerCase() == 'client';
      context.read<NetPositionBloc>().add(
        LoadNetPositionsEvent(isClient: isClient),
      );
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
            const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: NetPositionTable(
                  showDeviceInfo: false,
                  isStart: true,
                  autoFit: false,
                  isBorderFit: true,
                ),
              ),
            ),
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
    final authState = context.read<AuthBloc>().state;
    final isClient =
        authState is AuthAuthenticated &&
        authState.user.role.toLowerCase() == 'client';
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
                borderRadius: 8.r,
                onPressed: () {
                  if (isClient) {
                    SquareOffDialog.show(context: context);
                  } else {
                    SelectUserDialog.show(
                      context: context,
                      actionType: 'SquareOff',
                    );
                  }
                },
              ),
              SizedBox(width: 8.w),
              CustomActionButton(
                text: 'Roll Over',
                backgroundColor: const Color(0xFF224E69),
                width: 110.w,
                height: 36.h,
                borderRadius: 8.r,
                onPressed: () {
                  if (isClient) {
                    RollOverDialog.show(context: context);
                  } else {
                    SelectUserDialog.show(
                      context: context,
                      actionType: 'RollOver',
                    );
                  }
                },
              ),
              SizedBox(width: 8.w),
              if (isClient) ...[
                CustomActionButton(
                  text: 'Profit Position Square Off',
                  backgroundColor: AppColors.buyColor,
                  width: 170.w,
                  height: 36.h,
                  borderRadius: 8.r,
                  onPressed: () {
                    _showSquareOffConfirmation(context, 'Profit');
                  },
                ),
                SizedBox(width: 8.w),
                CustomActionButton(
                  text: 'Loss Position Square Off',
                  backgroundColor: AppColors.sellColor,
                  width: 170.w,
                  height: 36.h,
                  borderRadius: 8.r,
                  onPressed: () {
                    _showSquareOffConfirmation(context, 'Loss');
                  },
                ),
              ],
            ],
          ),
          Container(
            height: 35.h,
            decoration: BoxDecoration(
              color: const Color(0xFFC6DBE8),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Row(
              children: [
                if (isClient) ...[
                  _buildMarginItem('Credit: 7856023'),
                  _buildDivider(),
                ],
                _buildMarginItem(
                  'Used Margin: 7856023',
                  isUnderlined: true,
                  onTap: () => UsedMarginDialog.show(context: context),
                ),
                _buildDivider(),
                _buildMarginItem('Free Margin : 1000000.00'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSquareOffConfirmation(BuildContext context, String type) {
    String title = 'Square off All Positions';
    String message = 'Are You Sure you want to Square off all Positions?';
    if (type == 'Profit') {
      title = 'Square off Profit Positions';
      message = 'Are You Sure you want to Square off all Profit Positions?';
    } else if (type == 'Loss') {
      title = 'Square off Loss Positions';
      message = 'Are You Sure you want to Square off all Loss Positions?';
    }
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: AppColors.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: SizedBox(
          width: 500.w,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: GoogleFonts.openSans(
                    fontSize: 22.sp,
                    color: AppColors.primaryBlue,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  message,
                  style: GoogleFonts.openSans(
                    fontSize: 16.sp,
                    color: Colors.grey.shade500,
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40.h,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: AppColors.primaryBlue,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            'No',
                            style: GoogleFonts.openSans(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: SizedBox(
                        height: 40.h,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            Future.delayed(Duration.zero, () {
                              SuccessDialog.show(
                                context: context,
                                title: 'Successful !',
                                subtitle:
                                    'Selected Position are Successfully Squared off',
                              );
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            'Yes',
                            style: GoogleFonts.openSans(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMarginItem(
    String text, {
    bool isUnderlined = false,
    VoidCallback? onTap,
  }) {
    Widget textWidget = Text(
      text,
      style: TextStyle(
        fontSize: 12.sp,
        color: AppColors.primaryBlue,
        decoration: TextDecoration.none,
      ),
    );
    if (isUnderlined) {
      textWidget = Container(
        padding: const EdgeInsets.only(bottom: 2),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.primaryBlue, width: 2.0),
          ),
        ),
        child: textWidget,
      );
    }
    Widget container = Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Center(child: textWidget),
    );
    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: container);
    }
    return container;
  }

  Widget _buildDivider() {
    return Container(
      width: 1.w,
      height: double.infinity,
      color: AppColors.primaryBlue,
      margin: EdgeInsets.symmetric(vertical: 4.h),
    );
  }
}
