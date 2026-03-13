import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import 'package:intl/intl.dart';
import '../../bloc/manual_trade/manual_trade_bloc.dart';
import '../../bloc/manual_trade/manual_trade_event.dart';
import '../../bloc/manual_trade/manual_trade_state.dart';

class ConfirmOrderDialog {
  static void show(BuildContext context, ManualTradeState data, bool isBuy) {
    final manualTradeBloc = context.read<ManualTradeBloc>();
    CommonDialog.show(
      context: context,
      title: 'Confirm Order',
      showButtons: true,
      buttonHeight: 35.h,
      buttonWidth: 140.w,
      cancelText: 'No',
      saveText: 'Yes',
      onSave: () {
        manualTradeBloc.add(const ConfirmManualTradeEvent());
      },
      content: BlocProvider.value(
        value: manualTradeBloc,
        child: _ConfirmOrderContent(data: data, isBuy: isBuy),
      ),
    );
  }
}

class _ConfirmOrderContent extends StatelessWidget {
  final ManualTradeState data;
  final bool isBuy;
  const _ConfirmOrderContent({
    Key? key,
    required this.data,
    required this.isBuy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Are You Sure you want to ${isBuy ? "Buy" : "Sell"} this Order ?',
          textAlign: TextAlign.center,
          style: GoogleFonts.openSans(
            fontSize: 14.sp,
            color: AppColors.primaryBlue,
          ),
        ),
        SizedBox(height: 5.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width: 1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            children: [
              _buildInfoRow('Client', data.selectedUser ?? ''),
              _buildInfoRow('Exchange', data.selectedExchange ?? ''),
              _buildInfoRow('Symbol', data.selectedSymbol ?? ''),
              _buildInfoRow('Qty', data.qty),
              _buildInfoRow('Lot', '${data.lot} Lot.'),
              _buildInfoRow('Price', data.price),
              _buildInfoRow(
                'Is Brk Calculated or Not',
                data.isBrkCalculated ? 'Allowed' : 'Not Allowed',
              ),
              _buildInfoRow(
                'Date',
                data.selectedDate != null
                    ? DateFormat('dd/MM/yy').format(data.selectedDate!)
                    : '',
              ),
              _buildInfoRow(
                'Time',
                data.selectedTime != null
                    ? data.selectedTime!.format(context)
                    : '',
              ),
              _buildInfoRow(
                'Trade Display for',
                data.selectedTradeDisplay ?? '',
              ),
              _buildInfoRow('Device ID', data.deviceId),
              _buildInfoRow('Device', data.device),
              _buildInfoRow('IP Address', data.ipAddress),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.openSans(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.openSans(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }
}
