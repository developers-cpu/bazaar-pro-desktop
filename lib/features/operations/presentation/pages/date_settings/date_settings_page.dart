import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_images.dart';
import '../../../../../core/widget/custom_input_field.dart';
import '../../bloc/date_settings/date_settings_bloc.dart';
import '../../bloc/date_settings/date_settings_state.dart';
import '../../widgets/date_settings/date_settings_tab_bar.dart';
import '../../widgets/date_settings/date_settings_headers.dart';
import '../../widgets/date_settings/date_settings_data_table.dart';
import '../../../domain/entities/date_settings/date_setting.dart';

class DateSettingsPage extends StatefulWidget {
  const DateSettingsPage({super.key});

  @override
  State<DateSettingsPage> createState() => _DateSettingsPageState();
}

class _DateSettingsPageState extends State<DateSettingsPage> {
  int _activeTab = 0;
  final _searchCtrl = TextEditingController();
  Set<String> _selectedIds = {};
  String _selectedMonth = 'February';

  final _exchanges = const [
    'NSE',
    'MCX',
    'CE/PE',
    'GIFT',
    'OTHERS',
    'COMEX',
    'CRYPTO',
    'FOREX',
    'USSTOCK',
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DateSettingsBloc, DateSettingsState>(
      listener: (ctx, state) {
        if (state is DateSettingsUpdateSuccess) {
          ScaffoldMessenger.of(
            ctx,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is DateSettingsError) {
          ScaffoldMessenger.of(
            ctx,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (_, state) {
        final allSettings = (state is DateSettingsLoaded)
            ? state.settings
            : <DateSetting>[];
        final filteredData = allSettings
            .where((s) => s.exchange == _exchanges[_activeTab])
            .toList();

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DateSettingsTabBar(
                tabs: _exchanges,
                activeTab: _activeTab,
                onTabChanged: (i) => setState(() {
                  _activeTab = i;
                  _selectedIds.clear();
                }),
              ),
              SizedBox(height: 10.h),
              DateSettingsHeaders(
                selectedMonth: _selectedMonth,
                onMonthChanged: (m) => setState(() => _selectedMonth = m),
              ),
              SizedBox(height: 10.h),
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
                    'RECORD : ${filteredData.length}',
                    style: GoogleFonts.openSans(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Expanded(child: _buildBody(state, filteredData)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(DateSettingsState state, List<DateSetting> displayData) {
    if (state is DateSettingsLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is DateSettingsError) {
      return Center(child: Text(state.message));
    }

    return DateSettingsDataTable(
      data: displayData,
      selectedIds: _selectedIds,
      onSelectionChanged: (ids) => setState(() => _selectedIds = ids),
    );
  }
}
