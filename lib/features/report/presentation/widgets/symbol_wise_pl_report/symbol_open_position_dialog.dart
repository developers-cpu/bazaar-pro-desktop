import 'package:bazarpro/core/constants/app_colors.dart';
import 'package:bazarpro/core/widget/common_dilog_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bazarpro/injection_container.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_record_count.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../../domain/entities/symbol_open_position.dart';
import '../../bloc/symbol_wise_pl/open_postion/symbol_open_position_bloc.dart';
import '../../bloc/symbol_wise_pl/open_postion/symbol_open_position_event.dart';
import '../../bloc/symbol_wise_pl/open_postion/symbol_open_position_state.dart';

class SymbolOpenPositionDialog extends StatelessWidget {
  final String? symbol;
  final String? exchange;
  const SymbolOpenPositionDialog({Key? key, this.symbol, this.exchange})
    : super(key: key);
  static void show(BuildContext context, {String? symbol, String? exchange}) {
    CommonDialog.show(
      context: context,
      title: 'Open Position',
      width: 1400.w,
      height: 700.h,
      content: SymbolOpenPositionDialog(symbol: symbol, exchange: exchange),
      showButtons: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<SymbolOpenPositionBloc>()
            ..add(LoadSymbolOpenPosition(symbol: symbol, exchange: exchange)),
      child: BlocBuilder<SymbolOpenPositionBloc, SymbolOpenPositionState>(
        builder: (context, state) {
          if (state is SymbolOpenPositionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SymbolOpenPositionError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is SymbolOpenPositionLoaded) {
            return SizedBox(
              height: 600.h,
              child: Column(
                children: [
                  ViewRecordCount(count: state.positions.length),
                  Flexible(
                    fit: FlexFit.loose,
                    child: ViewDataTable<SymbolOpenPosition>(
                      columns: const [
                        ViewTableColumn(id: 'name', label: 'U.NAME', width: 90),
                        ViewTableColumn(id: 'type', label: 'U.TYPE', width: 90),
                        ViewTableColumn(
                          id: 'exchange',
                          label: 'EXCH',
                          width: 80,
                        ),
                        ViewTableColumn(
                          id: 'symbol',
                          label: 'SYMBOL',
                          width: 110,
                        ),
                        ViewTableColumn(
                          id: 'buyQty',
                          label: 'BUY QTY',
                          width: 90,
                          isNumeric: true,
                        ),
                        ViewTableColumn(
                          id: 'sellQty',
                          label: 'SELL QTY',
                          width: 90,
                          isNumeric: true,
                        ),
                        ViewTableColumn(
                          id: 'netQty',
                          label: 'NET QTY',
                          width: 90,
                          isNumeric: true,
                        ),
                        ViewTableColumn(
                          id: 'netAvgPrice',
                          label: 'NET AVG PRICE',
                          width: 130,
                          isNumeric: true,
                        ),
                        ViewTableColumn(
                          id: 'cmp',
                          label: 'CMP',
                          width: 90,
                          isNumeric: true,
                        ),
                        ViewTableColumn(
                          id: 'm2m',
                          label: 'M2M AMT',
                          width: 100,
                          isNumeric: true,
                        ),
                        ViewTableColumn(
                          id: 'ourPercent',
                          label: 'OUR %',
                          width: 80,
                          isNumeric: true,
                        ),
                        ViewTableColumn(
                          id: 'user',
                          label: 'USER',
                          width: 80,
                          isNumeric: true,
                        ),
                        ViewTableColumn(
                          id: 'days',
                          label: 'DAYS',
                          width: 80,
                          isNumeric: true,
                        ),
                      ],
                      data: state.positions,
                      idExtractor: (item) => item.hashCode.toString(),
                      autoFit: true,
                      comparatorBuilder: (item, columnId) {
                        switch (columnId) {
                          case 'name':
                            return item.name;
                          case 'type':
                            return item.type;
                          case 'exchange':
                            return item.exchange;
                          case 'symbol':
                            return item.symbol;
                          case 'buyQty':
                            return item.buyQty;
                          case 'sellQty':
                            return item.sellQty;
                          case 'netQty':
                            return item.netQty;
                          case 'netAvgPrice':
                            return item.netAvgPrice;
                          case 'cmp':
                            return item.cmp;
                          case 'm2m':
                            return item.m2m;
                          case 'ourPercent':
                            return item.ourPercent;
                          case 'user':
                            return item.user;
                          case 'days':
                            return item.days;
                          default:
                            return '';
                        }
                      },
                      cellBuilder:
                          (SymbolOpenPosition item, ViewTableColumn column) {
                            final isDark = false;
                            switch (column.id) {
                              case 'name':
                                return ViewTextCell(
                                  text: item.name,
                                  isDark: isDark,
                                );
                              case 'type':
                                return ViewTextCell(
                                  text: item.type,
                                  isDark: isDark,
                                );
                              case 'exchange':
                                return ViewTextCell(
                                  text: item.exchange,
                                  isDark: isDark,
                                );
                              case 'symbol':
                                return ViewTextCell(
                                  text: item.symbol,
                                  isDark: isDark,
                                );
                              case 'buyQty':
                                return ViewNumberCell(
                                  value: item.buyQty,
                                  isDark: isDark,
                                  colorByValue: false,
                                );
                              case 'sellQty':
                                return ViewNumberCell(
                                  value: item.sellQty,
                                  isDark: isDark,
                                  fixedColor: AppColors.sellColor,
                                );
                              case 'netQty':
                                return ViewNumberCell(
                                  value: item.netQty,
                                  isDark: isDark,
                                );
                              case 'netAvgPrice':
                                return ViewNumberCell(
                                  value: item.netAvgPrice,
                                  isDark: isDark,
                                  colorByValue: false,
                                );
                              case 'cmp':
                                return ViewNumberCell(
                                  value: item.cmp,
                                  isDark: isDark,
                                  fixedColor: AppColors.buyColor,
                                );
                              case 'm2m':
                                return ViewNumberCell(
                                  value: item.m2m,
                                  isDark: isDark,
                                  fixedColor: AppColors.buyColor,
                                );
                              case 'ourPercent':
                                return ViewNumberCell(
                                  value: item.ourPercent,
                                  isDark: isDark,
                                  colorByValue: false,
                                );
                              case 'user':
                                return ViewTextCell(
                                  text: item.user,
                                  isDark: isDark,
                                  isNumeric: true,
                                );
                              case 'days':
                                return ViewTextCell(
                                  text: item.days.toString(),
                                  isDark: isDark,
                                  isNumeric: true,
                                );
                              default:
                                return const SizedBox.shrink();
                            }
                          },
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}