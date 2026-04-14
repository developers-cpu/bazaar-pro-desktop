import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/datasources/symbol_settings_datasource.dart';
import '../../../domain/entities/exchange_settings/market_timing.dart';
import '../../bloc/exchange_settings/exchange_settings_bloc.dart';
import '../../bloc/exchange_settings/exchange_settings_event.dart';
import '../../bloc/exchange_settings/exchange_settings_state.dart';
import '../../../../../core/widget/app_tab_bar.dart';
import '../../widgets/exchange_settings/password_dialog.dart';
import '../../widgets/exchange_settings/tab/auto_tick_size_tab.dart';
import '../../widgets/exchange_settings/tab/default_symbol_tab.dart';
import '../../widgets/exchange_settings/tab/exch_sequence_tab.dart';
import '../../widgets/exchange_settings/tab/high_low_between_trade_limit_tab.dart';
import '../../widgets/exchange_settings/tab/odd_lot_tab.dart';
import '../../widgets/exchange_settings/tab/order_type_tab.dart';
import '../../widgets/exchange_settings/tab/trade_attribute_tab.dart';
import '../../widgets/exchange_settings/tab/market_timing_tab.dart';
import '../operations_page_wrapper.dart';
import '../../../../../injection_container.dart';
import '../../../domain/entities/exchange_settings/exchange_setting.dart';


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
  final SymbolSettingsDatasource _symbolSettingsDatasource =
      SymbolSettingsDatasourceImpl();
  bool _orderMarket = true;
  bool _orderSL = false;
  bool _orderLimit = true;
  bool _selectTypeYes = false;
  String _attributeType = 'Full';
  String? _selectedExchange;
  String? _selectedAutoTickExchange;
  String? _selectedTradeAttributeExchange;
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
    'Trade Attribute',
    'Exch Sequence',
    'Default Symbol',
    'Market Timing',
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
            : <ExchangeSetting>[];
        final symbols = (state is ExchangeSettingsLoaded)
            ? state.defaultSymbols
            : <DefaultSymbol>[];
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
                  if (i != 1) _selectedAutoTickExchange = null;
                  if (i != 4) _selectedTradeAttributeExchange = null;
                  if (i != 6) _selectedExchange = null;
                  if (i == 7) {
                    context.read<ExchangeSettingsBloc>().add(
                      LoadMarketTimingsEvent(),
                    );
                  }
                }),
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: _buildActiveTab(
                  state,
                  settings,
                  symbols,
                  (state is ExchangeSettingsLoaded) ? state.marketTimings : [],
                ),
              ),
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

  Widget _buildActiveTab(
    ExchangeSettingsState state,
    List<ExchangeSetting> settings,
    List<DefaultSymbol> symbols,
    List<ExchangeMarketTiming> timings,
  ) {
    if (state is ExchangeSettingsLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is ExchangeSettingsError) {
      return Center(child: Text(state.message));
    }
    switch (_activeTab) {
      case 0:
        return HighLowBetweenTradeLimitTab(
          tradeLimitYes: _tradeLimitYes,
          onTradeLimitChanged: (v) => setState(() => _tradeLimitYes = v),
          searchCtrl: _searchCtrl,
          onSearchChanged: (_) => setState(() {}),
          settings: _filterSettings(settings),
          selectedIds: _selectedIds,
          onSelectionChanged: (ids) => setState(() => _selectedIds = ids),
          onUpdatePressed: _updateSelectedSettings,
        );
      case 1:
        return AutoTickSizeTab(
          autoTickYes: _autoTickYes,
          onAutoTickChanged: (v) => setState(() => _autoTickYes = v),
          tickSizeCtrl: _tickSizeCtrl,
          searchCtrl: _searchCtrl,
          onSearchChanged: (_) => setState(() {}),
          settings: _filterSettings(settings),
          detailSettings: _filterAutoTickDetails(
            _buildAutoTickDetails(settings),
          ),
          selectedIds: _selectedIds,
          onSelectionChanged: (ids) => setState(() => _selectedIds = ids),
          onUpdatePressed: _updateSelectedSettings,
          selectedExchange: _selectedAutoTickExchange,
          onExchangeTap: (exchange) => _openAutoTickDetail(exchange, settings),
          onBack: () => setState(() {
            _selectedAutoTickExchange = null;
            _selectedIds.clear();
          }),
        );
      case 2:
        return OrderTypeTab(
          orderMarket: _orderMarket,
          orderSL: _orderSL,
          orderLimit: _orderLimit,
          onOrderMarketChanged: (v) => setState(() => _orderMarket = v),
          onOrderSLChanged: (v) => setState(() => _orderSL = v),
          onOrderLimitChanged: (v) => setState(() => _orderLimit = v),
          searchCtrl: _searchCtrl,
          onSearchChanged: (_) => setState(() {}),
          settings: _filterSettings(settings),
          selectedIds: _selectedIds,
          onSelectionChanged: (ids) => setState(() => _selectedIds = ids),
          onUpdatePressed: _updateSelectedSettings,
        );
      case 3:
        return OddLotTab(
          selectTypeYes: _selectTypeYes,
          onSelectTypeChanged: (v) => setState(() => _selectTypeYes = v),
          searchCtrl: _searchCtrl,
          onSearchChanged: (_) => setState(() {}),
          settings: _filterSettings(settings),
          selectedIds: _selectedIds,
          onSelectionChanged: (ids) => setState(() => _selectedIds = ids),
          onUpdatePressed: _updateSelectedSettings,
        );
      case 4:
        return TradeAttributeTab(
          attributeType: _attributeType,
          onAttributeTypeChanged: (v) => setState(() => _attributeType = v),
          searchCtrl: _searchCtrl,
          onSearchChanged: (_) => setState(() {}),
          settings: _filterSettings(settings),
          detailSettings: _filterTradeAttributeDetails(
            _buildTradeAttributeDetails(settings),
          ),
          selectedIds: _selectedIds,
          onSelectionChanged: (ids) => setState(() => _selectedIds = ids),
          onUpdatePressed: _updateSelectedSettings,
          selectedExchange: _selectedTradeAttributeExchange,
          onExchangeTap: (exchange) =>
              _openTradeAttributeDetail(exchange, settings),
          onBack: () => setState(() {
            _selectedTradeAttributeExchange = null;
            _selectedIds.clear();
          }),
        );
      case 5:
        return ExchSequenceTab(
          searchCtrl: _searchCtrl,
          onSearchChanged: (_) => setState(() {}),
          settings: _filterSettings(settings),
          selectedIds: _selectedIds,
          onSelectionChanged: (ids) => setState(() => _selectedIds = ids),
          sequenceControllers: _seqControllers,
        );
      case 6:
        return DefaultSymbolTab(
          selectedExchange: _selectedExchange,
          exchanges: _exchanges,
          onExchangeChanged: (val) {
            setState(() => _selectedExchange = val);
            if (val != null) {
              context.read<ExchangeSettingsBloc>().add(
                LoadDefaultSymbolsEvent(exchange: val),
              );
            }
          },
          searchCtrl: _searchCtrl,
          onSearchChanged: (_) => setState(() {}),
          symbols: _filterSymbols(symbols),
          selectedIds: _selectedIds,
          onSelectionChanged: (ids) => setState(() => _selectedIds = ids),
          onUpdatePressed: _updateSelectedSettings,
          watchlistStates: _watchlistStates,
          onWatchlistToggle: (id) {
            setState(() {
              _watchlistStates[id] = !(_watchlistStates[id] ?? false);
            });
          },
        );
      case 7:
        return MarketTimingTab(
          timings: _filterMarketTimings(timings),
          searchCtrl: _searchCtrl,
          onSearchChanged: (_) => setState(() {}),
          onStatusChanged: (timing, value) {
            context.read<ExchangeSettingsBloc>().add(
                  UpdateMarketTimingStatusEvent(
                    id: timing.id,
                    isOn: value,
                  ),
                );
          }, 
        );
      default:
        return const SizedBox.shrink();
    }
  }

  List<ExchangeSetting> _filterSettings(List<ExchangeSetting> settings) {
    final query = _searchCtrl.text.trim().toLowerCase();
    if (query.isEmpty) {
      return settings;
    }
    return settings.where((item) {
      final haystack = [
        item.exchange,
        item.tickSize,
        item.marketPriceType,
        item.sequence,
        item.updatedOn,
        item.updatedBy,
        item.orderType.join(','),
      ].join(' ').toLowerCase();
      return haystack.contains(query);
    }).toList();
  }

  List<DefaultSymbol> _filterSymbols(List<DefaultSymbol> symbols) {
    final query = _searchCtrl.text.trim().toLowerCase();
    if (query.isEmpty) {
      return symbols;
    }
    return symbols.where((item) {
      final haystack = [
        item.symbol,
        item.exchange,
        item.updatedOn,
        item.updatedBy,
      ].join(' ').toLowerCase();
      return haystack.contains(query);
    }).toList();
  }

  List<AutoTickSymbolDetail> _buildAutoTickDetails(
    List<ExchangeSetting> settings,
  ) {
    final exchange = _selectedAutoTickExchange;
    if (exchange == null) {
      return const [];
    }
    final exchangeSetting = settings
        .where((item) => item.exchange == exchange)
        .firstOrNull;
    final updatedOn = exchangeSetting?.updatedOn ?? '26/12/25 | 12:00:00 AM';
    final updatedBy = exchangeSetting?.updatedBy ?? 'DEMO4';
    return _symbolSettingsDatasource
        .getSymbolSettings(exchange: exchange)
        .map(
          (item) => AutoTickSymbolDetail(
            id: item.id,
            symbol: item.symbol,
            autoTickSize: item.autoTickSize,
            tickSize: item.autoTickSize ? '-' : item.size,
            updatedOn: updatedOn,
            updatedBy: updatedBy,
          ),
        )
        .toList();
  }

  List<AutoTickSymbolDetail> _filterAutoTickDetails(
    List<AutoTickSymbolDetail> details,
  ) {
    final query = _searchCtrl.text.trim().toLowerCase();
    if (query.isEmpty) {
      return details;
    }
    return details.where((item) {
      final haystack = [
        item.symbol,
        item.tickSize,
        item.updatedOn,
        item.updatedBy,
        item.autoTickSize ? 'yes' : 'no',
      ].join(' ').toLowerCase();
      return haystack.contains(query);
    }).toList();
  }

  List<TradeAttributeSymbolDetail> _buildTradeAttributeDetails(
    List<ExchangeSetting> settings,
  ) {
    final exchange = _selectedTradeAttributeExchange;
    if (exchange == null) {
      return const [];
    }
    final exchangeSetting = settings
        .where((item) => item.exchange == exchange)
        .firstOrNull;
    final updatedOn = exchangeSetting?.updatedOn ?? '26/12/25 | 12:00:00 AM';
    final updatedBy = exchangeSetting?.updatedBy ?? 'DEMO4';
    return _symbolSettingsDatasource
        .getSymbolSettings(exchange: exchange)
        .map(
          (item) => TradeAttributeSymbolDetail(
            id: item.id,
            symbol: item.symbol,
            marketPriceType: _normalizeTradeAttribute(item.tradeAttribute),
            updatedOn: updatedOn,
            updatedBy: updatedBy,
          ),
        )
        .toList();
  }

  List<TradeAttributeSymbolDetail> _filterTradeAttributeDetails(
    List<TradeAttributeSymbolDetail> details,
  ) {
    final query = _searchCtrl.text.trim().toLowerCase();
    if (query.isEmpty) {
      return details;
    }
    return details.where((item) {
      final haystack = [
        item.symbol,
        item.marketPriceType,
        item.updatedOn,
        item.updatedBy,
      ].join(' ').toLowerCase();
      return haystack.contains(query);
    }).toList();
  }

  void _openAutoTickDetail(String exchange, List<ExchangeSetting> settings) {
    final selected = settings
        .where((item) => item.exchange == exchange)
        .firstOrNull;
    setState(() {
      _selectedAutoTickExchange = exchange;
      _selectedIds.clear();
      if (selected != null) {
        _autoTickYes = selected.autoTickSize;
        _tickSizeCtrl.text = selected.tickSize;
      }
    });
  }

  void _openTradeAttributeDetail(
    String exchange,
    List<ExchangeSetting> settings,
  ) {
    final selected = settings
        .where((item) => item.exchange == exchange)
        .firstOrNull;
    setState(() {
      _selectedTradeAttributeExchange = exchange;
      _selectedIds.clear();
      if (selected != null) {
        _attributeType = selected.marketPriceType;
      }
    });
  }

  String _normalizeTradeAttribute(String value) {
    if (value.isEmpty) {
      return value;
    }
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }

  void _updateSelectedSettings() {
    if (_selectedIds.isEmpty) {
      return;
    }
    context.read<ExchangeSettingsBloc>().add(
      UpdateExchangeSettingsEvent(ids: _selectedIds.toList()),
    );
  }

  List<ExchangeMarketTiming> _filterMarketTimings(List<ExchangeMarketTiming> timings) {
    final query = _searchCtrl.text.trim().toLowerCase();
    if (query.isEmpty) {
      return timings;
    }
    return timings.where((item) {
      final haystack = [
        item.exchange,
        item.date,
        item.timing,
        item.isOn ? 'on' : 'off',
      ].join(' ').toLowerCase();
      return haystack.contains(query);
    }).toList();
  }

  
}
