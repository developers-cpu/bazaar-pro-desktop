import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/dashboard_entity.dart';

/// Symbol Wise Report Pie Chart Widget with connector lines
class SymbolWiseChart extends StatefulWidget {
  final List<SymbolReportData> data;

  const SymbolWiseChart({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<SymbolWiseChart> createState() => _SymbolWiseChartState();
}

class _SymbolWiseChartState extends State<SymbolWiseChart> {
  int? _touchedIndex;

  static const List<Color> _chartColors = [
    Color(0xFF5B8DEF), // Blue - GIFTNIFTY
    Color(0xFFB8A8E8), // Light Purple - DOWJONES
    Color(0xFFFF9B8A), // Coral/Orange - NASDAQ
    Color(0xFF6EC4DB), // Cyan - GOLD
    Color(0xFFFFB347), // Orange - COPPER
    Color(0xFF7CB89D), // Green - ETHUSD
    Color(0xFF5B9BD5), // Bright Blue - BTUSD
    Color(0xFF9B7EBD), // Purple - CRUDOIL
    Color(0xFFE8D44D), // Yellow - NATURALGAS
    Color(0xFF6EC4DB), // Cyan - SILVER
    Color(0xFFFFB347), // Orange - COPPER
    Color(0xFF9B7EBD), // Purple - GOLD
  ];

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
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
        final availableHeight = constraints.maxHeight;
        final availableWidth = constraints.maxWidth;
        final chartAreaWidth = availableWidth * 0.75;
        final chartSize = math.min(chartAreaWidth, availableHeight) * 0.95;

        return Row(
          children: [

            Expanded(
              flex: 3,
              child: Center(
                child: SizedBox(
                  width: chartSize,
                  height: chartSize,
                  child: CustomPaint(
                    size: Size(chartSize, chartSize),
                    painter: _PieChartWithLabelsPainter(
                      data: widget.data,
                      colors: _chartColors,
                      touchedIndex: _touchedIndex,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: availableWidth * 0.25,
              child: _buildRightLegend(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRightLegend() {

    final halfLength = (widget.data.length / 2).ceil();
    final firstColumn = widget.data.take(halfLength).toList();
    final secondColumn = widget.data.skip(halfLength).toList();

    return Padding(
      padding: EdgeInsets.only(right: 8.w, left: 8.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: firstColumn.map((item) => _buildLegendItem(item)).toList(),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: secondColumn.map((item) => _buildLegendItem(item)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(SymbolReportData item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10.w,
            height: 10.h,
            decoration: BoxDecoration(
              color: _chartColors[item.colorIndex % _chartColors.length],
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 6.w),
          Flexible(
            child: Text(
              item.symbol,
              style: GoogleFonts.openSans(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
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


class _PieChartWithLabelsPainter extends CustomPainter {
  final List<SymbolReportData> data;
  final List<Color> colors;
  final int? touchedIndex;

  _PieChartWithLabelsPainter({
    required this.data,
    required this.colors,
    required this.touchedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final pieRadius = size.width * 0.28;
    final totalPercentage = data.fold<double>(0, (sum, item) => sum + item.percentage);
    _drawPieSections(canvas, center, pieRadius, totalPercentage);

    _drawLabelsWithConnectors(canvas, center, pieRadius, size, totalPercentage);
  }

  void _drawPieSections(Canvas canvas, Offset center, double radius, double totalPercentage) {
    double startAngle = -math.pi / 2;

    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      final normalizedPercentage = (item.percentage / totalPercentage) * 100;
      final sweepAngle = (normalizedPercentage / 100) * 2 * math.pi;
      final color = colors[item.colorIndex % colors.length];

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  void _drawLabelsWithConnectors(
      Canvas canvas,
      Offset center,
      double pieRadius,
      Size size,
      double totalPercentage,
      ) {
    double currentAngle = -math.pi / 2;

    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      final normalizedPercentage = (item.percentage / totalPercentage) * 100;
      final sweepAngle = (normalizedPercentage / 100) * 2 * math.pi;
      final midAngle = currentAngle + sweepAngle / 2;
      final color = colors[item.colorIndex % colors.length];

      final pieEdgeX = center.dx + pieRadius * math.cos(midAngle);
      final pieEdgeY = center.dy + pieRadius * math.sin(midAngle);
      final isLeftSide = midAngle < -math.pi / 2 || midAngle > math.pi / 2;

      final bendRadius = pieRadius * 1.3;
      final bendX = center.dx + bendRadius * math.cos(midAngle);
      final bendY = center.dy + bendRadius * math.sin(midAngle);

      final horizontalLength = size.width * 0.12;
      final labelX = isLeftSide ? bendX - horizontalLength : bendX + horizontalLength;
      final labelY = bendY;

      final linePaint = Paint()
        ..color = color
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;

      final path = Path();
      path.moveTo(pieEdgeX, pieEdgeY);
      path.lineTo(bendX, bendY);
      path.lineTo(labelX, labelY);
      canvas.drawPath(path, linePaint);

      _drawLabel(canvas, item, Offset(labelX, labelY), isLeftSide, color);

      currentAngle += sweepAngle;
    }
  }

  void _drawLabel(
      Canvas canvas,
      SymbolReportData item,
      Offset position,
      bool isLeftSide,
      Color color,
      ) {
    final symbolPainter = TextPainter(
      text: TextSpan(
        text: item.symbol,
        style: TextStyle(
          fontFamily: 'OpenSans',
          fontSize: 10,
          color: AppColors.black,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final valuePainter = TextPainter(
      text: TextSpan(
        text: '${item.value.toStringAsFixed(2)}  ${item.percentage.toStringAsFixed(2)}%',
        style: TextStyle(
          fontFamily: 'OpenSans',
          fontSize: 10,
          color: color,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();


    final totalHeight = symbolPainter.height + valuePainter.height + 2;
    final topOffset = position.dy - totalHeight / 2;

    if (isLeftSide) {
      symbolPainter.paint(
        canvas,
        Offset(position.dx - symbolPainter.width, topOffset),
      );
      valuePainter.paint(
        canvas,
        Offset(position.dx - valuePainter.width, topOffset + symbolPainter.height + 2),
      );
    } else {
      symbolPainter.paint(
        canvas,
        Offset(position.dx, topOffset),
      );
      valuePainter.paint(
        canvas,
        Offset(position.dx, topOffset + symbolPainter.height + 2),
      );
    }
  }

  @override
  bool shouldRepaint(_PieChartWithLabelsPainter oldDelegate) {
    return oldDelegate.touchedIndex != touchedIndex ||
        oldDelegate.data != data;
  }
}