import 'package:dio/dio.dart';
import '../models/script_master.dart';


/// Script Master remote data source interface
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

/// Script Master remote data source implementation
class ScriptMasterRemoteDataSourceImpl implements ScriptMasterRemoteDataSource {
  final Dio dio;

  ScriptMasterRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ScriptMasterModel>> getScriptMasters() async {
    try {
      // TODO: Replace with actual API call
      // final response = await dio.get('/script-masters');
      // return (response.data as List).map((e) => ScriptMasterModel.fromJson(e)).toList();

      // Mock data for development based on screenshots
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
      // TODO: Replace with actual API call with filters
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
      return ['NSE', 'MCX', 'CE/PE', 'OTHERS', 'COMEX', 'CRYPTO', 'GIFT', 'FOREX'];
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
    try {
      // TODO: Implement PDF export
      await Future.delayed(const Duration(seconds: 1));
      return 'script_masters_export_${DateTime.now().millisecondsSinceEpoch}.pdf';
    } catch (e) {
      throw Exception('Failed to export PDF: $e');
    }
  }

  @override
  Future<String> exportToExcel(List<ScriptMasterModel> scripts) async {
    try {
      // TODO: Implement Excel export
      await Future.delayed(const Duration(seconds: 1));
      return 'script_masters_export_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    } catch (e) {
      throw Exception('Failed to export Excel: $e');
    }
  }

  /// Generate mock script masters for development based on screenshots
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

    // Create expiry date: 30/12/25 | 12:00:00 AM
    final expiryDate = DateTime(2025, 12, 30, 0, 0, 0);

    for (int i = 0; i < 100; i++) {
      scripts.add(ScriptMasterModel(
        id: 'script_$i',
        exchange: exchanges[i % exchanges.length],
        symbol: symbols[i % symbols.length],
        expiryDate: expiryDate,
        tradeAttribute: tradeAttributes[i % tradeAttributes.length],
        allowTrade: true, // All showing "Yes" in screenshots
        lastUpdated: DateTime.now().subtract(Duration(hours: i)),
      ));
    }

    return scripts;
  }
}