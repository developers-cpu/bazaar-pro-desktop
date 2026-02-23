import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_images.dart';
import '../../../../../core/widget/custom_input_field.dart';
import '../../../../../core/widget/custom_action_button.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../bloc/surveillance/surveillance_bloc.dart';
import '../../bloc/surveillance/surveillance_event.dart';
import '../../bloc/surveillance/surveillance_state.dart';
import '../../widgets/trade_settings/trade_settings_tab_bar.dart';
import '../../widgets/surveillance/bulk_order_data_table.dart';
import '../../widgets/surveillance/vpn_restriction_view.dart';
import '../../widgets/surveillance/import_surveillance_dialog.dart';
import '../../../domain/entities/surveillance/surveillance_data.dart';

class SurveillancePage extends StatefulWidget {
  const SurveillancePage({super.key});

  @override
  State<SurveillancePage> createState() => _SurveillancePageState();
}

class _SurveillancePageState extends State<SurveillancePage> {
  int _activeTab = 0;
  final _searchCtrl = TextEditingController();
  final _intervalTimeCtrl = TextEditingController();
  final _totalQtyCtrl = TextEditingController();
  final _tradeSlLimitCtrl = TextEditingController();

  Set<String> _selectedIds = {};
  String? _selectedExchange;

  final _tabs = const ['Bulk Order', 'VPN Restriction'];
  final _exchanges = const [
    'NSE',
    'MCX',
    'CE/PE',
    'OTHERS',
    'COMEX',
    'CRYPTO',
    'GIFT',
    'FOREX',
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    _intervalTimeCtrl.dispose();
    _totalQtyCtrl.dispose();
    _tradeSlLimitCtrl.dispose();
    super.dispose();
  }

  void _showImportDialog() {
    showDialog(
      context: context,
      builder: (_) => const ImportSurveillanceDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SurveillanceBloc, SurveillanceState>(
      listener: (ctx, state) {
        if (state is SurveillanceUpdateSuccess) {
          ScaffoldMessenger.of(
            ctx,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is SurveillanceError) {
          ScaffoldMessenger.of(
            ctx,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (ctx, state) {
        SurveillanceData? currentData;
        if (state is SurveillanceLoaded) {
          currentData = state.data;
        } else if (state is SurveillanceUpdateSuccess) {
          currentData = state.data;
        } else if (state is SurveillanceError) {
          currentData = state.currentData;
        }

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
              if (_activeTab == 0) ..._buildBulkOrderHeader(currentData),
              if (_activeTab == 1 && currentData != null)
                VpnRestrictionView(vpnData: currentData.vpnRestriction),

              SizedBox(height: 15.h),
              if (_activeTab == 0)
                ..._buildBulkOrderSearchAndTable(state, currentData),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildBulkOrderHeader(SurveillanceData? data) {
    return [
      Row(
        children: [
          AppDropdown(
            hintText: 'Exchange',
            items: _exchanges,
            value: _selectedExchange,
            onChanged: (val) => setState(() => _selectedExchange = val),
            width: 250.w,
          ),
          const Spacer(),
          CustomActionButton(
            text: 'Import',
            onPressed: _showImportDialog,
            width: 100.w,
            height: 35.h,
            borderRadius: 8.r,
          ),
        ],
      ),
      SizedBox(height: 15.h),
      Row(
        children: [
          _buildLabeledInput(
            'Interval Time',
            _intervalTimeCtrl,
            hintText: '0.05',
          ),
          SizedBox(width: 20.w),
          _buildLabeledInput('Total Quantity', _totalQtyCtrl, hintText: '0.05'),
          SizedBox(width: 20.w),
          _buildLabeledInput(
            'Trade SL/Limit (%)',
            _tradeSlLimitCtrl,
            hintText: '0.05',
          ),
          const Spacer(),
          CustomActionButton(
            text: 'Update',
            onPressed: () {
              context.read<SurveillanceBloc>().add(SaveSurveillanceDataEvent());
            },
            width: 100.w,
            height: 35.h,
            borderRadius: 8.r,
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildBulkOrderSearchAndTable(
    SurveillanceState state,
    SurveillanceData? data,
  ) {
    if (state is SurveillanceLoading) {
      return [
        const Expanded(child: Center(child: CircularProgressIndicator())),
      ];
    }

    final bulkOrders = data?.bulkOrders ?? [];
    return [
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
            'RECORD : ${bulkOrders.length}',
            style: GoogleFonts.openSans(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlue,
            ),
          ),
        ],
      ),
      SizedBox(height: 10.h),
      Expanded(
        child: BulkOrderDataTable(
          data: bulkOrders,
          selectedIds: _selectedIds,
          onSelectionChanged: (ids) => setState(() => _selectedIds = ids),
        ),
      ),
    ];
  }

  Widget _buildLabeledInput(
    String label,
    TextEditingController controller, {
    String hintText = '',
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryBlue,
          ),
        ),
        SizedBox(height: 6.h),
        CustomInputField(
          hintText: hintText,
          controller: controller,
          width: 250.w,
          height: 35.h,
        ),
      ],
    );
  }
}
