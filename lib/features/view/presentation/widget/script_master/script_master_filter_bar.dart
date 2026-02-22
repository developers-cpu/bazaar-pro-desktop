import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../../../../core/widget/table/view_reset_buttons.dart';
import '../../bloc/script_master/script_master_bloc.dart';
import '../../bloc/script_master/script_master_event.dart';
import '../../bloc/script_master/script_master_state.dart';

class ScriptMasterFilterBar extends StatelessWidget {
  const ScriptMasterFilterBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScriptMasterBloc, ScriptMasterState>(
      builder: (context, state) {
        if (state is! ScriptMasterLoaded) {
          return const SizedBox.shrink();
        }
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              Expanded(
                child: AppDropdown(
                  type: AppDropdownType.simple,
                  hintText: 'Exchange',
                  value: state.selectedExchange,
                  items: state.exchanges,
                  showAllOption: false,
                  onChanged: (value) {
                    context.read<ScriptMasterBloc>().add(
                      ApplyFiltersEvent(
                        exchange: value,
                        symbol: state.selectedSymbol,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: AppDropdown(
                  type: AppDropdownType.search,
                  hintText: 'Symbol',
                  value: state.selectedSymbol,
                  items: state.symbols,
                  onChanged: (value) {
                    context.read<ScriptMasterBloc>().add(
                      ApplyFiltersEvent(
                        exchange: state.selectedExchange,
                        symbol: value,
                      ),
                    );
                  },
                ),
              ),
              const Spacer(),
              ViewResetButtons(
                onReset: () {
                  context.read<ScriptMasterBloc>().add(
                    const ResetFiltersEvent(),
                  );
                },
                onView: () {
                  context.read<ScriptMasterBloc>().add(
                    ApplyFiltersEvent(
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
