import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_record_count.dart';
import '../../../domain/entities/ban_script_entity.dart';

class BanScriptTable extends StatelessWidget {
  final List<BanScriptEntity> data;

  const BanScriptTable({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ViewRecordCount(count: data.length),
        Expanded(
          child: ViewDataTable<BanScriptEntity>(
      columns: [
        ViewTableColumn(
          id: 'exchange',
          label: 'EXCHANGE',
          width: 150.w,
          alignment: Alignment.centerLeft,
          sortable: true,
        ),
        ViewTableColumn(
          id: 'symbol',
          label: 'SYMBOL',
          width: 250.w,
          alignment: Alignment.centerLeft,
          sortable: true,
        ),
        ViewTableColumn(
          id: 'startTime',
          label: 'START TIMING',
          width: 200.w,
          alignment: Alignment.centerLeft,
          sortable: true,
        ),
        ViewTableColumn(
          id: 'banTime',
          label: 'BAN TIMING',
          width: 200.w,
          alignment: Alignment.centerLeft,
          sortable: true,
        ),
      ],
      data: data,
      idExtractor: (item) => item.id,
      autoFit: true,
      cellBuilder: (item, column) {
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
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left,
            );
          case 'startTime':
            return Text(
              item.startTime,
              style: GoogleFonts.openSans(
                fontSize: 12.sp,
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left,
            );
          case 'banTime':
            return Text(
              item.banTime,
              style: GoogleFonts.openSans(
                fontSize: 12.sp,
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left,
            );
          default:
            return const SizedBox.shrink();
        }
      },
          ),
        ),
      ],
    );
  }
}
