import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/dashboard_entity.dart';
class SymbolWiseChart extends StatelessWidget {
  final List<SymbolReportData> data;
  const SymbolWiseChart({Key? key, required this.data}) : super(key: key);
  static const List<Color> _chartColors = [
    Color(0xFF5B8DEF),
    Color(0xFFB8A8E8),
    Color(0xFFFF9B8A),
    Color(0xFF6EC4DB),
    Color(0xFFFFB347),
    Color(0xFF5CB89D),
    Color(0xFF5B9BD5),
    Color(0xFF9B7EBD),
    Color(0xFFE8D44D),
    Color(0xFF4EC4DB),
    Color(0xFFFFB340),
    Color(0xFF8B7EBD),
    Color(0xFFE57373),
    Color(0xFF64B5F6),
    Color(0xFF81C784),
  ];
  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: GoogleFonts.openSans(
            fontSize: 14.sp,
            color: LightThemeColors.supportiveTextColor,
          ),
        ),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final availableHeight = constraints.maxHeight;
        final showLegendSide = availableWidth > 500;
        if (showLegendSide) {
          return Row(
            children: [
              Expanded(
                flex: 3,
                child: CustomPaint(
                  size: Size(availableWidth * 0.75, availableHeight),
                  painter: _PieChartPainter(data: data, colors: _chartColors),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(flex: 1, child: _buildLegend()),
            ],
          );
        }
        return Column(
          children: [
            Expanded(
              child: CustomPaint(
                size: Size(availableWidth, availableHeight * 0.8),
                painter: _PieChartPainter(data: data, colors: _chartColors),
              ),
            ),
            SizedBox(height: 8.h),
            _buildLegend(),
          ],
        );
      },
    );
  }
  Widget _buildLegend() {
    final halfLen = (data.length / 2).ceil();
    final col1 = data.take(halfLen).toList();
    final col2 = data.skip(halfLen).toList();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: col1.map((item) => _legendItem(item)).toList(),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: col2.map((item) => _legendItem(item)).toList(),
            ),
          ),
        ],
      ),
    );
  }
  Widget _legendItem(SymbolReportData item) {
    final color = _chartColors[item.colorIndex % _chartColors.length];
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 6.w),
          Flexible(
            child: Text(
              item.symbol,
              style: GoogleFonts.openSans(
                fontSize: 9.sp,
                fontWeight: FontWeight.w600,
                color: LightThemeColors.textColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
class _PieChartPainter extends CustomPainter {
  final List<SymbolReportData> data;
  final List<Color> colors;
  _PieChartPainter({required this.data, required this.colors});
  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final n = data.length;
    final total = data.fold<double>(0, (s, d) => s + d.percentage);
    final labelFontSize = math.max(8.5, math.min(11.0, size.width / 55));
    final pieRadius = math.min(size.width, size.height) * 0.40;
    final center = Offset(size.width / 2, size.height / 2);
    final sweeps = <double>[];
    final midAngles = <double>[];
    double startAngle = -math.pi / 2;
    for (int i = 0; i < n; i++) {
      final sweep = (data[i].percentage / total) * 2 * math.pi;
      sweeps.add(sweep);
      midAngles.add(startAngle + sweep / 2);
      startAngle += sweep;
    }
    startAngle = -math.pi / 2;
    for (int i = 0; i < n; i++) {
      final color = colors[data[i].colorIndex % colors.length];
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: pieRadius),
        startAngle,
        sweeps[i],
        true,
        paint,
      );
      startAngle += sweeps[i];
    }
    final leftIndices = <int>[];
    final rightIndices = <int>[];
    for (int i = 0; i < n; i++) {
      final a = midAngles[i];
      final normalized = (a % (2 * math.pi) + 2 * math.pi) % (2 * math.pi);
      if (normalized > math.pi / 2 && normalized < 3 * math.pi / 2) {
        leftIndices.add(i);
      } else {
        rightIndices.add(i);
      }
    }
    leftIndices.sort(
      (a, b) => math.sin(midAngles[a]).compareTo(math.sin(midAngles[b])),
    );
    rightIndices.sort(
      (a, b) => math.sin(midAngles[a]).compareTo(math.sin(midAngles[b])),
    );
    final minLabelSpacing = labelFontSize * 2.8;
    List<double> resolveOverlaps(List<int> indices) {
      final ys = <double>[];
      for (final idx in indices) {
        final naturalY =
            center.dy + pieRadius * 1.15 * math.sin(midAngles[idx]);
        ys.add(naturalY);
      }
      for (int i = 1; i < ys.length; i++) {
        if (ys[i] - ys[i - 1] < minLabelSpacing) {
          ys[i] = ys[i - 1] + minLabelSpacing;
        }
      }
      return ys;
    }
    final leftYs = resolveOverlaps(leftIndices);
    final rightYs = resolveOverlaps(rightIndices);
    void drawLabel(int dataIndex, double labelY, bool isLeft) {
      final color = colors[data[dataIndex].colorIndex % colors.length];
      final midAngle = midAngles[dataIndex];
      final edgeX = center.dx + pieRadius * math.cos(midAngle);
      final edgeY = center.dy + pieRadius * math.sin(midAngle);
      final symbolPainter = TextPainter(
        text: TextSpan(
          text: data[dataIndex].symbol,
          style: TextStyle(
            fontSize: labelFontSize,
            fontWeight: FontWeight.w500,
            color: LightThemeColors.textColor,
            letterSpacing: 0.2,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: size.width * 0.28);
      final valuePainter = TextPainter(
        text: TextSpan(
          text:
              '${data[dataIndex].value.toStringAsFixed(2)}  ${data[dataIndex].percentage.toStringAsFixed(2)}%',
          style: TextStyle(
            fontSize: labelFontSize,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: size.width * 0.28);
      final textMaxWidth = math.max(symbolPainter.width, valuePainter.width);
      double hTurnX;
      if (isLeft) {
        hTurnX = math.min(edgeX, center.dx - pieRadius * 1.15);
      } else {
        hTurnX = math.max(edgeX, center.dx + pieRadius * 1.15);
      }
      final connectorPaint = Paint()
        ..color = color
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        Offset(edgeX, edgeY),
        Offset(hTurnX, labelY),
        connectorPaint,
      );
      if (isLeft) {
        final textStartX = hTurnX - textMaxWidth;
        canvas.drawLine(
          Offset(hTurnX, labelY),
          Offset(textStartX, labelY),
          connectorPaint,
        );
        symbolPainter.paint(
          canvas,
          Offset(textStartX, labelY - 2 - symbolPainter.height),
        );
        valuePainter.paint(canvas, Offset(textStartX, labelY + 2));
      } else {
        final textEndX = hTurnX + textMaxWidth;
        canvas.drawLine(
          Offset(hTurnX, labelY),
          Offset(textEndX, labelY),
          connectorPaint,
        );
        symbolPainter.paint(
          canvas,
          Offset(
            textEndX - symbolPainter.width,
            labelY - 2 - symbolPainter.height,
          ),
        );
        valuePainter.paint(
          canvas,
          Offset(textEndX - valuePainter.width, labelY + 2),
        );
      }
    }
    for (int ii = 0; ii < leftIndices.length; ii++) {
      drawLabel(leftIndices[ii], leftYs[ii], true);
    }
    for (int ii = 0; ii < rightIndices.length; ii++) {
      drawLabel(rightIndices[ii], rightYs[ii], false);
    }
  }
  @override
  bool shouldRepaint(_PieChartPainter oldDelegate) => oldDelegate.data != data;
}
