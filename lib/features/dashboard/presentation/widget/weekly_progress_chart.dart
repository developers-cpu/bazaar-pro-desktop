import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/dashboard_entity.dart';

class WeeklyProgressChart extends StatelessWidget {
  final List<WeeklyProgressData> data;

  const WeeklyProgressChart({Key? key, required this.data}) : super(key: key);

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

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          drawHorizontalLine: true,
          horizontalInterval: 250,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: LightThemeColors.dividerColor, strokeWidth: 1);
          },
          getDrawingVerticalLine: (value) {
            return FlLine(color: LightThemeColors.dividerColor, strokeWidth: 1);
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < data.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      data[index].label,
                      style: GoogleFonts.openSans(
                        fontSize: 10.sp,
                        color: LightThemeColors.textColor,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 250,
              reservedSize: 42,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: GoogleFonts.openSans(
                    fontSize: 12.sp,
                    color: LightThemeColors.supportiveTextColor,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: data.length.toDouble() - 1,
        minY: 0,
        maxY: 1250,
        lineBarsData: [
          LineChartBarData(
            spots: data
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.value))
                .toList(),
            isCurved: false,
            color: const Color(0xFF5D7E8E),
            barWidth: 1.5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 3,
                  color: AppColors.white,
                  strokeWidth: 1.5,
                  strokeColor: const Color(0xFF5D7E8E),
                );
              },
            ),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}
