import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../domain/entities/spraed_report_entity.dart';

class SpraedReportTable extends StatelessWidget {
  final List<SpraedReportEntity> data;

  const SpraedReportTable({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ViewDataTable<SpraedReportEntity>(
      columns: [
        ViewTableColumn(
          id: 'exchange',
          label: 'EXCHANGE',
          width: 250.w,
          alignment: Alignment.centerLeft,
          sortable: false,
        ),
        ViewTableColumn(
          id: 'symbol',
          label: 'SYMBOL',
          width: 300.w,
          alignment: Alignment.centerLeft,
          sortable: false,
        ),
        ViewTableColumn(
          id: 'spread',
          label: 'SPRAED %',
          width: 250.w,
          alignment: Alignment.centerRight,
          sortable: false,
        ),
      ],
      data: data,
      idExtractor: (item) => item.id,
      autoFit: true,
      cellBuilder: (item, column) {
        final isRed = item.symbol.contains('NIFTY') && !item.symbol.contains('BANK');
        
        switch (column.id) {
          case 'exchange':
            return Text(
              item.exchange,
              style: GoogleFonts.openSans(
                fontSize: 12.sp,
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left,
            );
          case 'symbol':
            return Text(
              item.symbol,
              style: GoogleFonts.openSans(
                fontSize: 12.sp,
                color: isRed ? AppColors.sellColor : AppColors.buyColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left,
            );
          case 'spread':
            return Text(
              item.spreadPercentage,
              style: GoogleFonts.openSans(
                fontSize: 12.sp,
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
