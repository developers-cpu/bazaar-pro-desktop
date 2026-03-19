import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_images.dart';
import '../../../../../core/widget/custom_input_field.dart';
import '../../../../../core/widget/app_date_picker.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../../../../core/widget/custom_action_button.dart';
import '../../bloc/script_settings/script_settings_bloc.dart';
import '../../bloc/script_settings/script_settings_event.dart';
import '../../bloc/script_settings/script_settings_state.dart';
import '../../../../../core/widget/app_tab_bar.dart';
import '../../widgets/script_settings/ban_script_data_table.dart';
import '../../widgets/script_settings/dividend_script_data_table.dart';
import '../../widgets/script_settings/bonas_data_table.dart';
import '../../widgets/script_settings/dividend_effect_data_table.dart';
import '../../../domain/entities/script_settings/script_setting.dart';
import '../../../../../core/widget/table/success_dialog.dart';
import '../../../domain/entities/script_settings/bonus_dividend_entry.dart';

class ScriptSettingsPage extends StatefulWidget {
  const ScriptSettingsPage({super.key});
  @override
  State<ScriptSettingsPage> createState() => _ScriptSettingsPageState();
}

class _ScriptSettingsPageState extends State<ScriptSettingsPage> {
  int _activeTab = 0;
  final _searchCtrl = TextEditingController();
  Set<String> _selectedIds = {};
  final _tabs = const ['Ban Script', 'Split Script', 'Bonas', 'Dividend'];

  String? _splitMonth;
  String? _splitExchange;
  String? _splitSymbol;
  DateTime? _splitCutDate;

  String? _bonasExchange;
  String? _bonasSymbol;
  String? _bonasBuySell;
  final _bonasRatioCtrl = TextEditingController();
  final _bonasClosePriceCtrl = TextEditingController();

  String? _dividendExchange;
  String? _dividendSymbol;
  String? _dividendBuySell;
  final _dividendCtrl = TextEditingController();
  final _dividendClosePriceCtrl = TextEditingController();

  final List<BonusDividendEntry> _bonasData = const [
    BonusDividendEntry(
      id: '1',
      username: 'Democlient1',
      symbol: 'REALINCE',
      netQty: 1200,
      closePrice: 400,
      ratio: '1:1',
      afterEffectNetQty: 2400,
      effectPrice: 200,
    ),
    BonusDividendEntry(
      id: '2',
      username: 'Democlient2',
      symbol: 'REALINCE',
      netQty: 100,
      closePrice: 400,
      ratio: '1:1',
      afterEffectNetQty: 200,
      effectPrice: 200,
    ),
    BonusDividendEntry(
      id: '3',
      username: 'Democlient3',
      symbol: 'REALINCE',
      netQty: 500,
      closePrice: 400,
      ratio: '1:1',
      afterEffectNetQty: 1000,
      effectPrice: 200,
    ),
    BonusDividendEntry(
      id: '4',
      username: 'Democlient4',
      symbol: 'REALINCE',
      netQty: 600,
      closePrice: 400,
      ratio: '1:1',
      afterEffectNetQty: 1200,
      effectPrice: 200,
    ),
    BonusDividendEntry(
      id: '5',
      username: 'Democlient5',
      symbol: 'REALINCE',
      netQty: 700,
      closePrice: 400,
      ratio: '1:1',
      afterEffectNetQty: 1400,
      effectPrice: 200,
    ),
  ];
  final List<BonusDividendEntry> _dividendData = const [
    BonusDividendEntry(
      id: '1',
      username: 'Democlient1',
      symbol: 'REALINCE',
      netQty: 1200,
      closePrice: 400,
      ratio: '5',
      afterEffectNetQty: 1200,
      effectPrice: 395,
    ),
    BonusDividendEntry(
      id: '2',
      username: 'Democlient2',
      symbol: 'REALINCE',
      netQty: 100,
      closePrice: 400,
      ratio: '5',
      afterEffectNetQty: 100,
      effectPrice: 395,
    ),
    BonusDividendEntry(
      id: '3',
      username: 'Democlient3',
      symbol: 'REALINCE',
      netQty: 500,
      closePrice: 400,
      ratio: '5',
      afterEffectNetQty: 500,
      effectPrice: 395,
    ),
    BonusDividendEntry(
      id: '4',
      username: 'Democlient4',
      symbol: 'REALINCE',
      netQty: 600,
      closePrice: 400,
      ratio: '5',
      afterEffectNetQty: 600,
      effectPrice: 395,
    ),
    BonusDividendEntry(
      id: '5',
      username: 'Democlient5',
      symbol: 'REALINCE',
      netQty: 700,
      closePrice: 400,
      ratio: '5',
      afterEffectNetQty: 700,
      effectPrice: 395,
    ),
  ];

