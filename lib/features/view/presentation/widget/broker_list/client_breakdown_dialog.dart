import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/common_dilog_box.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_data_table_footer.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';
class ClientBreakdownDialog extends StatelessWidget {
  final String brokerId;
  final String clientName;
  final bool isDarkMode;
  const ClientBreakdownDialog({
    Key? key,
    required this.brokerId,
    required this.clientName,
    this.isDarkMode = false,
  }) : super(key: key);
  static void show({
    required BuildContext context,
    required String brokerId,
    required String clientName,
    bool isDarkMode = false,
  }) {
    showDialog(
      context: context,
      barrierColor: AppColors.black.withOpacity(0.54),
      builder: (_) => ClientBreakdownDialog(
        brokerId: brokerId,
        clientName: clientName,
        isDarkMode: isDarkMode,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: "Detailed Client Breakdown",
      isDarkMode: isDarkMode,
      width: 1000.w,
      height: 800.h,
      headerColor: const Color(0xFF2C5F7A),
      showButtons: false,
      scrollable: true,
      contentPadding: EdgeInsets.zero,
      content: Column(
        children: [
          _buildHeader(),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                _buildSection(context, "NSE", _getNSEData()),
                SizedBox(height: 16.h),
                _buildSection(
                  context,
                  "MCX",
                  _getMCXData(),
                  isSymbolBased: true,
                ),
                SizedBox(height: 16.h),
                _buildSection(context, "CE/PE", _getCEPEData()),
                SizedBox(height: 16.h),
                _buildSection(context, "GIFTNIFTY", _getGIFTNIFTYData()),
                SizedBox(height: 16.h),
                _buildSection(
                  context,
                  "OTHER",
                  _getOtherData(),
                  isSymbolBased: true,
                  hasFooter: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      color: const Color(0xFF414C5D),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "BROKER Id : $brokerId",
            style: GoogleFonts.openSans(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "Client name : $clientName",
            style: GoogleFonts.openSans(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildSection(
    BuildContext context,
    String title,
    List<Map<String, dynamic>> data, {
    bool isSymbolBased = false,
    bool hasFooter = false,
  }) {
    final columns = [
      ViewTableColumn(
        id: isSymbolBased ? 'symbol' : 'exchange',
        label: isSymbolBased ? 'SYMBOL' : 'EXCHNAGE',
        width: 300,
      ),
      const ViewTableColumn(id: 'turnover', label: 'TURNOVER', width: 300),
      const ViewTableColumn(
        id: 'brokerage',
        label: 'BROKRAGE',
        width: 300,
        isNumeric: true,
      ),
    ];
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 4.h),
          margin: EdgeInsets.only(bottom: 2.h),
          decoration: BoxDecoration(
            color: isDarkMode ? DarkThemeColors.cardBackground : Colors.white,
            border: Border.all(
              color: AppColors.dividerColor(context),
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(4.r),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: GoogleFonts.openSans(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : AppColors.black,
            ),
          ),
        ),
        ViewDataTable<Map<String, dynamic>>(
          columns: columns,
          data: data,
          idExtractor: (item) =>
              (item['symbol'] ?? item['exchange']).toString(),
          isDarkMode: isDarkMode,
          shrinkWrap: true,
          autoFit: true,
          headerBgColor: const Color(0xFFD3E3EC),
          cellBuilder: (item, column) {
            final val = item[column.id];
            return ViewTextCell(text: val.toString(), isDark: isDarkMode);
          },
        ),
        if (hasFooter)
          ViewDataTableFooter(
            columns: columns,
            values: {
              isSymbolBased ? 'symbol' : 'exchange': 'TOTAL',
              'brokerage': '100000',
            },
            isDarkMode: isDarkMode,
          ),
      ],
    );
  }
  List<Map<String, dynamic>> _getNSEData() => [
    {"exchange": "NSE", "turnover": "100 CR", "brokerage": 2500},
  ];
  List<Map<String, dynamic>> _getMCXData() => [
    {"symbol": "GOLD", "turnover": "500 LOT", "brokerage": 2500},
    {"symbol": "GOLD MINI", "turnover": "500 LOT", "brokerage": 600},
    {"symbol": "SILVER", "turnover": "500 LOT", "brokerage": 750},
    {"symbol": "SILVER MINI", "turnover": "500 LOT", "brokerage": 1250},
    {"symbol": "SILVER MIC", "turnover": "500 LOT", "brokerage": 5100},
  ];
  List<Map<String, dynamic>> _getCEPEData() => [
    {"exchange": "CE/PE", "turnover": "100 CR", "brokerage": 2500},
  ];
  List<Map<String, dynamic>> _getGIFTNIFTYData() => [
    {"exchange": "GIFTYNIFTY", "turnover": "100 CR", "brokerage": 2500},
  ];
  List<Map<String, dynamic>> _getOtherData() => [
    {"symbol": "DOWJONSE", "turnover": "500 LOT", "brokerage": 2500},
    {"symbol": "NASDQ", "turnover": "500 LOT", "brokerage": 600},
    {"symbol": "S&P", "turnover": "500 LOT", "brokerage": 750},
  ];
}
