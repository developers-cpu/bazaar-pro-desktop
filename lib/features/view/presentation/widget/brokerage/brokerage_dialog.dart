import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/widget/app_dropdown.dart';
import '../../../../../../core/widget/common_dilog_box.dart';
import '../../../../../../injection_container.dart';
import '../../../domain/entities/brokerage/brokerage.dart';
import '../../bloc/brokerage/brokerage_bloc.dart';
import '../../bloc/brokerage/brokerage_event.dart';
import '../../bloc/brokerage/brokerage_state.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';

class BrokerageDialog {
  static void showFromPage(
    BuildContext context,
    BrokerageLoaded state, {
    VoidCallback? onClose,
  }) {
    final brokerageBloc = context.read<BrokerageBloc>();
    CommonDialog.show(
      context: context,
      title: 'Brokerage',
      width: 750.w,
      height: 750.h,
      showButtons: false,
      scrollable: false,
      contentPadding: EdgeInsets.zero,
      onClose: onClose,
      content: BlocProvider.value(
        value: brokerageBloc,
        child: _BrokerageContent(initialState: state),
      ),
    );
  }

  static void show(BuildContext context) {
    CommonDialog.show(
      context: context,
      title: 'Brokerage',
      width: 750.w,
      height: 750.h,
      showButtons: false,
      scrollable: false,
      contentPadding: EdgeInsets.zero,
      content: BlocProvider(
        create: (_) => sl<BrokerageBloc>(),
        child: const _BrokerageContent(),
      ),
    );
  }
}

class _BrokerageContent extends StatelessWidget {
  final BrokerageLoaded? initialState;
  const _BrokerageContent({super.key, this.initialState});
  static const List<ViewTableColumn> _columns = [
    ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 250),
    ViewTableColumn(
      id: 'brokeragePercentage',
      label: 'BROKERAGE (%)',
      width: 200,
      isNumeric: true,
    ),
    ViewTableColumn(
      id: 'brokerageAmount',
      label: 'BROKERAGE (AMT)',
      width: 200,
      isNumeric: true,
    ),
  ];
  Widget _buildCell(Brokerage item, ViewTableColumn column) {
    switch (column.id) {
      case 'symbol':
        return ViewTextCell(text: item.symbol);
      case 'brokeragePercentage':
        return ViewNumberCell(
          value: item.brokeragePercentage,
          displayText: item.brokeragePercentage.toStringAsFixed(0),
          colorByValue: false,
        );
      case 'brokerageAmount':
        return ViewNumberCell(
          value: item.brokerageAmount,
          displayText: item.brokerageAmount.toStringAsFixed(0),
          colorByValue: false,
        );
      default:
        return ViewTextCell(text: '');
    }
  }

  Widget _buildExchangeInfo(String exchange) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: const Color(0xFFD3E3EC),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Exchange', style: TextStyle(fontSize: 10.sp)),
            SizedBox(height: 2.h),
            Text(
              exchange,
              style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16.h),
        BlocBuilder<BrokerageBloc, BrokerageState>(
          builder: (context, state) {
            final current = state is BrokerageLoaded ? state : initialState;
            if (current != null) {
              return _buildExchangeInfo(current.selectedExchange ?? '');
            }
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: AppDropdown(
                width: double.infinity,
                height: 40.h,
                type: AppDropdownType.simple,
                hintText: 'Exchange',
                value: null,
                items: const [
                  'NSE',
                  'MCX',
                  'CE/PE',
                  'OTHERS',
                  'COMEX',
                  'CRYPTO',
                  'GIFT',
                  'FOREX',
                ],
                showAllOption: false,
                onChanged: (value) {
                  if (value != null) {
                    context.read<BrokerageBloc>().add(
                      LoadBrokeragesEvent(exchange: value),
                    );
                  }
                },
              ),
            );
          },
        ),
        SizedBox(height: 16.h),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: BlocBuilder<BrokerageBloc, BrokerageState>(
              builder: (context, state) {
                if (state is BrokerageLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                final loaded = state is BrokerageLoaded ? state : initialState;
                if (loaded != null) {
                  if (loaded.brokerages.isEmpty) {
                    return const Center(child: Text('No brokerage data found'));
                  }
                  return ViewDataTable<Brokerage>(
                    columns: _columns,
                    data: loaded.brokerages,
                    comparatorBuilder: (item, columnId) {
                      switch (columnId) {
                        case 'exchange':
                          return item.exchange;
                        case 'symbol':
                          return item.symbol;
                        case 'brokeragePercentage':
                          return item.brokeragePercentage;
                        default:
                          return '';
                      }
                    },
                    cellBuilder: _buildCell,
                    idExtractor: (item) =>
                        '${item.exchange}_${item.symbol}_${item.brokeragePercentage}',
                    emptyMessage: 'No brokerage data found',
                    autoFit: true,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
