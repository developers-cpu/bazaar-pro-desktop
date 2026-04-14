import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../bloc/exchange_settings/exchange_settings_bloc.dart';
import '../../bloc/exchange_settings/exchange_settings_event.dart';
import '../../bloc/exchange_settings/exchange_settings_state.dart';
import 'holiday_management_section.dart';
import 'timing_management_section.dart';

class ManageMarketTimingDialog extends StatefulWidget {
  final String exchange;
  final VoidCallback onClose;

  const ManageMarketTimingDialog({
    super.key,
    required this.exchange,
    required this.onClose,
  });

  static void show(BuildContext context, {required String exchange, required ExchangeSettingsBloc bloc}) {
    CommonDialog.show(
      context: context,
      title: 'Market Timing - $exchange',
      width: 1100.w,
      showButtons: false,
      scrollable: true,
      contentBuilder: (context, onClose) => BlocProvider.value(
        value: bloc,
        child: ManageMarketTimingDialog(
          exchange: exchange,
          onClose: onClose,
        ),
      ),
    );
  }

  @override
  State<ManageMarketTimingDialog> createState() => _ManageMarketTimingDialogState();
}

class _ManageMarketTimingDialogState extends State<ManageMarketTimingDialog> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    context.read<ExchangeSettingsBloc>()
      ..add(LoadExchangeHolidaysEvent(exchange: widget.exchange))
      ..add(LoadExchangeTimingsEvent(exchange: widget.exchange));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExchangeSettingsBloc, ExchangeSettingsState>(
      listener: (context, state) {
        if (state is ExchangeSettingsUpdateSuccess) {
          // You could show a specialized snackbar here or just let the page handle it.
        }
      },
      builder: (context, state) {
        if (state is ExchangeSettingsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (state is ExchangeSettingsLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TimingManagementSection(
                exchange: widget.exchange,
                timings: state.timings,
              ),
              const Divider(height: 48),
              HolidayManagementSection(
                exchange: widget.exchange,
                holidays: state.holidays,
              ),
              SizedBox(height: 24.h),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
