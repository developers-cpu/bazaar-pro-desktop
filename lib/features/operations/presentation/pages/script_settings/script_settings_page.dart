import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_images.dart';
import '../../../../../core/widget/custom_input_field.dart';
import '../../../../../core/widget/app_date_picker.dart';
import '../../../../../core/widget/custom_action_button.dart';
import '../../bloc/script_settings/script_settings_bloc.dart';
import '../../bloc/script_settings/script_settings_event.dart';
import '../../bloc/script_settings/script_settings_state.dart';
import '../../widgets/trade_settings/trade_settings_tab_bar.dart';
import '../../widgets/script_settings/ban_script_data_table.dart';
import '../../widgets/script_settings/dividend_script_data_table.dart';
import '../../../domain/entities/script_settings/script_setting.dart';

class ScriptSettingsPage extends StatefulWidget {
  const ScriptSettingsPage({super.key});
  @override
  State<ScriptSettingsPage> createState() => _ScriptSettingsPageState();
}

class _ScriptSettingsPageState extends State<ScriptSettingsPage> {
  int _activeTab = 0;
  final _searchCtrl = TextEditingController();
  Set<String> _selectedIds = {};
  DateTime? _cutDate;
  final _tabs = const ['Ban Script', 'Dividend Script'];
  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScriptSettingsBloc, ScriptSettingsState>(
      listener: (ctx, state) {
        if (state is ScriptSettingsUpdateSuccess) {
          ScaffoldMessenger.of(
            ctx,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is ScriptSettingsError) {
          ScaffoldMessenger.of(
            ctx,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (_, state) {
        final allSettings =
            (state is ScriptSettingsLoaded ||
                state is ScriptSettingsUpdateSuccess)
            ? (state is ScriptSettingsLoaded
                  ? state.settings
                  : (state as ScriptSettingsUpdateSuccess).settings)
            : <ScriptSetting>[];
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TradeSettingsTabBar(
                tabs: _tabs,
                activeTab: _activeTab,
                onTabChanged: (i) => setState(() {
                  _activeTab = i;
                  _selectedIds.clear();
                }),
              ),
              SizedBox(height: 15.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (_activeTab == 1)
                    AppDatePicker(
                      label: 'Cut Date',
                      value: _cutDate,
                      onChanged: (d) => setState(() => _cutDate = d),
                      width: 200.w,
                      height: 35.h,
                    ),
                  const Spacer(),
                  CustomActionButton(
                    text: 'Update',
                    onPressed: () {},
                    width: 100.w,
                    height: 35.h,
                    borderRadius: 8.r,
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Row(
                children: [
                  CustomInputField(
                    hintText: 'Search',
                    controller: _searchCtrl,
                    prefixSvgPath: AppImages.searchIcon,
                    width: 200.w,
                    height: 35.h,
                  ),
                  const Spacer(),
                  Text(
                    'RECORD : ${allSettings.length}',
                    style: GoogleFonts.openSans(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Expanded(child: _buildBody(context, state, allSettings)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    ScriptSettingsState state,
    List<ScriptSetting> displayData,
  ) {
    if (state is ScriptSettingsLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is ScriptSettingsError) {
      return Center(child: Text(state.message));
    }
    if (_activeTab == 0) {
      return BanScriptDataTable(
        data: displayData,
        selectedIds: _selectedIds,
        onSelectionChanged: (ids) => setState(() => _selectedIds = ids),
        onToggleStatus: (id, val) {
          context.read<ScriptSettingsBloc>().add(
            UpdateScriptSettingStatusEvent(settingId: id, isBanned: val),
          );
        },
      );
    } else {
      return DividendScriptDataTable(
        data: displayData,
        selectedIds: _selectedIds,
        onSelectionChanged: (ids) => setState(() => _selectedIds = ids),
      );
    }
  }
}
