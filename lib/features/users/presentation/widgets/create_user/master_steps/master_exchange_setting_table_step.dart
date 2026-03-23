import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/custom_input_field.dart';
import '../../../../../../core/widget/table/view_data_table.dart';
import '../../../bloc/user_form/user_form_bloc.dart';
import '../../../bloc/user_form/user_form_event.dart';
import '../../../bloc/user_form/user_form_state.dart';

class MasterExchangeSettingTableStep extends StatefulWidget {
  const MasterExchangeSettingTableStep({super.key});

  @override
  State<MasterExchangeSettingTableStep> createState() =>
      _MasterExchangeSettingTableStepState();
}

class _MasterExchangeSettingTableStepState
    extends State<MasterExchangeSettingTableStep> {
  final Map<String, TextEditingController> _profitControllers = {};
  final Map<String, TextEditingController> _timeControllers = {};

  static const List<ViewTableColumn> _columns = [
    ViewTableColumn(
      id: 'exchange',
      label: 'EXCHANGE',
      width: 80,
      sortable: false,
    ),
    ViewTableColumn(
      id: 'profitSquareOff',
      label: 'Profit Square off',
      width: 120,
      sortable: false,
    ),
    ViewTableColumn(
      id: 'timeRestriction',
      label: 'Time Restriction for SL /Limit',
      width: 150,
      sortable: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    final state = context.read<UserFormBloc>().state;
    for (final exchange in UserFormState.exchangeSettingTableExchanges) {
      final row = state.exchangeSettingTableData[exchange] ?? {};
      _profitControllers[exchange] = TextEditingController(
        text: row['profitSquareOff'] ?? '',
      );
      _timeControllers[exchange] = TextEditingController(
        text: row['timeRestriction'] ?? '',
      );
    }
  }

  @override
  void dispose() {
    for (final c in _profitControllers.values) {
      c.dispose();
    }
    for (final c in _timeControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _updateField(String exchange, String field, String value) {
    context.read<UserFormBloc>().add(
      UpdateExchangeTableSettingEvent(
        exchange: exchange,
        field: field,
        value: value,
      ),
    );
  }

  Widget _buildCell(String exchange, ViewTableColumn column) {
    switch (column.id) {
      case 'exchange':
        return Center(
          child: Text(
            exchange,
            style: GoogleFonts.openSans(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textColor(context),
            ),
          ),
        );
      case 'profitSquareOff':
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
          child: CustomInputField(
            controller: _profitControllers[exchange]!,
            hintText: 'Type here',
            height: 32.h,
            width: double.infinity,
            keyboardType: TextInputType.number,
            onChanged: (v) => _updateField(exchange, 'profitSquareOff', v),
          ),
        );
      case 'timeRestriction':
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
          child: CustomInputField(
            controller: _timeControllers[exchange]!,
            hintText: 'Type here',
            height: 32.h,
            width: double.infinity,
            onChanged: (v) => _updateField(exchange, 'timeRestriction', v),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewDataTable<String>(
      columns: _columns,
      data: UserFormState.exchangeSettingTableExchanges,
      idExtractor: (exchange) => exchange,
      comparatorBuilder: (exchange, _) => exchange,
      cellBuilder: _buildCell,
      autoFit: true,
      shrinkWrap: true,
      rowHeight: 48.h,
    );
  }
}
