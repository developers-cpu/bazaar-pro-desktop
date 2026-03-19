import 'dart:io';
import 'package:excel/excel.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../domain/entities/bill_generate_report.dart';

class BillExportService {
  static Future<void> exportAsPdf(
    BillGenerateReport report, {
    String? billType,
  }) async {
    final fontRegular = await PdfGoogleFonts.openSansRegular();
    final fontBold = await PdfGoogleFonts.openSansBold();
    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(base: fontRegular, bold: fontBold),
    );
    final isRegular = billType?.toLowerCase() == 'regular';
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
          final items = <pw.Widget>[];
          if (isRegular) {
            items.addAll(_buildRegularPdfBody(report));
          } else {
            items.addAll(_buildAdvancePdfBody(report));
          }
          return items;
        },
      ),
    );
    await _saveAndOpenFile(
      await pdf.save(),
      'Bill_Report_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }

  static List<pw.Widget> _buildAdvancePdfBody(BillGenerateReport report) {
    final items = <pw.Widget>[];
    items.add(
      pw.Container(
        width: double.infinity,
        decoration: pw.BoxDecoration(
          color: PdfColor.fromHex('7E899B'),
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
        ),
        padding: const pw.EdgeInsets.symmetric(vertical: 20),
        child: pw.Column(
          children: [
            pw.Text(
              report.headerInfo.userName,
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              'BILL SUMMARY ${report.headerInfo.dateRange.toUpperCase()}',
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
            ),
          ],
        ),
      ),
    );
    items.add(pw.SizedBox(height: 16));
    final bodyItems = <pw.Widget>[];
    for (final trade in report.scriptTrades) {
      bodyItems.add(
        pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 16),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                padding: const pw.EdgeInsets.all(6),
                width: double.infinity,
                child: pw.Text(
                  '${trade.exchange} ${trade.script}',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue900,
                  ),
                ),
              ),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: _buildPdfTradeLegTable(
                      'Buy',
                      trade.buyLegs,
                      PdfColors.green900,
                    ),
                  ),
                  pw.Container(width: 1, height: 40, color: PdfColors.grey300),
                  pw.Expanded(
                    child: _buildPdfTradeLegTable(
                      'Sell',
                      trade.sellLegs,
                      PdfColors.red900,
                    ),
                  ),
                ],
              ),
              pw.Divider(height: 1, color: PdfColors.grey300),
              pw.Padding(
                padding: const pw.EdgeInsets.all(6),
                child: pw.Row(
                  children: [
                    pw.Spacer(),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        _buildPdfSummaryRow(
                          'Total BVol:',
                          trade.totalBuyVol.toStringAsFixed(2),
                        ),
                        _buildPdfSummaryRow(
                          'Total SVol:',
                          trade.totalSellVol.toStringAsFixed(2),
                        ),
                        _buildPdfSummaryRow(
                          'Difference:',
                          trade.netDifference.toStringAsFixed(2),
                        ),
                        _buildPdfSummaryRow(
                          'Brokerage:',
                          trade.brokerage.toStringAsFixed(2),
                        ),
                        pw.SizedBox(height: 4),
                        _buildPdfSummaryRow(
                          'PROFIT/LOSS:',
                          trade.profitLoss.toStringAsFixed(2),
                          isBold: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    bodyItems.add(pw.SizedBox(height: 16));
    bodyItems.add(
      pw.Text(
        'General Summary',
        style: pw.TextStyle(
          fontSize: 16,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.blue,
        ),
      ),
    );
    bodyItems.add(pw.SizedBox(height: 8));
    final summaryData = [
      ['Exch', 'Script', 'Total(MTM)', 'Brokerage', 'Net Amount'],
      ...report.scriptWiseSummary.map(
        (s) => [
          s.exchange,
          s.script,
          s.total.toStringAsFixed(2),
          s.brokerage.toStringAsFixed(2),
          s.net.toStringAsFixed(2),
        ],
      ),
      [
        'TOTAL',
        '',
        report.summaryTotal.total.toStringAsFixed(2),
        report.summaryTotal.totalBrokerage.toStringAsFixed(2),
        report.summaryTotal.totalNet.toStringAsFixed(2),
      ],
    ];
    bodyItems.add(
      pw.TableHelper.fromTextArray(
        headers: summaryData.first,
        data: summaryData.sublist(1),
        headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        cellAlignment: pw.Alignment.centerRight,
      ),
    );
    items.add(
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 24),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: bodyItems,
        ),
      ),
    );
    return items;
  }

  static List<pw.Widget> _buildRegularPdfBody(BillGenerateReport report) {
    final items = <pw.Widget>[];

    items.add(
      pw.Container(
        width: double.infinity,
        decoration: pw.BoxDecoration(color: PdfColor.fromHex('7E899B')),
        padding: const pw.EdgeInsets.symmetric(vertical: 20),
        child: pw.Column(
          children: [
            pw.Text(
              report.headerInfo.userName,
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              'BILL SUMMARY ${report.headerInfo.dateRange.toUpperCase()}',
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
            ),
          ],
        ),
      ),
    );
    items.add(pw.SizedBox(height: 20));
    final bodyItems = <pw.Widget>[];

    bodyItems.add(_buildPdfRegularSectionTitle('EXCHANGE / TRADES'));

    final tradeData = <pw.Widget>[];

    tradeData.add(
      _buildPdfRegularRow([
        'EXCHANGE',
        'SCRIPT',
        'BUY QTY',
        'BUY PRICE',
        'SELL QTY',
        'SELL PRICE',
        'BROKERAGE',
        'PROFIT/LOSS',
      ], isHeader: true),
    );

    for (final trade in report.scriptTrades) {
      final maxLen = trade.buyLegs.length > trade.sellLegs.length
          ? trade.buyLegs.length
          : trade.sellLegs.length;
      for (int i = 0; i < maxLen; i++) {
        final buyLeg = i < trade.buyLegs.length ? trade.buyLegs[i] : null;
        final sellLeg = i < trade.sellLegs.length ? trade.sellLegs[i] : null;
        tradeData.add(
          _buildPdfRegularRow(
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
              PdfColor.fromHex('1E40AF'),
              PdfColor.fromHex('1E40AF'),
              PdfColor.fromHex('B91C1C'),
              PdfColor.fromHex('B91C1C'),
              null,
              trade.profitLoss >= 0
                  ? PdfColor.fromHex('1E40AF')
                  : PdfColor.fromHex('B91C1C'),
            ],
          ),
        );
      }
    }

    tradeData.add(
      _buildPdfRegularRow(
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
        colors: [
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          report.summaryTotal.total >= 0
              ? PdfColor.fromHex('1E40AF')
              : PdfColor.fromHex('B91C1C'),
        ],
      ),
    );
    bodyItems.add(
      pw.Container(
        decoration: pw.BoxDecoration(
          border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
        ),
        child: pw.Column(children: tradeData),
      ),
    );
    bodyItems.add(pw.SizedBox(height: 25));

    bodyItems.add(_buildPdfRegularSectionTitle('SCRIPT WISE SUMMARY'));
    final scriptSummaryRows = <pw.Widget>[];
    scriptSummaryRows.add(
      _buildPdfRegularRow([
        'EXCHANGE',
        'SCRIPT',
        'MTM',
        'BROKERAGE',
        'NET AMOUNT',
      ], isHeader: true),
    );

    for (final s in report.scriptWiseSummary) {
      scriptSummaryRows.add(
        _buildPdfRegularRow(
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
            s.total >= 0
                ? PdfColor.fromHex('1E40AF')
                : PdfColor.fromHex('B91C1C'),
            null,
            s.net >= 0
                ? PdfColor.fromHex('1E40AF')
                : PdfColor.fromHex('B91C1C'),
          ],
        ),
      );
    }

    scriptSummaryRows.add(
      _buildPdfRegularRow(
        [
          'TOTAL',
          '',
          report.summaryTotal.total.toStringAsFixed(2),
          report.summaryTotal.totalBrokerage.toStringAsFixed(2),
          report.summaryTotal.totalNet.toStringAsFixed(2),
        ],
        isBold: true,
        colors: [
          null,
          null,
          report.summaryTotal.total >= 0
              ? PdfColor.fromHex('1E40AF')
              : PdfColor.fromHex('B91C1C'),
          null,
          report.summaryTotal.totalNet >= 0
              ? PdfColor.fromHex('1E40AF')
              : PdfColor.fromHex('B91C1C'),
        ],
      ),
    );
    bodyItems.add(
      pw.Container(
        decoration: pw.BoxDecoration(
          border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
        ),
        child: pw.Column(children: scriptSummaryRows),
      ),
    );
    bodyItems.add(pw.SizedBox(height: 25));

    if (report.carryForward.isNotEmpty) {
      bodyItems.add(_buildPdfRegularSectionTitle('CARRY FORWARD SYMBOLS'));
      final cfRows = <pw.Widget>[];
      cfRows.add(
        _buildPdfRegularRow([
          'EXCHANGE',
          'SCRIPT',
          'POSITION',
          'QTY',
          'RATE',
        ], isHeader: true),
      );
      for (final cf in report.carryForward) {
        cfRows.add(
          _buildPdfRegularRow(
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
              cf.type.toLowerCase() == 'buy'
                  ? PdfColor.fromHex('1E40AF')
                  : PdfColor.fromHex('B91C1C'),
              null,
              PdfColor.fromHex('1E40AF'),
            ],
          ),
        );
      }
      bodyItems.add(
        pw.Container(
          decoration: pw.BoxDecoration(
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
          ),
          child: pw.Column(children: cfRows),
        ),
      );
      bodyItems.add(pw.SizedBox(height: 25));
    }

    if (report.exchangeWisePL.isNotEmpty) {
      bodyItems.add(_buildPdfRegularSectionTitle('EXCHANGE WISE SUMMARY'));
      final exSummaryRows = <pw.Widget>[];
      exSummaryRows.add(
        _buildPdfRegularRow([
          'EXCHANGE',
          'MTM',
          'BROKERAGE',
          'NET AMOUNT',
        ], isHeader: true),
      );
      for (final pl in report.exchangeWisePL) {
        exSummaryRows.add(
          _buildPdfRegularRow(
            [
              pl.exchange,
              pl.mtm.toStringAsFixed(2),
              pl.brok.toStringAsFixed(2),
              pl.pl.toStringAsFixed(2),
            ],
            colors: [
              null,
              pl.mtm >= 0
                  ? PdfColor.fromHex('1E40AF')
                  : PdfColor.fromHex('B91C1C'),
              null,
              pl.pl >= 0
                  ? PdfColor.fromHex('1E40AF')
                  : PdfColor.fromHex('B91C1C'),
            ],
          ),
        );
      }

      exSummaryRows.add(
        _buildPdfRegularRow(
          [
            'TOTAL',
            report.summaryTotal.total.toStringAsFixed(2),
            report.summaryTotal.totalBrokerage.toStringAsFixed(2),
            report.summaryTotal.totalNet.toStringAsFixed(2),
          ],
          isBold: true,
          colors: [
            null,
            report.summaryTotal.total >= 0
                ? PdfColor.fromHex('1E40AF')
                : PdfColor.fromHex('B91C1C'),
            null,
            report.summaryTotal.totalNet >= 0
                ? PdfColor.fromHex('1E40AF')
                : PdfColor.fromHex('B91C1C'),
          ],
        ),
      );
      bodyItems.add(
        pw.Container(
          decoration: pw.BoxDecoration(
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
          ),
          child: pw.Column(children: exSummaryRows),
        ),
      );
    }
    items.add(
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 24),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: bodyItems,
        ),
      ),
    );
    return items;
  }

  static pw.Widget _buildPdfRegularRow(
    List<String> values, {
    bool isHeader = false,
    bool isBold = false,
    List<PdfColor?>? colors,
  }) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        color: isHeader ? PdfColors.white : null,
        border: const pw.Border(
          bottom: pw.BorderSide(color: PdfColors.grey200, width: 0.5),
        ),
      ),
      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: pw.Row(
        children: values.asMap().entries.map((entry) {
          final i = entry.key;
          final value = entry.value;
          return pw.Expanded(
            child: pw.Text(
              value,
              textAlign: i <= 1 ? pw.TextAlign.left : pw.TextAlign.right,
              style: pw.TextStyle(
                fontSize: 8,
                fontWeight: (isHeader || isBold)
                    ? pw.FontWeight.bold
                    : pw.FontWeight.normal,
                color: colors != null && i < colors.length && colors[i] != null
                    ? colors[i]!
                    : (isHeader ? PdfColors.grey700 : PdfColors.black),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  static pw.Widget _buildPdfRegularSectionTitle(String title) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex('E9EBED'),
        borderRadius: const pw.BorderRadius.only(
          topLeft: pw.Radius.circular(4),
          topRight: pw.Radius.circular(4),
        ),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: pw.FontWeight.bold,
          color: PdfColor.fromHex('5A6677'),
        ),
      ),
    );
  }

  static Future<void> exportAsExcel(
    BillGenerateReport report, {
    String? billType,
  }) async {
    final excel = Excel.createExcel();
    final sheet = excel['Bill Generate Report'];
    excel.setDefaultSheet(sheet.sheetName);
    final isRegular = billType?.toLowerCase() == 'regular';
    if (isRegular) {
      _buildRegularExcelBody(sheet, report);
    } else {
      _buildAdvanceExcelBody(sheet, report);
    }
    final List<int>? fileBytes = excel.save();
    if (fileBytes != null) {
      await _saveAndOpenFile(
        fileBytes,
        'Bill_Report_${DateTime.now().millisecondsSinceEpoch}.xlsx',
      );
    }
  }

  static void _buildAdvanceExcelBody(Sheet sheet, BillGenerateReport report) {
    sheet.appendRow([
      TextCellValue('Bill Report - ${report.headerInfo.userName}'),
    ]);
    sheet.appendRow([TextCellValue(report.headerInfo.dateRange)]);
    sheet.appendRow([TextCellValue('')]);
    sheet.appendRow([TextCellValue('Trades')]);
    sheet.appendRow([
      TextCellValue('Script'),
      TextCellValue('Buy Vol'),
      TextCellValue('Sell Vol'),
      TextCellValue('Difference'),
      TextCellValue('Brokerage'),
      TextCellValue('P/L'),
    ]);
    for (final trade in report.scriptTrades) {
      sheet.appendRow([TextCellValue('${trade.exchange} ${trade.script}')]);
      sheet.appendRow([TextCellValue('BUY TRADES')]);
      sheet.appendRow([
        TextCellValue('Date'),
        TextCellValue('Qty'),
        TextCellValue('Price'),
        TextCellValue('Volume'),
      ]);
      for (final leg in trade.buyLegs) {
        sheet.appendRow([
          TextCellValue(leg.date),
          DoubleCellValue(leg.qty.toDouble()),
          DoubleCellValue(double.tryParse(leg.price) ?? 0.0),
          DoubleCellValue(leg.vol),
        ]);
      }
      sheet.appendRow([TextCellValue('SELL TRADES')]);
      sheet.appendRow([
        TextCellValue('Date'),
        TextCellValue('Qty'),
        TextCellValue('Price'),
        TextCellValue('Volume'),
      ]);
      for (final leg in trade.sellLegs) {
        sheet.appendRow([
          TextCellValue(leg.date),
          DoubleCellValue(leg.qty.toDouble()),
          DoubleCellValue(double.tryParse(leg.price) ?? 0.0),
          DoubleCellValue(leg.vol),
        ]);
      }
      sheet.appendRow([TextCellValue('Script Summary')]);
      sheet.appendRow([
        TextCellValue('Total BVol:'),
        DoubleCellValue(trade.totalBuyVol),
      ]);
      sheet.appendRow([
        TextCellValue('Total SVol:'),
        DoubleCellValue(trade.totalSellVol),
      ]);
      sheet.appendRow([
        TextCellValue('Difference:'),
        DoubleCellValue(trade.netDifference),
      ]);
      sheet.appendRow([
        TextCellValue('Brokerage:'),
        DoubleCellValue(trade.brokerage),
      ]);
      sheet.appendRow([
        TextCellValue('PROFIT/LOSS:'),
        DoubleCellValue(trade.profitLoss),
      ]);
      sheet.appendRow([TextCellValue('')]);
    }
    sheet.appendRow([TextCellValue('General Summary')]);
    sheet.appendRow([
      TextCellValue('Exchange'),
      TextCellValue('Script'),
      TextCellValue('Total(MTM)'),
      TextCellValue('Brokerage'),
      TextCellValue('Net Amount'),
    ]);
    for (final s in report.scriptWiseSummary) {
      sheet.appendRow([
        TextCellValue(s.exchange),
        TextCellValue(s.script),
        DoubleCellValue(s.total),
        DoubleCellValue(s.brokerage),
        DoubleCellValue(s.net),
      ]);
    }
    sheet.appendRow([
      TextCellValue('TOTAL'),
      TextCellValue(''),
      DoubleCellValue(report.summaryTotal.total),
      DoubleCellValue(report.summaryTotal.totalBrokerage),
      DoubleCellValue(report.summaryTotal.totalNet),
    ]);
  }

  static void _buildRegularExcelBody(Sheet sheet, BillGenerateReport report) {
    sheet.appendRow([TextCellValue(report.headerInfo.userName.toUpperCase())]);
    sheet.appendRow([
      TextCellValue(
        'BILL SUMMARY ${report.headerInfo.dateRange.toUpperCase()}',
      ),
    ]);
    sheet.appendRow([TextCellValue('')]);
    sheet.appendRow([TextCellValue('EXCHANGE / TRADES')]);
    sheet.appendRow([
      TextCellValue('EXCHANGE'),
      TextCellValue('SCRIPT'),
      TextCellValue('BUY QTY'),
      TextCellValue('BUY PRICE'),
      TextCellValue('SELL QTY'),
      TextCellValue('SELL PRICE'),
      TextCellValue('BROKERAGE'),
      TextCellValue('PROFIT/LOSS'),
    ]);
    for (final trade in report.scriptTrades) {
      final maxLen = trade.buyLegs.length > trade.sellLegs.length
          ? trade.buyLegs.length
          : trade.sellLegs.length;
      for (int i = 0; i < maxLen; i++) {
        final buyLeg = i < trade.buyLegs.length ? trade.buyLegs[i] : null;
        final sellLeg = i < trade.sellLegs.length ? trade.sellLegs[i] : null;
        sheet.appendRow([
          TextCellValue(trade.exchange),
          TextCellValue(trade.script),
          buyLeg != null
              ? DoubleCellValue(buyLeg.qty.toDouble())
              : TextCellValue(''),
          buyLeg != null
              ? DoubleCellValue(double.tryParse(buyLeg.price) ?? 0.0)
              : TextCellValue(''),
          sellLeg != null
              ? DoubleCellValue(sellLeg.qty.toDouble())
              : TextCellValue(''),
          sellLeg != null
              ? DoubleCellValue(double.tryParse(sellLeg.price) ?? 0.0)
              : TextCellValue(''),
          i == 0 ? DoubleCellValue(trade.brokerage) : TextCellValue(''),
          i == 0 ? DoubleCellValue(trade.profitLoss) : TextCellValue(''),
        ]);
      }
    }
    sheet.appendRow([
      TextCellValue('TOTAL'),
      TextCellValue(''),
      TextCellValue(''),
      TextCellValue(''),
      TextCellValue(''),
      TextCellValue(''),
      DoubleCellValue(report.summaryTotal.totalBrokerage),
      DoubleCellValue(report.summaryTotal.total),
    ]);
    sheet.appendRow([TextCellValue('')]);
    sheet.appendRow([TextCellValue('SCRIPT WISE SUMMARY')]);
    sheet.appendRow([
      TextCellValue('EXCHANGE'),
      TextCellValue('SCRIPT'),
      TextCellValue('MTM'),
      TextCellValue('BROKERAGE'),
      TextCellValue('NET AMOUNT'),
    ]);
    for (final s in report.scriptWiseSummary) {
      sheet.appendRow([
        TextCellValue(s.exchange),
        TextCellValue(s.script),
        DoubleCellValue(s.total),
        DoubleCellValue(s.brokerage),
        DoubleCellValue(s.net),
      ]);
    }
    sheet.appendRow([
      TextCellValue('TOTAL'),
      TextCellValue(''),
      DoubleCellValue(report.summaryTotal.total),
      DoubleCellValue(report.summaryTotal.totalBrokerage),
      DoubleCellValue(report.summaryTotal.totalNet),
    ]);
    sheet.appendRow([TextCellValue('')]);
    if (report.carryForward.isNotEmpty) {
      sheet.appendRow([TextCellValue('CARRY FORWARD SYMBOLS')]);
      sheet.appendRow([
        TextCellValue('EXCHANGE'),
        TextCellValue('SCRIPT'),
        TextCellValue('POSITION'),
        TextCellValue('QTY'),
        TextCellValue('RATE'),
      ]);
      for (final cf in report.carryForward) {
        sheet.appendRow([
          TextCellValue(cf.exchange),
          TextCellValue(cf.script),
          TextCellValue(cf.type.toUpperCase()),
          DoubleCellValue(cf.quantity),
          DoubleCellValue(cf.price),
        ]);
      }
      sheet.appendRow([TextCellValue('')]);
    }
    if (report.exchangeWisePL.isNotEmpty) {
      sheet.appendRow([TextCellValue('EXCHANGE WISE SUMMARY')]);
      sheet.appendRow([
        TextCellValue('EXCHANGE'),
        TextCellValue('MTM'),
        TextCellValue('BROKERAGE'),
        TextCellValue('NET AMOUNT'),
      ]);
      for (final pl in report.exchangeWisePL) {
        sheet.appendRow([
          TextCellValue(pl.exchange),
          DoubleCellValue(pl.mtm),
          DoubleCellValue(pl.brok),
          DoubleCellValue(pl.pl),
        ]);
      }
      sheet.appendRow([
        TextCellValue('TOTAL'),
        DoubleCellValue(report.summaryTotal.total),
        DoubleCellValue(report.summaryTotal.totalBrokerage),
        DoubleCellValue(report.summaryTotal.totalNet),
      ]);
    }
  }

  static Future<void> _saveAndOpenFile(List<int> bytes, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    await OpenFilex.open(file.path);
  }

  static pw.Widget _buildPdfTradeLegTable(
    String side,
    List<BillTradeLeg> legs,
    PdfColor textColor,
  ) {
    return pw.Column(
      children: [
        pw.Container(
          color: PdfColors.grey200,
          padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          child: pw.Row(
            children: [
              pw.Expanded(
                flex: 3,
                child: pw.Text(
                  'Date',
                  style: pw.TextStyle(
                    fontSize: 8,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Expanded(
                flex: 2,
                child: pw.Text(
                  'Qty',
                  style: pw.TextStyle(
                    fontSize: 8,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Expanded(
                flex: 2,
                child: pw.Text(
                  'Price',
                  style: pw.TextStyle(
                    fontSize: 8,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.right,
                ),
              ),
              pw.Expanded(
                flex: 3,
                child: pw.Text(
                  'Vol',
                  style: pw.TextStyle(
                    fontSize: 8,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        if (legs.isEmpty)
          pw.Padding(
            padding: const pw.EdgeInsets.all(4),
            child: pw.Text(
              'No trades',
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey),
            ),
          ),
        ...legs.map(
          (leg) => pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 2, horizontal: 4),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(color: PdfColors.grey200),
              ),
            ),
            child: pw.Row(
              children: [
                pw.Expanded(
                  flex: 3,
                  child: pw.Text(
                    leg.date,
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Text(
                    leg.qty.toString(),
                    style: pw.TextStyle(fontSize: 8, color: textColor),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Text(
                    leg.price,
                    style: const pw.TextStyle(fontSize: 8),
                    textAlign: pw.TextAlign.right,
                  ),
                ),
                pw.Expanded(
                  flex: 3,
                  child: pw.Text(
                    leg.vol.toStringAsFixed(2),
                    style: const pw.TextStyle(fontSize: 8),
                    textAlign: pw.TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildPdfSummaryRow(
    String label,
    String value, {
    bool isBold = false,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 1),
      child: pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          pw.SizedBox(width: 20),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}