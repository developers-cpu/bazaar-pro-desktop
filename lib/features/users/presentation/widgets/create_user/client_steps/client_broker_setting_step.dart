import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/custom_action_button.dart';
import '../../../../../../core/widget/custom_input_field.dart';
import '../../../bloc/user_form/user_form_bloc.dart';
import '../../../bloc/user_form/user_form_event.dart';
import '../../../bloc/user_form/user_form_state.dart';
import '../../../../../view/presentation/widget/common/view_data_table.dart';
import '../../../../../view/presentation/widget/common/view_record_count.dart';

class ClientBrokerSettingStep extends StatefulWidget {
  const ClientBrokerSettingStep({super.key});
  @override
  State<ClientBrokerSettingStep> createState() =>
      _ClientBrokerSettingStepState();
}

class _ClientBrokerSettingStepState extends State<ClientBrokerSettingStep> {
  late TextEditingController _brokerNameController;
  String _selectedExchange = 'NSE';

  @override
  void initState() {
    super.initState();
    _brokerNameController = TextEditingController(text: 'Broker 1');
  }

  @override
  void dispose() {
    _brokerNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserFormBloc, UserFormState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryBlue, width: 1.0),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 200.w,
                child: CustomInputField(
                  controller: _brokerNameController,
                  hintText: 'Broker Name',
                  height: 30.h,
                  onChanged: (v) {
                    context.read<UserFormBloc>().add(
                      UpdateFormFieldEvent(fieldName: 'brokerName', value: v),
                    );
                  },
                ),
              ),
              SizedBox(height: 8.h),
              _buildExchangeTabs(),
              SizedBox(height: 4.h),
              ViewRecordCount(count: _getDummySymbols().length),
              SizedBox(
                height: 260.h,
                child: ViewDataTable<Map<String, String>>(
                  shrinkWrap: false,
                  autoFit: true,
                  rowHeight: 28.h,
                  headerHeight: 32.h,
                  columns: _getColumns(),
                  data: _getDummySymbols(),
                  idExtractor: (item) => item['symbol'] ?? '',
                  emptyMessage: 'No symbols found',
                  cellBuilder: (item, column) =>
                      _buildCell(context, item, column),
                ),
              ),
              Center(
                child: CustomActionButton(
                  text: 'Add',
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

  Widget _buildExchangeTabs() {
    final exchanges = UserFormState.availableExchanges;
    return Row(
      children: exchanges.map((exchange) {
        final isSelected = _selectedExchange == exchange;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedExchange = exchange),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryBlue : Colors.transparent,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                exchange,
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? AppColors.white
                      : AppColors.textColor(context),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  List<ViewTableColumn> _getColumns() {
    final baseColumns = [
      ViewTableColumn(
        id: 'symbol',
        label: 'SYMBOL',
        width: 100,
        sortable: false,
      ),
      ViewTableColumn(
        id: 'masterBrkPercent',
        label: 'MASTER BRK\n(% Wise)',
        width: 120,
        sortable: false,
      ),
      ViewTableColumn(
        id: 'brokerBrkPercent',
        label: 'BROKER BRK\n(% Wise)',
        width: 120,
        sortable: false,
      ),
    ];

    if (_selectedExchange != 'NSE') {
      baseColumns.addAll([
        ViewTableColumn(
          id: 'masterBrkLot',
          label: 'MASTER BRK\n(Lot Wise)',
          width: 120,
          sortable: false,
        ),
        ViewTableColumn(
          id: 'brokerBrkLot',
          label: 'BROKER BRK\n(Lot Wise)',
          width: 120,
          sortable: false,
        ),
      ]);
    }

    return baseColumns;
  }

  List<Map<String, String>> _getDummySymbols() {
    if (_selectedExchange == 'NSE') {
      return [
        {
          'symbol': 'RELIANCE',
          'masterBrkPercent': '500',
          'brokerBrkPercent': '500',
          'masterBrkLot': '500',
          'brokerBrkLot': '500',
        },
        {
          'symbol': 'HDFC BANK',
          'masterBrkPercent': '500',
          'brokerBrkPercent': '500',
          'masterBrkLot': '500',
          'brokerBrkLot': '500',
        },
        {
          'symbol': 'ICICI BANK',
          'masterBrkPercent': '500',
          'brokerBrkPercent': '500',
          'masterBrkLot': '500',
          'brokerBrkLot': '500',
        },
        {
          'symbol': 'GOLD',
          'masterBrkPercent': '500',
          'brokerBrkPercent': '500',
          'masterBrkLot': '500',
          'brokerBrkLot': '500',
        },
        {
          'symbol': 'GOLD',
          'masterBrkPercent': '500',
          'brokerBrkPercent': '500',
          'masterBrkLot': '500',
          'brokerBrkLot': '500',
        },
        {
          'symbol': 'GOLD',
          'masterBrkPercent': '500',
          'brokerBrkPercent': '500',
          'masterBrkLot': '500',
          'brokerBrkLot': '500',
        },
      ];
    } else if (_selectedExchange == 'MCX') {
      return [
        {
          'symbol': 'GOLD',
          'masterBrkPercent': '-',
          'brokerBrkPercent': '-',
          'masterBrkLot': '500',
          'brokerBrkLot': '500',
        },
        {
          'symbol': 'GOLD',
          'masterBrkPercent': '-',
          'brokerBrkPercent': '-',
          'masterBrkLot': '500',
          'brokerBrkLot': '500',
        },
        {
          'symbol': 'GOLD',
          'masterBrkPercent': '-',
          'brokerBrkPercent': '-',
          'masterBrkLot': '500',
          'brokerBrkLot': '500',
        },
        {
          'symbol': 'GOLD',
          'masterBrkPercent': '-',
          'brokerBrkPercent': '-',
          'masterBrkLot': '500',
          'brokerBrkLot': '500',
        },
        {
          'symbol': 'GOLD',
          'masterBrkPercent': '-',
          'brokerBrkPercent': '-',
          'masterBrkLot': '500',
          'brokerBrkLot': '500',
        },
        {
          'symbol': 'GOLD',
          'masterBrkPercent': '-',
          'brokerBrkPercent': '-',
          'masterBrkLot': '500',
          'brokerBrkLot': '500',
        },
      ];
    }
    return [];
  }

  Widget _buildCell(
    BuildContext context,
    Map<String, String> item,
    ViewTableColumn column,
  ) {
    final value = item[column.id] ?? '';
    if (column.id == 'symbol') {
      return Text(
        value,
        style: GoogleFonts.openSans(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textColor(context),
        ),
        textAlign: TextAlign.center,
      );
    }
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.grey.withOpacity(0.6),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Text(
          value,
          style: GoogleFonts.openSans(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textColor(context),
          ),
        ),
      ),
    );
  }
}
