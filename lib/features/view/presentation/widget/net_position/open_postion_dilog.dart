import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../../domain/entities/net_postion/net_position.dart';
import '../../bloc/net_position/net_position_bloc.dart';
import '../../bloc/net_position/net_position_event.dart';
import '../../bloc/net_position/net_position_state.dart';
import '../common/view_reset_buttons.dart';

class OpenPositionDialog extends StatelessWidget {
  final bool isDarkMode;

  const OpenPositionDialog({
    Key? key,
    this.isDarkMode = false,
  }) : super(key: key);

  static void show({
    required BuildContext context,
    bool isDarkMode = false,
  }) {
    showDialog(
      context: context,
      barrierColor: AppColors.black.withOpacity(0.54),
      builder: (_) => BlocProvider.value(
        value: context.read<NetPositionBloc>(),
        child: OpenPositionDialog(
          isDarkMode: isDarkMode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = isDarkMode
        ? const Color(0xFF1A1A1A)
        : AppColors.white;

    final headerBgColor = const Color(0xFF2C5F7A);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(20.w),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          children: [
            _buildHeader(context, headerBgColor),
            _buildFilterRow(context),
            Expanded(
              child: BlocBuilder<NetPositionBloc, NetPositionState>(
                builder: (context, state) {
                  if (state is NetPositionLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is NetPositionError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: GoogleFonts.openSans(
                          fontSize: 16.sp,
                          color: AppColors.red,
                        ),
                      ),
                    );
                  }

                  if (state is NetPositionLoaded) {
                    return _buildTable(state.filteredPositions);
                  }

                  return const Center(
                    child: Text('No positions available'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color headerBgColor) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.r),
        topRight: Radius.circular(20.r),
      ),
      child: Container(
        width: double.infinity,
        height: 60.h,
        color: headerBgColor,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Open Position',
                style: GoogleFonts.openSans(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
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

  Widget _buildFilterRow(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: BlocBuilder<NetPositionBloc, NetPositionState>(
        builder: (context, state) {
          if (state is! NetPositionLoaded) {
            return const SizedBox.shrink();
          }

          return Row(
            children: [

              SizedBox(
                width: 250.w, 
                child: AppDropdown(
                  type: AppDropdownType.search,
                  hintText: 'Client',
                  value: state.selectedClient,
                  items: state.clients,
                  onChanged: (value) {
                    context.read<NetPositionBloc>().add(
                      ApplyFiltersEvent(
                        userType: state.selectedUserType,
                        client: value,
                        exchange: state.selectedExchange,
                        symbol: state.selectedSymbol,
                      ),
                    );
                  },
                ),
              ),

              const Spacer(),

              ViewResetButtons(
                onReset: () {
                  context.read<NetPositionBloc>().add(
                    const ResetFiltersEvent(),
                  );
                },
                onView: () {
                  context.read<NetPositionBloc>().add(
                    ApplyFiltersEvent(
                      userType: state.selectedUserType,
                      client: state.selectedClient,
                      exchange: state.selectedExchange,
                      symbol: state.selectedSymbol,
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTable(List<NetPosition> positions) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),

      child: Column(
        children: [

          Container(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
            alignment: Alignment.centerRight,
            child: Text(
              'RECORD : ${positions.length}',
              style: GoogleFonts.openSans(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryBlue,
              ),
            ),
          ),

          _buildTableHeader(),

          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: positions
                      .asMap()
                      .entries
                      .map((entry) => _buildTableRow(entry.value, entry.key))
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12.r),
        topRight: Radius.circular(12.r),
      ),
      child: Container(
        height: 55.h,
        decoration: const BoxDecoration(
          color: Color(0xFFC6DBE8),
          border: Border(
            bottom: BorderSide(
              color: AppColors.greyBorder,
              width: 2,
            ),
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildHeaderCell('U.NAME', 120),
              _buildHeaderCell('EXCH', 80),
              _buildHeaderCell('SYMBOL', 130),
              _buildHeaderCell('BUY QTY', 100),
              _buildHeaderCell('SELL QTY', 100),
              _buildHeaderCell('NET QTY', 100),
              _buildHeaderCell('NET AVG PRICE', 130),
              _buildHeaderCell('CMP', 100),
              _buildHeaderCell('M2M AMT', 120),
              _buildHeaderCell('OUR %', 80),
              _buildHeaderCell('USER', 60),
              _buildHeaderCell('DAYS', 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String label, double width) {
    return SizedBox(
      width: width.w,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Text(
          label,
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2C5F7A),
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildTableRow(NetPosition position, int index) {
    final rowColor = index % 2 == 0
        ? AppColors.white
        : const Color(0xFFF8F9FA);

    return InkWell(
      onTap: () {

      },
      child: Container(
        height: 45.h,
        decoration: BoxDecoration(
          color: rowColor,
          border: Border(
            bottom: BorderSide(
              color: AppColors.greyBorder,
              width: 1,
            ),
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildDataCell(position.userName, 120),
              _buildDataCell(position.exchange, 80),
              _buildDataCell(
                position.symbol,
                130,
                color: const Color(0xFF2C5F7A),
              ),
              _buildDataCell(
                position.buyQty.toStringAsFixed(2),
                100,
                isNumeric: true,
                color: position.buyQty > 0 ? AppColors.blue : AppColors.primaryTextColor,
              ),
              _buildDataCell(
                position.sellQty.toStringAsFixed(2),
                100,
                isNumeric: true,
                color: position.sellQty > 0 ? AppColors.red : AppColors.primaryTextColor,
              ),
              _buildDataCell(
                position.netQty.toStringAsFixed(0),
                100,
                isNumeric: true,
                color: position.netQty > 0 ? AppColors.blue : AppColors.red,
              ),
              _buildDataCell(
                position.netAvgPrice.toStringAsFixed(2),
                130,
                isNumeric: true,
              ),
              _buildDataCell(
                position.cmp.toStringAsFixed(0),
                100,
                isNumeric: true,
                color: AppColors.primaryBlue,
              ),
              _buildDataCell(
                position.m2mAmount.toStringAsFixed(0),
                120,
                isNumeric: true,
                color: position.m2mAmount >= 0 ? AppColors.blue : AppColors.red,
              ),
              _buildDataCell(
                '${position.ourPercentage.toStringAsFixed(2)}',
                80,
                isNumeric: true,
              ),
              _buildDataCell(
                position.userCount.toString(),
                60,
                isNumeric: true,
              ),
              _buildDataCell(
                position.days.toString(),
                60,
                isNumeric: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataCell(
      String text,
      double width, {
        bool isNumeric = false,
        Color? color,
      }) {
    return SizedBox(
      width: width.w,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Text(
          text,
          style: GoogleFonts.openSans(
            fontSize: 13.sp,
            fontWeight: isNumeric ? FontWeight.w600 : FontWeight.w400,
            color: color ?? AppColors.primaryTextColor,
          ),
          textAlign: isNumeric ? TextAlign.right : TextAlign.left,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}