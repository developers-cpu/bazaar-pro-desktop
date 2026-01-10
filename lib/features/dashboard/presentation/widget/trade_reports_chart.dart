import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/dashboard_entity.dart';

/// Trade Reports Bar Chart Widget
class TradeReportsChart extends StatefulWidget {
  final List<TradeReportData> data;

  const TradeReportsChart({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<TradeReportsChart> createState() => _TradeReportsChartState();
}

class _TradeReportsChartState extends State<TradeReportsChart> {
  int? _touchedGroupIndex;
  int? _touchedRodIndex;

  static const Color _deletedColor = Color(0xFF7FB3D5);
  static const Color _cancelledColor = Color(0xFFE74C3C);
  static const Color _successColor = Color(0xFF4A6572);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 100,
              minY: 0,
              groupsSpace: 20.w,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    String label;
                    switch (rodIndex) {
                      case 0:
                        label = 'Deleted';
                        break;
                      case 1:
                        label = 'Cancelled';
                        break;
                      case 2:
                        label = 'Success';
                        break;
                      default:
                        label = '';
                    }
                    return BarTooltipItem(
                      '${rod.toY.toInt()}',
                      GoogleFonts.openSans(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    );
                  },
                ),
                touchCallback: (event, response) {
                  setState(() {
                    if (response == null || response.spot == null) {
                      _touchedGroupIndex = null;
                      _touchedRodIndex = null;
                    } else {
                      _touchedGroupIndex = response.spot!.touchedBarGroupIndex;
                      _touchedRodIndex = response.spot!.touchedRodDataIndex;
                    }
                  });
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40.h,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < widget.data.length) {
                        return Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Text(
                            widget.data[index].date,
                            style: GoogleFonts.openSans(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: LightThemeColors.supportiveTextColor,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40.w,
                    interval: 20,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: GoogleFonts.openSans(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: LightThemeColors.supportiveTextColor,
                        ),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 20,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: LightThemeColors.dividerColor,
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  );
                },
              ),
              barGroups: _buildBarGroups(),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        _buildLegend(),
      ],
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return widget.data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;

      return BarChartGroupData(
        x: index,
        barRods: [
          _buildBarRod(item.deleted, _deletedColor, index, 0),
          _buildBarRod(item.cancelled, _cancelledColor, index, 1),
          _buildBarRod(item.success, _successColor, index, 2),
        ],
        barsSpace: 4.w,
      );
    }).toList();
  }

  BarChartRodData _buildBarRod(double value, Color color, int groupIndex, int rodIndex) {
    final isTouched = _touchedGroupIndex == groupIndex && _touchedRodIndex == rodIndex;

    return BarChartRodData(
      toY: value,
      color: color,
      width: 20.w,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(4.r),
        topRight: Radius.circular(4.r),
      ),
      backDrawRodData: BackgroundBarChartRodData(
        show: true,
        toY: 100,
        color: color.withOpacity(0.1),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('Deleted', _deletedColor),
        SizedBox(width: 24.w),
        _buildLegendItem('Cancelled', _cancelledColor),
        SizedBox(width: 24.w),
        _buildLegendItem('Success', _successColor),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16.w,
          height: 16.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: LightThemeColors.textColor,
          ),
        ),
      ],
    );
  }
}