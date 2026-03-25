import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../bloc/symbol_settings/symbol_settings_bloc.dart';
import '../../bloc/symbol_settings/symbol_settings_event.dart';
import '../../bloc/symbol_settings/symbol_settings_state.dart';

class SymbolSettingsFilterBar extends StatefulWidget {
  const SymbolSettingsFilterBar({super.key});

  @override
  State<SymbolSettingsFilterBar> createState() =>
      _SymbolSettingsFilterBarState();
}

class _SymbolSettingsFilterBarState extends State<SymbolSettingsFilterBar> {
  String? _tempExchange;
  bool _isInitialized = false;

  static const _exchanges = [
    'NSE', 'MCX', 'CE/PE', 'GIFT', 'OTHERS', 'CRYPTO', 'COMEX', 'FOREX',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SymbolSettingsBloc, SymbolSettingsState>(
      builder: (context, state) {
        if (!_isInitialized && state is SymbolSettingsLoaded) {
          _tempExchange = state.currentExchange;
          _isInitialized = true;
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppDropdown(
              hintText: 'Exchange',
              items: _exchanges,
              value: _tempExchange,
              showAllOption: true,
              allOptionText: 'All',
              onChanged: (val) {
                setState(() => _tempExchange = val);
                context.read<SymbolSettingsBloc>().add(
                  LoadSymbolSettingsEvent(
                    exchange: (val == null || val.isEmpty) ? null : val,
                  ),
                );
              },
              width: 160.w,
              height: 35.h,
            ),
          ],
        );
      },
    );
  }
}
