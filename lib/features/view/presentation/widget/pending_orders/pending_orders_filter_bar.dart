import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/app_dropdown.dart';
import '../../bloc/pending_orders/pending_orders_bloc.dart';
import '../../bloc/pending_orders/pending_orders_event.dart';
import '../../bloc/pending_orders/pending_orders_state.dart';
import '../../../../../core/widget/table/view_reset_buttons.dart';
import 'cancel_all_orders_dialog.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_state.dart';

class PendingOrdersFilterBar extends StatelessWidget {
  const PendingOrdersFilterBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PendingOrdersBloc, PendingOrdersState>(
      builder: (context, state) {
        if (state is! PendingOrdersLoaded) {
          return const SizedBox.shrink();
        }
        final authState = context.read<AuthBloc>().state;
        final isClient =
            authState is AuthAuthenticated &&
            authState.user.role.toLowerCase() == 'client';

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      if (!isClient) ...[
                        SizedBox(
                          width: 200.w,
                          child: AppDropdown(
                            type: AppDropdownType.search,
                            hintText: 'Client',
                            value: state.selectedClient,
                            items: state.clients,
                            onChanged: (value) {
                              context.read<PendingOrdersBloc>().add(
                                UpdateFiltersEvent(
                                  client: value,
                                  exchange: state.selectedExchange,
                                  symbol: state.selectedSymbol,
                                  type: state.selectedType,
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 12.w),
                        SizedBox(
                          width: 200.w,
                          child: AppDropdown(
                            type: AppDropdownType.simple,
                            hintText: 'Exchange',
                            value: state.selectedExchange,
                            items: state.exchanges,
                            onChanged: (value) {
                              context.read<PendingOrdersBloc>().add(
                                UpdateFiltersEvent(
                                  client: state.selectedClient,
                                  exchange: value,
                                  symbol: state.selectedSymbol,
                                  type: state.selectedType,
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 12.w),
                        SizedBox(
                          width: 200.w,
                          child: AppDropdown(
                            type: AppDropdownType.search,
                            hintText: 'Symbol',
                            value: state.selectedSymbol,
                            items: state.symbols,
                            onChanged: (value) {
                              context.read<PendingOrdersBloc>().add(
                                UpdateFiltersEvent(
                                  client: state.selectedClient,
                                  exchange: state.selectedExchange,
                                  symbol: value,
                                  type: state.selectedType,
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 12.w),
                        SizedBox(
                          width: 200.w,
                          child: AppDropdown(
                            type: AppDropdownType.simple,
                            hintText: 'Type',
                            value: state.selectedType,
                            items: state.types,
                            showAllOption: true,
                            onChanged: (value) {
                              context.read<PendingOrdersBloc>().add(
                                UpdateFiltersEvent(
                                  client: state.selectedClient,
                                  exchange: state.selectedExchange,
                                  symbol: state.selectedSymbol,
                                  type: value,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              if (!isClient)
                ViewResetButtons(
                  showReset: true,
                  onReset: () {
                    context.read<PendingOrdersBloc>().add(
                      const ResetFiltersEvent(),
                    );
                  },
                  onView: () {
                    context.read<PendingOrdersBloc>().add(
                      ApplyFiltersEvent(
                        client: state.selectedClient,
                        exchange: state.selectedExchange,
                        symbol: state.selectedSymbol,
                        type: state.selectedType,
                      ),
                    );
                  },
                ),
              SizedBox(width: 8.w),
              SizedBox(
                height: 35.h,
                child: ElevatedButton(
                  onPressed: () {
                    CancelAllOrdersDialog.show(
                      context: context,
                      pendingOrders: state.filteredOrders,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    elevation: 0,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                  ),
                  child: Text(
                    'Cancel All Orders',
                    style: GoogleFonts.openSans(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
