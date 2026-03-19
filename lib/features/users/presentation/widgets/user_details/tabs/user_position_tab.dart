import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/widget/table/view_data_table.dart'
    show ViewTableColumn, ViewDataTable;
import '../../../../../../core/widget/table/view_record_count.dart';
import '../../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../../../../../core/widget/table/view_reset_buttons.dart';
import '../../../../../../injection_container.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/app_dropdown.dart';
import '../../../../domain/entities/user.dart';
import '../../../../domain/entities/user_position/user_position.dart';
import '../../../bloc/user_position/user_position_bloc.dart';

class UserPositionTab extends StatelessWidget {
  final User user;
  const UserPositionTab({super.key, required this.user});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<UserPositionBloc>()..add(LoadUserPositions(user.id)),
      child: const UserPositionTabView(),
    );
  }
}

class UserPositionTabView extends StatelessWidget {
  const UserPositionTabView({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilterBar(context),
        _buildRecordCount(context),
        Expanded(child: _buildTable(context)),
        _buildFooter(context),
      ],
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      color: AppColors.white,
      child: BlocBuilder<UserPositionBloc, UserPositionState>(
        builder: (context, state) {
          String? selectedExchange;
          String? selectedSymbol;
          List<String> exchanges = [];
          List<String> symbols = [];
          if (state is UserPositionLoaded) {
            selectedExchange = state.selectedExchange;
            selectedSymbol = state.selectedSymbol;
            exchanges = state.exchanges;
            symbols = state.symbols;
          }
          return Row(
            children: [
              Row(
                children: [
                  AppDropdown(
                    hintText: 'Exchange',
                    items: exchanges,
                    value: selectedExchange,
                    onChanged: (val) {
                      context.read<UserPositionBloc>().add(
                        FilterUserPositions(
                          exchange: val,
                          symbol: selectedSymbol,
                        ),
                      );
                    },
                    width: 160.w,
                    height: 35.h,
                    type: AppDropdownType.simple,
                  ),
                  SizedBox(width: 5.w),
                  AppDropdown(
                    hintText: 'NIFTY Oct 28',
                    items: symbols,
                    value: selectedSymbol,
                    onChanged: (val) {
                      context.read<UserPositionBloc>().add(
                        FilterUserPositions(
                          exchange: selectedExchange,
                          symbol: val,
                        ),
                      );
                    },
                    width: 160.w,
                    height: 35.h,
                    type: AppDropdownType.search,
                  ),
                ],
              ),
              const Spacer(),
              ViewResetButtons(
                onReset: () {
                  context.read<UserPositionBloc>().add(
                    const FilterUserPositions(exchange: null, symbol: null),
                  );
                },
                onView: () {},
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRecordCount(BuildContext context) {
    return Container(
      color: AppColors.white,
      width: double.infinity,
      child: BlocBuilder<UserPositionBloc, UserPositionState>(
        builder: (context, state) {
          int count = 0;
          if (state is UserPositionLoaded) {
            count = state.filteredPositions.length;
          }
          return ViewRecordCount(count: count);
        },
      ),
    );
  }

  Widget _buildTable(BuildContext context) {
    return BlocBuilder<UserPositionBloc, UserPositionState>(
      builder: (context, state) {
        if (state is UserPositionLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is UserPositionError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        List<UserPosition> positions = [];
        if (state is UserPositionLoaded) {
          positions = state.filteredPositions;
        }
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return ViewDataTable<UserPosition>(
          autoFit: true,
          columns: [
            ViewTableColumn(id: 'exch', label: 'EXCH', width: 80.w),
            ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 100.w),
            ViewTableColumn(
              id: 'buyQty',
              label: 'BUY QTY',
              width: 90.w,
              isNumeric: true,
            ),
            ViewTableColumn(
              id: 'sellQty',
              label: 'SELL QTY',
              width: 100.w,
              isNumeric: true,
            ),
            ViewTableColumn(
              id: 'netQty',
              label: 'NET QTY',
              width: 100.w,
              isNumeric: true,
            ),
            ViewTableColumn(
              id: 'netAp',
              label: 'NET A. P.',
              width: 110.w,
              isNumeric: true,
            ),
            ViewTableColumn(
              id: 'cmp',
              label: 'CMP',
              width: 100.w,
              isNumeric: true,
            ),
            ViewTableColumn(
              id: 'm2m',
              label: 'M2M AMT',
              width: 120.w,
              isNumeric: true,
            ),
            ViewTableColumn(
              id: 'lot',
              label: 'LOT',
              width: 80.w,
              isNumeric: true,
            ),
          ],
          data: positions,
          idExtractor: (item) =>
              '${item.exchange}_${item.symbol}_${item.buyQty}',
          comparatorBuilder: (item, columnId) {
            switch (columnId) {
              case 'exch':
                return item.exchange;
              case 'symbol':
                return item.symbol;
              case 'buyQty':
                return item.buyQty;
              case 'sellQty':
                return item.sellQty;
              case 'netQty':
                return item.netQty;
              case 'netAp':
                return item.netAp;
              case 'cmp':
                return item.cmp;
              case 'm2m':
                return item.m2m;
              case 'lot':
                return item.lot;
              default:
                return '';
            }
          },
          cellBuilder: (item, column) {
            switch (column.id) {
              case 'exch':
                return ViewTextCell(text: item.exchange, isDark: isDark);
              case 'symbol':
                return ViewTextCell(text: item.symbol, isDark: isDark);
              case 'buyQty':
                return ViewNumberCell(
                  value: item.buyQty,
                  colorByValue: true,
                  isDark: isDark,
                );
              case 'sellQty':
                return ViewNumberCell(
                  value: item.sellQty,
                  colorByValue: true,
                  isDark: isDark,
                );
              case 'netQty':
                return ViewNumberCell(
                  value: item.netQty,
                  colorByValue: true,
                  isDark: isDark,
                );
              case 'netAp':
                return ViewNumberCell(
                  value: item.netAp,
                  fixedColor: AppColors.primaryBlue,
                  isDark: isDark,
                );
              case 'cmp':
                return ViewNumberCell(
                  value: item.cmp,
                  fixedColor: AppColors.errorColor,
                  isDark: isDark,
                );
              case 'm2m':
                return ViewNumberCell(
                  value: item.m2m,
                  colorByValue: true,
                  isDark: isDark,
                );
              case 'lot':
                return ViewNumberCell(
                  value: item.lot,
                  displayText: item.lot.toStringAsFixed(2),
                  colorByValue: false,
                  isDark: isDark,
                );
              default:
                return const SizedBox();
            }
          },
        );
      },
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      color: AppColors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFFC6DBE8).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                _buildFooterItem('Used Margin', '1000000.00'),
                _buildVerticalDivider(),
                _buildFooterItem('Free Margin', '1000000.00'),
                _buildVerticalDivider(),
                _buildFooterItem('Credit', '500000.00'),
              ],
            ),
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFFC6DBE8).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSummaryItem('Realised P&L', '0.00'),
                SizedBox(width: 12.w),
                Icon(Icons.add, size: 14.sp),
                SizedBox(width: 12.w),
                _buildSummaryItem('M2M', '124536.00'),
                SizedBox(width: 12.w),
                Icon(Icons.add, size: 14.sp),
                SizedBox(width: 12.w),
                _buildSummaryItem('BRK', '124536.00'),
                SizedBox(width: 12.w),
                const Text('=', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 12.w),
                Text(
                  '-81400.00',
                  style: GoogleFonts.openSans(
                    fontSize: 14.sp,
                    color: AppColors.errorColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 20.h,
      width: 1.w,
      color: const Color(0xFF1F4A66),
      margin: EdgeInsets.symmetric(horizontal: 12.w),
    );
  }

  Widget _buildFooterItem(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            color: AppColors.primaryBlue,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            color: AppColors.primaryBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Row(
      children: [
        Text(
          '$label : ',
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            color: AppColors.primaryBlue,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            color: AppColors.primaryBlue,
          ),
        ),
      ],
    );
  }
}