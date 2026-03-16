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
    final maxVal = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final computedMaxY = maxVal <= 0 ? 100.0 : maxVal * 1.2;
    final yInterval = (computedMaxY / 5).ceilToDouble().clamp(
      1.0,
      double.maxFinite,
    );
    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => AppColors.primaryBlue,
            tooltipBorderRadius: BorderRadius.circular(8.r),
            tooltipPadding: EdgeInsets.symmetric(
              horizontal: 8.w,
              vertical: 4.h,
            ),
            fitInsideHorizontally: true,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  spot.y.toStringAsFixed(1),
                  GoogleFonts.openSans(
                    fontSize: 11.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          drawHorizontalLine: true,
          horizontalInterval: yInterval,
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
            sideTitles: SideTitles(showTitles: false, reservedSize: 0),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false, reservedSize: 0),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 34,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (value == index.toDouble() &&
                    index >= 0 &&
                    index < data.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      data[index].label,
                      style: GoogleFonts.openSans(
                        fontSize: 12.sp,
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
              interval: yInterval,
              reservedSize: 45,
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
        clipData: const FlClipData.none(),
        minX: -0.5,
        maxX: data.length.toDouble() + 2.5,
        minY: 0,
        maxY: computedMaxY,
        lineBarsData: [
          LineChartBarData(
            spots: data
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.value))
                .toList(),
            isCurved: false,
            color: AppColors.primaryBlue,
            barWidth: 1.0,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 2,
                  color: AppColors.white,
                  strokeWidth: 1.0,
                  strokeColor: AppColors.primaryBlue,
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
