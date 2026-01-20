import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../bloc/script_quantity/script_quantity_bloc.dart';
import '../../bloc/script_quantity/script_quantity_event.dart';
import '../../bloc/script_quantity/script_quantity_state.dart';
import '../common/view_reset_buttons.dart';

/// Filter bar for Script Quantity page
class ScriptQuantityFilterBar extends StatefulWidget {
  const ScriptQuantityFilterBar({Key? key}) : super(key: key);

  @override
  State<ScriptQuantityFilterBar> createState() => _ScriptQuantityFilterBarState();
}

class _ScriptQuantityFilterBarState extends State<ScriptQuantityFilterBar> {
  String? _tempSelectedGroup;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScriptQuantityBloc, ScriptQuantityState>(
      builder: (context, state) {
        if (state is ScriptQuantityLoading) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is! ScriptQuantityFiltersLoaded) {
          return const SizedBox.shrink();
        }

        final bool isExchangeSelected = state.selectedExchange != null;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              // Exchange Dropdown
              SizedBox(
                width: 230.w,
                child: AppDropdown(
                  type: AppDropdownType.simple,
                  hintText: 'Exchange',
                  value: state.selectedExchange,
                  items: state.exchanges,
                  showAllOption: false,
                  onChanged: (value) {
                    if (value != null && value.isNotEmpty) {
                      setState(() {
                        _tempSelectedGroup = null;
                      });
                      context.read<ScriptQuantityBloc>().add(
                        LoadGroupsEvent(value),
                      );
                    }
                  },
                ),
              ),
              SizedBox(width: 12.w),

              // Group Dropdown
              SizedBox(
                width: 230.w,
                child: IgnorePointer(
                  ignoring: !isExchangeSelected,
                  child: Opacity(
                    opacity: isExchangeSelected ? 1.0 : 0.6,
                    child: AppDropdown(
                      type: AppDropdownType.search,
                      hintText: 'Symbol',
                      value: _tempSelectedGroup ?? state.selectedGroup,
                      items: isExchangeSelected ? state.groups : [],
                      onChanged: (value) {
                        if (value != null && value.isNotEmpty && state.selectedExchange != null) {
                          setState(() {
                            _tempSelectedGroup = value;
                          });

                          // Automatically load data when group is selected
                          context.read<ScriptQuantityBloc>().add(
                            LoadScriptQuantitiesEvent(
                              exchange: state.selectedExchange!,
                              group: value,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Reset and View Buttons
              ViewResetButtons(
                onReset: () {
                  setState(() {
                    _tempSelectedGroup = null;
                  });
                  context.read<ScriptQuantityBloc>().add(
                    const ResetFiltersEvent(),
                  );
                },
                onView: () {
                  // View button now just re-triggers load if both are selected
                  if (state.selectedExchange != null && _tempSelectedGroup != null) {
                    context.read<ScriptQuantityBloc>().add(
                      LoadScriptQuantitiesEvent(
                        exchange: state.selectedExchange!,
                        group: _tempSelectedGroup!,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Please select both Exchange and Group'),
                        backgroundColor: AppColors.errorColor,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}