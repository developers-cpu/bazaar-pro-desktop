import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/dashboard_entity.dart';

/// Symbol Wise Report Pie Chart Widget
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

  // Pie chart colors
  static const List<Color> _chartColors = [
    Color(0xFF5B8DEF), // Blue
    Color(0xFFB8D4E3), // Light Blue
    Color(0xFFFF9F7F), // Coral/Orange
    Color(0xFF87CEEB), // Sky Blue
    Color(0xFFFFD93D), // Yellow
    Color(0xFF6BCB77), // Green
    Color(0xFF4D96FF), // Bright Blue
    Color(0xFF9B59B6), // Purple
    Color(0xFF2ECC71), // Emerald
    Color(0xFFE74C3C), // Red
    Color(0xFFFF6B6B), // Light Red
    Color(0xFF48C9B0), // Teal
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

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildLeftLabels(),
        ),
        Expanded(
          flex: 4,
          child: _buildPieChartWithLabels(),
        ),
        Expanded(
          flex: 2,
          child: _buildRightLegend(),
        ),
      ],
    );
  }

  Widget _buildLeftLabels() {
    final leftItems = widget.data.take((widget.data.length / 2).ceil()).toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: leftItems.map((item) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.symbol,
                style: GoogleFonts.openSans(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: LightThemeColors.textColor,
                ),
              ),
              Text(
                '${item.value.toStringAsFixed(2)}  ${item.percentage.toStringAsFixed(2)}%',
                style: GoogleFonts.openSans(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: _getColor(item.colorIndex),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPieChartWithLabels() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Pie chart
            AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (event, response) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            response == null ||
                            response.touchedSection == null) {
                          _touchedIndex = null;
                        } else {
                          _touchedIndex = response.touchedSection!.touchedSectionIndex;
                        }
                      });
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 2,
                  centerSpaceRadius: 0,
                  sections: _buildPieSections(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<PieChartSectionData> _buildPieSections() {
    return widget.data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final isTouched = index == _touchedIndex;
      final radius = isTouched ? 110.r : 100.r;
      final fontSize = isTouched ? 10.sp : 9.sp;

      // Show title on the section if percentage is large enough
      final showTitle = item.percentage >= 6;

      return PieChartSectionData(
        value: item.percentage,
        title: showTitle ? '${item.symbol}\n${item.value.toStringAsFixed(2)} ${item.percentage.toStringAsFixed(2)}%' : '',
        titleStyle: GoogleFonts.openSans(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: _getContrastColor(_getColor(item.colorIndex)),
        ),
        color: _getColor(item.colorIndex),
        radius: radius,
        titlePositionPercentageOffset: 0.6,
      );
    }).toList();
  }

  Color _getContrastColor(Color color) {
    // Calculate luminance and return white or dark text
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? LightThemeColors.textColor : AppColors.white;
  }

  Widget _buildRightLegend() {
    // Split legend into two columns
    final halfLength = (widget.data.length / 2).ceil();
    final firstColumn = widget.data.take(halfLength).toList();
    final secondColumn = widget.data.skip(halfLength).toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: firstColumn.map((item) => _buildLegendItem(item)).toList(),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: secondColumn.map((item) => _buildLegendItem(item)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(SymbolReportData item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10.w,
            height: 10.h,
            decoration: BoxDecoration(
              color: _getColor(item.colorIndex),
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

  Color _getColor(int index) {
    return _chartColors[index % _chartColors.length];
  }
}