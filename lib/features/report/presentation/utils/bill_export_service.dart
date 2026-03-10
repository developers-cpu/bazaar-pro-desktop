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
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        '${trade.exchange} ${trade.script}',
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blue,
                        ),
                      ),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Buy Vol: ${trade.totalBuyVol.toStringAsFixed(2)}',
                          ),
                          pw.Text(
                            'Sell Vol: ${trade.totalSellVol.toStringAsFixed(2)}',
                          ),
                          pw.Text(
                            'Brokerage: ${trade.brokerage.toStringAsFixed(2)}',
                          ),
                          pw.Text(
                            'P/L: ${trade.profitLoss.toStringAsFixed(2)}',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
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
      sheet.appendRow([
        TextCellValue('${trade.exchange} ${trade.script}'),
        DoubleCellValue(trade.totalBuyVol),
        DoubleCellValue(trade.totalSellVol),
        DoubleCellValue(trade.netDifference),
        DoubleCellValue(trade.brokerage),
        DoubleCellValue(trade.profitLoss),
      ]);
    }

    sheet.appendRow([TextCellValue('')]);

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
}
