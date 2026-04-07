import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../bloc/surveillance/surveillance_bloc.dart';
import '../../bloc/surveillance/surveillance_event.dart';
import '../../bloc/surveillance/surveillance_state.dart';
import '../../../domain/entities/surveillance/surveillance_data.dart';
import '../../../domain/entities/surveillance/surveillance_bulk_order.dart';
import '../../widgets/surveillance/import_surveillance_dialog.dart';
import '../../widgets/surveillance/tab/spot_index_setting_tab.dart';
import '../../widgets/surveillance/tab/trade_sl_limit_tab.dart';
import '../../widgets/surveillance/tab/vpn_restriction_tab.dart';
import 'package:google_fonts/google_fonts.dart';

class SurveillancePage extends StatefulWidget {
  const SurveillancePage({super.key});

  @override
  State<SurveillancePage> createState() => _SurveillancePageState();
}

class _SurveillancePageState extends State<SurveillancePage> {
  static const List<String> _tabs = [
    'Trade SL/Limit (%)',
    'VPN Restriction',
    'Spot Index Setting',
  ];

  static const List<String> _spotIndexOptions = [
    'SGX GIFTNIFTY Oct 28',
    'NSE NIFTY Oct 28',
    'NSE BANKNIFTY Oct 28',
    'MINI GOLDMINI Dec 05',
    'MCX CRUDEOIL Nov 18',
    'MCX NATURALGAS Nov 22',
  ];

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _tradeLimitController = TextEditingController(
    text: '0.05',
  );

  int _activeTab = 0;
  String? _selectedExchange;
  Set<String> _selectedIds = {};
  List<String> _pendingSpotSymbols = [];
  List<String> _selectedSpotSymbols = [];
  SurveillanceData? _cachedData;

  @override
  void dispose() {
    _searchController.dispose();
    _tradeLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SurveillanceBloc, SurveillanceState>(
      listener: (context, state) {
        if (state is SurveillanceLoaded) {
          _cachedData = state.data;
          _pendingSpotSymbols = List<String>.from(state.data.spotIndexSymbols);
          _selectedSpotSymbols = List<String>.from(state.data.spotIndexSymbols);
        } else if (state is SurveillanceUpdateSuccess) {
          _cachedData = state.data;
          _pendingSpotSymbols = List<String>.from(state.data.spotIndexSymbols);
          _selectedSpotSymbols = List<String>.from(state.data.spotIndexSymbols);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is SurveillanceError) {
          if (state.currentData != null) {
            _cachedData = state.currentData;
          }
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (ctx, state) {
        final currentData = switch (state) {
          SurveillanceLoaded(:final data) => data,
          SurveillanceUpdateSuccess(:final data) => data,
          SurveillanceError(:final currentData) => currentData ?? _cachedData,
          _ => _cachedData,
        };

        if (currentData == null) {
          if (state is SurveillanceLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(child: Text('No data available'));
        }

        final filteredOrders = _filteredBulkOrders(currentData);

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTabs(),
              SizedBox(height: 12.h),
              Expanded(
                child: _buildActiveTab(
                  currentData,
                  filteredOrders,
                  isBusy: state is SurveillanceLoading,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final isSelected = _activeTab == index;
          return Padding(
            padding: EdgeInsets.only(right: 28.w),
            child: InkWell(
              onTap: () {
                setState(() {
                  _activeTab = index;
                  _selectedIds.clear();
                });
              },
              child: Container(
                padding: EdgeInsets.only(bottom: 6.h),
                decoration: BoxDecoration(
                  border: isSelected
                      ? const Border(
                          bottom: BorderSide(
                            color: AppColors.primaryBlue,
                            width: 2,
                          ),
                        )
                      : null,
                ),
                child: Text(
                  _tabs[index],
                  style: GoogleFonts.openSans(
                    fontSize: 13.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? AppColors.primaryBlue
                        : AppColors.primaryBlue.withOpacity(0.6),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildActiveTab(
    SurveillanceData currentData,
    List<SurveillanceBulkOrder> filteredOrders, {
    required bool isBusy,
  }) {
    switch (_activeTab) {
      case 0:
        final exchanges =
            currentData.bulkOrders
                .map((order) => order.exchange)
                .toSet()
                .toList()
              ..sort();
        return TradeSlLimitTab(
          exchanges: exchanges,
          selectedExchange: _selectedExchange,
          onExchangeChanged: (value) {
            setState(() {
              _selectedExchange = value;
              _selectedIds.clear();
            });
          },
          tradeLimitController: _tradeLimitController,
          searchController: _searchController,
          onSearchChanged: (_) => setState(() {}),
          filteredOrders: filteredOrders,
          selectedIds: _selectedIds,
          onSelectionChanged: (ids) {
            setState(() => _selectedIds = ids);
          },
          onImportPressed: () => ImportSurveillanceDialog.show(context),
          onUpdatePressed: _handleTradeLimitUpdate,
          isBusy: isBusy,
        );
      case 1:
        return VpnRestrictionTab(vpnData: currentData.vpnRestriction);
      case 2:
        return SpotIndexSettingTab(
          options: _spotIndexOptions,
          pendingSpotSymbols: _pendingSpotSymbols,
          onPendingSymbolsChanged: (values) {
            setState(() {
              _pendingSpotSymbols = values;
            });
          },
          selectedSpotSymbols: _selectedSpotSymbols,
          onRemoveSymbol: (symbol) {
            setState(() {
              _selectedSpotSymbols.remove(symbol);
              _pendingSpotSymbols.remove(symbol);
            });
          },
          onUpdatePressed: _handleSpotIndexUpdate,
          isBusy: isBusy,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  List<SurveillanceBulkOrder> _filteredBulkOrders(
    SurveillanceData currentData,
  ) {
    final query = _searchController.text.trim().toLowerCase();
    return currentData.bulkOrders.where((order) {
      final matchesExchange =
          _selectedExchange == null || order.exchange == _selectedExchange;
      final matchesQuery =
          query.isEmpty || order.symbol.toLowerCase().contains(query);
      return matchesExchange && matchesQuery;
    }).toList();
  }

  void _handleTradeLimitUpdate() {
    final tradeSlLimit = double.tryParse(_tradeLimitController.text.trim());
    if (tradeSlLimit == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid Trade SL/Limit value')),
      );
      return;
    }
    if (_selectedIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select at least one row to update')),
      );
      return;
    }

    final bloc = context.read<SurveillanceBloc>();
    bloc.add(
      UpdateTradeSlLimitEvent(
        ids: _selectedIds.toList(),
        tradeSlLimit: tradeSlLimit,
      ),
    );
    bloc.add(SaveSurveillanceDataEvent());
  }

  void _handleSpotIndexUpdate() {
    final mergedSymbols = <String>[
      ..._selectedSpotSymbols,
      ..._pendingSpotSymbols.where(
        (symbol) => !_selectedSpotSymbols.contains(symbol),
      ),
    ];

    setState(() {
      _selectedSpotSymbols = mergedSymbols;
      _pendingSpotSymbols = mergedSymbols;
    });
    context.read<SurveillanceBloc>().add(
      UpdateSpotIndexSymbolsEvent(symbols: mergedSymbols),
    );
    context.read<SurveillanceBloc>().add(SaveSurveillanceDataEvent());
  }
}
