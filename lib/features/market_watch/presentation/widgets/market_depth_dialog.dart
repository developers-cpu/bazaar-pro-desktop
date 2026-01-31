import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/market_depth/market_depth_bloc.dart';
import '../bloc/market_depth/market_depth_event.dart';
import '../bloc/market_depth/market_depth_state.dart';

class MarketDepthDialog extends StatelessWidget {
  const MarketDepthDialog({Key? key}) : super(key: key);

  static Future<void> show(BuildContext context) async {
    context.read<MarketDepthBloc>().add(const OpenMarketDepthEvent());

    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: AppColors.black.withOpacity(0.54),
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        backgroundColor: Colors.transparent,
        child: Container(
          width: 550.w,
          decoration: BoxDecoration(
            color: AppColors.isDarkMode(context)
                ? DarkThemeColors.cardBackground
                : LightThemeColors.cardBackground,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              _buildHeader(context),

              Flexible(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: const MarketDepthDialog(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).then((_) {

      context.read<MarketDepthBloc>().add(const CloseMarketDepthEvent());
    });
  }

  static Widget _buildHeader(BuildContext context) {
    final isDarkMode = AppColors.isDarkMode(context);
    final headerBgColor = isDarkMode
        ? LightThemeColors.primaryColor
        : AppColors.primaryBlue;

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.r),
        topRight: Radius.circular(16.r),
      ),
      child: Container(
        height: 60.h,
        color: headerBgColor,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Market Depth',
                style: GoogleFonts.openSans(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                context.read<MarketDepthBloc>().add(const CloseMarketDepthEvent());
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.close,
                size: 22.sp,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarketDepthBloc, MarketDepthState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            _buildDropdowns(context, state),
            SizedBox(height: 16.h),

            _buildSymbolInfo(context, state),
            SizedBox(height: 16.h),

            _buildMarketDataCards(context, state),
            SizedBox(height: 16.h),

            _buildBidAskTable(context, state),
          ],
        );
      },
    );
  }

  Widget _buildDropdowns(BuildContext context, MarketDepthState state) {
    return Row(
      children: [

        Expanded(
          child: _buildThemedDropdown(
            context: context,
            hintText: 'Exchange',
            value: state.exchange.isEmpty ? null : state.exchange,
            items: const ['NSE', 'BSE', 'MCX', 'NFO'],
            onChanged: (value) {
              if (value != null) {
                context.read<MarketDepthBloc>().add(UpdateExchangeEvent(value));
              }
            },
          ),
        ),
        SizedBox(width: 16.w),

        Expanded(
          child: _buildThemedDropdown(
            context: context,
            hintText: 'Symbol',
            value: state.symbol.isEmpty ? null : state.symbol,
            items: const ['NIFTY25NOV25', 'BANKNIFTY', 'RELIANCE', 'TCS'],
            onChanged: (value) {
              if (value != null) {
                context.read<MarketDepthBloc>().add(UpdateSymbolEvent(value));
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildThemedDropdown({
    required BuildContext context,
    required String hintText,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    final isDarkMode = AppColors.isDarkMode(context);
    final borderColor = AppColors.primaryColor(context);
    final textColor = AppColors.textColor(context);
    final bgColor = AppColors.inputFieldBackground(context);
    final dropdownBgColor = AppColors.cardBackground(context);

    return Container(
      height: 45.h,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: dropdownBgColor,

          shadowColor: Colors.transparent,
        ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton<String>(
              value: value,
              hint: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Text(
                  hintText,
                  style: GoogleFonts.openSans(
                    fontSize: 14.sp,
                    color: AppColors.supportiveTextColor(context),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              isExpanded: true,
              icon: Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: textColor,
                  size: 20.sp,
                ),
              ),
              style: GoogleFonts.openSans(
                fontSize: 14.sp,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
              dropdownColor: dropdownBgColor,
              borderRadius: BorderRadius.circular(8.r),
              elevation: 8,
              menuMaxHeight: 250.h,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.h,
                      horizontal: 4.w,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.dividerColor(context),
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Text(
                      item,
                      style: GoogleFonts.openSans(
                        fontSize: 14.sp,
                        color: textColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSymbolInfo(BuildContext context, MarketDepthState state) {
    final textColor = AppColors.textColor(context);
    final positiveColor = AppColors.chipTextBlueColor(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              state.exchange.isEmpty ? 'MCX' : state.exchange,
              style: GoogleFonts.openSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              Icons.trending_up,
              size: 18.sp,
              color: positiveColor,
            ),
            SizedBox(width: 8.w),
            Text(
              state.symbol.isEmpty ? 'NIFTY25NOV25' : state.symbol,
              style: GoogleFonts.openSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMarketDataCards(BuildContext context, MarketDepthState state) {
    final data = state.marketDepthData;
    final cardBgColor = AppColors.chipBgBlue(context).withOpacity(0.3);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Expanded(
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: cardBgColor,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: AppColors.cardBorderColor(context),
                width: 0.5,
              ),
            ),
            child: Column(
              children: [
                _buildDataRow(context, 'Lot Size', data?.lotSize.toString() ?? '35'),
                _buildDataRow(context, 'LTP', data?.ltp.toString() ?? '60013'),
                _buildDataRow(context, 'Volume', data?.volume.toString() ?? '422590'),
                _buildDataRow(context, 'Avg. Price', data?.avgPrice.toString() ?? '52402'),
                _buildDataRow(context, 'L.CRKT', data?.lCrkt.toString() ?? '80254'),
              ],
            ),
          ),
        ),
        SizedBox(width: 16.w),

        Expanded(
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: cardBgColor,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: AppColors.cardBorderColor(context),
                width: 0.5,
              ),
            ),
            child: Column(
              children: [
                _buildDataRow(context, 'Open', data?.open.toString() ?? '35'),
                _buildDataRow(context, 'High', data?.high.toString() ?? '60013'),
                _buildDataRow(context, 'Low', data?.low.toString() ?? '422590'),
                _buildDataRow(context, 'Close', data?.close.toString() ?? '52402'),
                _buildDataRow(context, 'U.CRKT', data?.uCrkt.toString() ?? '80254'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDataRow(BuildContext context, String label, String value) {
    final textColor = AppColors.textColor(context);
    final supportiveColor = AppColors.supportiveTextColor(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.openSans(
              fontSize: 12.sp,
              color: supportiveColor,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.openSans(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBidAskTable(BuildContext context, MarketDepthState state) {
    final data = state.marketDepthData;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.chipBgBlue(context).withOpacity(0.3),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: AppColors.cardBorderColor(context),
                width: 0.5,
              ),
            ),
            child: Column(
              children: [

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: AppColors.chipTextBlueColor(context).withOpacity(0.15),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.r),
                      topRight: Radius.circular(8.r),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Bid',
                          style: GoogleFonts.openSans(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.chipTextBlueColor(context),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Orders',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor(context),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Qty',
                          textAlign: TextAlign.right,
                          style: GoogleFonts.openSans(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                ...?data?.bidRows.map((row) => _buildBidRow(context, row)),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: AppColors.cardBorderColor(context),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Total',
                          style: GoogleFonts.openSans(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.chipTextBlueColor(context),
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        child: Text(
                          data?.totalBidQty.toString() ?? '11',
                          textAlign: TextAlign.right,
                          style: GoogleFonts.openSans(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.chipTextBlueColor(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 16.w),

        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.chipBgRed(context).withOpacity(0.3),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: AppColors.cardBorderColor(context),
                width: 0.5,
              ),
            ),
            child: Column(
              children: [

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: AppColors.chipTextRedColor(context).withOpacity(0.15),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.r),
                      topRight: Radius.circular(8.r),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Asked',
                          style: GoogleFonts.openSans(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.chipTextRedColor(context),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Orders',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor(context),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Qty',
                          textAlign: TextAlign.right,
                          style: GoogleFonts.openSans(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                ...?data?.askRows.map((row) => _buildAskRow(context, row)),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: AppColors.cardBorderColor(context),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Total',
                          style: GoogleFonts.openSans(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.chipTextRedColor(context),
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        child: Text(
                          data?.totalAskQty.toString() ?? '11',
                          textAlign: TextAlign.right,
                          style: GoogleFonts.openSans(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.chipTextRedColor(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBidRow(BuildContext context, MarketDepthRow row) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              row.price.toInt().toString(),
              style: GoogleFonts.openSans(
                fontSize: 11.sp,
                color: AppColors.chipTextBlueColor(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              row.orders.toString(),
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 11.sp,
                color: AppColors.supportiveTextColor(context),
              ),
            ),
          ),
          Expanded(
            child: Text(
              row.qty.toString(),
              textAlign: TextAlign.right,
              style: GoogleFonts.openSans(
                fontSize: 11.sp,
                color: AppColors.chipTextBlueColor(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAskRow(BuildContext context, MarketDepthRow row) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              row.price.toInt().toString(),
              style: GoogleFonts.openSans(
                fontSize: 11.sp,
                color: AppColors.chipTextRedColor(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              row.orders.toString(),
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 11.sp,
                color: AppColors.supportiveTextColor(context),
              ),
            ),
          ),
          Expanded(
            child: Text(
              row.qty.toString(),
              textAlign: TextAlign.right,
              style: GoogleFonts.openSans(
                fontSize: 11.sp,
                color: AppColors.chipTextRedColor(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}