import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/app_checkbox.dart';
import '../../../../../../core/widget/app_dropdown.dart';
import '../../../../../../core/widget/app_radio_group.dart';
import '../../../../../../core/widget/custom_action_button.dart';
import '../../../../../../core/widget/custom_input_field.dart';
import '../../../bloc/user_form/user_form_bloc.dart';
import '../../../bloc/user_form/user_form_event.dart';
import '../../../bloc/user_form/user_form_state.dart';
import '../../../../../../core/widget/table/view_data_table.dart';
import '../../../../../../core/widget/table/view_record_count.dart';

class BrokerageSettingStep extends StatefulWidget {
  final bool showUpdateButton;
  const BrokerageSettingStep({super.key, this.showUpdateButton = true});
  @override
  State<BrokerageSettingStep> createState() => _BrokerageSettingStepState();
}

class _BrokerageSettingStepState extends State<BrokerageSettingStep> {
  late TextEditingController _exchangeWiseBrkController;
  late TextEditingController _symbolWiseBrkController;
  @override
  void initState() {
    super.initState();
    final state = context.read<UserFormBloc>().state;
    _exchangeWiseBrkController = TextEditingController(
      text: state.exchangeWiseBrk,
    );
    _symbolWiseBrkController = TextEditingController(text: state.symbolWiseBrk);
  }

  @override
  void dispose() {
    _exchangeWiseBrkController.dispose();
    _symbolWiseBrkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserFormBloc, UserFormState>(
      builder: (context, state) {
        final isExchangeWise = state.brokerageViewMode == 'Exchange Wise';
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryBlue, width: 1.0),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppRadioGroup<String>(
                options: const [
                  RadioOption(value: 'Exchange Wise', label: 'Exchange Wise'),
                  RadioOption(value: 'Symbol Wise', label: 'Symbol Wise'),
                ],
                value: state.brokerageViewMode,
                onChanged: (value) {
                  context.read<UserFormBloc>().add(
                    UpdateBrokerageViewModeEvent(value ?? 'Exchange Wise'),
                  );
                },
              ),
              SizedBox(height: 10.h),
              if (isExchangeWise)
                _buildExchangeWiseInputs(state)
              else
                _buildSymbolWiseInputs(state),
              ViewRecordCount(count: UserFormState.availableExchanges.length),
              SizedBox(
                height: 260.h,
                child: ViewDataTable<String>(
                  shrinkWrap: false,
                  autoFit: true,
                  comparatorBuilder: (item, columnId) {
                    return item;
                  },
                  rowHeight: 28.h,
                  headerHeight: 32.h,
                  columns: _getColumns(context, state),
                  data: UserFormState.availableExchanges,
                  idExtractor: (item) => item,
                  emptyMessage: 'No exchanges found',
                  cellBuilder: (item, column) =>
                      _buildCell(context, state, item, column),
                ),
              ),
              if (widget.showUpdateButton)
                Center(
                  child: CustomActionButton(
                    text: 'Update',
                    width: 200.w,
                    height: 35.h,
                    borderRadius: 10.r,
                    onPressed: () {},
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExchangeWiseInputs(UserFormState state) {
    return Row(
      children: [
        Expanded(
          child: AppDropdown(
            hintText: 'Exchange',
            value: state.selectedBrokerageExchange,
            items: UserFormState.availableExchanges,
            height: 30.h,
            onChanged: (value) {
              context.read<UserFormBloc>().add(
                UpdateFormFieldEvent(
                  fieldName: 'selectedBrokerageExchange',
                  value: value,
                ),
              );
            },
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: CustomInputField(
            controller: _exchangeWiseBrkController,
            hintText: 'Type exch wise brk',
            height: 30.h,
            keyboardType: TextInputType.number,
            onChanged: (v) {
              context.read<UserFormBloc>().add(
                UpdateFormFieldEvent(fieldName: 'exchangeWiseBrk', value: v),
              );
            },
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: CustomInputField(
            controller: _symbolWiseBrkController,
            hintText: 'Type symbol wise brk',
            height: 30.h,
            keyboardType: TextInputType.number,
            onChanged: (v) {
              context.read<UserFormBloc>().add(
                UpdateFormFieldEvent(fieldName: 'symbolWiseBrk', value: v),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSymbolWiseInputs(UserFormState state) {
    return Row(
      children: [
        Expanded(
          child: AppDropdown(
            hintText: 'Exchange',
            value: state.selectedBrokerageExchange,
            items: UserFormState.availableExchanges,
            height: 30.h,
            onChanged: (value) {
              context.read<UserFormBloc>().add(
                UpdateFormFieldEvent(
                  fieldName: 'selectedBrokerageExchange',
                  value: value,
                ),
              );
            },
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: CustomInputField(
            controller: _exchangeWiseBrkController,
            hintText: 'Type brokerage price',
            height: 30.h,
            keyboardType: TextInputType.number,
            onChanged: (v) {
              context.read<UserFormBloc>().add(
                UpdateFormFieldEvent(fieldName: 'exchangeWiseBrk', value: v),
              );
            },
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(child: const SizedBox()),
      ],
    );
  }

  List<ViewTableColumn> _getColumns(BuildContext context, UserFormState state) {
    final isAllSelected =
        state.selectedBrokerageExchanges.length ==
        UserFormState.availableExchanges.length;
    return [
      ViewTableColumn(
        id: 'checkbox',
        label: '',
        width: 40,
        sortable: false,
        customHeaderWidget: AppCheckbox(
          value: isAllSelected,
          onChanged: (value) {
            context.read<UserFormBloc>().add(
              ToggleAllBrokerageExchangesEvent(value ?? false),
            );
          },
        ),
      ),
      ViewTableColumn(
        id: 'exchange',
        label: state.brokerageViewMode == 'Symbol Wise' ? 'SYMBOL' : 'EXCHANGE',
        width: 80,
        sortable: false,
      ),
      ViewTableColumn(
        id: 'turnover',
        label: 'TURNOVER WISE\n(Rs.PER1/CR)',
        width: 130,
        sortable: false,
      ),
      ViewTableColumn(
        id: 'symbol',
        label: 'SYMBOL WISE BRK (Rs.)',
        width: 140,
        sortable: false,
      ),
    ];
  }

  Widget _buildCell(
    BuildContext context,
    UserFormState state,
    String exchange,
    ViewTableColumn column,
  ) {
    final data = state.brokerageData[exchange];
    final isSelected = state.selectedBrokerageExchanges.contains(exchange);
    switch (column.id) {
      case 'checkbox':
        return AppCheckbox(
          value: isSelected,
          onChanged: (value) {
            context.read<UserFormBloc>().add(
              UpdateBrokerageEvent(
                exchange: exchange,
                isSelected: value ?? false,
              ),
            );
          },
        );
      case 'exchange':
        return Text(
          exchange,
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor(context),
          ),
          textAlign: TextAlign.center,
        );
      case 'turnover':
        return Text(
          data?.turnoverWise ?? '00',
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textColor(context),
          ),
          textAlign: TextAlign.center,
        );
      case 'symbol':
        return Text(
          data?.symbolWiseBrk ?? '00',
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textColor(context),
          ),
          textAlign: TextAlign.center,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
