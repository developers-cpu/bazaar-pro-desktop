import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../../../view/presentation/widget/common/view_reset_buttons.dart';
import '../../bloc/symbol_wise_position_report/symbol_wise_position_report_bloc.dart';
import '../../bloc/symbol_wise_position_report/symbol_wise_position_report_event.dart';
import '../../bloc/symbol_wise_position_report/symbol_wise_position_report_state.dart';
class SymbolWisePositionReportFilterBar extends StatelessWidget {
  const SymbolWisePositionReportFilterBar({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      SymbolWisePositionReportBloc,
      SymbolWisePositionReportState
    >(
      builder: (context, state) {
        if (state is! SymbolWisePositionReportLoaded) {
          return const SizedBox.shrink();
        }
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              AppDropdown(
                width: 200.w,
                height: 35.h,
                type: AppDropdownType.simple,
                hintText: 'Exchange',
                value: state.selectedExchange,
                items: state.exchanges,
                showAllOption: true,
                onChanged: (value) {
                  context.read<SymbolWisePositionReportBloc>().add(
                    FilterSymbolWisePositionReport(exchange: value),
                  );
                },
              ),
              SizedBox(width: 12.w),
              AppDropdown(
                width: 200.w,
                height: 35.h,
                type: AppDropdownType.search,
                hintText: 'Symbol',
                searchHint: 'Search & Add',
                value: state.selectedSymbol,
                items: state.symbols,
                onChanged: (value) {
                  context.read<SymbolWisePositionReportBloc>().add(
                    FilterSymbolWisePositionReport(symbol: value),
                  );
                },
              ),
              const Spacer(),
              ViewResetButtons(
                onReset: () {
                  context.read<SymbolWisePositionReportBloc>().add(
                    const ResetSymbolWisePositionReportFilters(),
                  );
                },
                onView: () {
                  context.read<SymbolWisePositionReportBloc>().add(
                    FilterSymbolWisePositionReport(
                      exchange: state.selectedExchange,
                      symbol: state.selectedSymbol,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
