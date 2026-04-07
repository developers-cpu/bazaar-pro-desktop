import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widget/app_dropdown.dart';
import '../../../../core/widget/common_dilog_box.dart';
import '../bloc/market_depth/market_depth_bloc.dart';
import '../bloc/market_depth/market_depth_event.dart';
import '../bloc/market_depth/market_depth_state.dart';

class MarketDepthDialog extends StatefulWidget {
  const MarketDepthDialog({Key? key}) : super(key: key);
  static Future<void> show(BuildContext context) async {
    context.read<MarketDepthBloc>().add(const OpenMarketDepthEvent());
    CommonDialog.show(
      context: context,
      title: 'Market Depth',
      width: 350.w,
      content: BlocProvider.value(
        value: context.read<MarketDepthBloc>(),
        child: const MarketDepthDialog(),
      ),
      showButtons: false,
      isDarkMode: true,
      headerColor: AppColors.primaryBlue,
      backgroundColor: AppColors.backgroundColor,
      contentPadding: EdgeInsets.all(8.w),
      onCancel: () {
        context.read<MarketDepthBloc>().add(const CloseMarketDepthEvent());
      },
    );
  }

  @override
  State<MarketDepthDialog> createState() => _MarketDepthDialogState();
}

class _MarketDepthDialogState extends State<MarketDepthDialog> {
  final FocusScopeNode _dialogScopeNode = FocusScopeNode(
    debugLabel: 'MarketDepthDialog',
  );
  final FocusNode _exchangeFocusNode = FocusNode();
  final FocusNode _symbolFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _dialogScopeNode.requestFocus();
        _exchangeFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _dialogScopeNode.dispose();
    _exchangeFocusNode.dispose();
    _symbolFocusNode.dispose();
    super.dispose();
  }

  KeyEventResult _handleDialogKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
        event.logicalKey == LogicalKeyboardKey.arrowRight ||
        event.logicalKey == LogicalKeyboardKey.arrowUp ||
        event.logicalKey == LogicalKeyboardKey.arrowDown) {
      return KeyEventResult.skipRemainingHandlers;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      node: _dialogScopeNode,
      onKeyEvent: _handleDialogKeyEvent,
      child: BlocBuilder<MarketDepthBloc, MarketDepthState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDropdowns(context, state),
              SizedBox(height: 8.h),
              _buildSymbolInfo(context, state),
              SizedBox(height: 8.h),
              _buildMarketDataCards(context, state),
              SizedBox(height: 8.h),
              _buildBidAskTable(context, state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDropdowns(BuildContext context, MarketDepthState state) {
    return Row(
      children: [
        Expanded(
          child: AppDropdown(
            type: AppDropdownType.simple,
            hintText: 'Exchange',
            value: state.exchange.isEmpty ? null : state.exchange,
            items: const ['NSE', 'BSE', 'MCX', 'NFO'],
            height: 28.h,
            focusNode: _exchangeFocusNode,
            onChanged: (value) {
              if (value != null) {
                context.read<MarketDepthBloc>().add(UpdateExchangeEvent(value));
              }
            },
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: AppDropdown(
            type: AppDropdownType.search,
            hintText: 'Symbol',
            value: state.symbol.isEmpty ? null : state.symbol,
            items: const ['NIFTY25NOV25', 'BANKNIFTY', 'RELIANCE', 'TCS'],
            height: 28.h,
            searchHint: 'Search Symbol',
            focusNode: _symbolFocusNode,
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

  Widget _buildSymbolInfo(BuildContext context, MarketDepthState state) {
    return Row(
      children: [
        Text(
          state.exchange.isEmpty ? 'MCX' : state.exchange,
          style: GoogleFonts.openSans(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        SizedBox(width: 4.w),
        Icon(Icons.trending_up, size: 14.sp, color: AppColors.primaryBlue),
        SizedBox(width: 4.w),
        Text(
          state.symbol.isEmpty ? 'NIFTY25NOV25' : state.symbol,
          style: GoogleFonts.openSans(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildMarketDataCards(BuildContext context, MarketDepthState state) {
    final data = state.marketDepthData;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: AppColors.greyBorder, width: 0.5),
            ),
            child: Column(
              children: [
                _buildDataRow('Lot Size', data?.lotSize.toString() ?? '35'),
                _buildDataRow('LTP', data?.ltp.toString() ?? '60013'),
                _buildDataRow('Volume', data?.volume.toString() ?? '422590'),
                _buildDataRow(
                  'Avg. Price',
                  data?.avgPrice.toString() ?? '52402',
                ),
                _buildDataRow('L.CRKT', data?.lCrkt.toString() ?? '80254'),
              ],
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: AppColors.greyBorder, width: 0.5),
            ),
            child: Column(
              children: [
                _buildDataRow('Open', data?.open.toString() ?? '35'),
                _buildDataRow('High', data?.high.toString() ?? '60013'),
                _buildDataRow('Low', data?.low.toString() ?? '422590'),
                _buildDataRow('Close', data?.close.toString() ?? '52402'),
                _buildDataRow('U.CRKT', data?.uCrkt.toString() ?? '80254'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.openSans(
              fontSize: 10.sp,
              color: AppColors.black.withOpacity(0.6),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.openSans(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
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
              color: AppColors.primaryBlue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: AppColors.greyBorder, width: 0.5),
            ),
            child: Column(
              children: [
                _buildTableHeader(
                  'Bid',
                  'Orders',
                  'Qty',
                  AppColors.primaryBlue,
                  AppColors.primaryBlue.withOpacity(0.1),
                ),
                ...?data?.bidRows.map((row) => _buildBidRow(row)),
                _buildTotalRow(
                  'Total',
                  data?.totalBidQty.toString() ?? '11',
                  AppColors.primaryBlue,
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.03),
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: AppColors.greyBorder, width: 0.5),
            ),
            child: Column(
              children: [
                _buildTableHeader(
                  'Asked',
                  'Orders',
                  'Qty',
                  Colors.red.shade700,
                  Colors.red.withOpacity(0.08),
                ),
                ...?data?.askRows.map((row) => _buildAskRow(row)),
                _buildTotalRow(
                  'Total',
                  data?.totalAskQty.toString() ?? '11',
                  Colors.red.shade700,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeader(
    String col1,
    String col2,
    String col3,
    Color accentColor,
    Color bgColor,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6.r),
          topRight: Radius.circular(6.r),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              col1,
              style: GoogleFonts.openSans(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: accentColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              col2,
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ),
          Expanded(
            child: Text(
              col3,
              textAlign: TextAlign.right,
              style: GoogleFonts.openSans(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String value, Color accentColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.greyBorder, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.openSans(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: accentColor,
              ),
            ),
          ),
          Expanded(child: SizedBox()),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.openSans(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBidRow(MarketDepthRow row) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              row.price.toInt().toString(),
              style: GoogleFonts.openSans(
                fontSize: 10.sp,
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              row.orders.toString(),
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 10.sp,
                color: AppColors.black.withOpacity(0.6),
              ),
            ),
          ),
          Expanded(
            child: Text(
              row.qty.toString(),
              textAlign: TextAlign.right,
              style: GoogleFonts.openSans(
                fontSize: 10.sp,
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAskRow(MarketDepthRow row) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              row.price.toInt().toString(),
              style: GoogleFonts.openSans(
                fontSize: 10.sp,
                color: Colors.red.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              row.orders.toString(),
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 10.sp,
                color: AppColors.black.withOpacity(0.6),
              ),
            ),
          ),
          Expanded(
            child: Text(
              row.qty.toString(),
              textAlign: TextAlign.right,
              style: GoogleFonts.openSans(
                fontSize: 10.sp,
                color: Colors.red.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
