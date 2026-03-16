import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/table/view_data_table.dart';
import '../../../domain/entities/settlement_progress/bhav_copy_entity.dart';
class SettlementProgressDataTable extends StatelessWidget {
  final List<BhavCopyEntity> data;
  const SettlementProgressDataTable({super.key, required this.data});
  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(
        child: Text(
          'No Data Available',
          style: GoogleFonts.openSans(
            fontSize: 14.sp,
            color: AppColors.textDark,
          ),
        ),
      );
    }
    return ViewDataTable<BhavCopyEntity>(
      columns: [
        ViewTableColumn(id: 'exch', label: 'EXCH', width: 80.w),
        ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 150.w),
        ViewTableColumn(id: 'expiryDate', label: 'EXPIRY DATE', width: 100.w),
        ViewTableColumn(id: 'dayHigh', label: 'DAY HIGH', width: 120.w),
        ViewTableColumn(id: 'dayLow', label: 'DAY LOW', width: 120.w),
        ViewTableColumn(id: 'dayClose', label: 'DAY CLOSE', width: 120.w),
      ],
      data: data,
      idExtractor: (item) => item.symbol,
      autoFit: true,
      comparatorBuilder: (item, columnId) {
        switch (columnId) {
          case 'exch':
            return item.exch;
          case 'symbol':
            return item.symbol;
          case 'expiryDate':
            return item.expiryDate;
          case 'dayHigh':
            return item.dayHigh;
          case 'dayLow':
            return item.dayLow;
          case 'dayClose':
            return item.dayClose;
          default:
            return '';
        }
      },
      cellBuilder: (item, column) {
        switch (column.id) {
          case 'exch':
            return Text(item.exch);
          case 'symbol':
            return Text(item.symbol);
          case 'expiryDate':
            return Text(item.expiryDate);
          case 'dayHigh':
            return Text(item.dayHigh.toStringAsFixed(0));
          case 'dayLow':
            return Text(item.dayLow.toStringAsFixed(0));
          case 'dayClose':
            return Text(item.dayClose.toStringAsFixed(0));
          default:
            return const SizedBox();
        }
      },
    );
  }
}
