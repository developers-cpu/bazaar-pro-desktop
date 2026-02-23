import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_images.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../../../core/widget/svg_icon.dart';
import '../../../../../../injection_container.dart';
import '../../bloc/total_volume/total_volume_bloc.dart';
import '../../../domain/entities/total_volume_entity.dart';
class TotalVolumeDialog extends StatefulWidget {
  const TotalVolumeDialog({Key? key}) : super(key: key);
  static void show(BuildContext context) {
    CommonDialog.show(
      context: context,
      title: 'Total Volume',
      width: 400.w,
      showButtons: false,
      contentPadding: EdgeInsets.all(20.w),
      content: const TotalVolumeDialog(),
    );
  }
  @override
  State<TotalVolumeDialog> createState() => _TotalVolumeDialogState();
}
class _TotalVolumeDialogState extends State<TotalVolumeDialog> {
  String? _selectedExchange;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<TotalVolumeBloc>()..add(GetTotalVolumeExchangesEvent()),
      child: BlocBuilder<TotalVolumeBloc, TotalVolumeState>(
        builder: (context, state) {
          final exchanges =
              state.exchanges.isEmpty &&
                  state.exchangeStatus == ExchangeStatus.success
              ? ['NSE', 'MCX']
              : state.exchanges;
          return SizedBox(
            height: 220.h,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (state.exchangeStatus == ExchangeStatus.loading)
                  const Center(child: CircularProgressIndicator())
                else
                  AppDropdown(
                    width: 200.w,
                    height: 40.h,
                    items: exchanges,
                    hintText: 'Select Exchange',
                    value: _selectedExchange,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedExchange = value;
                        });
                        context.read<TotalVolumeBloc>().add(
                          GetTotalVolumeEvent(value),
                        );
                      }
                    },
                  ),
                if (_selectedExchange != null) ...[
                  SizedBox(height: 16.h),
                  _buildContent(state),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
  Widget _buildContent(TotalVolumeState state) {
    if (state.status == TotalVolumeStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state.status == TotalVolumeStatus.success &&
        state.totalVolume != null) {
      return _buildVolumeCard(state.totalVolume!);
    } else if (state.status == TotalVolumeStatus.error) {
      return Center(
        child: Text(state.errorMessage, style: TextStyle(color: Colors.red)),
      );
    }
    return const SizedBox.shrink();
  }
  Widget _buildVolumeCard(TotalVolumeEntity data) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1E3A56),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgIcon(
            assetPath: AppImages.pendingOrdersIcon,
            activeColor: AppColors.successColor,
            size: 32.sp,
            isActive: true,
          ),
          SizedBox(height: 12.h),
          Text(
            '${data.exchange} Total Volume',
            style: GoogleFonts.openSans(
              fontSize: 20.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Divider(color: AppColors.white.withOpacity(0.2), height: 1.h),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data.totalVolume,
                style: GoogleFonts.openSans(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.white,
                ),
              ),
              Text(
                data.totalVolumeShort,
                style: GoogleFonts.openSans(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
