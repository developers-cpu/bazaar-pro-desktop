import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import '../../domain/entities/broker_list/client_breakdown.dart';

class ClientBreakdownService {
  static Future<void> exportAsPdf(ClientBreakdown breakdown) async {
    final fontRegular = await PdfGoogleFonts.openSansRegular();
    final fontBold = await PdfGoogleFonts.openSansBold();
    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(base: fontRegular, bold: fontBold),
    );
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          final items = <pw.Widget>[];

          items.add(
            pw.Center(
              child: pw.Text(
                "Detailed Client Breakdown",
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue900,
                ),
              ),
            ),
          );
          items.add(pw.SizedBox(height: 20));

          items.add(
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              color: PdfColors.blueGrey800,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    "BROKER Id : ${breakdown.brokerId}",
                    style: pw.TextStyle(color: PdfColors.white, fontSize: 12),
                  ),
                  pw.Text(
                    "Client name : ${breakdown.clientName}",
                    style: pw.TextStyle(color: PdfColors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          );
          items.add(pw.SizedBox(height: 20));

          for (final section in breakdown.sections) {
            items.add(_buildSection(section));
            items.add(pw.SizedBox(height: 16));
          }
          return items;
        },
      ),
    );
    final fileName =
        'Client_Breakdown_${breakdown.clientName}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    await _saveAndOpenFile(await pdf.save(), fileName);
  }

  static pw.Widget _buildSection(ClientBreakdownSection section) {
    return pw.Column(
      children: [
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.symmetric(vertical: 4),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300),
          ),
          alignment: pw.Alignment.center,
          child: pw.Text(
            section.title,
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
        ),

        pw.TableHelper.fromTextArray(
          headers: [
            section.isSymbolBased ? 'SYMBOL' : 'EXCHNAGE',
            'TURNOVER',
            'BROKRAGE',
          ],
          data: section.rows
              .map(
                (row) => [
                  row.label,
                  row.turnover,
                  row.brokerage.toStringAsFixed(0),
                ],
              )
              .toList(),
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.blue50),
          cellAlignment: pw.Alignment.center,
          border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
        ),

        if (section.hasFooter)
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
              color: PdfColors.grey100,
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Expanded(
                  child: pw.Text(
                    'TOTAL',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Expanded(child: pw.SizedBox()),
                pw.Expanded(
                  child: pw.Text(
                    section.rows
                        .fold(0.0, (sum, row) => sum + row.brokerage)
                        .toStringAsFixed(0),
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  static Future<void> _saveAndOpenFile(List<int> bytes, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    await OpenFilex.open(file.path);
  }
}
