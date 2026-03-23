import 'package:bazarpro/core/widget/table/table_export_service.dart';
import 'package:bazarpro/core/widget/table/view_data_table.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../../models/script_master/script_master.dart';

abstract class ScriptMasterRemoteDataSource {
  Future<List<ScriptMasterModel>> getScriptMasters();
  Future<List<ScriptMasterModel>> getScriptMastersWithFilters({
    String? exchange,
    String? symbol,
  });
  Future<List<String>> getExchanges();
  Future<List<String>> getSymbols();
  Future<String> exportToPdf(List<ScriptMasterModel> scripts);
  Future<String> exportToExcel(List<ScriptMasterModel> scripts);
}

class ScriptMasterRemoteDataSourceImpl implements ScriptMasterRemoteDataSource {
  final Dio dio;
  ScriptMasterRemoteDataSourceImpl({required this.dio});
  @override
  Future<List<ScriptMasterModel>> getScriptMasters() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return _generateMockScriptMasters();
    } catch (e) {
      throw Exception('Failed to fetch script masters: $e');
    }
  }

  @override
  Future<List<ScriptMasterModel>> getScriptMastersWithFilters({
    String? exchange,
    String? symbol,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final allScripts = await getScriptMasters();
      return allScripts.where((script) {
        bool matches = true;
        if (exchange != null && exchange.isNotEmpty && exchange != 'All') {
          matches = matches && script.exchange == exchange;
        }
        if (symbol != null && symbol.isNotEmpty) {
          matches = matches && script.symbol.contains(symbol.toUpperCase());
        }
        return matches;
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch filtered script masters: $e');
    }
  }

  @override
  Future<List<String>> getExchanges() async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      return [
        'NSE',
        'MCX',
        'CE/PE',
        'OTHERS',
        'COMEX',
        'CRYPTO',
        'GIFT',
        'FOREX',
      ];
    } catch (e) {
      throw Exception('Failed to fetch exchanges: $e');
    }
  }

  @override
  Future<List<String>> getSymbols() async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      return [
        'GIFTNIFTY Oct 28',
        'NIFTY Oct 28',
        'BANKNIFTY Oct 28',
        'MINI GOLDMINI Dec 05',
        'MINI SILVERMINI Dec 05',
        'DOW Dec 19',
        'NASDAQ Dec 19',
        'S & P Dec 19',
        '3600NE30DEC',
        'ABB30DEC',
        'ABCAPITAL30DEC',
        'ADANIENSOL30DEC',
      ];
    } catch (e) {
      throw Exception('Failed to fetch symbols: $e');
    }
  }

  @override
  Future<String> exportToPdf(List<ScriptMasterModel> scripts) async {
    const columns = [
      ViewTableColumn(id: 'exchange', label: 'EXCHANGE', width: 90),
      ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 180),
      ViewTableColumn(id: 'expiryDate', label: 'EXPIRY', width: 100),
      ViewTableColumn(id: 'tradeAttribute', label: 'ATTRIBUTE', width: 120),
      ViewTableColumn(id: 'allowTrade', label: 'ALLOW', width: 80),
    ];
    final df = DateFormat('dd/MM/yy');
    await TableExportService.exportAsPdf<ScriptMasterModel>(
      title: 'Script Master',
      columns: columns,
      data: scripts,
      cellValueExtractor: (s, col) {
        switch (col.id) {
          case 'exchange':
            return s.exchange;
          case 'symbol':
            return s.symbol;
          case 'expiryDate':
            return df.format(s.expiryDate);
          case 'tradeAttribute':
            return s.tradeAttribute;
          case 'allowTrade':
            return s.allowTrade ? 'Yes' : 'No';
          default:
            return '-';
        }
      },
    );
    return 'script_masters_export_${DateTime.now().millisecondsSinceEpoch}.pdf';
  }

  @override
  Future<String> exportToExcel(List<ScriptMasterModel> scripts) async {
    const columns = [
      ViewTableColumn(id: 'exchange', label: 'EXCHANGE', width: 90),
      ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 180),
      ViewTableColumn(id: 'expiryDate', label: 'EXPIRY', width: 100),
      ViewTableColumn(id: 'tradeAttribute', label: 'ATTRIBUTE', width: 120),
      ViewTableColumn(id: 'allowTrade', label: 'ALLOW', width: 80),
    ];
    final df = DateFormat('dd/MM/yy');
    await TableExportService.exportAsExcel<ScriptMasterModel>(
      title: 'Script Master',
      columns: columns,
      data: scripts,
      cellValueExtractor: (s, col) {
        switch (col.id) {
          case 'exchange':
            return s.exchange;
          case 'symbol':
            return s.symbol;
          case 'expiryDate':
            return df.format(s.expiryDate);
          case 'tradeAttribute':
            return s.tradeAttribute;
          case 'allowTrade':
            return s.allowTrade ? 'Yes' : 'No';
          default:
            return '-';
        }
      },
    );
    return 'script_masters_export_${DateTime.now().millisecondsSinceEpoch}.xlsx';
  }

  List<ScriptMasterModel> _generateMockScriptMasters() {
    final List<ScriptMasterModel> scripts = [];
    final exchanges = ['NSE', 'MCX', 'CE/PE', 'COMEX', 'GIFT'];
    final symbols = [
      '3600NE30DEC',
      'ABB30DEC',
      'ABCAPITAL30DEC',
      'ADANIENSOL30DEC',
      'GIFTNIFTY Oct 28',
      'NIFTY Oct 28',
      'BANKNIFTY Oct 28',
      'MINI GOLDMINI Dec 05',
      'MINI SILVERMINI Dec 05',
      'DOW Dec 19',
      'NASDAQ Dec 19',
      'S & P Dec 19',
    ];
    final tradeAttributes = ['full', 'close'];
    final expiryDate = DateTime(2025, 12, 30, 0, 0, 0);
    for (int i = 0; i < 100; i++) {
      scripts.add(
        ScriptMasterModel(
          id: 'script_$i',
          exchange: exchanges[i % exchanges.length],
          symbol: symbols[i % symbols.length],
          expiryDate: expiryDate,
          tradeAttribute: tradeAttributes[i % tradeAttributes.length],
          allowTrade: i % 2 == 0,
          lastUpdated: DateTime.now().subtract(Duration(hours: i)),
        ),
      );
    }
    return scripts;
  }
}
