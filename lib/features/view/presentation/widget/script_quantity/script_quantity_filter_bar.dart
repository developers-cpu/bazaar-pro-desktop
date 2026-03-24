import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../../../../core/widget/table/view_reset_buttons.dart';
import '../../bloc/script_quantity/script_quantity_bloc.dart';
import '../../bloc/script_quantity/script_quantity_event.dart';
import '../../bloc/script_quantity/script_quantity_state.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_state.dart';

class ScriptQuantityFilterBar extends StatefulWidget {
  const ScriptQuantityFilterBar({Key? key}) : super(key: key);
  @override
  State<ScriptQuantityFilterBar> createState() =>
      _ScriptQuantityFilterBarState();
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
        final authState = context.read<AuthBloc>().state;
        final isClient =
            authState is AuthAuthenticated &&
            authState.user.role.toLowerCase() == 'client';
        final bool isExchangeSelected = state.selectedExchange != null;
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
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
                      if (isClient) {
                        context.read<ScriptQuantityBloc>().add(
                          UpdateScriptQuantityFilterEvent(value),
                        );
                      } else {
                        setState(() {
                          _tempSelectedGroup = null;
                        });
                        context.read<ScriptQuantityBloc>().add(
                          LoadGroupsEvent(value),
                        );
                      }
                    }
                  },
                ),
              ),
              if (!isClient) ...[
                SizedBox(width: 12.w),
                SizedBox(
                  width: 230.w,
                  child: IgnorePointer(
                    ignoring: !isExchangeSelected,
                    child: AppDropdown(
                      type: AppDropdownType.search,
                      hintText: 'Group Name',
                      value: _tempSelectedGroup ?? state.selectedGroup,
                      items: isExchangeSelected ? state.groups : [],
                      onChanged: (value) {
                        if (value != null &&
                            value.isNotEmpty &&
                            state.selectedExchange != null) {
                          setState(() {
                            _tempSelectedGroup = value;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
              SizedBox(width: 12.w),
              ViewResetButtons(
                showReset: !isClient,
                onReset: () {
                  setState(() {
                    _tempSelectedGroup = null;
                  });
                  context.read<ScriptQuantityBloc>().add(
                    const ResetFiltersEvent(),
                  );
                },
                onView: () {
                  if (isClient) {
                    if (state.selectedExchange != null &&
                        state.selectedExchange!.isNotEmpty) {
                      final defaultGroup = '${state.selectedExchange}_X';
                      context.read<ScriptQuantityBloc>().add(
                        LoadScriptQuantitiesEvent(
                          exchange: state.selectedExchange!,
                          group: defaultGroup,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Please select Exchange'),
                          backgroundColor: AppColors.errorColor,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  } else {
                    if (state.selectedExchange != null &&
                        _tempSelectedGroup != null) {
                      context.read<ScriptQuantityBloc>().add(
                        LoadScriptQuantitiesEvent(
                          exchange: state.selectedExchange!,
                          group: _tempSelectedGroup!,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Please select both Exchange and Group',
                          ),
                          backgroundColor: AppColors.errorColor,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
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
