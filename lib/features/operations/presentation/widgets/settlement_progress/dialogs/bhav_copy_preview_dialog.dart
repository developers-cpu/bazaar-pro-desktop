import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_images.dart';
import '../../../../../../core/widget/common_dilog_box.dart';
import '../../../../../../core/widget/custom_action_button.dart';

import '../../../../../../core/widget/custom_input_field.dart';
import '../../../../../../core/widget/table/view_data_table.dart';
import '../../../../domain/entities/settlement_progress/bhav_copy_entity.dart';
import '../../../bloc/settlement_progress/settlement_progress_bloc.dart';
import '../../../bloc/settlement_progress/settlement_progress_event.dart';

class BhavCopyPreviewDialog extends StatefulWidget {
  final List<BhavCopyEntity> data;
  const BhavCopyPreviewDialog({super.key, required this.data});

  @override
  State<BhavCopyPreviewDialog> createState() => _BhavCopyPreviewDialogState();
}

class _BhavCopyPreviewDialogState extends State<BhavCopyPreviewDialog> {
  final _searchController = TextEditingController();
  List<BhavCopyEntity> _filteredData = [];

  @override
  void initState() {
    super.initState();
    _filteredData = widget.data;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredData = widget.data;
      });
      return;
    }

    final lowerQuery = query.toLowerCase();
    setState(() {
      _filteredData = widget.data.where((item) {
        return item.symbol.toLowerCase().contains(lowerQuery) ||
            item.exch.toLowerCase().contains(lowerQuery);
      }).toList();
    });
  }

  void _onSubmit(BuildContext context) {
    context.read<SettlementProgressBloc>().add(
      SubmitBhavCopyEvent(widget.data),
    );
    Navigator.of(context).pop(); 
  }

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: 'Bhav Copy',
      width: 1000.w, 
      height: 600.h,
      showButtons: false,
      scrollable: false,
      contentPadding: EdgeInsets.zero,
      content: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          children: [
            Row(
              children: [
                CustomInputField(
                  controller: _searchController,
                  hintText: 'Search',
                  prefixSvgPath: AppImages.searchIcon,
                  height: 35.h,
                  width: 300.w,
                  onChanged: _onSearch,
                ),
                const Spacer(),
              ],
            ),
            SizedBox(height: 5.h),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'RECORD : ${_filteredData.length}',
                style: GoogleFonts.openSans(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: ViewDataTable<BhavCopyEntity>(
                columns: [
                  ViewTableColumn(id: 'exch', label: 'EXCH', width: 100.w),
                  ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 150.w),
                  ViewTableColumn(
                    id: 'expiryDate',
                    label: 'EXPIRY DATE',
                    width: 120.w,
                  ),
                  ViewTableColumn(
                    id: 'dayHigh',
                    label: 'DAY HIGH',
                    width: 120.w,
                  ),
                  ViewTableColumn(id: 'dayLow', label: 'DAY LOW', width: 120.w),
                  ViewTableColumn(
                    id: 'dayClose',
                    label: 'DAY CLOSE',
                    width: 120.w,
                  ),
                ],
                data: _filteredData,
                autoFit: true,
                cellBuilder: (item, column) {
                  final dataItem = item;
                  switch (column.id) {
                    case 'exch':
                      return Text(dataItem.exch);
                    case 'symbol':
                      return Text(dataItem.symbol);
                    case 'expiryDate':
                      return Text(dataItem.expiryDate);
                    case 'dayHigh':
                      return Text(dataItem.dayHigh.toStringAsFixed(0));
                    case 'dayLow':
                      return Text(dataItem.dayLow.toStringAsFixed(0));
                    case 'dayClose':
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.primaryBlue,
                            width: 1.2,
                          ),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          dataItem.dayClose.toStringAsFixed(0),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    default:
                      return const SizedBox();
                  }
                },
                idExtractor: (item) => item.symbol,
              ),
            ),
            SizedBox(height: 15.h),
            CustomActionButton(
              text: 'Submit',
              onPressed: () => _onSubmit(context),
              width: 120.w,
              height: 40.h,
            ),
          ],
        ),
      ),
    );
  }
}
