import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../domain/entities/bill_generate_report.dart';

class BillGenerateView extends StatelessWidget {
  final BillGenerateReport report;
  final String? billType;
  const BillGenerateView({super.key, required this.report, this.billType});
  @override
  Widget build(BuildContext context) {
    final isRegular = billType?.toLowerCase() == 'regular';
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isRegular) _buildRegularBody() else _buildAdvanceBody(),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvanceBody() {
    return Column(
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
      ],
    );
  }

  Widget _buildRegularBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRegularHeader(report.headerInfo),
        Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              _buildRegularSectionTitle('EXCHANGE / TRADES'),
              _buildRegularTradesTable(),
              SizedBox(height: 25.h),
              _buildRegularSectionTitle('SCRIPT WISE SUMMARY'),
              _buildRegularScriptWiseSummary(),
              SizedBox(height: 25.h),
              if (report.carryForward.isNotEmpty) ...[
                _buildRegularSectionTitle('CARRY FORWARD SYMBOLS'),
                _buildRegularCarryForward(),
                SizedBox(height: 25.h),
              ],
              if (report.exchangeWisePL.isNotEmpty) ...[
                _buildRegularSectionTitle('EXCHANGE WISE SUMMARY'),
                _buildRegularExchangeSummary(),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRegularHeader(BillHeaderInfo info) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Color(0xFF7E899B)),
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        children: [
          Text(
            info.userName,
            style: GoogleFonts.openSans(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'BILL SUMMARY ${info.dateRange.toUpperCase()}',
            style: GoogleFonts.openSans(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegularSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE9EBED),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4.r),
          topRight: Radius.circular(4.r),
        ),
      ),
      child: Text(
        title,
        style: GoogleFonts.openSans(
          fontSize: 13.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF5A6677),
        ),
      ),
    );
  }

  Widget _buildRegularTradesTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD1D5DB)),
      ),
      child: Column(
        children: [
          _buildRegularRow([
            'EXCHANGE',
            'SCRIPT',
            'BUY QTY',
            'BUY PRICE',
            'SELL QTY',
            'SELL PRICE',
            'BROKERAGE',
            'PROFIT/LOSS',
          ], isHeader: true),
          ...report.scriptTrades.expand((trade) {
            final List<Widget> legs = [];
            final maxLen = trade.buyLegs.length > trade.sellLegs.length
                ? trade.buyLegs.length
                : trade.sellLegs.length;
            for (int i = 0; i < maxLen; i++) {
              final buyLeg = i < trade.buyLegs.length ? trade.buyLegs[i] : null;
              final sellLeg = i < trade.sellLegs.length
                  ? trade.sellLegs[i]
                  : null;
              legs.add(
                _buildRegularRow(
                  [
                    trade.exchange,
                    trade.script,
                    buyLeg?.qty.toString() ?? '',
                    buyLeg?.price ?? '',
                    sellLeg?.qty.toString() ?? '',
                    sellLeg?.price ?? '',
                    i == 0 ? trade.brokerage.toStringAsFixed(2) : '',
                    i == 0 ? trade.profitLoss.toStringAsFixed(2) : '',
                  ],
                  colors: [
                    null,
                    null,
                    AppColors.blue,
                    AppColors.blue,
                    AppColors.red,
                    AppColors.red,
                    null,
                    trade.profitLoss >= 0 ? AppColors.blue : AppColors.red,
                  ],
                ),
              );
            }
            return legs;
          }),
          _buildRegularRow(
            [
              'TOTAL',
              '',
              '',
              '',
              '',
              '',
              report.summaryTotal.totalBrokerage.toStringAsFixed(2),
              report.summaryTotal.total.toStringAsFixed(2),
            ],
            isBold: true,
            backgroundColor: const Color(0xFFF3F4F6),
            colors: [
              null,
              null,
              null,
              null,
              null,
              null,
              null,
              report.summaryTotal.total >= 0 ? AppColors.blue : AppColors.red,
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRegularScriptWiseSummary() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD1D5DB)),
      ),
      child: Column(
        children: [
          _buildRegularRow([
            'EXCHANGE',
            'SCRIPT',
            'MTM',
            'BROKERAGE',
            'NET AMOUNT',
          ], isHeader: true),
          ...report.scriptWiseSummary.map(
            (s) => _buildRegularRow(
              [
                s.exchange,
                s.script,
                s.total.toStringAsFixed(2),
                s.brokerage.toStringAsFixed(2),
                s.net.toStringAsFixed(2),
              ],
              colors: [
                null,
                null,
                s.total >= 0 ? AppColors.blue : AppColors.red,
                null,
                s.net >= 0 ? AppColors.blue : AppColors.red,
              ],
            ),
          ),
          _buildRegularRow(
            [
              'TOTAL',
              '',
              report.summaryTotal.total.toStringAsFixed(2),
              report.summaryTotal.totalBrokerage.toStringAsFixed(2),
              report.summaryTotal.totalNet.toStringAsFixed(2),
            ],
            isBold: true,
            backgroundColor: const Color(0xFFF3F4F6),
            colors: [
              null,
              null,
              report.summaryTotal.total >= 0 ? AppColors.blue : AppColors.red,
              null,
              report.summaryTotal.totalNet >= 0
                  ? AppColors.blue
                  : AppColors.red,
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRegularCarryForward() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD1D5DB)),
      ),
      child: Column(
        children: [
          _buildRegularRow([
            'EXCHANGE',
            'SCRIPT',
            'POSITION',
            'QTY',
            'RATE',
          ], isHeader: true),
          ...report.carryForward.map(
            (cf) => _buildRegularRow(
              [
                cf.exchange,
                cf.script,
                cf.type.toUpperCase(),
                cf.quantity.toStringAsFixed(2),
                cf.price.toStringAsFixed(6),
              ],
              colors: [
                null,
                null,
                cf.type.toLowerCase() == 'buy' ? AppColors.blue : AppColors.red,
                null,
                AppColors.blue,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegularExchangeSummary() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD1D5DB)),
      ),
      child: Column(
        children: [
          _buildRegularRow([
            'EXCHANGE',
            'MTM',
            'BROKERAGE',
            'NET AMOUNT',
          ], isHeader: true),
          ...report.exchangeWisePL.map(
            (pl) => _buildRegularRow(
              [
                pl.exchange,
                pl.mtm.toStringAsFixed(2),
                pl.brok.toStringAsFixed(2),
                pl.pl.toStringAsFixed(2),
              ],
              colors: [
                null,
                pl.mtm >= 0 ? AppColors.blue : AppColors.red,
                null,
                pl.pl >= 0 ? AppColors.blue : AppColors.red,
              ],
            ),
          ),
          _buildRegularRow(
            [
              'TOTAL',
              report.summaryTotal.total.toStringAsFixed(2),
              report.summaryTotal.totalBrokerage.toStringAsFixed(2),
              report.summaryTotal.totalNet.toStringAsFixed(2),
            ],
            isBold: true,
            backgroundColor: const Color(0xFFF3F4F6),
            colors: [
              null,
              report.summaryTotal.total >= 0 ? AppColors.blue : AppColors.red,
              null,
              report.summaryTotal.totalNet >= 0
                  ? AppColors.blue
                  : AppColors.red,
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRegularRow(
    List<String> values, {
    bool isHeader = false,
    bool isBold = false,
    List<Color?>? colors,
    Color? backgroundColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? (isHeader ? Colors.white : null),
        border: Border(bottom: BorderSide(color: const Color(0xFFE5E7EB))),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
      child: Row(
        children: values.asMap().entries.map((entry) {
          final i = entry.key;
          final value = entry.value;
          return Expanded(
            child: Text(
              value,
              textAlign: i <= 1 ? TextAlign.left : TextAlign.right,
              style: GoogleFonts.openSans(
                fontSize: 11.sp,
                fontWeight: (isHeader || isBold)
                    ? FontWeight.bold
                    : FontWeight.w500,
                color: colors != null && colors[i] != null
                    ? colors[i]
                    : (isHeader ? const Color(0xFF4B5563) : Colors.black87),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHeader(BillHeaderInfo info) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Color(0xFF7E899B)),
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        children: [
          Text(
            info.userName,
            style: GoogleFonts.openSans(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'BILL SUMMARY ${info.dateRange.toUpperCase()}',
            style: GoogleFonts.openSans(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
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
        fontSize: 14.sp,
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
        fontSize: 14.sp,
        fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
        color: color ?? Colors.black87,
      ),
    );
  }
}