  final _exchanges = const [
    'NSE',
    'MCX',
    'CE/PE',
    'OTHERS',
    'COMEX FUTURE',
    'CRYPTO',
    'GIFT',
    'FOREX',
  ];
  final _symbols = const [
    'GIFTNIFTY Oct 28',
    'NIFTY Oct 28',
    'BANKNIFTY Oct 28',
    'MINI GOLDMINI Dec 05',
    'MINI SILVERMINI Dec 05',
    'DOW Dec 19',
    'NASDAQ Dec 19',
    'S & P Dec 19',
  ];
  final _buySellOptions = const ['Buy', 'Sell'];

  @override
  void dispose() {
    _searchCtrl.dispose();
    _bonasRatioCtrl.dispose();
    _bonasClosePriceCtrl.dispose();
    _dividendCtrl.dispose();
    _dividendClosePriceCtrl.dispose();
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
              AppTabBar(
                tabs: _tabs,
                activeTab: _activeTab,
                onTabChanged: (i) => setState(() {
                  _activeTab = i;
                  _selectedIds.clear();
                }),
              ),
              SizedBox(height: 15.h),
              _buildFilterRow(),
              SizedBox(height: 15.h),
              if (_activeTab <= 1) ...[
                _buildSearchAndRecordRow(allSettings.length),
                SizedBox(height: 10.h),
              ],
              if (_activeTab > 1) ...[
                _buildRecordRow(
                  _activeTab == 2 ? _bonasData.length : _dividendData.length,
                ),
                SizedBox(height: 10.h),
              ],
              Expanded(child: _buildBody(context, state, allSettings)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterRow() {
    switch (_activeTab) {
      case 0:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Spacer(),
            CustomActionButton(
              text: 'Update',
              onPressed: () {},
              width: 100.w,
              height: 35.h,
              borderRadius: 8.r,
            ),
          ],
        );
      case 1:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AppDropdown(
              hintText: 'Month',
              items: const [
                'January',
                'February',
                'March',
                'April',
                'May',
                'June',
                'July',
                'August',
                'September',
                'October',
                'November',
                'December',
              ],
              value: _splitMonth,
              onChanged: (val) => setState(() => _splitMonth = val),
              width: 150.w,
              height: 35.h,
            ),
            SizedBox(width: 10.w),
            AppDropdown(
              hintText: 'Exchange',
              items: _exchanges,
              value: _splitExchange,
              onChanged: (val) => setState(() => _splitExchange = val),
              width: 150.w,
              height: 35.h,
            ),
            SizedBox(width: 10.w),
            AppDropdown(
              hintText: 'Symbol',
              items: _symbols,
              value: _splitSymbol,
              onChanged: (val) => setState(() => _splitSymbol = val),
              width: 150.w,
              height: 35.h,
            ),
            SizedBox(width: 10.w),
            AppDatePicker(
              label: 'Select Cut Date',
              value: _splitCutDate,
              onChanged: (d) => setState(() => _splitCutDate = d),
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
        );
      case 2:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AppDropdown(
              hintText: 'Exchange',
              items: _exchanges,
              value: _bonasExchange,
              onChanged: (val) => setState(() => _bonasExchange = val),
              width: 130.w,
              height: 35.h,
            ),
            SizedBox(width: 10.w),
            AppDropdown(
              hintText: 'Symbol',
              items: _symbols,
              value: _bonasSymbol,
              onChanged: (val) => setState(() => _bonasSymbol = val),
              width: 130.w,
              height: 35.h,
            ),
            SizedBox(width: 10.w),
            AppDropdown(
              hintText: 'Buy',
              items: _buySellOptions,
              value: _bonasBuySell,
              onChanged: (val) => setState(() => _bonasBuySell = val),
              width: 130.w,
              height: 35.h,
            ),
            SizedBox(width: 10.w),
            CustomInputField(
              hintText: 'Bonas ratio',
              controller: _bonasRatioCtrl,
              width: 130.w,
              height: 35.h,
            ),
            SizedBox(width: 10.w),
            CustomInputField(
              hintText: 'Close Price',
              controller: _bonasClosePriceCtrl,
              width: 130.w,
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
        );
      case 3:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AppDropdown(
              hintText: 'Exchange',
              items: _exchanges,
              value: _dividendExchange,
              onChanged: (val) => setState(() => _dividendExchange = val),
              width: 130.w,
              height: 35.h,
            ),
            SizedBox(width: 10.w),
            AppDropdown(
              hintText: 'Symbol',
              items: _symbols,
              value: _dividendSymbol,
              onChanged: (val) => setState(() => _dividendSymbol = val),
              width: 130.w,
              height: 35.h,
            ),
            SizedBox(width: 10.w),
            AppDropdown(
              hintText: 'Buy',
              items: _buySellOptions,
              value: _dividendBuySell,
              onChanged: (val) => setState(() => _dividendBuySell = val),
              width: 130.w,
              height: 35.h,
            ),
            SizedBox(width: 10.w),
            CustomInputField(
              hintText: 'Dividend',
              controller: _dividendCtrl,
              width: 130.w,
              height: 35.h,
            ),
            SizedBox(width: 10.w),
            CustomInputField(
              hintText: 'Close Price',
              controller: _dividendClosePriceCtrl,
              width: 130.w,
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
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildSearchAndRecordRow(int recordCount) {
    return Row(
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
          'RECORD : $recordCount',
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildRecordRow(int recordCount) {
    return Row(
      children: [
        const Spacer(),
        Text(
          'RECORD : $recordCount',
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildBody(
    BuildContext context,
    ScriptSettingsState state,
    List<ScriptSetting> displayData,
  ) {
    if (_activeTab <= 1) {
      if (state is ScriptSettingsLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (state is ScriptSettingsError) {
        return Center(child: Text(state.message));
      }
    }
    switch (_activeTab) {
      case 0:
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
      case 1:
        return DividendScriptDataTable(
          data: displayData,
          selectedIds: _selectedIds,
          onSelectionChanged: (ids) => setState(() => _selectedIds = ids),
        );
      case 2:
        return SingleChildScrollView(
          child: Column(
            children: [
              BonasDataTable(data: _bonasData),
              SizedBox(height: 15.h),
              CustomActionButton(
                text: 'Submit',
                onPressed: () => _showConfirmDialog('Bonas'),
                width: 150.w,
                height: 40.h,
                borderRadius: 8.r,
              ),
              SizedBox(height: 10.h),
            ],
          ),
        );
      case 3:
        return SingleChildScrollView(
          child: Column(
            children: [
              DividendEffectDataTable(data: _dividendData),
              SizedBox(height: 15.h),
              CustomActionButton(
                text: 'Submit',
                onPressed: () => _showConfirmDialog('Dividend'),
                width: 150.w,
                height: 40.h,
                borderRadius: 8.r,
              ),
              SizedBox(height: 10.h),
            ],
          ),
        );
      default:
        return const SizedBox();
    }
  }

  void _showConfirmDialog(String operationType) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: SizedBox(
          width: 400.w,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Want to Execute this Operation ?',
                  style: GoogleFonts.openSans(
                    fontSize: 22.sp,
                    color: AppColors.primaryBlue,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Are You Sure you want to Execute this Operation?',
                  style: GoogleFonts.openSans(
                    fontSize: 16.sp,
                    color: Colors.grey.shade500,
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40.h,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: AppColors.primaryBlue,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            'No',
                            style: GoogleFonts.openSans(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: SizedBox(
                        height: 40.h,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            Future.delayed(Duration.zero, () {
                              SuccessDialog.show(
                                context: context,
                                title: 'Successful Executed !',
                                subtitle:
                                    '$operationType is Successfully Executed for the Selected Script',
                              );
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            'Yes',
                            style: GoogleFonts.openSans(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}