import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/dashboard_entity.dart';

/// Symbol Wise Report Pie Chart Widget matching Figma design
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

  // Pie chart colors matching the image
  static const List<Color> _chartColors = [
    Color(0xFF6B9BD1), // Blue - GIFTNIFTY
    Color(0xFFB8A8E8), // Light Purple - DOWJONES
    Color(0xFFFF9B8A), // Coral/Orange - NASDAQ
    Color(0xFF6EC4DB), // Cyan - GOLD
    Color(0xFFFFB347), // Orange - COPPER
    Color(0xFF7CB89D), // Green - ETHUSD
    Color(0xFF5B9BD5), // Bright Blue - BTUSD
    Color(0xFF9B7EBD), // Purple - CRUDOIL
    Color(0xFFE8D44D), // Yellow - NATURALGAS
    Color(0xFF6EC4DB), // Cyan - SILVER
    Color(0xFFFFB347), // Orange - GOLD (duplicate)
    Color(0xFF5B9BD5), // Blue - COPPER (duplicate)
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

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Pie chart + labels together
              SizedBox(width: 100.w),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 500.w,
                    height: 500.h,
                    child: CustomPaint(
                      painter: _PieChartLabelsPainter(
                        data: widget.data,
                        colors: _chartColors,
                        touchedIndex: _touchedIndex,
                        textStyle: GoogleFonts.openSans(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: LightThemeColors.textColor,
                        ),
                        valueStyle: GoogleFonts.openSans(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 200.w,
                    height: 200.h,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback: (event, response) {
                            setState(() {
                              _touchedIndex = response?.touchedSection
                                  ?.touchedSectionIndex;
                            });
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 0, // No gap between sections
                        centerSpaceRadius: 0,
                        sections: _buildPieSections(),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(width: 120.w),

              /// Legend
              _buildLegend(),
            ],
          );
        },
      ),
    );
  }

  List<PieChartSectionData> _buildPieSections() {
    return widget.data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final isTouched = index == _touchedIndex;
      final radius = isTouched ? 105.r : 100.r;

      return PieChartSectionData(
        value: item.percentage,
        title: '',
        color: _getColor(item.colorIndex),
        radius: radius,
        borderSide: BorderSide.none,
      );
    }).toList();
  }

  Widget _buildLegend() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: widget.data
            .map((item) => _buildLegendItem(item))
            .toList(),
      ),
    );
  }

  Widget _buildLegendItem(SymbolReportData item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 12.h,
            decoration: BoxDecoration(
              color: _getColor(item.colorIndex),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            item.symbol,
            style: GoogleFonts.openSans(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: LightThemeColors.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor(int index) {
    return _chartColors[index % _chartColors.length];
  }
}

// Custom painter for labels and connector lines
class _PieChartLabelsPainter extends CustomPainter {
  final List<SymbolReportData> data;
  final List<Color> colors;
  final int? touchedIndex;
  final TextStyle textStyle;
  final TextStyle valueStyle;

  _PieChartLabelsPainter({
    required this.data,
    required this.colors,
    required this.touchedIndex,
    required this.textStyle,
    required this.valueStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final pieRadius = 100.0;
    final labelDistance = 200.0;

    double currentAngle = -math.pi / 2; // Start from top

    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      final sweepAngle = (item.percentage / 100) * 2 * math.pi;
      final midAngle = currentAngle + sweepAngle / 2;
      final isTouched = i == touchedIndex;

      // Calculate point on pie edge
      final pieEdgeX = center.dx + pieRadius * math.cos(midAngle);
      final pieEdgeY = center.dy + pieRadius * math.sin(midAngle);

      // Determine if label is on left or right
      final isLeft = midAngle > math.pi / 2 && midAngle < 3 * math.pi / 2;

      // Calculate bend point (where line changes from angled to horizontal)
      final bendDistance = 140.0;
      final bendX = center.dx + bendDistance * math.cos(midAngle);
      final bendY = center.dy + bendDistance * math.sin(midAngle);

      // Calculate final label position (horizontal line end)
      final horizontalExtension = 60.0;
      final labelX = bendX + (isLeft ? -horizontalExtension : horizontalExtension);
      final labelY = bendY;

      // Draw connector lines with NO gaps
      final lineColor = colors[item.colorIndex % colors.length];
      final linePaint = Paint()
        ..color = lineColor
        ..strokeWidth = isTouched ? 2.0 : 1.5
        ..style = PaintingStyle.stroke;

      // Create path for smooth connection
      final path = Path();
      path.moveTo(pieEdgeX, pieEdgeY);
      path.lineTo(bendX, bendY);
      path.lineTo(labelX, labelY);

      canvas.drawPath(path, linePaint);

      // Draw label directly at the end of the line (NO gap)
      _drawLabel(
        canvas,
        item,
        Offset(labelX, labelY),
        isLeft,
        isTouched,
      );

      currentAngle += sweepAngle;
    }
  }

  void _drawLabel(
      Canvas canvas,
      SymbolReportData item,
      Offset position,
      bool isLeft,
      bool isHighlighted,
      ) {
    final labelColor = colors[item.colorIndex % colors.length];

    // Symbol name
    final symbolPainter = TextPainter(
      text: TextSpan(
        text: item.symbol,
        style: textStyle.copyWith(
          color: labelColor,
          fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w600,
          fontSize: 13,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    // Value and percentage
    final valuePainter = TextPainter(
      text: TextSpan(
        text: '${item.value.toStringAsFixed(2)}  ${item.percentage.toStringAsFixed(2)}%',
        style: valueStyle.copyWith(
          color: labelColor,
          fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w500,
          fontSize: 12,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    // Position labels directly at line end (NO spacing/gap)
    if (isLeft) {
      // Left side - align right, text touches the line
      symbolPainter.paint(
        canvas,
        Offset(
          position.dx - symbolPainter.width,
          position.dy - symbolPainter.height - 2,
        ),
      );
      valuePainter.paint(
        canvas,
        Offset(
          position.dx - valuePainter.width,
          position.dy + 2,
        ),
      );
    } else {
      // Right side - align left, text touches the line
      symbolPainter.paint(
        canvas,
        Offset(
          position.dx,
          position.dy - symbolPainter.height - 2,
        ),
      );
      valuePainter.paint(
        canvas,
        Offset(
          position.dx,
          position.dy + 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(_PieChartLabelsPainter oldDelegate) {
    return oldDelegate.touchedIndex != touchedIndex;
  }
}