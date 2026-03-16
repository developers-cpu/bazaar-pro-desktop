import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../bloc/exchange_settings/exchange_settings_bloc.dart';
import '../../bloc/exchange_settings/exchange_settings_event.dart';
import '../../bloc/exchange_settings/exchange_settings_state.dart';
import '../../widgets/exchange_settings/exchange_settings_tab_bar.dart';
import '../../widgets/exchange_settings/exchange_settings_headers.dart';
import '../../widgets/exchange_settings/exchange_settings_toolbar.dart';
import '../../widgets/exchange_settings/exchange_settings_data_table.dart';
import '../../widgets/exchange_settings/password_dialog.dart';
import '../operations_page_wrapper.dart';
import '../../../../../injection_container.dart';
class ExchangeSettingsPageWithAppBar extends StatelessWidget {
  const ExchangeSettingsPageWithAppBar({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<ExchangeSettingsBloc>()..add(LoadExchangeSettingsEvent()),
      child: Builder(
        builder: (context) {
          return OperationsPageWrapper(
            pageTitle: 'Exchange Settings',
            onExportPdf: () {},
            onExportExcel: () {},
            child: const ExchangeSettingsPage(),
          );
        },
      ),
    );
  }
}
class ExchangeSettingsPage extends StatefulWidget {
  const ExchangeSettingsPage({super.key});
  @override
  State<ExchangeSettingsPage> createState() => _ExchangeSettingsPageState();
}
class _ExchangeSettingsPageState extends State<ExchangeSettingsPage> {
  bool _authenticated = false;
  int _activeTab = 0;
  final _searchCtrl = TextEditingController();
  Set<String> _selectedIds = {};
  bool _tradeLimitYes = true;
  bool _autoTickYes = false;
  final _tickSizeCtrl = TextEditingController(text: '0.05');
  bool _orderMarket = true;
  bool _orderSL = false;
  bool _orderLimit = true;
  bool _selectTypeYes = false;
  String _attributeType = 'Full';
  String? _selectedExchange;
  Map<String, TextEditingController> _seqControllers = {};
  Map<String, bool> _watchlistStates = {};
  final _exchanges = [
    'MCX',
    'NSE',
    'CE/PE',
    'GIFT',
    'OTHERS',
    'CRYPTO',
    'COMEX',
    'FOREX',
    'USSTOCK',
  ];
  final _tabs = const [
    'High Low Between Trade Limit',
    'Auto Tick Size',
    'Order Type',
    'Odd Lot',
    'Trade Quantity Setting',
    'Trade Attribute',
    'Exch Sequence',
    'Default Symbol',
  ];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showPasswordDialog());
  }
  @override
  void dispose() {
    _searchCtrl.dispose();
    _tickSizeCtrl.dispose();
    for (final c in _seqControllers.values) {
      c.dispose();
    }
    super.dispose();
  }
  void _showPasswordDialog() {
    PasswordDialog.show(
      context,
      onSuccess: (result) {
        if (result && mounted) {
          setState(() => _authenticated = true);
        }
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    if (!_authenticated) {
      return const Center(child: Text(''));
    }
    return BlocConsumer<ExchangeSettingsBloc, ExchangeSettingsState>(
      listener: (ctx, state) {
        if (state is ExchangeSettingsUpdateSuccess) {
          ScaffoldMessenger.of(
            ctx,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is ExchangeSettingsError) {
          ScaffoldMessenger.of(
            ctx,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
        if (state is ExchangeSettingsLoaded) {
          _initSeqControllers(state.settings);
          _initWatchlistStates(state.defaultSymbols);
        }
      },
      builder: (_, state) {
        final settings = (state is ExchangeSettingsLoaded)
            ? state.settings
            : [];
        final symbols = (state is ExchangeSettingsLoaded)
            ? state.defaultSymbols
            : [];
        final isDefaultSymbolTab = _activeTab == 7;
        final displayData = isDefaultSymbolTab ? symbols : settings;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExchangeSettingsTabBar(
                tabs: _tabs,
                activeTab: _activeTab,
                onTabChanged: (i) => setState(() {
                  _activeTab = i;
                  _selectedIds.clear();
                  if (i != 7) _selectedExchange = null;
                }),
              ),
              SizedBox(height: 10.h),
              ExchangeSettingsHeader(
                activeTab: _activeTab,
                tradeLimitYes: _tradeLimitYes,
                onTradeLimitChanged: (v) => setState(() => _tradeLimitYes = v),
                autoTickYes: _autoTickYes,
                onAutoTickChanged: (v) => setState(() => _autoTickYes = v),
                tickSizeCtrl: _tickSizeCtrl,
                orderMarket: _orderMarket,
                orderSL: _orderSL,
                orderLimit: _orderLimit,
                onOrderMarketChanged: (v) => setState(() => _orderMarket = v),
                onOrderSLChanged: (v) => setState(() => _orderSL = v),
                onOrderLimitChanged: (v) => setState(() => _orderLimit = v),
                selectTypeYes: _selectTypeYes,
                onSelectTypeChanged: (v) => setState(() => _selectTypeYes = v),
                attributeType: _attributeType,
                onAttributeTypeChanged: (v) =>
                    setState(() => _attributeType = v),
                selectedExchange: _selectedExchange,
                onExchangeChanged: (v) => setState(() => _selectedExchange = v),
                exchanges: _exchanges,
                searchCtrl: _searchCtrl,
                selectedIds: _selectedIds,
              ),
              SizedBox(height: 10.h),
              if (!isDefaultSymbolTab || _selectedExchange != null) ...[
                ExchangeSettingsToolbar(
                  activeTab: _activeTab,
                  recordCount: displayData.length,
                  searchCtrl: _searchCtrl,
                ),
                SizedBox(height: 10.h),
              ],
              Expanded(child: _buildBody(state, displayData)),
            ],
          ),
        );
      },
    );
  }
  void _initSeqControllers(List<dynamic> settings) {
    if (_seqControllers.isEmpty) {
      for (final s in settings) {
        _seqControllers[s.id] = TextEditingController(text: s.sequence);
      }
    }
  }
  void _initWatchlistStates(List<dynamic> symbols) {
    _watchlistStates.clear();
    for (final s in symbols) {
      _watchlistStates[s.id] = s.showInWatchlist;
    }
  }
  Widget _buildBody(ExchangeSettingsState state, List<dynamic> displayData) {
    if (state is ExchangeSettingsLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is ExchangeSettingsError) {
      return Center(child: Text(state.message));
    }
    if (_activeTab == 7 && _selectedExchange == null) {
      return const SizedBox.shrink();
    }
    return ExchangeSettingsDataTable(
      data: displayData,
      selectedIds: _selectedIds,
      onSelectionChanged: (ids) => setState(() => _selectedIds = ids),
      columns: _columnsForTab(),
      activeTab: _activeTab,
      sequenceControllers: _seqControllers,
      watchlistStates: _watchlistStates,
      onWatchlistToggle: (id) {
        setState(() {
          _watchlistStates[id] = !(_watchlistStates[id] ?? false);
        });
      },
    );
  }
  List<ViewTableColumn> _columnsForTab() {
    switch (_activeTab) {
      case 0:
        return [
          ViewTableColumn(id: 'exchange', label: 'EXCHANGE', width: 120.w),
          ViewTableColumn(
            id: 'betweenHighLow',
            label: 'BETWEEN HIGH _ LOW LIMIT PLACE',
            width: 300.w,
          ),
          ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 220.w),
          ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 150.w),
        ];
      case 1:
        return [
          ViewTableColumn(id: 'exchange', label: 'EXCHANGE', width: 120.w),
          ViewTableColumn(
            id: 'autoTickSize',
            label: 'AUTO TICK SIZE',
            width: 200.w,
          ),
          ViewTableColumn(id: 'tickSize', label: 'TICK SIZE', width: 150.w),
          ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 220.w),
          ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 150.w),
        ];
      case 2:
        return [
          ViewTableColumn(id: 'exchange', label: 'EXCHANGE', width: 120.w),
          ViewTableColumn(id: 'orderType', label: 'ORDER TYPE', width: 250.w),
          ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 220.w),
          ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 150.w),
        ];
      case 3:
        return [
          ViewTableColumn(id: 'exchange', label: 'EXCHANGE', width: 120.w),
          ViewTableColumn(id: 'oddLot', label: 'ODD LOT', width: 200.w),
          ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 220.w),
          ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 150.w),
        ];
      case 5:
        return [
          ViewTableColumn(id: 'exchange', label: 'EXCHANGE', width: 120.w),
          ViewTableColumn(
            id: 'marketPriceType',
            label: 'MARKET PRICE TYPE',
            width: 250.w,
          ),
          ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 220.w),
          ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 150.w),
        ];
      case 6:
        return [
          ViewTableColumn(id: 'exchange', label: 'EXCHANGE', width: 120.w),
          ViewTableColumn(id: 'sequence', label: 'SEQUENCE', width: 250.w),
          ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 220.w),
          ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 150.w),
        ];
      case 7:
        return [
          ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 180.w),
          ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 220.w),
          ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 180.w),
          ViewTableColumn(
            id: 'showInWatchlist',
            label: 'SHOW IN WATCHLIST',
            width: 150.w,
          ),
        ];
      default:
        return [
          ViewTableColumn(id: 'exchange', label: 'EXCHANGE', width: 120.w),
          ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 300.w),
          ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 200.w),
        ];
    }
  }
}
