import 'package:bazarpro/core/widget/common_dilog_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bazarpro/injection_container.dart';
import '../../../../view/presentation/widget/common/view_data_table.dart';
import '../../../../view/presentation/widget/common/view_record_count.dart';
import '../../../../view/presentation/widget/common/view_table_cell_styles.dart';
import '../../../domain/entities/symbol_trade_log.dart';
import '../../bloc/symbol_wise_pl/trade_list/symbol_trade_list_bloc.dart';
import '../../bloc/symbol_wise_pl/trade_list/symbol_trade_list_event.dart';
import '../../bloc/symbol_wise_pl/trade_list/symbol_trade_list_state.dart';

class SymbolTradeListDialog extends StatelessWidget {
  final String? symbol;
  final String? exchange;

  const SymbolTradeListDialog({Key? key, this.symbol, this.exchange})
    : super(key: key);

  static void show(BuildContext context, {String? symbol, String? exchange}) {
    CommonDialog.show(
      context: context,
      title: 'User Details',
      width: 1200.w,
      height: 700.h,
      content: SymbolTradeListDialog(symbol: symbol, exchange: exchange),
      showButtons: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<SymbolTradeListBloc>()
            ..add(LoadSymbolTradeList(symbol: symbol, exchange: exchange)),
      child: BlocBuilder<SymbolTradeListBloc, SymbolTradeListState>(
        builder: (context, state) {
          if (state is SymbolTradeListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SymbolTradeListError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is SymbolTradeListLoaded) {
            return SizedBox(
              height: 600.h,
              child: Column(
                children: [
                  ViewRecordCount(count: state.tradeLogs.length),
                  Expanded(
                    child: ViewDataTable<SymbolTradeLog>(
                      columns: const [
                        ViewTableColumn(
                          id: 'sequence',
                          label: 'SEQUENCE',
                          width: 100,
                        ),
                        ViewTableColumn(
                          id: 'userName',
                          label: 'U. NAME',
                          width: 120,
                        ),
                        ViewTableColumn(
                          id: 'pUser',
                          label: 'P USER',
                          width: 120,
                        ),
                        ViewTableColumn(
                          id: 'exchange',
                          label: 'EXCH',
                          width: 80,
                        ),
                        ViewTableColumn(
                          id: 'symbol',
                          label: 'SYMBOL',
                          width: 150,
                        ),
                        ViewTableColumn(id: 'buySell', label: 'B/S', width: 80),
                        ViewTableColumn(
                          id: 'tradeType',
                          label: 'Trade Type',
                          width: 100,
                        ),
                        ViewTableColumn(id: 'qty', label: 'QTY', width: 100),
                        ViewTableColumn(id: 'lot', label: 'Lot', width: 80),
                        ViewTableColumn(id: 'pl', label: 'P/L', width: 100),
                        ViewTableColumn(
                          id: 'validity',
                          label: 'Validity',
                          width: 100,
                        ),
                        ViewTableColumn(
                          id: 'tradePrice',
                          label: 'T. PRICE',
                          width: 100,
                        ),
                        ViewTableColumn(
                          id: 'brokerage',
                          label: 'Brk',
                          width: 80,
                        ),
                        ViewTableColumn(
                          id: 'netPrice',
                          label: 'NET P',
                          width: 100,
                        ),
                        ViewTableColumn(
                          id: 'orderDateTime',
                          label: 'Order D/T',
                          width: 180,
                        ),
                        ViewTableColumn(
                          id: 'executionDateTime',
                          label: 'Execution D/T',
                          width: 180,
                        ),
                        ViewTableColumn(
                          id: 'referencePrice',
                          label: 'R. PRICE',
                          width: 100,
                        ),
                      ],
                      data: state.tradeLogs,
                      idExtractor: (item) => item.hashCode.toString(),
                      autoFit: true,
                      cellBuilder:
                          (SymbolTradeLog item, ViewTableColumn column) {
                            final isDark = false;
                            switch (column.id) {
                              case 'sequence':
                                return ViewTextCell(
                                  text: item.sequence,
                                  isDark: isDark,
                                );
                              case 'userName':
                                return ViewTextCell(
                                  text: item.userName,
                                  isDark: isDark,
                                  fontWeight: FontWeight.bold,
                                );
                              case 'pUser':
                                return ViewTextCell(
                                  text: item.pUser,
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
                                  color: Colors.red,
                                );
                              case 'buySell':
                                return ViewBuySellCell(
                                  text: item.buySell,
                                  isDark: isDark,
                                );
                              case 'tradeType':
                                return ViewTextCell(
                                  text: item.tradeType,
                                  isDark: isDark,
                                );
                              case 'qty':
                                return ViewNumberCell(
                                  value: item.qty,
                                  isDark: isDark,
                                );
                              case 'lot':
                                return ViewNumberCell(
                                  value: item.lot,
                                  isDark: isDark,
                                  colorByValue: false,
                                );
                              case 'pl':
                                return ViewNumberCell(
                                  value: item.pl,
                                  isDark: isDark,
                                );
                              case 'validity':
                                return ViewTextCell(
                                  text: item.validity,
                                  isDark: isDark,
                                );
                              case 'tradePrice':
                                return ViewNumberCell(
                                  value: item.tradePrice,
                                  isDark: isDark,
                                );
                              case 'brokerage':
                                return ViewNumberCell(
                                  value: item.brokerage,
                                  isDark: isDark,
                                  colorByValue: false,
                                );
                              case 'netPrice':
                                return ViewNumberCell(
                                  value: item.netPrice,
                                  isDark: isDark,
                                );
                              case 'orderDateTime':
                                return ViewTextCell(
                                  text: item.orderDateTime,
                                  isDark: isDark,
                                );
                              case 'executionDateTime':
                                return ViewTextCell(
                                  text: item.executionDateTime,
                                  isDark: isDark,
                                );
                              case 'referencePrice':
                                return ViewNumberCell(
                                  value: item.referencePrice,
                                  isDark: isDark,
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
