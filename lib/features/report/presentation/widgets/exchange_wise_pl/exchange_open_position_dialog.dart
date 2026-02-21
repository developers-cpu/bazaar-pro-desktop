import 'package:bazarpro/core/constants/app_colors.dart';
import 'package:bazarpro/core/widget/app_dropdown.dart';
import 'package:bazarpro/core/widget/common_dilog_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bazarpro/injection_container.dart';
import '../../../../view/presentation/widget/common/view_data_table.dart';
import '../../../../view/presentation/widget/common/view_record_count.dart';
import '../../../../view/presentation/widget/common/view_reset_buttons.dart';
import '../../../../view/presentation/widget/common/view_table_cell_styles.dart';
import '../../../domain/entities/symbol_open_position.dart';
import '../../bloc/symbol_wise_pl/open_postion/symbol_open_position_bloc.dart';
import '../../bloc/symbol_wise_pl/open_postion/symbol_open_position_event.dart';
import '../../bloc/symbol_wise_pl/open_postion/symbol_open_position_state.dart';
class ExchangeOpenPositionDialog extends StatelessWidget {
  final String? symbol;
  final String? exchange;
  const ExchangeOpenPositionDialog({Key? key, this.symbol, this.exchange})
    : super(key: key);
  static void show(BuildContext context, {String? symbol, String? exchange}) {
    CommonDialog.show(
      context: context,
      title: 'Order Position',
      width: 1400.w,
      height: 700.h,
      content: ExchangeOpenPositionDialog(symbol: symbol, exchange: exchange),
      showButtons: false,
    );
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<SymbolOpenPositionBloc>()
            ..add(LoadSymbolOpenPosition(symbol: symbol, exchange: exchange)),
      child: _DialogContent(symbol: symbol, exchange: exchange),
    );
  }
}
class _DialogContent extends StatefulWidget {
  final String? symbol;
  final String? exchange;
  const _DialogContent({Key? key, this.symbol, this.exchange})
    : super(key: key);
  @override
  State<_DialogContent> createState() => _DialogContentState();
}
class _DialogContentState extends State<_DialogContent> {
  String? selectedUser;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SymbolOpenPositionBloc, SymbolOpenPositionState>(
      builder: (context, state) {
        List<SymbolOpenPosition> positions = [];
        if (state is SymbolOpenPositionLoaded) {
          positions = state.positions;
        }
        return SizedBox(
          height: 600.h,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  children: [
                    AppDropdown(
                      width: 200.w,
                      height: 40.h,
                      type: AppDropdownType
                          .search,
                      hintText: 'User',
                      value: selectedUser,
                      items: positions
                          .map((e) => e.name)
                          .toSet()
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedUser = value;
                        });
                        context.read<SymbolOpenPositionBloc>().add(
                          LoadSymbolOpenPosition(
                            symbol: widget.symbol,
                            exchange: widget.exchange,
                            user: value,
                          ),
                        );
                      },
                    ),
                    const Spacer(),
                    ViewResetButtons(
                      onReset: () {
                        setState(() {
                          selectedUser = null;
                        });
                        context.read<SymbolOpenPositionBloc>().add(
                          LoadSymbolOpenPosition(
                            symbol: widget.symbol,
                            exchange: widget.exchange,
                          ),
                        );
                      },
                      onView: () {
                      },
                    ),
                  ],
                ),
              ),
              if (state is SymbolOpenPositionLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state is SymbolOpenPositionError)
                Expanded(child: Center(child: Text('Error: ${state.message}')))
              else ...[
                ViewRecordCount(count: positions.length),
                Expanded(
                  child: ViewDataTable<SymbolOpenPosition>(
                    columns: const [
                      ViewTableColumn(id: 'name', label: 'U.NAME', width: 120),
                      ViewTableColumn(id: 'exchange', label: 'EXCH', width: 80),
                      ViewTableColumn(
                        id: 'symbol',
                        label: 'SYMBOL',
                        width: 150,
                      ),
                      ViewTableColumn(
                        id: 'buyQty',
                        label: 'BUY QTY',
                        width: 100,
                      ),
                      ViewTableColumn(
                        id: 'sellQty',
                        label: 'SELL QTY',
                        width: 100,
                      ),
                      ViewTableColumn(
                        id: 'netQty',
                        label: 'NET QTY',
                        width: 100,
                      ),
                      ViewTableColumn(
                        id: 'netAvgPrice',
                        label: 'NET AVG PRICE',
                        width: 120,
                      ),
                      ViewTableColumn(id: 'cmp', label: 'CMP', width: 100),
                      ViewTableColumn(id: 'm2m', label: 'M2M AMT', width: 120),
                      ViewTableColumn(
                        id: 'ourPercent',
                        label: 'OUR %',
                        width: 80,
                      ),
                    ],
                    data: positions,
                    idExtractor: (item) => item.hashCode.toString(),
                    autoFit: true,
                    cellBuilder:
                        (SymbolOpenPosition item, ViewTableColumn column) {
                          final isDark = false;
                          switch (column.id) {
                            case 'name':
                              return ViewTextCell(
                                text: item.name,
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
                                fontWeight: FontWeight.bold,
                              );
                            case 'buyQty':
                              return ViewNumberCell(
                                value: item.buyQty,
                                isDark: isDark,
                                colorByValue: false,
                              );
                            case 'sellQty':
                              return ViewTextCell(
                                text: item.sellQty.toStringAsFixed(2),
                                isDark: isDark,
                                color: Colors.red,
                              );
                            case 'netQty':
                              return InkWell(
                                child: ViewTextCell(
                                  text: item.netQty.toString(),
                                  isDark: isDark,
                                  color: AppColors.primaryBlue,
                                  fontWeight: FontWeight.w600,
                                ),
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
                                fixedColor: Colors.blue,
                              );
                            case 'm2m':
                              return ViewNumberCell(
                                value: item.m2m,
                                isDark: isDark,
                                fixedColor: Colors.blue,
                              );
                            case 'ourPercent':
                              return ViewNumberCell(
                                value: item.ourPercent,
                                isDark: isDark,
                                colorByValue: false,
                              );
                            default:
                              return const SizedBox.shrink();
                          }
                        },
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
