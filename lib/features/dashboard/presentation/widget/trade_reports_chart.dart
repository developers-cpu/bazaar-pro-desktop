import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/dashboard_entity.dart';

class TradeReportsChart extends StatefulWidget {
  final List<TradeReportData> data;
  const TradeReportsChart({Key? key, required this.data}) : super(key: key);
  @override
  State<TradeReportsChart> createState() => _TradeReportsChartState();
}

class _TradeReportsChartState extends State<TradeReportsChart> {
  int? _touchedGroupIndex;
  int? _touchedRodIndex;
  static const Color _deletedColor = Color(0xFF4993F4);
  static const Color _cancelledColor = Color(0xFFFF1201);
  static const Color _successColor = Color(0xFF1F4A66);
  static const Color _deletedBgColor = Color(0xFFE8F2FE);
  static const Color _cancelledBgColor = Color(0xFFFFE8E6);
  static const Color _successBgColor = Color(0xFFE6EEF2);
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
        final isCompact = constraints.maxWidth < 600;
        final barWidth =
            (isCompact ? 24.w : (constraints.maxWidth < 650 ? 32.w : 42.w))
                .clamp(10.0, 30.0);
        final groupSpacing =
            (isCompact ? 12.w : (constraints.maxWidth < 650 ? 20.w : 30.w))
                .clamp(8.0, 24.0);
        return Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: 10.w,
                  top: constraints.maxHeight > 300 ? 16.h : 6.h,
                ),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 100,
                    minY: 0,
                    groupsSpace: groupSpacing,
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        fitInsideHorizontally: true,
                        fitInsideVertically: true,
                        tooltipPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        getTooltipColor: (group) {
                          if (_touchedRodIndex != null) {
                            switch (_touchedRodIndex) {
                              case 0:
                                return _deletedColor;
                              case 1:
                                return _cancelledColor;
                              case 2:
                                return _successColor;
                              default:
                                return _successColor;
                            }
                          }
                          return _successColor;
                        },
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
                            '$label: ${rod.toY.toInt()}',
                            GoogleFonts.openSans(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
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
                            _touchedGroupIndex =
                                response.spot!.touchedBarGroupIndex;
                            _touchedRodIndex =
                                response.spot!.touchedRodDataIndex;
                          }
                        });
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32.h,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index >= 0 && index < widget.data.length) {
                              return Padding(
                                padding: EdgeInsets.only(top: 8.h),
                                child: Text(
                                  widget.data[index].date,
                                  style: GoogleFonts.openSans(
                                    fontSize: constraints.maxWidth > 600
                                        ? 13.sp
                                        : 11.sp,
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
                          reservedSize: 32.w,
                          interval: 20,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: GoogleFonts.openSans(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: LightThemeColors.supportiveTextColor,
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        bottom: BorderSide(
                          color: LightThemeColors.dividerColor,
                          width: 1,
                        ),
                        left: BorderSide(
                          color: LightThemeColors.dividerColor,
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignInside,
                        ),
                        top: BorderSide(
                          color: LightThemeColors.dividerColor,
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignInside,
                        ),
                        right: BorderSide(
                          color: LightThemeColors.dividerColor,
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignInside,
                        ),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      drawHorizontalLine: true,
                      horizontalInterval: 20,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: LightThemeColors.dividerColor,
                          strokeWidth: 1,
                          dashArray: [5, 5],
                        );
                      },
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: LightThemeColors.dividerColor,
                          strokeWidth: 1,
                          dashArray: [5, 5],
                        );
                      },
                      verticalInterval: 1,
                      checkToShowVerticalLine: (value) {
                        final index = value.toInt();
                        return index > 0 && index < widget.data.length;
                      },
                    ),
                    barGroups: _buildBarGroups(constraints, barWidth),
                  ),
                ),
              ),
            ),
            SizedBox(height: 6.h),
            _buildLegend(),
            SizedBox(height: 4.h),
          ],
        );
      },
    );
  }

  List<BarChartGroupData> _buildBarGroups(
    BoxConstraints constraints,
    double barWidth,
  ) {
    return widget.data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          _buildBarRod(
            item.deleted,
            _deletedColor,
            _deletedBgColor,
            index,
            0,
            barWidth,
          ),
          _buildBarRod(
            item.cancelled,
            _cancelledColor,
            _cancelledBgColor,
            index,
            1,
            barWidth,
          ),
          _buildBarRod(
            item.success,
            _successColor,
            _successBgColor,
            index,
            2,
            barWidth,
          ),
        ],
        barsSpace: 3.w.clamp(2.0, 4.0),
      );
    }).toList();
  }

  BarChartRodData _buildBarRod(
    double value,
    Color color,
    Color bgColor,
    int groupIndex,
    int rodIndex,
    double barWidth,
  ) {
    final isTouched =
        _touchedGroupIndex == groupIndex && _touchedRodIndex == rodIndex;
    return BarChartRodData(
      toY: value,
      color: isTouched ? color.withOpacity(0.9) : color,
      width: barWidth,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(2.r),
        topRight: Radius.circular(2.r),
      ),
      rodStackItems: [],
      backDrawRodData: BackgroundBarChartRodData(
        show: true,
        toY: 100,
        color: bgColor,
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('Deleted', _deletedColor),
        SizedBox(width: 20.w),
        _buildLegendItem('Cancelled', _cancelledColor),
        SizedBox(width: 20.w),
        _buildLegendItem('Success', _successColor),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10.w,
          height: 10.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: GoogleFonts.openSans(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: LightThemeColors.textColor,
          ),
        ),
      ],
    );
  }
}