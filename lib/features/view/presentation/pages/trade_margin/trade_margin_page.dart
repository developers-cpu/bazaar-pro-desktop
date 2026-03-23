import 'package:bazarpro/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../injection_container.dart';
import '../../bloc/trade_margin/trade_margin_bloc.dart' show TradeMarginBloc;
import '../../bloc/trade_margin/trade_margin_event.dart';
import '../../bloc/trade_margin/trade_margin_state.dart';
import '../../widget/trade_margin/trade_margin_dialog.dart';
import '../../widget/trade_margin/trade_margin_filter_bar.dart';

class TradeMarginPage extends StatefulWidget {
  const TradeMarginPage({super.key});
  @override
  State<TradeMarginPage> createState() => _TradeMarginPageState();
}

class _TradeMarginPageState extends State<TradeMarginPage> {
  bool _isDialogOpen = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TradeMarginBloc>()..add(const LoadTradeMargins()),
      child: BlocListener<TradeMarginBloc, TradeMarginState>(
        listener: _handleStateChange,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              const TradeMarginFilterBar(),
              Expanded(
                child: Center(
                  child: Text(
                    'Select Exchange and Search, then click View to see trade margins',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleStateChange(BuildContext context, TradeMarginState state) {
    if (state is TradeMarginLoaded && state.showDialog) {
      if (!_isDialogOpen) {
        if (state.tradeMargins.isNotEmpty ||
            state.searchQuery != null ||
            state.selectedExchange != null) {
          _isDialogOpen = true;
          TradeMarginDialog.show(
            context,
            onClose: () {
              if (mounted) {
                setState(() {
                  _isDialogOpen = false;
                });
                context.read<TradeMarginBloc>().add(
                  const UpdateTradeMarginFilters(),
                );
              }
            },
          );
        }
      }
    }
    if (state is TradeMarginError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
