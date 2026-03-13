import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/common_dilog_box.dart';
import '../../../../../../injection_container.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_data_table_footer.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../../domain/entities/broker_list/client_breakdown.dart';
import '../../bloc/broker_list/client_breakdown_bloc.dart';

class ClientBreakdownDialog {
  static void show({
    required BuildContext context,
    required String brokerId,
    required String clientName,
    bool isDarkMode = false,
  }) {
    CommonDialog.show(
      context: context,
      title: "Detailed Client Breakdown",
      isDarkMode: isDarkMode,
      width: 1000.w,
      height: 800.h,
      headerColor: const Color(0xFF2C5F7A),
      showButtons: false,
      scrollable: true,
      contentPadding: EdgeInsets.zero,
      content: BlocProvider(
        create:
            (context) => sl<ClientBreakdownBloc>()
              ..add(
                LoadClientBreakdownEvent(
                  brokerId: brokerId,
                  clientName: clientName,
                ),
              ),
        child: _ClientBreakdownContent(
          brokerId: brokerId,
          clientName: clientName,
          isDarkMode: isDarkMode,
        ),
      ),
    );
  }
}

class _ClientBreakdownContent extends StatelessWidget {
  final String brokerId;
  final String clientName;
  final bool isDarkMode;
  const _ClientBreakdownContent({
    Key? key,
    required this.brokerId,
    required this.clientName,
    this.isDarkMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientBreakdownBloc, ClientBreakdownState>(
      builder: (context, state) {
        if (state is ClientBreakdownLoading) {
          return SizedBox(
            height: 600.h,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ClientBreakdownError) {
          return SizedBox(
            height: 600.h,
            child: Center(
              child: Text(
                state.message,
                style: GoogleFonts.openSans(color: Colors.red),
              ),
            ),
          );
        }

        if (state is ClientBreakdownLoaded) {
          final breakdown = state.breakdown;
          return Column(
            children: [
              _buildHeader(context, breakdown),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children:
                      breakdown.sections.map((section) {
                        return Column(
                          children: [
                            _buildSection(
                              context,
                              section.title,
                              section.rows,
                              isSymbolBased: section.isSymbolBased,
                              hasFooter: section.hasFooter,
                            ),
                            SizedBox(height: 16.h),
                          ],
                        );
                      }).toList(),
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildHeader(BuildContext context, ClientBreakdown breakdown) {
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
          Row(
            children: [
              InkWell(
                onTap: () {
                  context.read<ClientBreakdownBloc>().add(
                    ExportClientBreakdownPdfEvent(breakdown),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.picture_as_pdf,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      "Download PDF",
                      style: GoogleFonts.openSans(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20.w),
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
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<ClientBreakdownRow> rows, {
    bool isSymbolBased = false,
    bool hasFooter = false,
  }) {
    final columns = [
      ViewTableColumn(
        id: isSymbolBased ? 'symbol' : 'exchange',
        label: isSymbolBased ? 'SYMBOL' : 'EXCHNAGE',
        width: 300,
      ),
      const ViewTableColumn(
        id: 'turnover',
        label: 'TURNOVER',
        width: 300,
        isNumeric: true,
      ),
      const ViewTableColumn(
        id: 'brokerage',
        label: 'BROKRAGE',
        width: 300,
        isNumeric: true,
      ),
    ];

    
    final data =
        rows
            .map(
              (row) => {
                isSymbolBased ? 'symbol' : 'exchange': row.label,
                'turnover': row.turnover,
                'brokerage': row.brokerage,
              },
            )
            .toList();

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
          idExtractor:
              (item) => (item['symbol'] ?? item['exchange']).toString(),
          isDarkMode: isDarkMode,
          shrinkWrap: true,
          autoFit: true,
          comparatorBuilder: (item, columnId) {
            final val = item[columnId];
            if (val is num) return val;
            return val?.toString() ?? '';
          },
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
              'brokerage': rows
                  .fold(0.0, (sum, row) => sum + row.brokerage)
                  .toStringAsFixed(0),
            },
            isDarkMode: isDarkMode,
          ),
      ],
    );
  }
}
