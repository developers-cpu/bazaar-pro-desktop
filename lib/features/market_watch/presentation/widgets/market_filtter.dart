import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/market_watch_bloc.dart';
import '../bloc/market_watch_event.dart';
import '../bloc/market_watch_state.dart';
import 'exchange_filter.dart';
import 'symbol_filter.dart';

/// Filter row widget with exchange and symbol dropdowns
/// Allows users to filter market data by exchange and symbol
class MarketFilters extends StatelessWidget {
  final MarketWatchLoaded state;

  const MarketFilters({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final availableSymbols = state.items
        .map((item) => item.symbol)
        .toSet()
        .toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          ExchangeFilter(
            selectedExchange: state.selectedExchange,
            onChanged: (exchange) {
              context.read<MarketWatchBloc>().add(
                FilterByExchangeEvent(exchange: exchange),
              );
            },
          ),
          const SizedBox(width: 16),
          SymbolFilter(
            selectedSymbol: state.selectedSymbol,
            onChanged: (symbol) {
              context.read<MarketWatchBloc>().add(
                FilterBySymbolEvent(symbol: symbol),
              );
            },
            availableSymbols: availableSymbols,
          ),
        ],
      ),
    );
  }
}