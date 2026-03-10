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
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  ...report.scriptTrades.map(
                    (trade) => _buildScriptTradeSection(trade),
                  ),
                  SizedBox(height: 16.h),
                  _buildSummaryTable(
                    'General Summary',
                    report.scriptWiseSummary,
                    report.summaryTotal,
                  ),
                  SizedBox(height: 16.h),
                  if (report.carryForward.isNotEmpty) ...[
                    _buildCarryForwardTable(report.carryForward),
                    SizedBox(height: 16.h),
                  ],
                  if (report.exchangeWisePL.isNotEmpty) ...[
                    _buildExchangeWisePLTable(report.exchangeWisePL),
                    SizedBox(height: 16.h),
                  ],
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
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      color: AppColors.primaryBlue.withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            info.userName,
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            info.dateRange,
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
      width: double.infinity,
      child: Text(
        title,
        style: GoogleFonts.openSans(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryBlue,
        ),
      ),
    );
  }

  Widget _buildScriptTradeSection(BillScriptTrade trade) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          _buildSectionHeader('${trade.exchange} ${trade.script}'),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildTradeLegTable(true, trade.buyLegs)),
              Container(width: 1, color: Colors.grey.shade300),
              Expanded(child: _buildTradeLegTable(false, trade.sellLegs)),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Container()),
                Container(width: 1, color: Colors.grey.shade300),
                Expanded(child: _buildTradeSummary(trade)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTradeLegTable(bool isBuy, List<BillTradeLeg> legs) {
    return Column(
      children: [
        Container(
          color: Colors.grey.shade200,
          padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: _buildTableHeaderText('Date', alignLeft: true),
              ),
              Expanded(
                flex: 2,
                child: _buildTableHeaderText(isBuy ? 'B Qty' : 'S Qty'),
              ),
              Expanded(flex: 2, child: _buildTableHeaderText('Price')),
              Expanded(
                flex: 3,
                child: _buildTableHeaderText(isBuy ? 'BVol.' : 'SVol.'),
              ),
            ],
          ),
        ),
        if (legs.isEmpty)
          Padding(
            padding: EdgeInsets.all(8.h),
            child: Text(
              'No trades',
              style: TextStyle(fontSize: 11.sp, color: Colors.grey),
            ),
          ),
        ...legs.map(
          (leg) => Container(
            padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _buildDataText(leg.date, alignLeft: true),
                ),
                Expanded(
                  flex: 2,
                  child: _buildDataText(
                    leg.qty.toString(),
                    color: isBuy ? AppColors.buyColor : AppColors.sellColor,
                  ),
                ),
                Expanded(flex: 2, child: _buildDataText(leg.price)),
                Expanded(
                  flex: 3,
                  child: _buildDataText(leg.vol.toStringAsFixed(2)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTradeSummary(BillScriptTrade trade) {
    return Padding(
      padding: EdgeInsets.all(8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildSummaryRowText(
            'Total BVol:',
            trade.totalBuyVol.toStringAsFixed(2),
          ),
          SizedBox(height: 2.h),
          _buildSummaryRowText(
            'Total SVol:',
            trade.totalSellVol.toStringAsFixed(2),
          ),
          SizedBox(height: 2.h),
          _buildSummaryRowText(
            'Difference.:',
            trade.netDifference.toStringAsFixed(2),
            color: trade.netDifference < 0
                ? AppColors.sellColor
                : AppColors.buyColor,
          ),
          SizedBox(height: 2.h),
          _buildSummaryRowText(
            'Brokerage:',
            trade.brokerage.toStringAsFixed(2),
          ),
          SizedBox(height: 4.h),
          Divider(height: 1, color: Colors.grey.shade300),
          SizedBox(height: 4.h),
          _buildSummaryRowText(
            'PROFIT/LOSS:',
            trade.profitLoss.toStringAsFixed(2),
            color: trade.profitLoss < 0
                ? AppColors.sellColor
                : AppColors.buyColor,
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRowText(
    String label,
    String value, {
    Color? color,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.openSans(
            fontSize: 11.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.openSans(
            fontSize: 11.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: color ?? Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryTable(
    String title,
    List<ScriptBillSummary> summaries,
    BillTotal overallTotal,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          _buildSectionHeader(title),
          Container(
            color: Colors.grey.shade200,
            padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildTableHeaderText('EXCHANGE', alignLeft: true),
                ),
                Expanded(
                  flex: 3,
                  child: _buildTableHeaderText('SCRIPT', alignLeft: true),
                ),
                Expanded(flex: 2, child: _buildTableHeaderText('TOTAL(MTM)')),
                Expanded(flex: 2, child: _buildTableHeaderText('BROKERAGE')),
                Expanded(flex: 2, child: _buildTableHeaderText('NET AMOUNT')),
              ],
            ),
          ),
          ...summaries.map(
            (s) => Container(
              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildDataText(s.exchange, alignLeft: true),
                  ),
                  Expanded(
                    flex: 3,
                    child: _buildDataText(s.script, alignLeft: true),
                  ),
                  Expanded(
                    flex: 2,
                    child: _buildDataText(
                      s.total.toStringAsFixed(2),
                      color: s.total < 0
                          ? AppColors.sellColor
                          : AppColors.buyColor,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: _buildDataText(s.brokerage.toStringAsFixed(2)),
                  ),
                  Expanded(
                    flex: 2,
                    child: _buildDataText(
                      s.net.toStringAsFixed(2),
                      color: s.net < 0
                          ? AppColors.sellColor
                          : AppColors.buyColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: AppColors.primaryBlue.withOpacity(0.1),
            padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: _buildDataText('TOTAL', alignLeft: true, isBold: true),
                ),
                Expanded(
                  flex: 2,
                  child: _buildDataText(
                    overallTotal.total.toStringAsFixed(2),
                    isBold: true,
                    color: overallTotal.total < 0
                        ? AppColors.sellColor
                        : AppColors.buyColor,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: _buildDataText(
                    overallTotal.totalBrokerage.toStringAsFixed(2),
                    isBold: true,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: _buildDataText(
                    overallTotal.totalNet.toStringAsFixed(2),
                    isBold: true,
                    color: overallTotal.totalNet < 0
                        ? AppColors.sellColor
                        : AppColors.buyColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarryForwardTable(List<CarryForwardTrade> cfTrades) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          _buildSectionHeader('Carry Forward Summary'),
          Container(
            color: Colors.grey.shade200,
            padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildTableHeaderText('EXCH', alignLeft: true),
                ),
                Expanded(
                  flex: 4,
                  child: _buildTableHeaderText('SCRIPT', alignLeft: true),
                ),
                Expanded(flex: 2, child: _buildTableHeaderText('TYPE')),
                Expanded(flex: 2, child: _buildTableHeaderText('QUANTITY')),
                Expanded(flex: 2, child: _buildTableHeaderText('PRICE')),
              ],
            ),
          ),
          ...cfTrades.map(
            (cf) => Container(
              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildDataText(cf.exchange, alignLeft: true),
                  ),
                  Expanded(
                    flex: 4,
                    child: _buildDataText(cf.script, alignLeft: true),
                  ),
                  Expanded(
                    flex: 2,
                    child: _buildDataText(
                      cf.type.toUpperCase(),
                      color: cf.type.toLowerCase() == 'buy'
                          ? AppColors.buyColor
                          : AppColors.sellColor,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: _buildDataText(cf.quantity.toString()),
                  ),
                  Expanded(
                    flex: 2,
                    child: _buildDataText(cf.price.toStringAsFixed(2)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExchangeWisePLTable(List<ExchangeWisePL> plList) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          _buildSectionHeader('Exchange Wise P/L'),
          Container(
            color: Colors.grey.shade200,
            padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _buildTableHeaderText('EXCHANGE', alignLeft: true),
                ),
                Expanded(flex: 3, child: _buildTableHeaderText('MTM')),
                Expanded(flex: 3, child: _buildTableHeaderText('BROK')),
                Expanded(flex: 3, child: _buildTableHeaderText('P/L')),
              ],
            ),
          ),
          ...plList.map(
            (pl) => Container(
              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildDataText(pl.exchange, alignLeft: true),
                  ),
                  Expanded(
                    flex: 3,
                    child: _buildDataText(
                      pl.mtm.toStringAsFixed(2),
                      color: pl.mtm < 0
                          ? AppColors.sellColor
                          : AppColors.buyColor,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: _buildDataText(pl.brok.toStringAsFixed(2)),
                  ),
                  Expanded(
                    flex: 3,
                    child: _buildDataText(
                      pl.pl.toStringAsFixed(2),
                      color: pl.pl < 0
                          ? AppColors.sellColor
                          : AppColors.buyColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeaderText(String text, {bool alignLeft = false}) {
    return Text(
      text,
      textAlign: alignLeft ? TextAlign.left : TextAlign.right,
      style: GoogleFonts.openSans(
        fontSize: 10.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildDataText(
    String text, {
    bool alignLeft = false,
    Color? color,
    bool isBold = false,
  }) {
    return Text(
      text,
      textAlign: alignLeft ? TextAlign.left : TextAlign.right,
      style: GoogleFonts.openSans(
        fontSize: 11.sp,
        fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
        color: color ?? Colors.black87,
      ),
    );
  }
}
