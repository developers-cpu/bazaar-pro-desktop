import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../injection_container.dart';
import '../../bloc/symbol_settings/symbol_settings_bloc.dart';
import '../../bloc/symbol_settings/symbol_settings_event.dart';
import '../../bloc/symbol_settings/symbol_settings_state.dart';
import '../../../domain/entities/symbol_settings/symbol_setting.dart';
import '../../widgets/symbol_settings/symbol_settings_filter_bar.dart';
import '../../widgets/symbol_settings/symbol_settings_data_table.dart';
import '../../widgets/symbol_settings/symbol_edit_dialog.dart';
import '../../widgets/symbol_settings/trade_margin_dialog.dart';
import '../operations_page_wrapper.dart';

class SymbolSettingsPageWithAppBar extends StatelessWidget {
  const SymbolSettingsPageWithAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SymbolSettingsBloc>()..add(LoadSymbolSettingsEvent()),
      child: const OperationsPageWrapper(
        pageTitle: 'Symbol Settings',
        child: SymbolSettingsPage(),
      ),
    );
  }
}

class SymbolSettingsPage extends StatelessWidget {
  const SymbolSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SymbolSettingsFilterBar(),
          SizedBox(height: 10.h),
          BlocBuilder<SymbolSettingsBloc, SymbolSettingsState>(
            builder: (context, state) {
              final count = state is SymbolSettingsLoaded
                  ? state.settings.length
                  : 0;
              return Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'RECORD : $count',
                  style: GoogleFonts.openSans(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlue,
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: BlocBuilder<SymbolSettingsBloc, SymbolSettingsState>(
              builder: (context, state) {
                if (state is SymbolSettingsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is SymbolSettingsError) {
                  return Center(child: Text(state.message));
                }
                final List<SymbolSetting> data = state is SymbolSettingsLoaded
                    ? state.settings
                    : [];
                return SymbolSettingsDataTable(
                  data: data,
                  onEditPressed: (item) {
                    SymbolEditDialog.show(
                      context,
                      item: item,
                      onSave: (updated) {
                        context.read<SymbolSettingsBloc>().add(
                          UpdateSymbolSettingEvent(
                            id: updated.id,
                            updated: updated,
                          ),
                        );
                      },
                    );
                  },
                  onTradeMarginPressed: (item) {
                    TradeMarginDialog.show(
                      context,
                      item: item,
                      onSave: ({
                        required marginType,
                        required intradayMarginPercent,
                        required carryForwardMarginPercent,
                        required intradayMarginAmount,
                        required carryForwardMarginAmount,
                      }) {
                        context.read<SymbolSettingsBloc>().add(
                          UpdateSymbolTradeMarginEvent(
                            id: item.id,
                            marginType: marginType,
                            intradayMarginPercent: intradayMarginPercent,
                            carryForwardMarginPercent: carryForwardMarginPercent,
                            intradayMarginAmount: intradayMarginAmount,
                            carryForwardMarginAmount: carryForwardMarginAmount,
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
