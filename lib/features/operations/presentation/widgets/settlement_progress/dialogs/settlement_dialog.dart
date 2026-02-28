import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/common_dilog_box.dart';
import '../../../../../../core/widget/custom_action_button.dart';
import '../../../../../../core/widget/table/view_data_table.dart';
import 'settlement_progress_dialog.dart';

class SettlementDialog extends StatefulWidget {
  const SettlementDialog({super.key});

  @override
  State<SettlementDialog> createState() => _SettlementDialogState();
}

class _SettlementDialogState extends State<SettlementDialog> {
  final List<String> _exchanges = const [
    'MCX',
    'NSE',
    'CE/PE',
    'GIFT',
    'OTHERS',
    'CRYPTO',
    'COMEX FUTURE',
    'FOREX',
    'USSTOCK',
  ];

  Set<String> _selectedIds = {};

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: 'Settlement',
      width: 500.w,
      height: 450.h,
      showButtons: false,
      scrollable: false,
      contentPadding: EdgeInsets.zero,
      content: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          children: [
            Expanded(
              child: ViewDataTable<String>(
                data: _exchanges,
                idExtractor: (item) => item,
                autoFit: true,
                columns: [
                  ViewTableColumn(
                    id: 'checkbox',
                    label: '',
                    width: 50.w,
                    sortable: false,
                    customHeaderWidget: SizedBox(
                      height: 20.h,
                      width: 20.w,
                      child: Checkbox(
                        value: _selectedIds.length == _exchanges.length,
                        onChanged: (val) {
                          setState(() {
                            if (val == true) {
                              _selectedIds = _exchanges.toSet();
                            } else {
                              _selectedIds.clear();
                            }
                          });
                        },
                        activeColor: AppColors.primaryBlue,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                  ),
                  ViewTableColumn(
                    id: 'exch',
                    label: 'EXCH',
                    width: 350.w,
                    sortable: true,
                  ),
                ],
                cellBuilder: (item, column) {
                  switch (column.id) {
                    case 'checkbox':
                      return SizedBox(
                        height: 20.h,
                        width: 20.w,
                        child: Checkbox(
                          value: _selectedIds.contains(item),
                          onChanged: (val) {
                            setState(() {
                              if (val == true) {
                                _selectedIds.add(item);
                              } else {
                                _selectedIds.remove(item);
                              }
                            });
                          },
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          activeColor: AppColors.primaryBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      );
                    case 'exch':
                      return Center(
                        child: Text(
                          item,
                          style: GoogleFonts.openSans(
                            fontSize: 12.sp,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      );
                    default:
                      return const SizedBox.shrink();
                  }
                },
              ),
            ),
            SizedBox(height: 20.h),
            Center(
              child: CustomActionButton(
                text: 'Start',
                onPressed: () {
                  final selectedExchanges = _selectedIds.toList();
                  Navigator.of(context).pop();
                  if (selectedExchanges.isNotEmpty) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => SettlementProgressDialog(
                        exchanges: selectedExchanges,
                      ),
                    );
                  }
                },
                width: 120.w,
                height: 35.h,
                borderRadius: 8.r,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
