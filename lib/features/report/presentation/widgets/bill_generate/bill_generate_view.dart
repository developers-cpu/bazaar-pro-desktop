import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../domain/entities/bill_generate_report.dart';

class BillGenerateView extends StatelessWidget {
  final BillGenerateReport report;
  const BillGenerateView({super.key, required this.report});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(report.headerInfo),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  ...report.exchangeReports.map(
                    (exchangeReport) => _buildExchangeSection(exchangeReport),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    alignment: Alignment.center,
                    color: AppColors.billTableHeaderBg,
                    child: Text(
                      'SCRIPT WISE SUMMARY',
                      style: GoogleFonts.openSans(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.billTableHeaderText,
                      ),
                    ),
                  ),
                  _buildScriptWiseSummaryTable(
                    report.scriptWiseSummary,
                    report.overallTotal,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BillHeaderInfo info) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      decoration: const BoxDecoration(color: AppColors.billHeaderBg),
      child: Column(
        children: [
          Text(
            info.userName,
            style: GoogleFonts.openSans(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'BILL SUMMARY ${info.dateRange.toUpperCase()}',
            style: GoogleFonts.openSans(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.95),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExchangeSection(ExchangeBillReport report) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.billBorderColor, width: 1),
      ),
      child: Column(
        children: [
          _buildTableHeader(),
          ...report.trades.asMap().entries.map(
            (entry) => _buildTradeRow(entry.value, entry.key.isEven),
          ),
          _buildExchangeTotalRow(report.total),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      color: AppColors.billTableHeaderBg,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        children: [
          _buildHeaderCell('EXCHANGE', flex: 2),
          _buildHeaderCell('SCRIPT', flex: 3),
          _buildHeaderCell('BUY QTY', flex: 2, alignRight: true),
          _buildHeaderCell('BUY PRICE', flex: 2, alignRight: true),
          _buildHeaderCell('SELL QTY', flex: 2, alignRight: true),
          _buildHeaderCell('SELL PRICE', flex: 2, alignRight: true),
          _buildHeaderCell('BROK', flex: 2, alignRight: true),
          _buildHeaderCell('PROFIT/LOSS', flex: 2, alignRight: true),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(
    String text, {
    int flex = 1,
    bool alignRight = false,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: alignRight ? TextAlign.right : TextAlign.left,
        style: GoogleFonts.openSans(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.billTableHeaderText,
        ),
      ),
    );
  }

  Widget _buildTradeRow(BillTradeDetail trade, bool isEven) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isEven ? Colors.white : AppColors.billRowAltBg,
        border: Border(
          bottom: BorderSide(color: AppColors.billBorderColor, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          _buildDataCell(trade.exchange, flex: 2),
          _buildDataCell(trade.script, flex: 3),
          _buildDataCell(
            trade.buyQty?.toString() ?? '',
            flex: 2,
            alignRight: true,
            color: AppColors.billBuyColor,
          ),
          _buildDataCell(
            trade.buyPrice?.toStringAsFixed(0) ?? '',
            flex: 2,
            alignRight: true,
            color: AppColors.billBuyColor,
          ),
          _buildDataCell(
            trade.sellQty?.toString() ?? '',
            flex: 2,
            alignRight: true,
            color: AppColors.billSellColor,
          ),
          _buildDataCell(
            trade.sellPrice?.toStringAsFixed(0) ?? '',
            flex: 2,
            alignRight: true,
            color: AppColors.billSellColor,
          ),
          _buildDataCell(
            trade.brokerage > 0 ? trade.brokerage.toStringAsFixed(0) : '',
            flex: 2,
            alignRight: true,
          ),
          _buildDataCell(
            trade.profitLoss != 0 ? trade.profitLoss.toStringAsFixed(0) : '',
            flex: 2,
            alignRight: true,
            color: trade.profitLoss >= 0
                ? AppColors.billProfitColor
                : AppColors.billLossColor,
          ),
        ],
      ),
    );
  }

  Widget _buildDataCell(
    String text, {
    int flex = 1,
    bool alignRight = false,
    Color? color,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: alignRight ? TextAlign.right : TextAlign.left,
        style: GoogleFonts.openSans(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: color ?? AppColors.billDataText,
        ),
      ),
    );
  }

  Widget _buildExchangeTotalRow(BillExchangeTotal total) {
    return Container(
      color: AppColors.billTotalRowBg,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              'TOTAL',
              style: GoogleFonts.openSans(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.billTableHeaderText,
              ),
            ),
          ),
          _buildTotalCell(total.totalBuyQty.toString(), flex: 2),
          _buildTotalCell('', flex: 2),
          _buildTotalCell(total.totalSellQty.toString(), flex: 2),
          _buildTotalCell('', flex: 2),
          _buildTotalCell(total.totalBrokerage.toStringAsFixed(0), flex: 2),
          _buildTotalCell(
            total.totalProfitLoss.toStringAsFixed(0),
            flex: 2,
            color: total.totalProfitLoss >= 0
                ? AppColors.billProfitColor
                : AppColors.billLossColor,
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCell(String text, {int flex = 1, Color? color}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.right,
        style: GoogleFonts.openSans(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: color ?? AppColors.billTableHeaderText,
        ),
      ),
    );
  }

