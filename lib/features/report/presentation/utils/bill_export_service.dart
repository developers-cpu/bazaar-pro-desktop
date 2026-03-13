import 'dart:io';

import 'package:excel/excel.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../domain/entities/bill_generate_report.dart';

class BillExportService {
  static Future<void> exportAsPdf(BillGenerateReport report) async {
    final fontRegular = await PdfGoogleFonts.openSansRegular();
    final fontBold = await PdfGoogleFonts.openSansBold();

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(base: fontRegular, bold: fontBold),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          final items = <pw.Widget>[];

          items.add(
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              color: PdfColors.blue50,
              width: double.infinity,
              child: pw.Column(
                children: [
                  pw.Text(
                    report.headerInfo.userName,
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    report.headerInfo.dateRange,
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          );
          items.add(pw.SizedBox(height: 16));

          for (final trade in report.scriptTrades) {
            items.add(
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
                          child: _buildPdfTradeLegTable('Buy', trade.buyLegs, PdfColors.green900),
                        ),
                        pw.Container(width: 1, height: 40, color: PdfColors.grey300),
                        pw.Expanded(
                          child: _buildPdfTradeLegTable('Sell', trade.sellLegs, PdfColors.red900),
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
                              _buildPdfSummaryRow('Total BVol:', trade.totalBuyVol.toStringAsFixed(2)),
                              _buildPdfSummaryRow('Total SVol:', trade.totalSellVol.toStringAsFixed(2)),
                              _buildPdfSummaryRow('Difference:', trade.netDifference.toStringAsFixed(2)),
                              _buildPdfSummaryRow('Brokerage:', trade.brokerage.toStringAsFixed(2)),
                              pw.SizedBox(height: 4),
                              _buildPdfSummaryRow('PROFIT/LOSS:', trade.profitLoss.toStringAsFixed(2), isBold: true),
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

          items.add(pw.SizedBox(height: 16));

          items.add(
            pw.Text(
              'General Summary',
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue,
              ),
            ),
          );
          items.add(pw.SizedBox(height: 8));

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

          items.add(
            pw.TableHelper.fromTextArray(
              headers: summaryData.first,
              data: summaryData.sublist(1),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              cellAlignment: pw.Alignment.centerRight,
            ),
          );

          return items;
        },
      ),
    );

    await _saveAndOpenFile(
      await pdf.save(),
      'Bill_Report_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }

  static Future<void> exportAsExcel(BillGenerateReport report) async {
    final excel = Excel.createExcel();
    final sheet = excel['Bill Generate Report'];
    excel.setDefaultSheet(sheet.sheetName);

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
      sheet.appendRow([TextCellValue('Total BVol:'), DoubleCellValue(trade.totalBuyVol)]);
      sheet.appendRow([TextCellValue('Total SVol:'), DoubleCellValue(trade.totalSellVol)]);
      sheet.appendRow([TextCellValue('Difference:'), DoubleCellValue(trade.netDifference)]);
      sheet.appendRow([TextCellValue('Brokerage:'), DoubleCellValue(trade.brokerage)]);
      sheet.appendRow([TextCellValue('PROFIT/LOSS:'), DoubleCellValue(trade.profitLoss)]);
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

    final List<int>? fileBytes = excel.save();
    if (fileBytes != null) {
      await _saveAndOpenFile(
        fileBytes,
        'Bill_Report_${DateTime.now().millisecondsSinceEpoch}.xlsx',
      );
    }
  }

  static Future<void> _saveAndOpenFile(List<int> bytes, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    await OpenFilex.open(file.path);
  }

  static pw.Widget _buildPdfTradeLegTable(String side, List<BillTradeLeg> legs, PdfColor textColor) {
    return pw.Column(
      children: [
        pw.Container(
          color: PdfColors.grey200,
          padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          child: pw.Row(
            children: [
              pw.Expanded(flex: 3, child: pw.Text('Date', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold))),
              pw.Expanded(flex: 2, child: pw.Text('Qty', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center)),
              pw.Expanded(flex: 2, child: pw.Text('Price', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right)),
              pw.Expanded(flex: 3, child: pw.Text('Vol', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right)),
            ],
          ),
        ),
        if (legs.isEmpty)
          pw.Padding(
            padding: const pw.EdgeInsets.all(4),
            child: pw.Text('No trades', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
          ),
        ...legs.map(
          (leg) => pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 2, horizontal: 4),
            decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey200))),
            child: pw.Row(
              children: [
                pw.Expanded(flex: 3, child: pw.Text(leg.date, style: const pw.TextStyle(fontSize: 8))),
                pw.Expanded(flex: 2, child: pw.Text(leg.qty.toString(), style: pw.TextStyle(fontSize: 8, color: textColor), textAlign: pw.TextAlign.center)),
                pw.Expanded(flex: 2, child: pw.Text(leg.price, style: const pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.right)),
                pw.Expanded(flex: 3, child: pw.Text(leg.vol.toStringAsFixed(2), style: const pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.right)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildPdfSummaryRow(String label, String value, {bool isBold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 1),
      child: pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(fontSize: 9, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal),
          ),
          pw.SizedBox(width: 20),
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: 9, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