  Widget _buildScriptWiseSummaryTable(
    List<ScriptBillSummary> summaries,
    BillTotal overallTotal,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.billBorderColor, width: 1),
      ),
      child: Column(
        children: [
          Container(
            color: AppColors.billTableHeaderBg,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Row(
              children: [
                _buildHeaderCell('EXCHANGE', flex: 2),
                _buildHeaderCell('SCRIPT', flex: 4),
                const Spacer(flex: 4),
                _buildHeaderCell('MTM', flex: 2, alignRight: true),
                _buildHeaderCell('BROKERAGE', flex: 2, alignRight: true),
                _buildHeaderCell('NET AMOUNT', flex: 2, alignRight: true),
              ],
            ),
          ),
          ...summaries.asMap().entries.map(
            (entry) => _buildSummaryRow(entry.value, entry.key.isEven),
          ),
          _buildOverallTotalRow(overallTotal),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(ScriptBillSummary summary, bool isEven) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isEven ? Colors.white : AppColors.billRowAltBg,
        border: Border(
          bottom: BorderSide(color: AppColors.billBorderColor, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          _buildDataCell(summary.exchange, flex: 2),
          _buildDataCell(summary.script, flex: 4),
          const Spacer(flex: 4),
          _buildDataCell(
            summary.mtm.toStringAsFixed(0),
            flex: 2,
            alignRight: true,
            color: summary.mtm >= 0
                ? AppColors.billProfitColor
                : AppColors.billLossColor,
          ),
          _buildDataCell(
            summary.brokerage.toStringAsFixed(0),
            flex: 2,
            alignRight: true,
            color: AppColors.billBrokerageColor,
          ),
          _buildDataCell(
            summary.netAmount.toStringAsFixed(0),
            flex: 2,
            alignRight: true,
            color: summary.netAmount >= 0
                ? AppColors.billProfitColor
                : AppColors.billLossColor,
          ),
        ],
      ),
    );
  }

  Widget _buildOverallTotalRow(BillTotal total) {
    return Container(
      color: AppColors.billTotalRowBg,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Text(
              'TOTAL',
              style: GoogleFonts.openSans(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.billTableHeaderText,
              ),
            ),
          ),
          const Spacer(flex: 4),
          _buildTotalCell(
            total.totalMtm.toStringAsFixed(0),
            flex: 2,
            color: total.totalMtm >= 0
                ? AppColors.billProfitColor
                : AppColors.billLossColor,
          ),
          _buildTotalCell(
            total.totalBrokerage.toStringAsFixed(0),
            flex: 2,
            color: AppColors.billBrokerageColor,
          ),
          _buildTotalCell(
            total.totalNetAmount.toStringAsFixed(0),
            flex: 2,
            color: total.totalNetAmount >= 0
                ? AppColors.billProfitColor
                : AppColors.billLossColor,
          ),
        ],
      ),
    );
  }
}
